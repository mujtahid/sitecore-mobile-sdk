#import "SCAsyncTestCase.h"

@interface ReadPagingItemsAuthTest : SCAsyncTestCase
@end

@implementation ReadPagingItemsAuthTest

-(void)testPagedItemSCWithoutAuth
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSNumber* items_count_ = 0;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestItemPath;
        request_.scope       = SCItemReaderSelfScope | SCItemReaderChildrenScope;
        request_.request     = @"/sitecore/content/Nicam/";
        request_.flags       = SCItemReaderRequestReadFieldsValues;
        request_.fieldNames  = nil;
        request_.pageSize    = 2;

        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
        {
            items_count_ = result_;
            [ pagedItems_ itemReaderForIndex: 0 ]( ^( id result_, NSError* error_ )
            {
                [ pagedItems_ itemReaderForIndex: 5 ]( ^( id result_, NSError* error_ )
                {
                    didFinishCallback_();
                } );
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ items_count_ unsignedIntValue ] == 9, @"OK" );

    GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
    SCItem* parent_ = [ pagedItems_ itemForIndex: 0 ];
    GHAssertTrue( [ parent_.displayName isEqualToString: @"Nicam" ], @"OK" );
    GHAssertTrue( parent_.allFieldsByName != nil, @"OK" );
    GHAssertTrue( [ parent_.allFieldsByName count ] == [ parent_.readFieldsByName count ], @"OK" );

    GHAssertTrue( [ parent_.readChildren count ] == 3, @"OK" );
    GHAssertTrue( parent_.parent == nil, @"OK" );

    GHAssertTrue( [ pagedItems_ itemForIndex: 1 ] != nil, @"OK" );
    SCItem* child_ = [ pagedItems_ itemForIndex: 1 ];
    GHAssertTrue( child_.parent  == parent_, @"OK" );
    GHAssertTrue( child_.readChildren == nil, @"OK" );

    GHAssertTrue( child_.allFieldsByName != nil, @"OK" );
    GHAssertTrue( [ child_.allFieldsByName count ] == [ child_.readFieldsByName count ], @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 4 ] != nil, @"OK" );   
    GHAssertTrue( [ pagedItems_ itemForIndex: 3 ] == nil, @"OK" ); 
}

-(void)testPagedItemSCWithAuth
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSNumber* items_count_ = 0;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiLogin 
                                            password: SCWebApiPassword ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestItemPath;
        request_.scope       = SCItemReaderSelfScope | SCItemReaderChildrenScope;
        request_.request     = @"/sitecore/content/Nicam/";
        request_.flags       = SCItemReaderRequestReadFieldsValues;
        request_.fieldNames  = nil;
        request_.pageSize    = 2;

        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
        {
            items_count_ = result_;
            [ pagedItems_ itemReaderForIndex: 0 ]( ^( id result_, NSError* error_ )
            {
                [ pagedItems_ itemReaderForIndex: 5 ]( ^( id result_, NSError* error_ )
                {
                    didFinishCallback_();
                } );
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ items_count_ unsignedIntValue ] == 12, @"OK" );

    GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
    SCItem* parent_ = [ pagedItems_ itemForIndex: 0 ];
    GHAssertTrue( [ parent_.displayName isEqualToString: @"Nicam" ], @"OK" );
    GHAssertTrue( parent_.allFieldsByName != nil, @"OK" );
    GHAssertTrue( [ parent_.allFieldsByName count ] == [ parent_.readFieldsByName count ], @"OK" );
    GHAssertTrue( parent_.parent == nil, @"OK" );

    GHAssertTrue( [ pagedItems_ itemForIndex: 1 ] != nil, @"OK" );
    SCItem* child_ = [ pagedItems_ itemForIndex: 1 ];
    GHAssertTrue( child_.parent  == parent_, @"OK" );
    GHAssertTrue( child_.readChildren == nil, @"OK" );

    GHAssertTrue( child_.allFieldsByName != nil, @"OK" );
    GHAssertTrue( [ child_.allFieldsByName count ] == [ child_.readFieldsByName count ], @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 4 ] != nil, @"OK" );   
    GHAssertTrue( [ pagedItems_ itemForIndex: 3 ] == nil, @"OK" ); 
}

@end
