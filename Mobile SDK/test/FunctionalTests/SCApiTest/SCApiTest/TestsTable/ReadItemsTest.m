#import "SCAsyncTestCase.h"

@interface ReadItemsTest : SCAsyncTestCase
@end

@implementation ReadItemsTest

-(void)testFieldsOfProsuctsItem:( SCItem* )item_
{
    GHAssertTrue( [ item_.displayName isEqualToString: @"Products" ], @"OK" );
    GHAssertTrue( [ item_.path isEqualToString: @"/sitecore/content/nicam/products" ], @"OK" );
    GHAssertTrue( item_.hasChildren, @"OK" );
    GHAssertTrue( [ item_.itemId isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}" ], @"OK" );
    GHAssertTrue( [ item_.itemTemplate isEqualToString: @"Nicam/Item Types/Site Section" ], @"OK" );
}

-(void)testReadProductsItemWithRelativePath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* products_item_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSString* path_ = @"/sitecore/content/nicam/products";

        [ local_session_ itemReaderForItemPath: path_ ]( ^( SCItem* item_, NSError* error_ )
        {
            products_item_ = item_;
            didFinishCallback_();
        } );

        apiContext_ = local_session_;
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_item_ != nil, @"Nicam item should be read" );

    [ self testFieldsOfProsuctsItem: products_item_ ];
}

-(void)testReadProductsItemWithAbsolutePath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* products_item_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSString* path_ = @"/sitecore/content/nicam/products";

        [ local_session_ itemReaderForItemPath: path_ ]( ^( SCItem* item_, NSError* error_ )
        {
            products_item_ = item_;
            didFinishCallback_();
        } );

        apiContext_ = local_session_;
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( products_item_ != nil, @"OK" );

    [ self testFieldsOfProsuctsItem: products_item_ ];
}

-(void)testRetainRelations
{
    // a(content) -> b(nicam) -> c(products)
    //1. a reads c
    //2. a reads b
    //3. release a
    //4. get c via b after finish
    __weak __block SCApiContext* apiContext_ = nil;
    __weak __block SCItem* content_item_ = nil;
    __block SCItem* nicam_item_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        apiContext_ = local_session_;

        NSString* content_path_ = @"/sitecore/content";
        [ local_session_ itemReaderForItemPath: content_path_ ]( ^( SCItem* item_, NSError* error_ )
        {
            if ( error_ )
            {
                didFinishCallback_();
                return;
            }
            content_item_ = item_;
            NSString* products_path_ = @"/sitecore/content/nicam/products";
            [ item_.apiContext itemReaderForItemPath: products_path_ ]( ^( SCItem* products_item_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSString* nicam_path_ = @"/sitecore/content/nicam";
                [ products_item_.apiContext itemReaderForItemPath: nicam_path_ ]( ^( SCItem* item_, NSError* error_ )
                {
                    [ products_item_ class ];//retain products_item_ while reading the nicam item
                    nicam_item_ = item_;
                    didFinishCallback_();
                } );
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( content_item_ == nil, @"OK" );
    GHAssertTrue( nicam_item_ != nil, @"OK" );

    SCItem* products_item_ = [ nicam_item_.apiContext itemWithPath: @"/sitecore/content/nicam/products" ];
    GHAssertTrue( products_item_ != nil, @"OK" );
    [ self testFieldsOfProsuctsItem: products_item_ ];
}

-(void)testProductsItemChildren:( NSArray* )products_children_
{
    GHAssertTrue( products_children_ != nil, @"OK" );

    GHAssertTrue( [ products_children_ count ] == SCProductsChildrenItemsCount, @"OK" );
}

//STODO fix the order of all Children
-(void)testChildren:( NSArray* )children1_
    equalToChildren:( NSArray* )children2_
{
    GHAssertTrue( [ children1_ count ] == [ children2_ count ], @"OK" );

    NSComparator comparator_ = ^NSComparisonResult( SCItem* item1_, SCItem* item2_ )
    {
        return [ item1_.itemId compare: item2_.itemId ];
    };

    children1_ = [ children1_ sortedArrayUsingComparator: comparator_ ];
    children2_ = [ children2_ sortedArrayUsingComparator: comparator_ ];

    for ( NSUInteger index_ = 0; index_ < [ children1_ count ]; ++index_ )
    {
        SCItem* item1_ = [ children1_ objectAtIndex: index_ ];
        SCItem* item2_ = [ children2_ objectAtIndex: index_ ];
        if ( item1_ != item2_ )
            GHFail( @"fail" );
    }
}

-(void)testGetChildren
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* products_item_ = nil;
    __block NSArray* products_children_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSString* path_ = @"/sitecore/content/nicam/products";

        [ local_session_ itemReaderForItemPath: path_ ]( ^( SCItem* item_, NSError* error_ )
        {
            products_item_ = item_;
            if ( !products_item_ )
            {
                didFinishCallback_();
            }
            else
            {
                [ products_item_ childrenReader ]( ^( NSArray* children_, NSError* error_ )
                {
                    products_children_ = children_;
                    didFinishCallback_();
                } );
            }
        } );

        apiContext_ = local_session_;
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_item_ != nil, @"Nicam item should be read" );

    GHAssertTrue( products_children_ != nil, @"Nicam item should be read" );

    [ self testChildren: products_item_.allChildren
        equalToChildren: products_children_ ];

    [ self testProductsItemChildren: products_children_ ];
}

-(void)testGetChildrenForItemWithPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* products_item_ = nil;
    __block NSArray* products_children_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSString* path_ = @"/sitecore/content/nicam/products";

        [ local_session_ childrenReaderWithItemPath: path_ ]( ^( NSArray* children_, NSError* error_ )
        {
            products_item_ = [ local_session_ itemWithPath: path_ ];
            products_children_ = children_;
            didFinishCallback_();
        } );

        apiContext_ = local_session_;
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                          selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_item_ == nil, @"Nicam item should be read" );

    GHAssertTrue( products_children_ != nil, @"Nicam item should be read" );
    [ self testProductsItemChildren: products_children_ ];
}

