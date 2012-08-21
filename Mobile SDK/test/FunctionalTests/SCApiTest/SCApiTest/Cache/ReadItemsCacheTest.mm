#import "SCAsyncTestCase.h"

@interface ReadItemsCacheTest : SCAsyncTestCase

@end

@implementation ReadItemsCacheTest

//NSString* item_relative_path = @"/sitecore/content/nicam/Products/Lenses/Normal";
NSString* item_full_path = @"/sitecore/content/Nicam/Products/Lenses/Normal";
NSString* item_id = @"{A1FF0BEE-AE21-4BAF-BECD-8029FC89601A}";
NSString* item_display_name = @"Normal";
NSString* parent_display_name = @"Lenses";
int children_count = 3;

//Items Info:
/*
 Items for testing:
 
 Current Item: 
 Name: Normal
 ID: {A1FF0BEE-AE21-4BAF-BECD-8029FC89601A}
 path: Products/Lenses/Normal
 full path: /sitecore/content/Nicam/Products/Lenses/Normal
 template: /sitecore/templates/Nicam/Items Groups/Product Group
 fields: Title, Image
 
 Parent Item:
 Name: Lenses
 path: /sitecore/content/Nicam/Products/Lenses
 template: /sitecore/templates/Nicam/Items Groups/Product Group
 fields: Title, Image
 
 Children: 3
 Name: 24-120mm_f_3_5-5_6G_ED-IF_AF-S_VR_NIKKOR  (
 Display Name: 24-120mm f 3 5-5 6G ED-IF AF-S VR NIKKOR
 path: /sitecore/content/Nicam/Products/Lenses/Normal/24-120mm_f_3_5-5_6G_ED-IF_AF-S_VR_NIKKOR
 template: /sitecore/templates/Components/Products/Lenses
 fields: Title, Image
 
 */

#pragma Read items S
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 0 ----
-(SCItem*)testReadItemSWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 1, @"OK" );

    SCItem* product_item_ = [ products_items_ objectAtIndex: 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( product_item_.allChildren == nil, @"OK" );
    }

    GHAssertTrue( product_item_ != nil, @"OK" );
    GHAssertTrue( [ product_item_.displayName isEqualToString: item_display_name ], @"OK" );
    GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );
    NSLog( @"[ product_item_.allFieldsByName count ]: %d", [ product_item_.allFieldsByName count ]);
    GHAssertTrue( SCNormalLensesAllFieldsCount == [ product_item_.allFieldsByName count ], @"OK" );
    GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );

    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 1 ----
-(SCItem*)testReadItemSWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_ 
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* lenses_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* itemId_ = item_id;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", @"Image", nil ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            lenses_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( lenses_items_ != nil, @"OK" );
    GHAssertTrue( [ lenses_items_ count ] == 1, @"OK" );

    SCItem* lenses_item_ = [ lenses_items_ objectAtIndex: 0 ];
    if ( rootItem_ == nil )
    {
        GHAssertTrue( lenses_item_.parent == nil, @"OK" );
        GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );
        GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );
    }
    GHAssertTrue( lenses_item_ != nil, @"OK" );

    GHAssertTrue( [ lenses_item_.displayName isEqualToString: item_display_name ], @"OK" );
    if (lenses_item_.allFieldsByName == nil )
    {
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 2 <= [ lenses_item_.readFieldsByName count ], @"OK" );
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 2 ----  
-(SCItem*)testReadItemSWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                       selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 1, @"OK" );

    SCItem* product_item_ = [ products_items_ objectAtIndex: 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( product_item_.allChildren == nil, @"OK" );
        GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ product_item_.readFieldsByName count ] == 0, @"OK" );
    }

    GHAssertTrue( product_item_ != nil, @"OK" );
    GHAssertTrue( [ product_item_.displayName isEqualToString: item_display_name ], @"OK" );

    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

