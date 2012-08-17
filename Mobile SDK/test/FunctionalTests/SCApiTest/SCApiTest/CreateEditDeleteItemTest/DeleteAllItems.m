#import "SCAsyncTestCase.h"

@interface ZRemoveAllItems : SCAsyncTestCase
@end

@implementation ZRemoveAllItems

static NSString* master_path_ = @"/sitecore/content/Test Data/Create Edit Delete Tests/Positive";
static NSString* web_path_ = @"/sitecore/layout/Layouts/Test Data/Create Edit Delete Tests";
static NSString* media_path_ = @"/sitecore/media library/Test Data/Create Edit Delete Media";

-(void)testRemoveAllItems
{
    __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSString* delete_response_ = @"";

    void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];

        apiContext_.defaultDatabase = @"master";
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: master_path_ ];
        request_.scope = SCItemReaderChildrenScope;
        [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
        {
            delete_response_ = [ NSString stringWithFormat:@"%@", response_ ];
            SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemPath: master_path_ ];
            item_request_.scope = SCItemReaderChildrenScope;
            item_request_.flags = SCItemReaderRequestIngnoreCache;
            [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
            {
                items_ = read_items_;
                NSLog( @"items: %@", items_ );
                didFinishCallback_();
            } );
        } );
    };
    void (^delete_system_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];

        apiContext_.defaultDatabase = @"master";
        SCItemsReaderRequest* request_ = 
            [ SCItemsReaderRequest requestWithItemPath: @"/sitecore/system/Settings/Workflow/Test Data/Create Edit Delete Tests" ];
        request_.scope = SCItemReaderChildrenScope;
        [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
        {
             apiContext_.defaultDatabase = @"web";
             request_.request = web_path_;
             [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
             {
                 request_.request = media_path_;
                 [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                 {
                     apiContext_.defaultDatabase = @"core";
                     request_.request = web_path_;
                     [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                     {
                         request_.request = media_path_;
                         [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                         {
                             didFinishCallback_();
                         });
                     });
                 });
             });
        } );
        
    };

    [ self performAsyncRequestOnMainThreadWithBlock: delete_system_block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                           selector: _cmd ];

}

@end