////////////////////////////////

// a(content) -> b(nicam) -> c(products)
//1. a reads b(1)
//2. b(1) reads c
//3. a reads children
//4. check that b(1) released
//5. check that b(2) and c exists

-(void)testRetainRelationsWhenGetChildren
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* content_item_ = nil;
    __weak __block SCItem* nicam1_item_ = nil;
    __weak __block SCItem* products_item_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        apiContext_ = local_session_;

        NSString* content_path_ = @"/sitecore/content";
        [ local_session_ itemReaderForItemPath: content_path_ ]( ^( SCItem* item_
                                                                   , NSError* error_ )
        {
            if ( error_ )
            {
                didFinishCallback_();
                return;
            }
            content_item_ = item_;

            [ content_item_.apiContext itemReaderForItemPath: @"/sitecore/content/nicam" ]( ^( SCItem* local_nicam_item_
                                                                                              , NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                nicam1_item_ = local_nicam_item_;

                [ nicam1_item_.apiContext itemReaderForItemPath: @"/sitecore/content/nicam/products" ]( ^( SCItem* local_products_item_
                                                                                                          , NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    products_item_ = local_products_item_;

                    [ content_item_ childrenReader ]( ^( NSArray* children_, NSError* error_ )
                    {
                        didFinishCallback_();
                    } );
                } );
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( content_item_ != nil, @"OK" );
    GHAssertTrue( nicam1_item_ == nil, @"OK" );
    GHAssertTrue( [ content_item_.allChildren count ] == 9, @"OK" );

    SCItem* nicam2_item_ = [ content_item_.apiContext itemWithPath: @"/sitecore/content/nicam" ];
    GHAssertTrue( nicam2_item_ != nil, @"OK" );

    GHAssertTrue( products_item_ == nil, @"OK" );
    SCItem* current_products_item_ = [ nicam2_item_.apiContext itemWithPath: @"/sitecore/content/nicam/products" ];
    GHAssertTrue( current_products_item_ != nil, @"OK" );
}

//STODO test this on fail
-(void)testGetNotExistingItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* content_item_ = nil;
    __block SCItem* found_item_ = nil;
    __block NSError* found_error_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        apiContext_ = local_session_;

        NSString* content_path_ = @"/sitecore/content";
        [ local_session_ itemReaderForItemPath: content_path_ ]( ^( SCItem* item_
                                                                   , NSError* error_ )
        {
            if ( error_ )
            {
                didFinishCallback_();
                return;
            }
            content_item_ = item_;

            [ content_item_.apiContext itemReaderForItemPath: @"nicamTraTararam" ]( ^( SCItem* local_found_item_
                                                                                      , NSError* error_ )
            {
                found_item_  = local_found_item_;
                found_error_ = error_;
                didFinishCallback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( content_item_ != nil, @"OK" );
    GHAssertTrue( found_item_ == nil, @"OK" );
    GHAssertTrue( found_error_ != nil, @"OK" );
}

-(void)testGetItemFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* lenses_item_ = nil;
    __block NSDictionary* lenses_fields_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        apiContext_ = local_session_;

        NSString* lenses_path_ = @"/sitecore/content/nicam/products/lenses";
        
        if( !local_session_ )
        {
            didFinishCallback_();
            return;
        }
        [ local_session_ itemReaderForItemPath: lenses_path_ ]( ^( SCItem* item_, NSError* error_ )
        {
            if ( error_ )
            {
                didFinishCallback_();
                return;
            }
            lenses_item_ = item_;

            [ lenses_item_ fieldsReaderForFieldsNames: nil ]( ^( NSDictionary* fields_, NSError* error_ )
            {
                lenses_fields_ = fields_;
                didFinishCallback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_    != nil, @"OK" );
    GHAssertTrue( lenses_item_   != nil, @"OK" );
    GHAssertTrue( lenses_fields_ != nil, @"OK" );

    SCField* menuField_ = [ lenses_item_ fieldWithName: @"Menu title" ];
    GHAssertTrue( menuField_.item != nil, @"OK" );
    GHAssertTrue( menuField_.item == lenses_item_, @"OK" );

    GHAssertTrue( [ [ lenses_item_ fieldValueWithName: @"Menu title" ] isEqualToString: @"Lenses" ], @"OK" );
    GHAssertTrue( [ [ lenses_item_ fieldValueWithName: @"Title" ] isEqualToString: @"Lenses" ], @"OK" );

    __block BOOL testPassed_ = NO;
    void (^block2_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        __block NSDictionary* lensesFields2_ = nil;
        [ lenses_item_ fieldsReaderForFieldsNames: nil ]( ^( NSDictionary* fields_, NSError* error_ )
        {
            lensesFields2_ = fields_;
        } );
        testPassed_ = ( [ [ lensesFields2_ allKeys ] isEqual: [ lenses_fields_ allKeys ] ] );

        didFinishCallback_();
    };
    [ self performAsyncRequestOnMainThreadWithBlock: block2_
                                           selector: _cmd ];

    GHAssertTrue( testPassed_, @"OK" );
}

-(void)testGetFieldValue
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* r1_item_      = nil;
    __block SCField* image_field_ = nil;
    __block UIImage* image_       = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        apiContext_ = local_session_;

        NSString* item_path_ = @"/sitecore/content/Nicam/Products/Accessories/Flash/R1";
        if( !local_session_ )
        {
            didFinishCallback_();
            return;
        }
        [ local_session_ itemReaderForItemPath: item_path_ ]( ^( SCItem* item_, NSError* error_ )
        {
            if ( error_ )
            {
                didFinishCallback_();
                return;
            }
            r1_item_ = item_;

            [ r1_item_ fieldsReaderForFieldsNames: nil ]( ^( NSDictionary* fields_, NSError* error_ )
            {
                image_field_ = [ fields_ objectForKey: @"Image" ];
                if ( !image_field_ )
                {
                    didFinishCallback_();
                    return;
                }
                [ image_field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                {
                    image_ = (UIImage*)result_;
                    didFinishCallback_();
                } );
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_  != nil, @"OK" );
    GHAssertTrue( r1_item_     != nil, @"OK" );
    GHAssertTrue( image_field_ != nil, @"OK" );
    GHAssertTrue( image_       != nil, @"OK" );

    GHAssertTrue( image_field_.item != nil     , @"OK" );
    GHAssertTrue( image_field_.item == r1_item_, @"OK" );

    GHAssertTrue( [ image_field_.name isEqualToString: @"Image" ], @"OK" );
}

-(void)testFieldsReaderForItemWithPath
{
   __weak __block SCApiContext* apiContext_ = nil;
   __block NSDictionary* lenses_fields_ = nil;

   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
   {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        apiContext_ = local_session_;

        NSString* lenses_path_ = @"/sitecore/content/nicam/products/lenses";
        SCAsyncOp reader_ = [ local_session_ itemReaderWithFieldsNames: nil
                                                              itemPath: lenses_path_ ];
        reader_( ^( SCItem* item_, NSError* error_ )
        {
            lenses_fields_ = item_.allFieldsByName;
            didFinishCallback_();
        } );
   };

   [ self performAsyncRequestOnMainThreadWithBlock: block_
                                          selector: _cmd ];

   GHAssertTrue( apiContext_ != nil, @"OK" );
   GHAssertTrue( lenses_fields_ != nil, @"OK" );

   GHAssertTrue( [ [ [ lenses_fields_ objectForKey: @"Menu title" ] rawValue ] isEqualToString: @"Lenses" ], @"OK" );
   GHAssertTrue( [ [ [ lenses_fields_ objectForKey: @"Title"      ] rawValue ] isEqualToString: @"Lenses" ], @"OK" );
}

-(void)testChildrenFieldsValuesReaderForItemWithPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;

    @autoreleasepool
    {
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", @"Tab Icon", nil ];
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.request = @"/sitecore/content/nicam/child::*[@@templatename='Site Section']";
        request_.requestType = SCItemReaderRequestQuery;
        request_.fieldNames = fieldsNames_;
        request_.flags = SCItemReaderRequestReadFieldsValues;

        SCAsyncOp asyncOp_ = [ apiContext_ itemsReaderWithRequest: request_ ];
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            asyncOp_( ^( id result_, NSError* error_ )
            {
                items_ = result_;
                didFinishCallback_();
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( items_  != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 4, @"OK" );

    SCItem* firstItem_ = [ items_ objectAtIndex: 0 ];
    SCItem* lastItem_ = [ items_ lastObject ];

    NSString* firstTitle_ = [ firstItem_ fieldValueWithName: @"Title" ];
    UIImage*  firstImage_ = [ firstItem_ fieldValueWithName: @"Tab Icon" ];

    GHAssertTrue( [ firstTitle_ isEqualToString: @"Products" ], @"OK" );
    GHAssertTrue( firstImage_ != nil, @"OK" );

    NSString* secondTitle_ = [ lastItem_ fieldValueWithName: @"Title" ];
    UIImage*  secondImage_ = [ lastItem_ fieldValueWithName: @"Tab Icon" ];

    GHAssertTrue( [ secondTitle_ isEqualToString: @"Company" ], @"OK" );
    GHAssertTrue( secondImage_ != nil, @"OK" );
}

//fieldsValuesReaderForFieldsNames

-(void)testFieldsValuesReaderForFieldsNames
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* lenses_item_ = nil;
    __block NSDictionary* lenses_fields_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        apiContext_ = local_session_;

        NSString* lenses_path_ = @"/sitecore/content/nicam/products/lenses";
        [ local_session_ itemReaderForItemPath: lenses_path_ ]( ^( SCItem* item_, NSError* error_ )
        {
            if ( error_ )
            {
                didFinishCallback_();
                return;
            }
            lenses_item_ = item_;

            NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Image", @"Title", nil ];
            if( !lenses_item_ )
            {
                didFinishCallback_();
                return;
            }
            [ lenses_item_ fieldsValuesReaderForFieldsNames: fieldsNames_ ]( ^( NSDictionary* fields_
                                                                               , NSError* error_ )
            {
                lenses_fields_ = fields_;
                didFinishCallback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_    != nil, @"OK" );
    GHAssertTrue( lenses_item_   != nil, @"OK" );
    GHAssertTrue( lenses_fields_ != nil, @"OK" );

    GHAssertTrue( [ [ lenses_fields_ objectForKey: @"Image" ] isKindOfClass: [ UIImage class ] ], @"OK" );
    GHAssertTrue( [ [ lenses_fields_ objectForKey: @"Title" ] isEqualToString: @"Lenses" ], @"OK" );
}

-(void)testFieldsReaderForFieldsNames
{
    __weak __block SCApiContext* apiContext_   = nil;
    __block SCItem*       lenses_item_   = nil;
    __block NSDictionary* lenses_fields_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* local_session_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        apiContext_ = local_session_;

        NSString* lenses_path_ = @"/sitecore/content/nicam/products/lenses";
        [ local_session_ itemReaderForItemPath: lenses_path_ ]( ^( SCItem* item_, NSError* error_ )
        {
            if ( error_ )
            {
                didFinishCallback_();
                return;
            }
            lenses_item_ = item_;

            NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Image", @"Title", nil ];
            if( !lenses_item_ )
            {
                didFinishCallback_();
                return;
            }
            [ lenses_item_ fieldsReaderForFieldsNames: fieldsNames_ ]( ^( NSDictionary* fields_, NSError* error_ )
            {
                lenses_fields_ = fields_;
                didFinishCallback_();
            } );
        } );
    };

   //Description
   [ self performAsyncRequestOnMainThreadWithBlock: block_
                                          selector: _cmd ];

   GHAssertTrue( apiContext_    != nil, @"OK" );
   GHAssertTrue( lenses_item_   != nil, @"OK" );
   GHAssertTrue( lenses_fields_ != nil, @"OK" );

   SCField* imageField_ = [ lenses_item_ fieldWithName: @"Image" ];
   SCField* titleField_ = [ lenses_item_ fieldWithName: @"Title" ];
   SCField* descrField_ = [ lenses_item_ fieldWithName: @"Description" ];

   GHAssertTrue( imageField_.item != nil, @"OK" );
   GHAssertTrue( imageField_.item == lenses_item_, @"OK" );

   GHAssertTrue( imageField_ != nil, @"OK" );
   GHAssertTrue( titleField_ != nil, @"OK" );
   GHAssertTrue( descrField_ == nil, @"OK" );
}

////////////////////////////////

//1. read Children
//2. read ChildrenWithFieldsImediatly
//???

//-(void)testChildrenForRelativePath
//{
//   __weak __block SCApiContext* apiContext_ = nil;
//   __block SCItem* nicam_item_ = nil;
//
//   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
//   {
//      SCApiContext* local_session_ = [ SCApiContext session ];
//
//      NSString* path_ = @"/sitecore/content/nicam";
//
//      [ local_session_ getChildrenForItemWithPath: path_
//                                         callback: ^( NSError* error_ )
//      {
//         nicam_item_ = [ local_session_ itemWithPath: @"content/nicam/products" ];
//         didFinishCallback_();
//      } ];
//
//      apiContext_ = local_session_;
//   };
//
//   [ self performAsyncRequestOnMainThreadWithBlock: block_
//                                          selector: _cmd ];
//
//   GHAssertTrue( apiContext_ != nil, @"OK" );
//   GHAssertTrue( nicam_item_ != nil, @"Nicam item should be read" );
//   GHAssertTrue( [ nicam_item_.key isEqualToString: @"products" ], @"Nicam item should be read" );
//
//   GHAssertTrue( [ nicam_item_.path isEqualToString: @"/sitecore/content/nicam/products" ], @"Nicam item should be read" );
//}
//
//-(void)testChildrenForAbsolutePath
//{
//   __weak __block SCApiContext* apiContext_ = nil;
//   __block SCItem* nicam_item_ = nil;
//
//   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
//   {
//      SCApiContext* local_session_ = [ SCApiContext session ];
//
//      NSString* path_ = @"/sitecore/content/nicam";
//
//      [ local_session_ getChildrenForItemWithPath: path_
//                                         callback: ^( NSError* error_ )
//      {
//         nicam_item_ = [ local_session_ itemWithPath: @"/sitecore/content/nicam/products" ];
//         didFinishCallback_();
//      } ];
//
//      apiContext_ = local_session_;
//   };
//
//   [ self performAsyncRequestOnMainThreadWithBlock: block_
//                                          selector: _cmd ];
//
//   GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
//   GHAssertTrue( nicam_item_ != nil, @"Nicam item should be read" );
//   GHAssertTrue( [ nicam_item_.key isEqualToString: @"products" ], @"Nicam item should be read" );
//
//   GHAssertTrue( [ nicam_item_.path isEqualToString: @"/sitecore/content/nicam/products" ], @"Nicam item should be read" );
//}

@end