#pragma Read items C
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 3 ----
-(SCItem*)testReadItemCWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_children_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil 
                                                                              scope: SCItemReaderChildrenScope ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_children_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ products_children_items_ count ] == children_count, @"OK" );

    for ( SCItem* item_ in products_children_items_ )
    {
        if ( rootItem_ == nil )
        {
            GHAssertTrue( item_.parent == nil, @"OK" );
        }
        GHAssertTrue( [ item_.readFieldsByName count ] != 0, @"OK" );
        GHAssertTrue( [ item_.allFieldsByName    count ] != 0, @"OK" );
        GHAssertTrue( [ item_.allFieldsByName count ] == [ item_.readFieldsByName count ], @"OK" );;
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 4 ----
-(SCItem*)testReadItemCWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* lenses_children_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* itemId_   = item_id;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", @"Image", nil ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: SCItemReaderChildrenScope ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            lenses_children_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ lenses_children_items_ count ] == children_count, @"OK" );

    for ( SCItem* item_ in lenses_children_items_ )
    {
        if ( rootItem_ == nil )
        {
            GHAssertTrue( item_.parent == nil, @"OK" );
            GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        }
        if (item_.allFieldsByName == nil)
        {
            // STODO: If Cache: allFieldsByName != nil
            GHAssertTrue( 2 <= [ item_.readFieldsByName count ], @"OK" );
        }
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 5 ----
-(SCItem*)testReadItemCWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                       selector:( SEL )selector_
{
   __weak __block SCApiContext* apiContext_ = nil;
   __block NSArray* products_children_items_ = nil;

   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
   {
       apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                              login: SCWebApiAdminLogin
                                           password: SCWebApiAdminPassword];

      NSString* path_ = item_full_path;
      NSSet* fieldsNames_ = [ NSSet new ];

      SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: SCItemReaderChildrenScope ];
      [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
      {
         products_children_items_ = items_;
         didFinishCallback_();
      } );
   };

   [ self performAsyncRequestOnMainThreadWithBlock: block_
                                          selector: selector_ ];

   GHAssertTrue( apiContext_ != nil, @"OK" );
   GHAssertTrue( [ products_children_items_ count ] == children_count, @"OK" );

   for( SCItem* item_ in products_children_items_ )
   {
      if ( rootItem_ == nil )
      {
         GHAssertTrue( item_.parent == nil, @"OK" );
         GHAssertTrue( item_.allFieldsByName    == nil, @"OK" );
         GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
      }
   }
   return [ apiContext_ itemWithPath: @"/sitecore" ];
}

#pragma Read items P
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 6 ----
-(SCItem*)testReadItemPWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil 
                                                                              scope: SCItemReaderParentScope ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 1, @"OK" );

    SCItem* product_item_ = [ products_items_ objectAtIndex: 0 ];
    if ( rootItem_ == nil )
    {
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( product_item_.allChildren == nil, @"OK" );
    }
    GHAssertTrue( product_item_ != nil, @"OK" );

    GHAssertTrue( [ product_item_.displayName isEqualToString: parent_display_name ], @"OK" );

    GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );

    GHAssertTrue( SCNormalLensesAllFieldsCount == [ product_item_.allFieldsByName count ], @"OK" );
    GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 7 ----
-(SCItem*)testReadItemPWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* lenses_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* itemId_ = item_id;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", @"Image", nil ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: SCItemReaderParentScope ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            lenses_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( lenses_items_ != nil, @"OK" );
    GHAssertTrue( [ lenses_items_ count ] == 1, @"OK" );

    SCItem* lenses_item_ = [ lenses_items_ objectAtIndex: 0 ];
    if ( rootItem_ == nil )
    {
        GHAssertTrue( lenses_item_.parent == nil, @"OK" );
        GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );
        GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );
    }
    GHAssertTrue( lenses_item_ != nil, @"OK" );
    GHAssertTrue( [ lenses_item_.displayName isEqualToString: parent_display_name ], @"OK" );
    if ( lenses_item_.allFieldsByName == nil )
    {
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 2 <= [ lenses_item_.readFieldsByName count ], @"OK" );
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 8 ----
-(SCItem*)testReadItemPWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                       selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ 
                                                                              scope: SCItemReaderParentScope ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 1, @"OK" );

    SCItem* product_item_ = [ products_items_ objectAtIndex: 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( product_item_.allChildren == nil, @"OK" );
        GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ product_item_.readFieldsByName count ] == 0, @"OK" );
    }

    GHAssertTrue( product_item_ != nil, @"OK" );
    GHAssertTrue( [ product_item_.displayName isEqualToString: parent_display_name ], @"OK" );

    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

