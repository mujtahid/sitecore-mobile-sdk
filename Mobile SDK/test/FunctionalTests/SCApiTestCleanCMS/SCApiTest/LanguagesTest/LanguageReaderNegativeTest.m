#import "SCAsyncTestCase.h"

@interface LanguageReaderNegativeTest : SCAsyncTestCase
@end

@implementation LanguageReaderNegativeTest

-(void)testContextWrongDefaultLanguage
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
 
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            apiContext_.defaultLanguage = @"en";
            apiContext_.defaultLanguage = @"fr";
            NSString* path_ = @"/sitecore/content/nicam/products/lenses";
            NSSet* fieldNames_ = [ NSSet setWithObject: @"Title" ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                            fieldsNames: fieldNames_ ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
            {
                if ( [ da_result_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = [ da_result_ objectAtIndex: 0 ];
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    //Test danish item
    GHAssertTrue( item_ != nil, @"OK" );
    SCField* field_ = [ item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == item_, @"OK" );
}

-(void)testWrongRequestLanguage
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* da_item_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            NSSet* fields_ = [ NSSet setWithObject: @"Title" ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: @"/sitecore/content/nicam/products/lenses" 
                                                                            fieldsNames: fields_ ];
            request_.language = @"xx";
            apiContext_.defaultLanguage = @"da";
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
            {
                if ( [ da_result_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                da_item_ = [ da_result_ objectAtIndex: 0 ];
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //Test danish item
    GHAssertTrue( da_item_ != nil, @"OK" );
    SCField* field_ = [ da_item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Objektiver" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == da_item_, @"OK" );
}

-(void)testLanguageReadNotExistedItems
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* base_item_ = nil;
    __block SCItem* lense_item_ = nil;
    __block NSSet* field_names_ = [ NSSet setWithObjects: @"Image Size pixels", @"Focal length", nil ];
 
     void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
     {
         @autoreleasepool
         {
             apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
             SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
             request_.requestType = SCItemReaderRequestQuery;
             request_.request = @"/sitecore/content/Nicam/Products/Lenses/Normal/50mm_f_1_4D_NIKKOR/Specification/*";
             request_.language = @"da";
             request_.fieldNames = field_names_;
             [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
             {
                 base_item_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam/Products/Lenses/Normal/50mm_f_1_4D_NIKKOR/Specification/Base" ];
                 NSLog( @"base_item_.field: %@", [ [ base_item_ fieldWithName: @"Image Size pixels" ] rawValue ]);
                 lense_item_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam/Products/Lenses/Normal/50mm_f_1_4D_NIKKOR/Specification/Lense" ];
                 NSLog( @"lense_item_.field: %@", [ [ lense_item_ fieldWithName: @"Focal length" ] rawValue ]);
     
                 didFinishCallback_();
             } );
         }
     };
 
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //Test base item (is available in danish)
    GHAssertTrue( base_item_ != nil, @"OK" );
    SCField* field_ = [ base_item_ fieldWithName: @"Image Size pixels" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"1" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == base_item_, @"OK" );
    //Test lense item (isn't available in danish) - return empty field
    GHAssertTrue( lense_item_ != nil, @"OK" );
    field_ = [ lense_item_ fieldWithName: @"Focal length" ];
    NSLog( @"field_.rawValue: %@", field_);
    GHAssertTrue( [ field_.rawValue isEqualToString: @"" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == lense_item_, @"OK" );
}
 
@end