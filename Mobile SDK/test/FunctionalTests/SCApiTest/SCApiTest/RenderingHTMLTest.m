#import "SCAsyncTestCase.h"

@interface RenderingHTMLTest : SCAsyncTestCase
@end

@implementation RenderingHTMLTest

-(void)testRenderingHTMLWithTrueIds
{
    __block SCApiContext* apiContext_ = nil;
    __block NSString* loaderResult_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCAsyncOp loader_ = [ apiContext_ renderingHTMLLoaderForRenderingWithId: @"{E036028E-9CB4-4B41-A945-E4D6FF4FA549}"
                                                                       sourceId: @"{2F1EB20B-B6C6-4F33-B1B0-80BD2AE15AFD}" ];
        loader_(^( id result, NSError* error_ )
        {
            loaderResult_ = result;
            did_finish_callback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( nil != apiContext_                , @"api context is not initialised" );
    GHAssertTrue( nil != loaderResult_              , @"result should not be nil"       );
    GHAssertTrue( [ loaderResult_ hasPrefix: @"<" ] , @"first tag is not correct"       );
    //GHAssertTrue( [ loaderResult_ hasSuffix: @">" ]  , @"last tag is not correct"        );
}

-(void)testRenderingHTMLWithLayoutIds
{
    __block SCApiContext* apiContext_ = nil;
    __block NSString* loaderResult_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCAsyncOp loader_ = [ apiContext_ renderingHTMLLoaderForRenderingWithId: @"{0DD9ED2E-DCE9-4639-B612-6A30F2D1F812}"
                                                                       sourceId: @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}" ];
        loader_(^( id result, NSError* error_ )
        {
            loaderResult_ = result;
            did_finish_callback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    NSString* expectedResponse_ = @"<div>Preview is unavailable for the Nicam rendering.</div>";

    GHAssertTrue( nil != apiContext_   , @"api context is not initialised" );
    GHAssertTrue( nil != loaderResult_ , @"result should not be nil"       );
    GHAssertTrue( [ loaderResult_ isEqualToString: expectedResponse_ ], @"response is not valid" );
}

-(void)testRenderingHTMLWithFakeIds
{
    __block SCApiContext* apiContext_ = nil;
    __block NSString* loaderResult_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCAsyncOp loader_ = [ apiContext_ renderingHTMLLoaderForRenderingWithId: @"{0DD9ED2E-DCE9-4639-B612-6A30F2D1F812}"
                                                                       sourceId: @"{010D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}" ];
        loader_(^( id result, NSError* error_ )
        {
            loaderResult_ = result;
            did_finish_callback_();
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    NSString* expectedPartOfResponse_ = @"<title>500 - Internal server error.</title>";

    GHAssertTrue( nil != apiContext_   , @"api context is not initialised" );
    GHAssertTrue( nil != loaderResult_ , @"result should not be nil"       );

    GHAssertTrue( 0 < [ loaderResult_ rangeOfString: expectedPartOfResponse_ ].location, @"response is not valid" );
}

@end