#pragma Read items SC
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 9 ----
-(SCItem*)testReadItemSCWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)(SCItemReaderSelfScope | SCItemReaderChildrenScope);
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
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

    SCItem* product_item_ = [ products_items_ objectAtIndex: 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( product_item_.parent == nil, @"OK" );
    }

    GHAssertTrue( product_item_ != nil, @"OK" );
    GHAssertTrue( [ product_item_.displayName isEqualToString: item_display_name ], @"OK" );

    GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );

    GHAssertTrue( SCNormalLensesAllFieldsCount == [ product_item_.allFieldsByName count ], @"OK" );
    GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );

    GHAssertTrue( [ product_item_.allChildren count ] == children_count, @"OK" );
    GHAssertTrue( [ product_item_.readChildren count ] == [ product_item_.allChildren count ], @"OK" );

    for ( SCItem* item_ in product_item_.allChildren )
    {
        GHAssertTrue( item_.parent == product_item_, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] != 0, @"OK" );
        GHAssertTrue( [ item_.allFieldsByName count ] != 0, @"OK" );
        GHAssertTrue( [ item_.allFieldsByName count ] == [ item_.readFieldsByName count ], @"OK" );;
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 10 ----
-(SCItem*)testReadItemSCWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                          selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* lenses_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* itemId_   = item_id;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", @"Image", nil ];

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)(SCItemReaderSelfScope | SCItemReaderChildrenScope);
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: scope_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            lenses_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( lenses_items_ != nil, @"OK" );
    GHAssertTrue( [ lenses_items_ count ] >= 1, @"OK" );

    SCItem* lenses_item_ = [ lenses_items_ objectAtIndex: 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( lenses_item_.parent == nil, @"OK" );
        GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );
    }

    GHAssertTrue( lenses_item_ != nil, @"OK" );
    GHAssertTrue( [ lenses_item_.displayName isEqualToString: item_display_name ], @"OK" );
    if ( lenses_item_.allFieldsByName == nil )
    {
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 2 <= [ lenses_item_.readFieldsByName count ], @"OK" );
    }
    GHAssertTrue( [ lenses_item_.allChildren count ] == children_count, @"OK" );
    GHAssertTrue( [ lenses_item_.readChildren count ] == [ lenses_item_.allChildren count ], @"OK" );

    for ( SCItem* item_ in lenses_item_.readChildren )
    {
        GHAssertTrue( item_.parent == lenses_item_, @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        }
        if ( item_.allFieldsByName == nil )
        {
            // STODO: If Cache: allFieldsByName != nil
            GHAssertTrue( 2 <= [ item_.readFieldsByName count ], @"OK" );
        }
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 11 ----
-(SCItem*)testReadItemSCWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)(SCItemReaderSelfScope | SCItemReaderChildrenScope);
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ 
                                                                              scope: scope_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

    SCItem* product_item_ = [ products_items_ objectAtIndex: 0 ];

    if ( rootItem_ == nil )
    {
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ product_item_.readFieldsByName count ] == 0, @"OK" );
    }
    GHAssertTrue( product_item_ != nil, @"OK" );
    GHAssertTrue( [ product_item_.displayName isEqualToString: item_display_name ], @"OK" );

    GHAssertTrue( [ product_item_.allChildren count ] == children_count, @"OK" );
    GHAssertTrue( [ product_item_.readChildren count ] == [ product_item_.allChildren count ], @"OK" );

    for ( SCItem* item_ in product_item_.allChildren )
    {
        GHAssertTrue( item_.parent == product_item_, @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( item_.allFieldsByName    == nil, @"OK" );
            GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
        }
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}


