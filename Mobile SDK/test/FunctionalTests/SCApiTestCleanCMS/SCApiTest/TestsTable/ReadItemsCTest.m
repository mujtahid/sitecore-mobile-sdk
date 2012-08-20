#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderChildrenScope;

typedef SCAsyncOp (^SCTestedReader)( SCApiContext* itemReader_
                                    , NSString* queryData_
                                    , NSSet* fieldsNames_ );

@interface ReadItemsCTest : SCAsyncTestCase
@end

@implementation ReadItemsCTest

-(void)testReadItemWithAllFieldsWithReader:( SCTestedReader )testedReader_
                                  selector:( SEL )selector_
{
   __block SCApiContext* apiContext_ = nil;
   __block NSArray* products_children_items_ = nil;

   __block BOOL called_instantly_ = NO;

   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
   {
      SCApiContext* local_session_ = apiContext_ ? apiContext_ : [ SCApiContext contextWithHost: SCWebApiHostName ];

      NSString* path_ = @"/sitecore/content/nicam/products";

      testedReader_( local_session_, path_, nil )( ^( NSArray* items_, NSError* error_ )
      {
         products_children_items_ = items_;
         didFinishCallback_();
      } );

      apiContext_ = local_session_;
   };

   void (^resultTest_)(void) = ^void( void )
   {
       NSLog( @"[ products_children_items_ count ]: %d", [ products_children_items_ count ] );
      GHAssertTrue( [ products_children_items_ count ] == SCProductsChildrenItemsCount, @"OK" );

      for ( SCItem* item_ in products_children_items_ )
      {
         GHAssertTrue( item_.parent == nil, @"OK" );
         GHAssertTrue( [ item_.readFieldsByName count ] != 0, @"OK" );
         GHAssertTrue( [ item_.allFieldsByName  count ] != 0, @"OK" );
         GHAssertTrue( [ item_.allFieldsByName count ] == [ item_.readFieldsByName count ], @"OK" );
      }
   };

   //test first call
   {
      [ self performAsyncRequestOnMainThreadWithBlock: block_
                                             selector: selector_ ];
      GHAssertFalse( called_instantly_, @"OK" );
      resultTest_();
   }

//   {
//      [ self performAsyncRequestOnMainThreadWithBlock: block_
//                                             selector: selector_ ];
//
//      GHAssertTrue( called_instantly_, @"OK" );
//      resultTest_();
//   }
}

//by relative path
// 0(+),1(-),2(-),3(-),4(-),5(-),6(-),7(-)
-(void)testReadItemWithAllFields
{
    SCTestedReader testedReader_ = ^SCAsyncOp( SCApiContext* itemReader_
                                              , NSString* path_
                                              , NSSet* fieldsNames_ )
    {
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_
                                                                              scope: scope_ ];
        return [ itemReader_ itemsReaderWithRequest: request_ ];
    };
    [ self testReadItemWithAllFieldsWithReader: testedReader_
                                      selector: _cmd ];
}

//by item id
// 0(+),1(-),2(-),3(-),4(-),5(-),6(-),7(-)
-(void)testReadItemWithSomeFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* lenses_children_items_ = nil;

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
            lenses_children_items_ = items_;
            didFinishCallback_();
        } );

        apiContext_ = local_session_;
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ lenses_children_items_ count ] == 4, @"OK" );

    for ( SCItem* item_ in lenses_children_items_ )
    {
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( 2 == [ item_.readFieldsByName count ], @"OK" );
    }
}

//by absolute path
// 0(+),1(-),2(-),3(-),4(-),5(-),6(-),7(-)
-(void)testReadItemWithNoFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_children_items_ = nil;

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
            products_children_items_ = items_;
            didFinishCallback_();
        } );

        apiContext_ = local_session_;
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ products_children_items_ count ] == SCProductsChildrenItemsCount, @"OK" );

    for ( SCItem* item_ in products_children_items_ )
    {
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( item_.allFieldsByName  == nil, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
    }
}

@end
