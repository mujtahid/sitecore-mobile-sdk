 #import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderSelfScope | SCItemReaderChildrenScope;

@interface ReadItemsSCTest : SCAsyncTestCase
@end

@implementation ReadItemsSCTest

//by relative path
// 0(+),1(-),2(-),3(-),4(-),5(-),6(-),7(-)
-(void)testReadItemWithAllFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSString* path_ = @"/sitecore/content/nicam/products";

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

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

    SCItem* product_item_ = [ products_items_ objectAtIndex: 0 ];

    GHAssertTrue( product_item_ != nil, @"OK" );
    GHAssertTrue( product_item_.parent == nil, @"OK" );
    GHAssertTrue( [ product_item_.displayName isEqualToString: @"Products" ], @"OK" );

    //GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );

   //GHAssertTrue( SCProductsAllFieldsCount <= [ product_item_.allFieldsByName count ], @"OK" );
   //GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );

    GHAssertTrue( [ product_item_.allChildren count ] == SCProductsChildrenItemsCount, @"OK" );
    GHAssertTrue( [ product_item_.allChildren count ] == [ product_item_.readChildren count ] , @"OK" );

    for ( SCItem* item_ in product_item_.allChildren )
    {
        GHAssertTrue( item_.parent == product_item_, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] != 0, @"OK" );
        //GHAssertTrue( [ item_.allFieldsByName  count ] != 0, @"OK" );
        //because of field's security
        //GHAssertTrue( [ item_.allFieldsByName count ] == [ item_.readFieldsByName count ], @"OK" );;
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

        NSString* itemId_     = @"{0E1BB3F7-7C3A-4DD9-8041-50B68689E6A2}";
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

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( lenses_items_ != nil, @"OK" );
    GHAssertTrue( [ lenses_items_ count ] >= 1, @"OK" );

    SCItem* lenses_item_ = [ lenses_items_ objectAtIndex: 0 ];

    GHAssertTrue( lenses_item_ != nil, @"OK" );
    GHAssertTrue( lenses_item_.parent == nil, @"OK" );
    GHAssertTrue( [ lenses_item_.displayName isEqualToString: @"Lenses" ], @"OK" );
    GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );

    GHAssertTrue( 2 == [ lenses_item_.readFieldsByName count ], @"OK" );

    GHAssertTrue( [ lenses_item_.allChildren count ] == 4, @"OK" );
    GHAssertTrue( [ lenses_item_.allChildren count ] == [ lenses_item_.readChildren count ] , @"OK" );

   for ( SCItem* item_ in lenses_item_.allChildren )
   {
        GHAssertTrue( item_.parent == lenses_item_, @"OK" );
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( 2 == [ item_.readFieldsByName count ], @"OK" );
   }
}

//by absolute path
// 0(+),1(-),2(-),3(-),4(-),5(-),6(-),7(-)

-(void)testReadItemWithNoFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSString* path_ = @"/sitecore/content/nicam/products";
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
   GHAssertTrue( products_items_ != nil, @"OK" );
   GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

   SCItem* product_item_ = [ products_items_ objectAtIndex: 0 ];

   GHAssertTrue( product_item_ != nil, @"OK" );
   GHAssertTrue( product_item_.parent == nil, @"OK" );
   GHAssertTrue( [ product_item_.displayName isEqualToString: @"Products" ], @"OK" );
    NSLog( @"product_item_.allFieldsByName:%@", product_item_.allFieldsByName );
   GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
   GHAssertTrue( [ product_item_.readFieldsByName count ] == 0, @"OK" );

   GHAssertTrue( [ product_item_.allChildren count ] == SCProductsChildrenItemsCount, @"OK" );
   GHAssertTrue( [ product_item_.allChildren count ] == [ product_item_.readChildren count ], @"OK" );

   for ( SCItem* item_ in product_item_.allChildren )
   {
      GHAssertTrue( item_.parent == product_item_, @"OK" );
      GHAssertTrue( item_.allFieldsByName  == nil, @"OK" );
      GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
   }
}

@end