#pragma Read items SP
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 12 ----
-(SCItem*)testReadItemSPWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)(SCItemReaderSelfScope | SCItemReaderParentScope);
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
                                           selector: selector_ ];

    SCItem* product_item_ = nil;

    //test products item
    {
        GHAssertTrue( products_items_ != nil, @"OK" );
        GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

        product_item_ = [ products_items_ objectAtIndex: 0 ];

        GHAssertTrue( product_item_.readChildren != nil, @"OK" );

        if ( rootItem_ == nil )
        {
            GHAssertTrue( product_item_.parent == nil, @"OK" );
            GHAssertTrue( product_item_.allChildren == nil, @"OK" );
            GHAssertTrue( [ product_item_.readChildren count ] == 1, @"OK" );
        }

        GHAssertTrue( product_item_ != nil, @"OK" );

        GHAssertTrue( [ product_item_.displayName isEqualToString: parent_display_name ], @"OK" );

        GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );

        GHAssertTrue( SCNormalLensesAllFieldsCount == [ product_item_.allFieldsByName count ], @"OK" );
        GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );
    }

    //test lenses item
    {
        //STODO get item via property readChildren
        SCItem* lenses_item_ = [ product_item_.readChildren objectAtIndex: 0 ];

        GHAssertTrue( lenses_item_ != nil, @"OK" );

        GHAssertTrue( lenses_item_.parent == product_item_, @"OK" );
        GHAssertTrue( [ lenses_item_.displayName isEqualToString: item_display_name ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );
            GHAssertTrue( lenses_item_.readChildren == nil, @"OK" );
        }
        GHAssertTrue( lenses_item_.allFieldsByName != nil, @"OK" );

        GHAssertTrue( 3 <= [ lenses_item_.allFieldsByName count ], @"OK" );
        GHAssertTrue( [ lenses_item_.allFieldsByName count ] == [ lenses_item_.readFieldsByName count ], @"OK" );
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 13 ----
// stop modifying tests
-(SCItem*)testReadItemSPWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                          selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* lenses_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* itemId_ = item_id;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", @"Image", nil ];

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)(SCItemReaderSelfScope | SCItemReaderParentScope);
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: scope_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            lenses_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    SCItem* lenses_item_ = nil;

    GHAssertTrue( apiContext_ != nil, @"OK" );
    //test lenses item
    {
        GHAssertTrue( lenses_items_ != nil, @"OK" );
        GHAssertTrue( [ lenses_items_ count ] >= 1, @"OK" );

        lenses_item_ = [ lenses_items_ objectAtIndex: 0 ];
        GHAssertTrue( lenses_item_.readChildren != nil, @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( lenses_item_.parent == nil, @"OK" );
            GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );
            GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ lenses_item_.readChildren count ] == 1, @"OK" );
        }

        GHAssertTrue( lenses_item_ != nil, @"OK" );
        GHAssertTrue( [ lenses_item_.displayName isEqualToString: parent_display_name ], @"OK" );
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 2 <= [ lenses_item_.readFieldsByName count ], @"OK" );
    }

    //test macro item
    {
        //STODO get item via property readChildren
        SCItem* macro_item_ = [ apiContext_ itemWithPath: item_full_path ];

        GHAssertTrue( macro_item_ != nil, @"OK" );

        GHAssertTrue( macro_item_.parent == lenses_item_, @"OK" );
        GHAssertTrue( [ macro_item_.displayName isEqualToString: item_display_name ], @"OK" );

        if (rootItem_ == nil )
        {
            GHAssertTrue( macro_item_.allChildren == nil, @"OK" );
            GHAssertTrue( macro_item_.readChildren == nil, @"OK" );
            GHAssertTrue( macro_item_.allFieldsByName == nil, @"OK" );
        }
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 2 <= [ macro_item_.readFieldsByName count ], @"OK" );
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 14 ----
-(SCItem*)testReadItemSPWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)(SCItemReaderSelfScope | SCItemReaderParentScope);
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ 
                                                                              scope: scope_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    SCItem* product_item_ = nil;
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //test products item
    {
        GHAssertTrue( products_items_ != nil, @"OK" );
        GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

        product_item_ = [ products_items_ objectAtIndex: 0 ];
        GHAssertTrue( product_item_ != nil, @"OK" );
        GHAssertTrue( product_item_.readChildren != nil, @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( product_item_.parent == nil, @"OK" );
            GHAssertTrue( product_item_.allChildren == nil, @"OK" );
            GHAssertTrue( [ product_item_.readChildren count ] == 1, @"OK" );
            GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ product_item_.readFieldsByName count ] == 0, @"OK" );
        }

        GHAssertTrue( [ product_item_.displayName isEqualToString: parent_display_name ], @"OK" );
    }

    //test lenses item
    {
        SCItem* lenses_item_ = [ apiContext_ itemWithPath: item_full_path ];

        GHAssertTrue( lenses_item_ != nil, @"OK" );
        GHAssertTrue( lenses_item_.parent == product_item_, @"OK" );
        GHAssertTrue( [ lenses_item_.displayName isEqualToString: item_display_name ], @"OK" );

        if ( rootItem_ == nil )
        {
            GHAssertTrue( lenses_item_.parent == product_item_, @"OK" );
            GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );
            GHAssertTrue( lenses_item_.readChildren == nil, @"OK" );
            GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ lenses_item_.readFieldsByName count ] == 0, @"OK" );
        }
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

