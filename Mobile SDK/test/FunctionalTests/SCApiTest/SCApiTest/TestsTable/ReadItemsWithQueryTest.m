#import "SCAsyncTestCase.h"


@interface ReadItemsQueryTest : SCAsyncTestCase
@end

@implementation ReadItemsQueryTest

-(void)testReadItemSWithAllFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    //NSString* path_ = @"/sitecore/content/nicam/products/lenses";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.request = @"/sitecore/content/Nicam/Products/*[@@key='lenses']";
        request_.requestType = SCItemReaderRequestQuery;
        request_.fieldNames = nil;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 1, @"OK" );

    SCItem* product_item_ = nil;

    //test product item
    {
        product_item_ = [ products_items_ objectAtIndex: 0 ];      
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( [ product_item_.displayName isEqualToString: @"Lenses" ], @"OK" );

        GHAssertTrue( product_item_.allChildren == nil, @"OK" );
        GHAssertTrue( product_item_.readChildren == nil, @"OK" );

        GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );
    }
}

-(void)testReadItemCWithNoFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    //NSString* path_ = @"/sitecore/content/nicam/products/lenses";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.request = @"/sitecore/content/Nicam/Products/*[@@templatename='Product Group']";
        request_.requestType = SCItemReaderRequestQuery;
        request_.fieldNames  = [ NSSet new ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 5, @"OK" );

    for ( int i = 0; i < 5; i++ )
    {
        SCItem* product_item_ = [ products_items_ objectAtIndex: i ];
        //test product item
        {
            GHAssertTrue( product_item_.parent == nil, @"OK" );
            //GHAssertTrue( [ product_item_.itemTemplate isEqualToString: @"Product Group" ], @"OK" );
            GHAssertTrue( [ product_item_.allChildren count ] == 0, @"OK" );
            GHAssertTrue( product_item_.readChildren == nil, @"OK" );

            GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ product_item_.readFieldsByName count ] == 0, @"OK" );
        }
    }
}

-(void)testReadItemSCWithNoFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.request = @"/sitecore/content/Nicam/Products/Lenses/descendant-or-self::*[@@templatename='Product Group']";
        request_.requestType = SCItemReaderRequestQuery;
        request_.fieldNames = [ NSSet new ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 5, @"OK" );
    SCItem* parent_item_ = [ products_items_ objectAtIndex: 0 ];
    //test parent item
    GHAssertTrue( parent_item_.parent == nil, @"OK" );
    NSLog(@"parent_item_.readedChildren: %@", parent_item_.readChildren );
    //GHAssertTrue( parent_item_.allChildren != nil, @"OK" );
    GHAssertTrue( [ parent_item_.readChildren count ] == 4, @"OK" );
    //GHAssertTrue( [ parent_item_.readedChildren count ] == [ parent_item_.allChildren count ], @"OK" );

    GHAssertTrue( parent_item_.allFieldsByName == nil, @"OK" );
    GHAssertTrue( [ parent_item_.readFieldsByName count ] == 0, @"OK" );

    for ( int i = 1; i < 5; i++ )
    {
        SCItem* child_item_ = [ products_items_ objectAtIndex: i ];
        //test child item
        {
            GHAssertTrue( child_item_.parent != nil, @"OK" );
            GHAssertTrue( child_item_.parent == parent_item_, @"OK" );
            GHAssertTrue( [ child_item_.allChildren count ] == 0, @"OK" );
            GHAssertTrue( child_item_.readChildren == nil, @"OK" );

            GHAssertTrue( child_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ child_item_.readFieldsByName count ] == 0, @"OK" );
        }
    }
}

-(void)testReadItemSPWithAllFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.request = @"/sitecore/content/Nicam/Products/Lenses/Normal/ancestor-or-self::*[@@templatename='Product Group']";
        request_.requestType = SCItemReaderRequestQuery;
        request_.fieldNames = nil;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 2, @"OK" );
    SCItem* parent_item_ = [ products_items_ objectAtIndex: 1 ];
    //test parent item
    GHAssertTrue( parent_item_.parent == nil, @"OK" );
    GHAssertTrue( [ parent_item_.readChildren count ] == 1, @"OK" );

    GHAssertTrue( parent_item_.allFieldsByName != nil, @"OK" );
    GHAssertTrue( [ parent_item_.readFieldsByName count ] == [ parent_item_.allFieldsByName count ], @"OK" );

    SCItem* child_item_ = [ products_items_ objectAtIndex: 0 ];
    //test child item
    {
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == parent_item_, @"OK" );
        GHAssertTrue( [ child_item_.allChildren count ] == 0, @"OK" );
        GHAssertTrue( child_item_.readChildren == nil, @"OK" );

        GHAssertTrue( child_item_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( [ child_item_.readFieldsByName count ] == [ child_item_.allFieldsByName count ], @"OK" );
    }
}

-(void)testReadItemSCPWithNoFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.request = @"/sitecore/content/Nicam/Products/Lenses/Normal/ancestor-or-self::*[@@templatename='Product Group' or @@templatename='Site Section']";
        request_.requestType = SCItemReaderRequestQuery;
        request_.fieldNames = [ NSSet new ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
         {
             products_items_ = items_;
             didFinishCallback_();
         } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 3, @"OK" );
    SCItem* parent_item_ = [ products_items_ objectAtIndex: 2 ];
    //test parent item
    GHAssertTrue( parent_item_.parent == nil, @"OK" );
    GHAssertTrue( [ parent_item_.readChildren count ] == 1, @"OK" );
    GHAssertTrue( [ parent_item_.readChildren objectAtIndex: 0 ] == [ products_items_ objectAtIndex: 1 ], @"OK" );

    GHAssertTrue( parent_item_.allFieldsByName == nil, @"OK" );
    GHAssertTrue( [ parent_item_.readFieldsByName count ] == 0, @"OK" );

    SCItem* self_item_ = [ products_items_ objectAtIndex: 1 ];
    //test self item
    {
        GHAssertTrue( self_item_.parent != nil, @"OK" );
        GHAssertTrue( self_item_.parent == parent_item_, @"OK" );
        GHAssertTrue( self_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( [ self_item_.readChildren objectAtIndex: 0 ] == [ products_items_ objectAtIndex: 0 ], @"OK" );
        
        GHAssertTrue( self_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ self_item_.readFieldsByName count ] == 0, @"OK" );
    }
    SCItem* child_item_ = [ products_items_ objectAtIndex: 0 ];
    //test child item
    {
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_, @"OK" );
        GHAssertTrue( [ child_item_.allChildren count ] == 0, @"OK" );
        GHAssertTrue( child_item_.readChildren == nil, @"OK" );

        GHAssertTrue( child_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ child_item_.readFieldsByName count ] == 0, @"OK" );
    }
}


@end