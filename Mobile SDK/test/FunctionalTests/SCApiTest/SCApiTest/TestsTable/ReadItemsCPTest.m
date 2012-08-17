#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderParentScope | SCItemReaderChildrenScope;

@interface ReadItemsCPTest : SCAsyncTestCase
@end

@implementation ReadItemsCPTest

//by relative path
// 0(+),1(-),2(-),3(-),4(-),5(-),6(-),7(-)
-(void)testReadItemWithAllFields
{
   __weak __block SCApiContext* weakApiContext_ = nil;
   __block NSArray* products_items_ = nil;

   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
   {
       SCApiContext* apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
       weakApiContext_ = apiContext_;

       NSString* path_ = @"/sitecore/content/nicam/products/lenses";

       SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                       fieldsNames: nil
                                                                             scope: scope_ ];
       [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
       {
           products_items_ = items_;
           didFinishCallback_();
       } );
   };

   [ self performAsyncRequestOnMainThreadWithBlock: block_
                                          selector: _cmd ];

   GHAssertTrue( weakApiContext_ != nil, @"OK" );
   GHAssertTrue( products_items_ != nil, @"OK" );
   GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

   SCItem* product_item_ = [ products_items_ objectAtIndex: 0 ];

   GHAssertTrue( product_item_ != nil, @"OK" );

   //test product item
   {
      GHAssertTrue( product_item_.parent == nil, @"OK" );
      GHAssertTrue( [ product_item_.displayName isEqualToString: @"Products" ], @"OK" );

      GHAssertTrue( product_item_.allChildren == nil, @"OK" );
      GHAssertTrue( product_item_.readChildren == nil, @"OK" );
      GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );

      //GHAssertTrue( SCProductsAllFieldsCount <= [ product_item_.allFieldsByName count ], @"OK" );
      //GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );
   }

   //test lenses item
   {
      SCItem* lenses_item_ = [ product_item_.apiContext itemWithPath: @"lenses" ];
      GHAssertTrue( lenses_item_ == nil, @"OK" );
   }

   //test childs
   {
      NSRange childrenRange = NSMakeRange( 1, [ products_items_ count ] - 1 );
      NSArray* children_ = [ products_items_ subarrayWithRange: childrenRange ];

      GHAssertTrue( 4 == [ children_ count ], @"OK" );
      for ( SCItem* item_ in children_ )
      {
         GHAssertTrue( item_.parent == nil, @"OK" );
         GHAssertTrue( item_.allChildren == nil, @"OK" );
         GHAssertTrue( item_.readChildren == nil, @"OK" );
         GHAssertTrue( item_.allFieldsByName != nil, @"OK" );
      }
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
        SCApiContext* localSession_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        //Macro item ID
        NSString* itemId_ = @"{AEE0704D-5C40-4209-AB6B-16B6A24DD629}";
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", @"Image", nil ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_
                                                                            scope: scope_ ];
        if ( !localSession_ )
        {
            didFinishCallback_();
            return;
       }
       [ localSession_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
       {
           lenses_items_ = items_;
           didFinishCallback_();
       } );

        apiContext_ = localSession_;
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( lenses_items_ != nil, @"OK" );
    GHAssertTrue( [ lenses_items_ count ] >= 1, @"OK" );

    SCItem* lenses_item_ = nil;
    {
        lenses_item_ = [ lenses_items_ objectAtIndex: 0 ];

        GHAssertTrue( lenses_item_.parent == nil, @"OK" );
        GHAssertTrue( lenses_item_ != nil, @"OK" );
        GHAssertTrue( [ lenses_item_.displayName isEqualToString: @"Lenses" ], @"OK" );
        GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );
        GHAssertTrue( lenses_item_.readChildren == nil, @"OK" );
        GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );

        GHAssertTrue( 2 == [ lenses_item_.readFieldsByName count ], @"OK" );
    }

    //test lenses item
    {
        SCItem* macro_item_ = [ lenses_item_.apiContext itemWithPath: @"macro" ];
        GHAssertTrue( macro_item_ == nil, @"OK" );
    }

    //test childs
    {
        NSRange childrenRange = NSMakeRange( 1, [ lenses_items_ count ] - 1 );
        NSArray* children_ = [ lenses_items_ subarrayWithRange: childrenRange ];

        GHAssertTrue( 3 == [ children_ count ], @"OK" );
        for ( SCItem* item_ in children_ )
        {
            GHAssertTrue( item_.parent == nil, @"OK" );
            GHAssertTrue( item_.allChildren == nil, @"OK" );
            GHAssertTrue( item_.readChildren == nil, @"OK" );
            GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( 2 == [ item_.readFieldsByName count ], @"OK" );
        }
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

        NSString* path_ = @"/sitecore/content/nicam/products/lenses";
        NSSet* fieldsNames_ = [NSSet new];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_
                                                                              scope: scope_ ];
        if ( !local_session_ )
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

   SCItem* product_item_ = nil;
   {
      product_item_ = [ products_items_ objectAtIndex: 0 ];

      GHAssertTrue( product_item_.parent == nil, @"OK" );
      GHAssertTrue( product_item_ != nil, @"OK" );
      GHAssertTrue( [ product_item_.displayName isEqualToString: @"Products" ], @"OK" );
      GHAssertTrue( product_item_.allChildren == nil, @"OK" );
      GHAssertTrue( product_item_.readChildren == nil, @"OK" );
      GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
      GHAssertTrue( [ product_item_.readFieldsByName count ] == 0, @"OK" );
   }

   //test lenses item
   {
      SCItem* lenses_item_ = [ product_item_.apiContext itemWithPath: @"lenses" ];
      GHAssertTrue( lenses_item_ == nil, @"OK" );
   }

   //test childs
   {
      NSRange childrenRange = NSMakeRange( 1, [ products_items_ count ] - 1 );
      NSArray* children_ = [ products_items_ subarrayWithRange: childrenRange ];
      
      GHAssertTrue( 4 == [ children_ count ], @"OK" );
      for ( SCItem* item_ in children_ )
      {
         GHAssertTrue( item_.parent == nil, @"OK" );
         GHAssertTrue( item_.allChildren == nil, @"OK" );
         GHAssertTrue( item_.readChildren == nil, @"OK" );
         GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
      }
   }
}

@end