#pragma Read items CP
//by relative path
// 0(-),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 15 ----
-(SCItem*)testReadItemCPWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)( SCItemReaderParentScope | SCItemReaderChildrenScope );
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
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

    SCItem* product_item_ = [ products_items_ objectAtIndex: 0 ];

    GHAssertTrue( product_item_ != nil, @"OK" );

    {
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( [ product_item_.displayName isEqualToString: parent_display_name ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( product_item_.allChildren == nil, @"OK" );
            GHAssertTrue( product_item_.readChildren == nil, @"OK" );
            GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );
        }

        GHAssertTrue( SCNormalLensesAllFieldsCount == [ product_item_.allFieldsByName count ], @"OK" );
        GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );
    }

    //test childs
    {
        NSLog( @"products_items_ count: %d", [ products_items_ count ] );
        NSRange childrenRange = NSMakeRange( 1, [ products_items_ count ] - 1 );
        NSArray* children_ = [ products_items_ subarrayWithRange: childrenRange ];
        GHAssertTrue( children_count == [ children_ count ], @"OK" );
        for ( SCItem* item_ in children_ )
        {
            GHAssertTrue( item_ != nil, @"OK" );
            if ( rootItem_ == nil )
            {
                GHAssertTrue( item_.parent == nil, @"OK" );
                GHAssertTrue( item_.allChildren == nil, @"OK" );
                GHAssertTrue( item_.readChildren == nil, @"OK" );
            }
        }
    }

    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by item id
