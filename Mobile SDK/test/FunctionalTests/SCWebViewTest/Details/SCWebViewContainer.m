#import "SCWebViewContainer.h"

@interface NSString (SCWebViewContainer)

//STODO move to header
-(NSString*)dwFilePath;

@end

@interface SCWebViewContainer ()

@property ( nonatomic, retain ) SCWebView* webView;

@end

@implementation SCWebViewContainer
{
    __strong NSString* _JSToTest;
    __strong NSString* _javascript;
}

@synthesize testWebViewRequest;
@synthesize webView = _webView;

-(id)initWithJSResourcePath:( NSString* )path_
                   JSToTest:( NSString* )JSToTest_
{
    self = [ super init ];

    if ( self )
    {
        UIWindow* window_ = [ [ UIApplication sharedApplication ] keyWindow ];

        _webView = [ SCWebView new ];

        [ window_ addSubviewAndScale: _webView ];
        [ _webView.ownerships addObject: self ];
        _webView.delegate = self;

        NSString* htmlPath_ = [ [ NSBundle mainBundle ] pathForResource: @"test"
                                                                 ofType: @"html" ];

        [ _webView loadURLWithString: [ htmlPath_ dwFilePath ] ];

        _JSToTest = JSToTest_;

        _javascript = [ NSString stringWithContentsOfFile: path_
                                                 encoding: NSUTF8StringEncoding
                                                    error: nil ];
    }

    return self;
}

#pragma mark SCWebViewDelegate

-(void)webViewDidFinishLoad:(SCWebView *)webView
{
    [ _webView stringByEvaluatingJavaScriptFromString: _javascript ];
    [ webView stringByEvaluatingJavaScriptFromString: _JSToTest ];
}

- (BOOL)webView:(SCWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request_
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ( request_.URL == nil
        || [ [ request_.URL absoluteString ] isEqualToString: @"about:blank" ] )
        return YES;

    if ( testWebViewRequest( request_ ) )
    {
        [ _webView removeFromSuperview ];
        [ _webView.ownerships removeObject: self ];
    }

    return NO;
}

@end

