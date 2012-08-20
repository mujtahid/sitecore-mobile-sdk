#import "SCAsyncTestCase.h"

@interface InvalidRequestErrorTest : SCAsyncTestCase
@end

@implementation InvalidRequestErrorTest

-(void)testInvalidRequestTypeItemIDWithPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block SCError* error_ = nil;

    NSString* path_ = @"/sitecore/content/Nicam/*[@@key='my_nicam']/*[@Menu title='Edit profile']";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: path_
                                                                      fieldsNames: [ NSSet new ] ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* result_error_ )
        {
            items_ = result_items_;
            error_ = (SCError*)result_error_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( items_ == nil, @"OK" );
    GHAssertTrue( error_ != nil, @"OK" );

    GHAssertTrue( [ error_ isKindOfClass: [ SCInvalidItemIdError class ] ] == TRUE, @"OK" );
}

-(void)testInvalidRequestTypeItemPathWithQuery
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block SCError* error_ = nil;

    NSString* path_ = @"/sitecore/content/Nicam/*[@@key='my_nicam']/*[@Menu title='Edit profile']";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: [ NSSet new ] ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* result_error_ )
        {
            items_ = result_items_;
            error_ = (SCError*)result_error_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( items_ == nil, @"OK" );
    GHAssertTrue( error_ != nil, @"OK" );
    GHAssertTrue( [ error_ isKindOfClass: [ SCInvalidResponseFormatError class ] ] == TRUE, @"OK" );
}

-(void)testInvalidRequestTypeItemPathWithId
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block SCError* error_ = nil;

    NSString* path_ = @"{A1FF0BEE-AE21-4BAF-BECD-8029FC89601A}";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: [ NSSet new ] ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* resultItems_
                                                            , NSError* resultError_ )
        {
            items_ = resultItems_;
            error_ = (SCError*)resultError_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( items_ == nil, @"OK" );
    GHAssertTrue( error_ != nil, @"OK" );
    GHAssertTrue( [ error_ isKindOfClass: [ SCInvalidPathError class ] ] == TRUE, @"OK" );
}


-(void)testInvalidRequestTypeItemQueryWithId
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block SCError* error_ = nil;

    NSString* path_ = @"{A1FF0BEE-AE21-4BAF-0000-8029FC89601A}";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [SCItemsReaderRequest new ];
        request_.request = path_;
        request_.fieldNames = [ NSSet new ];
        request_.requestType = SCItemReaderRequestQuery;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* resultError_ )
        {
            items_ = result_items_;
            error_ = (SCError*)resultError_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    GHAssertTrue( error_ == nil, @"OK" );
}

@end