// 0(-),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 16 ----
-(SCItem*)testReadItemCPWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                          selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* lenses_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* itemId_ = item_id;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", @"Image", nil ];

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)(SCItemReaderParentScope | SCItemReaderChildrenScope);
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: scope_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            lenses_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( lenses_items_ != nil, @"OK" );
    GHAssertTrue( [ lenses_items_ count ] >= 1, @"OK" );

    {
        SCItem* lenses_item_ = [ lenses_items_ objectAtIndex: 0 ];

        GHAssertTrue( lenses_item_.parent == nil, @"OK" );
        GHAssertTrue( lenses_item_ != nil, @"OK" );
        GHAssertTrue( [ lenses_item_.displayName isEqualToString: parent_display_name ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );
            GHAssertTrue( lenses_item_.readChildren == nil, @"OK" );
            GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );
        }
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 2 <= [ lenses_item_.readFieldsByName count ], @"OK" );
    }

    {
        NSRange childrenRange = NSMakeRange( 1, [ lenses_items_ count ] - 1 );
        NSArray* children_ = [ lenses_items_ subarrayWithRange: childrenRange ];
        GHAssertTrue( children_count == [ children_ count ], @"OK" );
        for ( SCItem* item_ in children_ )
        {
            if ( rootItem_ == nil )
            {
                GHAssertTrue( item_.parent == nil, @"OK" );
                GHAssertTrue( item_.allChildren == nil, @"OK" );
                GHAssertTrue( item_.readChildren == nil, @"OK" );
                GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
            }
            GHAssertTrue( 2 <= [ item_.readFieldsByName count ], @"OK" );
        }
    }

    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by absolute path
// 0(-),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 17 ----
-(SCItem*)testReadItemCPWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                        selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)(SCItemReaderParentScope | SCItemReaderChildrenScope);
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ 
                                                                              scope: scope_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

    {
        SCItem* product_item_ = [ products_items_ objectAtIndex: 0 ];

        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( product_item_ != nil, @"OK" );
        GHAssertTrue( [ product_item_.displayName isEqualToString: parent_display_name ], @"OK" );
        if (rootItem_ == nil )
        {
            GHAssertTrue( product_item_.allChildren == nil, @"OK" );
            GHAssertTrue( product_item_.readChildren == nil, @"OK" );
            GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ product_item_.readFieldsByName count ] == 0, @"OK" );
        }
    }

    {
        NSRange childrenRange = NSMakeRange( 1, [ products_items_ count ] - 1 );
        NSArray* children_ = [ products_items_ subarrayWithRange: childrenRange ];
        GHAssertTrue( children_count == [ children_ count ], @"OK" );
        for ( SCItem* item_ in children_ )
        {
            if ( rootItem_ == nil )
            {
                GHAssertTrue( item_.parent == nil, @"OK" );
                GHAssertTrue( item_.allChildren == nil, @"OK" );
                GHAssertTrue( item_.readChildren == nil, @"OK" );
                GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
            }
        }
    }

    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

