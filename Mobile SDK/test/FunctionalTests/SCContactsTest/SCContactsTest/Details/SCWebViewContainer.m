#import "SCWebViewContainer.h"

#import "NSURLRequest+isTestDomain.h"

@interface NSString (SCWebViewContainer)

//STODO move to header
-(NSString*)dwFilePath;

@end

@implementation SCWebViewContainer
{
   __strong SCWebView* _webView;

   __strong NSString* _JSToTest;
   __strong NSString* _javascript;
}

@synthesize testWebViewRequest = _testWebViewRequest;

-(id)initWithJSResourcePath:( NSString* )path_
                   JSToTest:( NSString* )JSToTest_
{
    self = [ super init ];

    if ( self )
    {
        _webView = [ SCWebView new ];
        [ _webView.ownerships addObject: self ];
        _webView.delegate = self;

        [ _webView loadURLWithString: @"http://ws-alr1.dk.sitecore.net/mobilesdk-test-path" ];

        _JSToTest = JSToTest_;

        _javascript = [ NSString stringWithContentsOfFile: path_
                                                 encoding: NSUTF8StringEncoding
                                                    error: nil ];
    }

    return self;
}

#pragma mark SCWebViewDelegate

-(void)webViewDidFinishLoad:( SCWebView* )webView_
{
    [ _webView stringByEvaluatingJavaScriptFromString: _javascript ];
    [ webView_ stringByEvaluatingJavaScriptFromString: _JSToTest ];
}

- (BOOL)webView:(SCWebView *)webView
shouldStartLoadWithRequest:( NSURLRequest* )request_
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [ request_ isTestDomain ] )
        return YES;

    if ( request_.URL == nil
        || [ [ request_.URL absoluteString ] isEqualToString: @"about:blank" ] )
        return YES;

    if ( self->_testWebViewRequest( request_ ) )
        [ _webView.ownerships removeObject: self ];

    return NO;
}

@end

