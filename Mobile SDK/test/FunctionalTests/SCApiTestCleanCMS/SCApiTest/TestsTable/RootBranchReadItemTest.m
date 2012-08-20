#import "SCAsyncTestCase.h"

@interface RootBranchReadItemTest : SCAsyncTestCase
@end

@implementation RootBranchReadItemTest

-(void)testReadOtherBranchFromItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* nicam_item_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSString* path_ = @"/sitecore/content/nicam/products";

        [ local_session_ itemReaderForItemPath: path_ ] (^( id result, NSError* error_ )
        {
            nicam_item_ = [ local_session_ itemWithPath: path_ ];
            didFinishCallback_();
        } );

        apiContext_ = local_session_;
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( nicam_item_ != nil, @"Nicam item should be read" );

    __block SCItem* feed_item_ = nil;

    block_ = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSString* path_ = @"/sitecore/layout/devices/feed";

        [ apiContext_ itemReaderForItemPath: path_ ] (^( id result, NSError* error_ )
        {
            feed_item_ = [ apiContext_ itemWithPath: path_ ];
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( feed_item_ != nil, @"Nicam item should be read" );
    GHAssertTrue( [ feed_item_.displayName isEqualToString: @"Feed" ], @"Nicam item should be read" );
    GHAssertTrue( [ feed_item_.path isEqualToString: @"/sitecore/layout/devices/feed" ], @"YES" );
}

@end
