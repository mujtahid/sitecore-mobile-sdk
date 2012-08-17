#import "SCAsyncTestCase.h"

#import "SCWebViewContainer.h"

@implementation SCAsyncTestCase

-(void)performAsyncRequestOnMainThreadWithBlock:( void (^)(JFFSimpleBlock) )block_
                                       selector:( SEL )selector_
{
    block_ = [ block_ copy ];
    void (^autorelease_block_)() = ^void()
    {
        @autoreleasepool
        {
            void (^didFinishCallback_)(void) = ^void()
            {
                [ self notify: kGHUnitWaitStatusSuccess forSelector: selector_ ];
            };

            block_( [ didFinishCallback_ copy ] );
        }
    };

    [ self prepare ];
    
    dispatch_async( dispatch_get_main_queue(), autorelease_block_ );
    
    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: 300. ];
}

-(void)runTestWithSelector:( SEL )sel_
                 testsPath:( NSString* )js_path_
                 javasript:( NSString* )javasript_
               nativeTests:( PerformNativeTests )nativeTests_
{
    __block BOOL result_ = NO;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSString* path_ = [ [ NSBundle mainBundle ] pathForResource: js_path_
                                                             ofType: @"js" ];
        SCWebViewContainer* container_ =
        [ [ SCWebViewContainer alloc ] initWithJSResourcePath: path_
                                                     JSToTest: javasript_ ];

        didFinishCallback_ = [ didFinishCallback_ copy ];
        container_.testWebViewRequest = ^BOOL( NSURLRequest* request_ )
        {
            if ( [ request_.URL.host isEqualToString: @"PERFORM_NATIVE_TESTS" ] )
            {
                nativeTests_( ^( BOOL ok_ )
                {
                    NSString* redirect_ = ok_
                        ? @"resultCallback( 'OK' )"
                        : @"resultCallback( 'ERROR_IN_NATIVE_TESTS' )";

                    [ container_.webView stringByEvaluatingJavaScriptFromString: redirect_ ];
                } );
                return NO;
            }

            if ( [ request_.URL.host isEqualToString: @"OK" ] )
            {
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
