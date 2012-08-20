#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderParentScope;

@interface ReadItemsPTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsPTestAuth

-(void)testReadItemPWithAllFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;

    NSString* path_ = @"/sitecore/content/Nicam/Community";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            didFinishCallback_();
        } );
    };
    
     [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    NSLog( @"items_: %@", items_ );
    GHAssertTrue( apiContext_ == nil, @"OK" );
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
}

-(void)testReadItemPWithNoFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    NSLog( @"items_: %@", items_ );
    GHAssertTrue( apiContext_ == nil, @"OK" );
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
}

-(void)testReadItemPWithQuery
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;

    NSString* path_ = @"/sitecore/content/Nicam/My_Nicam/PhotoAlbum";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    NSLog( @"items_: %@", items_ );
    GHAssertTrue( apiContext_ == nil, @"OK" );
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
}

@end