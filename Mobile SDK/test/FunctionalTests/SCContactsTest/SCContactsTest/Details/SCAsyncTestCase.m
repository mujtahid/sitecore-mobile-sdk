#import "SCAsyncTestCase.h"

#import "SCWebViewContainer.h"

#import <JFFTestTools/GHAsyncTestCase+MainThreadTests.h>

@implementation SCAsyncTestCase

-(void)runTestWithSelector:( SEL )sel_
                 testsPath:( NSString* )jsPath_
                 javasript:( NSString* )javasript_
{
    [ self runTestWithSelector: sel_
                     testsPath: jsPath_
                     javasript: javasript_
                     afterTest: nil ];
}

-(void)runTestWithSelector:( SEL )sel_
                 testsPath:( NSString* )jsPath_
                 javasript:( NSString* )javasript_
                 afterTest:( void (^)( NSDictionary* result_ ) )afterTestBlock_
{
    __block BOOL result_ = NO;

    afterTestBlock_ = [ afterTestBlock_ copy ];

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSString* path_ = [ [ NSBundle mainBundle ] pathForResource: jsPath_
                                                             ofType: @"js" ];
        SCWebViewContainer* container_ =
        [ [ SCWebViewContainer alloc ] initWithJSResourcePath: path_
                                                     JSToTest: javasript_ ];

        didFinishCallback_ = [ didFinishCallback_ copy ];
        container_.testWebViewRequest = ^BOOL( NSURLRequest* request_ )
        {
            if ( [ request_.URL.host isEqualToString: @"OK" ] )
            {
                if ( afterTestBlock_ )
                {
                    afterTestBlock_( [ request_.URL.query dictionaryFromQueryComponents ] );
                }
                result_ = YES;
            }

            if ( !result_ )
                NSLog( @"fail: %@", request_.URL.host );

            didFinishCallback_();

            return YES;
        };
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: sel_ ];

    GHAssertTrue( result_, @"Test: %@ was failed", javasript_ );
}

@end