#pragma Read items SCP
//by relative path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 18 ----
-(SCItem*)testReadItemSCPWithAllFieldsWithRootItem:( SCItem* )rootItem_
                                          selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)(SCItemReaderSelfScope | SCItemReaderParentScope | SCItemReaderChildrenScope);
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
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

    SCItem* product_item_ = nil;

    //test parent item
    {
        product_item_ = [ products_items_ objectAtIndex: 0 ];
        GHAssertTrue( product_item_ != nil, @"OK" );
        GHAssertTrue( [ product_item_.displayName isEqualToString: parent_display_name ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( product_item_.parent == nil, @"OK" );
            GHAssertTrue( product_item_.allChildren == nil, @"OK" );
        }
        GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );

        GHAssertTrue( SCNormalLensesAllFieldsCount == [ product_item_.allFieldsByName count ], @"OK" );
        GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );
    }

    //test self with children item
    {
        SCItem* lenses_item_ = [ apiContext_ itemWithPath: item_full_path ];

        GHAssertTrue( lenses_item_ != nil, @"OK" );

        GHAssertTrue( lenses_item_.parent == product_item_, @"OK" );
        GHAssertTrue( [ lenses_item_.displayName isEqualToString: item_display_name ], @"OK" );
        GHAssertTrue( lenses_item_.allFieldsByName != nil, @"OK" );

        GHAssertTrue( 3 <= [ lenses_item_.allFieldsByName count ], @"OK" );
        GHAssertTrue( [ lenses_item_.allFieldsByName count ] == [ lenses_item_.readFieldsByName count ], @"OK" );

        GHAssertTrue( [ lenses_item_.allChildren count ] == children_count, @"OK" );

        for ( SCItem* item_ in lenses_item_.allChildren )
        {
            GHAssertTrue( item_.parent == lenses_item_, @"OK" );
            GHAssertTrue( [ item_.readFieldsByName count ] != 0, @"OK" );
            GHAssertTrue( [ item_.allFieldsByName    count ] != 0, @"OK" );
            GHAssertTrue( [ item_.allFieldsByName count ] == [ item_.readFieldsByName count ], @"OK" );;
        }
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by item id
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 19 ----
-(SCItem*)testReadItemSCPWithSomeFieldsWithRootItem:( SCItem* )rootItem_
                                           selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* lenses_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* itemId_ = item_id;
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", @"Image", nil ];

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)(SCItemReaderSelfScope | SCItemReaderParentScope | SCItemReaderChildrenScope);
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId_
                                                                      fieldsNames: fieldsNames_ 
                                                                            scope: scope_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            lenses_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( lenses_items_ != nil, @"OK" );
    GHAssertTrue( [ lenses_items_ count ] >= 1, @"OK" );

    SCItem* lenses_item_ = nil;
    //test parent item
    {
        lenses_item_ = [ lenses_items_ objectAtIndex: 0 ];

        GHAssertTrue( lenses_item_ != nil, @"OK" );
        GHAssertTrue( [ lenses_item_.displayName isEqualToString: parent_display_name ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( lenses_item_.parent == nil, @"OK" );
            GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );
            GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );
        }
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 2 <= [ lenses_item_.readFieldsByName count ], @"OK" );
    }

    //test self with children item
    {
        SCItem* macro_item_ = [ apiContext_ itemWithPath: item_full_path ];

        GHAssertTrue( macro_item_ != nil, @"OK" );
        GHAssertTrue( macro_item_.parent == lenses_item_, @"OK" );
        GHAssertTrue( [ macro_item_.displayName isEqualToString: item_display_name ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( macro_item_.allFieldsByName == nil, @"OK" );
        }
        // STODO: If Cache: allFieldsByName != nil
        GHAssertTrue( 2 <= [ macro_item_.readFieldsByName count ], @"OK" );

        GHAssertTrue( [ macro_item_.allChildren count ] == children_count, @"OK" );

        for ( SCItem* item_ in macro_item_.allChildren )
        {
            GHAssertTrue( item_.parent == macro_item_, @"OK" );
            if ( rootItem_ == nil )
            {
                GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
            }
            // STODO: If Cache: allFieldsByName != nil
            GHAssertTrue( 2 <= [ item_.readFieldsByName count ], @"OK" );
        }
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

//by absolute path
// 0(+),2(-),3(-),4(-),5(-),6(-),7(-)   ---- 20 ----
-(SCItem*)testReadItemSCPWithNoFieldsWithRootItem:( SCItem* )rootItem_
                                         selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword];

        NSString* path_ = item_full_path;
        NSSet* fieldsNames_ = [ NSSet new ];

        SCItemReaderScopeType scope_ = (SCItemReaderScopeType)(SCItemReaderSelfScope | SCItemReaderParentScope | SCItemReaderChildrenScope);
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: fieldsNames_ 
                                                                              scope: scope_ ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: selector_ ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] >= 1, @"OK" );

    SCItem* product_item_ = nil;

    //test parent item
    {
        product_item_ = [ products_items_ objectAtIndex: 0 ];

        GHAssertTrue( product_item_ != nil, @"OK" );
        GHAssertTrue( [ product_item_.displayName isEqualToString: parent_display_name ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( product_item_.parent == nil, @"OK" );
            GHAssertTrue( product_item_.allChildren == nil, @"OK" );
            GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ product_item_.readFieldsByName count ] == 0, @"OK" );
        }
    }

    //test self with children item
    {
        SCItem* lenses_item_ = [ apiContext_ itemWithPath: item_full_path ];

        GHAssertTrue( lenses_item_ != nil, @"OK" );
        GHAssertTrue( lenses_item_.parent == product_item_, @"OK" );
        GHAssertTrue( [ lenses_item_.displayName isEqualToString: item_display_name ], @"OK" );
        if ( rootItem_ == nil )
        {
            GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );
            GHAssertTrue( [ lenses_item_.readFieldsByName count ] == 0, @"OK" );
        }
        GHAssertTrue( [ lenses_item_.allChildren count ] == children_count, @"OK" );

        for ( SCItem* item_ in lenses_item_.allChildren )
        {
            GHAssertTrue( item_.parent == lenses_item_, @"OK" );
            if ( rootItem_ == nil )
            {
                GHAssertTrue( item_.allFieldsByName  == nil, @"OK" );
                GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
            }
        }
    }
    return [ apiContext_ itemWithPath: @"/sitecore" ];
}

