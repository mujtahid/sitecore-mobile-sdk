    #import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderSelfScope | SCItemReaderParentScope;

@interface ReadItemsSPTest : SCAsyncTestCase
@end

@implementation ReadItemsSPTest

//by relative path
// 0(+),1(-),2(-),3(-),4(-),5(-),6(-),7(-)
-(void)testReadItemWithAllFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    NSString* path_ = @"/sitecore/content/nicam/products/lenses";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil
                                                                              scope: scope_ ];
        if( !local_session_ )
        {
            didFinishCallback_();
            return;
        }
        [ local_session_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );

        apiContext_ = local_session_;
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );

    SCItem* product_item_ = nil;

    //test products item
    {
        GHAssertTrue( products_items_ != nil, @"OK" );
        GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

        product_item_ = [ products_items_ objectAtIndex: 0 ];

        GHAssertTrue( product_item_ != nil, @"OK" );

        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( [ product_item_.displayName isEqualToString: @"Products" ], @"OK" );

        GHAssertTrue( product_item_.allChildren == nil, @"OK" );
        GHAssertTrue( product_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ product_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( SCProductsAllFieldsCount <= [ product_item_.readFieldsByName count ], @"OK" );
        GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );
    }

    //test lenses item
    {
        SCItem* lenses_item_ = [ product_item_.readChildren objectAtIndex: 0 ];

        GHAssertTrue( lenses_item_ != nil, @"OK" );

        GHAssertTrue( lenses_item_.parent == product_item_, @"OK" );
        GHAssertTrue( [ lenses_item_.displayName isEqualToString: @"Lenses" ], @"OK" );

        GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );
        GHAssertTrue( lenses_item_.readChildren == nil, @"OK" );
        GHAssertTrue( lenses_item_.allFieldsByName != nil, @"OK" );
        
        NSLog(@"Count: %d", [ lenses_item_.readFieldsByName count ]);
        NSLog(@"Count: %d", [ product_item_.allFieldsByName count ]);
        GHAssertTrue( SCNormalLensesAllFieldsCount == [ lenses_item_.readFieldsByName count ], @"OK" );
        GHAssertTrue( [ lenses_item_.allFieldsByName count ] == [ lenses_item_.readFieldsByName count ], @"OK" );
    }
}

//by item id
// 0(+),1(-),2(-),3(-),4(-),5(-),6(-),7(-)
-(void)testReadItemWithSomeFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* lenses_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSString* itemId_ = @"{AEE0704D-5C40-4209-AB6B-16B6A24DD629}";
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", @"Image", nil ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_
                                                                            scope: scope_ ];
        if( !local_session_ )
        {
            didFinishCallback_();
            return;
        }
        [ local_session_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            lenses_items_ = items_;
            didFinishCallback_();
        } );

        apiContext_ = local_session_;
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    SCItem* lenses_item_ = nil;

    //test lenses item
    {
       GHAssertTrue( apiContext_ != nil, @"OK" );
       GHAssertTrue( lenses_items_ != nil, @"OK" );
       GHAssertTrue( [ lenses_items_ count ] >= 1, @"OK" );

       lenses_item_ = [ lenses_items_ objectAtIndex: 0 ];

       GHAssertTrue( lenses_item_ != nil, @"OK" );
       GHAssertTrue( lenses_item_.parent == nil, @"OK" );
       GHAssertTrue( [ lenses_item_.displayName isEqualToString: @"Lenses" ], @"OK" );

       GHAssertTrue( lenses_item_.readChildren != nil, @"OK" );
       GHAssertTrue( [ lenses_item_.readChildren count ] == 1, @"OK" );
       GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );

       GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );

       GHAssertTrue( 2 == [ lenses_item_.readFieldsByName count ], @"OK" );
    }

   //test macro item
   {
      //NSString* path_ = @"/sitecore/content/nicam/products/lenses/macro";
      SCItem* macro_item_ = [ lenses_item_.readChildren objectAtIndex: 0 ];
      
      GHAssertTrue( macro_item_ != nil, @"OK" );

      GHAssertTrue( macro_item_.parent == lenses_item_, @"OK" );
      GHAssertTrue( [ macro_item_.displayName isEqualToString: @"Macro" ], @"OK" );

      GHAssertTrue( macro_item_.allChildren == nil, @"OK" );
      GHAssertTrue( macro_item_.readChildren == nil, @"OK" );
      GHAssertTrue( macro_item_.allFieldsByName == nil, @"OK" );

      GHAssertTrue( 2 == [ macro_item_.readFieldsByName count ], @"OK" );
   }
}

//by absolute path
// 0(+),1(-),2(-),3(-),4(-),5(-),6(-),7(-)
-(void)testReadItemWithNoFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    NSString* path_ = @"/sitecore/content/nicam/products/lenses";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSSet* fieldsNames_ = [ NSSet new ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_
                                                                              scope: scope_ ];
        if( !local_session_ )
        {
            didFinishCallback_();
            return;
        }
        [ local_session_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );

        apiContext_ = local_session_;
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );

    SCItem* product_item_ = nil;
    //test products item
    {
        GHAssertTrue( products_items_ != nil, @"OK" );
        GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

        product_item_ = [ products_items_ objectAtIndex: 0 ];
        GHAssertTrue( product_item_ != nil, @"OK" );
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( [ product_item_.displayName isEqualToString: @"Products" ], @"OK" );

        GHAssertTrue( product_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ product_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( product_item_.allChildren == nil, @"OK" );

        GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ product_item_.readFieldsByName count ] == 0, @"OK" );
   }

   //test lenses item
   {
      SCItem* lenses_item_ = [ product_item_.readChildren objectAtIndex: 0 ];

      GHAssertTrue( lenses_item_ != nil, @"OK" );

      GHAssertTrue( lenses_item_.parent == product_item_, @"OK" );
      GHAssertTrue( [ lenses_item_.displayName isEqualToString: @"Lenses" ], @"OK" );

      GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );
      GHAssertTrue( lenses_item_.readChildren == nil, @"OK" );
      GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );
      GHAssertTrue( [ lenses_item_.readFieldsByName count ] == 0, @"OK" );
   }
}

@end
