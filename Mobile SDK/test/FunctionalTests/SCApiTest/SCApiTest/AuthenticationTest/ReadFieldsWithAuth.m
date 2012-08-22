#import "SCAsyncTestCase.h"

@interface ReadFieldsWithAuth : SCAsyncTestCase
@end

@implementation ReadFieldsWithAuth

-(void)testReadItemSWithSomeFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_         = nil;

    NSString* path_ = @"/sitecore/content/Nicam/Articles/Books/ClimbingPhotography";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        NSSet* field_names_ = [ NSSet setWithObjects: @"Short Description", nil];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: field_names_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    NSLog( @"items_: %@", items_ );
    NSLog( @"items_fields_: %@", [ items_[ 0 ] readFieldsByName ]);
    GHAssertTrue( apiContext_ != nil, @"OK" );

    //test get item with auth
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 1, @"OK" );
    SCItem* item_ = nil;
    //test product item
    {
        item_ = items_[ 0 ];
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( [ item_.displayName isEqualToString: @"ClimbingPhotography" ], @"OK" );
        NSLog( @"item_children: %@", [item_ allChildren] );
        GHAssertTrue( [ item_.allChildren count ] == 0, @"OK" );
        GHAssertTrue( [ item_.readChildren count ] == 0, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 1, @"OK" );
        GHAssertTrue( [ [ item_ fieldWithName: @"Short Description" ] rawValue ] != nil, @"OK" );
    }
}


@end