-(void)testReadItemsSWithAndWithoutFieldsWithCache
{
    typedef SCItem*(^LensesBlock)(SCItem*, SEL);
    NSMutableArray* array_ = [ NSMutableArray new ];
    //   NSMutableArray* inner_array_ = [ NSMutableArray new ];
    //Add block functions to array
    {
        //Read items S
        LensesBlock block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSWithAllFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSWithSomeFieldsWithRootItem: rootItem_ 
                                                         selector: selector_];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSWithNoFieldsWithRootItem: rootItem_  
                                                       selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        //Read items C
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCWithAllFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCWithSomeFieldsWithRootItem: rootItem_   
                                                         selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCWithNoFieldsWithRootItem: rootItem_   
                                                       selector: selector_ ];
        };
        [ array_ addObject: block_ ];

        //Read items P
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemPWithAllFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemPWithSomeFieldsWithRootItem: rootItem_   
                                                         selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemPWithNoFieldsWithRootItem: rootItem_   
                                                       selector: selector_ ];
        };
        [ array_ addObject: block_ ];

        //Read items SC
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCWithAllFieldsWithRootItem: rootItem_   
                                                         selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCWithSomeFieldsWithRootItem: rootItem_   
                                                          selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCWithNoFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];

        //Read items SP
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSPWithAllFieldsWithRootItem: rootItem_   
                                                         selector: selector_ ];
        };
        [ array_ addObject: block_ ];
      
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSPWithSomeFieldsWithRootItem: rootItem_   
                                                          selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSPWithNoFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];

        //Read items CP
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCPWithAllFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCPWithSomeFieldsWithRootItem: rootItem_   
                                                          selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemCPWithNoFieldsWithRootItem: rootItem_   
                                                        selector: selector_ ];
        };
        [ array_ addObject: block_ ];

        //Read items SCP
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCPWithAllFieldsWithRootItem: rootItem_   
                                                          selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCPWithSomeFieldsWithRootItem: rootItem_   
                                                           selector: selector_ ];
        };
        [ array_ addObject: block_ ];
        block_ = ^( SCItem* rootItem_, SEL selector_)
        {
            return [ self testReadItemSCPWithNoFieldsWithRootItem: rootItem_   
                                                         selector: selector_ ];
        };
        [ array_ addObject: block_ ];
    }

    for ( int i = 0; i < [ array_ count ]; ++i )
    {
        for ( int j = 0; j < [ array_ count ]; ++j )
        {
            NSLog( @"for: i=%d, j=%d", i, j );
            @autoreleasepool
            {
                LensesBlock block1_ = [ array_ objectAtIndex: i ];
                LensesBlock block2_ = [ array_ objectAtIndex: j ];

                SCItem* rootItem_ = block1_( nil, _cmd );
                block2_( rootItem_, _cmd );
            }
        }
    }
}
@end
