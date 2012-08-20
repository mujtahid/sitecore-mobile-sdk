
#import "SCAsyncTestCase.h"

@interface PagingItemsTest : SCAsyncTestCase
@end

@implementation PagingItemsTest

static NSString* item_id_ = @"{A1FF0BEE-AE21-4BAF-BECD-8029FC89601A}";
static NSString* item_display_name_ = @"Normal";
static NSString* item_full_path_ = @"/sitecore/content/Nicam/Products/Lenses/Normal";
static int children_count_ = 3;

-(void)testPagedItemCWithSomeFields
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSNumber* items_count_ = 0;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestItemPath;
        request_.scope = SCItemReaderChildrenScope;
        request_.request = @"/sitecore/content/Nicam/";
        request_.flags = SCItemReaderRequestReadFieldsValues;
        request_.fieldNames = [ NSSet setWithObjects: @"Title", @"Tab Icon", nil ];
        request_.pageSize = 2;

        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        if ( !pagedItems_ )
        {
            didFinishCallback_();
            return;
        }
        [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
        {
            items_count_ = result_;
            [ pagedItems_ itemReaderForIndex: 1 ]( ^( id result_, NSError* error_ )
            {
                [ pagedItems_ itemReaderForIndex: 4 ]( ^( id result_, NSError* error_ )
                {
                    didFinishCallback_();
                } );
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );

    GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
    SCItem* child_ = [ pagedItems_ itemForIndex: 0 ];

    GHAssertTrue( child_.parent  == nil, @"OK" );
    GHAssertTrue( child_.readChildren  == nil, @"OK" );

    GHAssertTrue( [ child_ fieldValueWithName: @"Title" ] != nil, @"OK" );
    GHAssertTrue( [ child_ fieldValueWithName: @"Tab Icon" ] != nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 1 ] != nil, @"OK" );

    child_ = [ pagedItems_ itemForIndex: 1 ];

    GHAssertTrue( child_.parent  == nil, @"OK" );
    GHAssertTrue( child_.readChildren  == nil, @"OK" );

    GHAssertTrue( [ child_ fieldValueWithName: @"Title" ] != nil, @"OK" );
    GHAssertTrue( [ child_ fieldValueWithName: @"Tab Icon" ] != nil, @"OK" );

    GHAssertTrue( [ pagedItems_ itemForIndex: 2 ] == nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 3 ] == nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 4 ] != nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 5 ] != nil, @"OK" );

   GHAssertTrue( [ items_count_ unsignedIntValue ] == 8, @"OK" );
   
}

-(void)testPagedItemSCWithAllFields
{
   __block SCPagedItems* pagedItems_;
   __weak __block SCApiContext* apiContext_ = nil;
   //__block NSArray* lenses_items_ = nil;
   __block NSNumber* items_count_ = 0;
   
   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
   {
      apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
      
      SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
      request_.requestType = SCItemReaderRequestItemId;
      request_.scope       = SCItemReaderSelfScope | SCItemReaderChildrenScope;
      request_.request     = item_id_;
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
            didFinishCallback_();
         } );
      } );
   };

   [ self performAsyncRequestOnMainThreadWithBlock: block_
                                          selector: _cmd ];

   GHAssertTrue( apiContext_ != nil, @"OK" );
   NSLog( @"items_count_: %@", items_count_ );
   GHAssertTrue( [ items_count_ unsignedIntValue ] == children_count_ + 1, @"OK" );

   GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
   SCItem* parent_ = [ pagedItems_ itemForIndex: 0 ];
   NSLog( @"parent_.displayName: %@", parent_.displayName );
   GHAssertTrue( [ parent_.displayName isEqualToString: @"Normal" ], @"OK" );
   GHAssertTrue( parent_.allFieldsByName != nil, @"OK" );
   GHAssertTrue( [ parent_.allFieldsByName count ] == [ parent_.readFieldsByName count ], @"OK" );

   GHAssertTrue( [ parent_.readChildren count ] == 1, @"OK" );
   GHAssertTrue( parent_.parent == nil, @"OK" );

   GHAssertTrue( parent_.allFieldsByName != nil, @"OK" );
   GHAssertTrue( [ parent_.allFieldsByName count ] == [ parent_.readFieldsByName count ], @"OK" );

   GHAssertTrue( [ pagedItems_ itemForIndex: 1 ] != nil, @"OK" );
   SCItem* child_ = [ pagedItems_ itemForIndex: 1 ];
   GHAssertTrue( child_.parent  == parent_, @"OK" );
   GHAssertTrue( child_.readChildren == nil, @"OK" );

   GHAssertTrue( child_.allFieldsByName != nil, @"OK" );
   GHAssertTrue( [ child_.allFieldsByName count ] == [ child_.readFieldsByName count ], @"OK" );
   
   GHAssertTrue( [ pagedItems_ itemForIndex: 2 ] == nil, @"OK" );   
   
}

-(void)testPagedItemSPWithNoFields
{
   __block SCPagedItems* pagedItems_;
   __weak __block SCApiContext* apiContext_ = nil;
   //__block NSArray* lenses_items_ = nil;
   __block NSNumber* items_count_ = 0;
   
   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
   {
      apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

      SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
      request_.requestType = SCItemReaderRequestItemId;
      request_.scope       = SCItemReaderSelfScope | SCItemReaderParentScope;
      request_.request     = item_id_;
      request_.flags       = SCItemReaderRequestReadFieldsValues;
      request_.fieldNames  = [ NSSet new ];
      request_.pageSize    = 2;

      pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                    request: request_ ];
      [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
        {
           items_count_ = result_;
           [ pagedItems_ itemReaderForIndex: 0 ]( ^( id result_, NSError* error_ )
            {
                didFinishCallback_();
            } );
        } );
      
   };
   
   [ self performAsyncRequestOnMainThreadWithBlock: block_
                                          selector: _cmd ];
   
   GHAssertTrue( apiContext_ != nil, @"OK" );
   NSLog( @"items_count_: %@", items_count_ );
   GHAssertTrue( [ items_count_ unsignedIntValue ] == 2, @"OK" );
   
   GHAssertTrue( [ pagedItems_ itemForIndex: 1 ] != nil, @"OK" );
   SCItem* child_ = [ pagedItems_ itemForIndex: 1 ];
   NSLog( @"child_.displayName: %@", child_.displayName );
   GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
   SCItem* parent_ = [ pagedItems_ itemForIndex: 0 ];
   NSLog( @"parent_.displayName: %@", parent_.displayName );
   
   GHAssertTrue( [ child_.displayName isEqualToString: @"Normal" ], @"OK" );
   GHAssertTrue( child_.parent  == parent_, @"OK" );
   GHAssertTrue( child_.readChildren == nil, @"OK" );
   
   GHAssertTrue( [ child_.readFieldsByName count ] == 0, @"OK" );
   GHAssertTrue( child_.allFieldsByName == nil, @"OK" );
   
   GHAssertTrue( [ parent_.displayName isEqualToString: @"Lenses" ], @"OK" );
   GHAssertTrue( [ parent_.readFieldsByName count ] == 0, @"OK" );
   GHAssertTrue( parent_.allFieldsByName == nil, @"OK" );
                                 
   GHAssertTrue( [ parent_.readChildren count ] == 1, @"OK" );
   GHAssertTrue( parent_.parent == nil, @"OK" );
}

-(void)testPagedItemCPWithAllFields
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    //__block NSArray* lenses_items_ = nil;
    __block NSNumber* items_count_ = 0;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestItemId;
        request_.scope = SCItemReaderParentScope | SCItemReaderChildrenScope;
        request_.request = item_id_;
        request_.flags = SCItemReaderRequestReadFieldsValues;
        request_.fieldNames = nil;
        request_.pageSize = 3;

        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
        {
            items_count_ = result_;
            [ pagedItems_ itemReaderForIndex: 0 ]( ^( id result_, NSError* error_ )
            {
                didFinishCallback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"items_count_: %@", items_count_ );
    GHAssertTrue( [ items_count_ unsignedIntValue ] == children_count_ + 1, @"OK" );

    GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
    SCItem* parent_ = [ pagedItems_ itemForIndex: 0 ];
    NSLog( @"parent_.displayName: %@", parent_.displayName );
    GHAssertTrue( [ parent_.displayName isEqualToString: @"Lenses" ], @"OK" );
    GHAssertTrue( parent_.allFieldsByName != nil, @"OK" );
    GHAssertTrue( [ parent_.allFieldsByName count ] == [ parent_.readFieldsByName count ], @"OK" );

    GHAssertTrue( parent_.readChildren == nil, @"OK" );
    GHAssertTrue( parent_.parent == nil, @"OK" );

    GHAssertTrue( parent_.allFieldsByName != nil, @"OK" );
    GHAssertTrue( [ parent_.allFieldsByName count ] == [ parent_.readFieldsByName count ], @"OK" );

    GHAssertTrue( [ pagedItems_ itemForIndex: 1 ] != nil, @"OK" );
    SCItem* child_ = [ pagedItems_ itemForIndex: 1 ];
    GHAssertTrue( child_.parent  == nil, @"OK" );
    GHAssertTrue( child_.readChildren == nil, @"OK" );

    GHAssertTrue( child_.allFieldsByName != nil, @"OK" );
    GHAssertTrue( [ child_.allFieldsByName count ] == [ child_.readFieldsByName count ], @"OK" );

    GHAssertTrue( [ pagedItems_ itemForIndex: 2 ] != nil, @"OK" );  
    GHAssertTrue( [ pagedItems_ itemForIndex: 3 ] == nil, @"OK" ); 
}

-(void)testPagedItemSCPWithNoFields
{
   __block SCPagedItems* pagedItems_;
   __weak __block SCApiContext* apiContext_ = nil;
   //__block NSArray* lenses_items_ = nil;
   __block NSNumber* items_count_ = 0;

   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
   {
      apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

      SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
      request_.requestType = SCItemReaderRequestItemId;
      request_.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope | SCItemReaderParentScope;
      request_.request = item_id_;
      request_.flags = SCItemReaderRequestReadFieldsValues;
      request_.fieldNames = [ NSSet new ];
      request_.pageSize = 2;

      pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                    request: request_ ];
      [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
      {
          items_count_ = result_;
          [ pagedItems_ itemReaderForIndex: 1 ]( ^( id result_, NSError* error_ )
          {
              [ pagedItems_ itemReaderForIndex: 4 ]( ^( id result_, NSError* error_ )
              {
                  didFinishCallback_();
              } );
          } );
      } );
      
   };
   
   [ self performAsyncRequestOnMainThreadWithBlock: block_
                                          selector: _cmd ];
   
   GHAssertTrue( apiContext_ != nil, @"OK" );
   NSLog( @"items_count_: %@", items_count_ );
   GHAssertTrue( [ items_count_ unsignedIntValue ] == children_count_ + 2, @"OK" );
   
   GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
   SCItem* parent_ = [ pagedItems_ itemForIndex: 0 ];
   NSLog( @"parent_.displayName: %@", parent_.displayName );
   GHAssertTrue( [ pagedItems_ itemForIndex: 1 ] != nil, @"OK" );
   SCItem* self_ = [ pagedItems_ itemForIndex: 1 ];
   GHAssertTrue( [ pagedItems_ itemForIndex: 4 ] != nil, @"OK" );
   SCItem* child_ = [ pagedItems_ itemForIndex: 4 ];
   GHAssertTrue( [ pagedItems_ itemForIndex: 2 ] == nil, @"OK" ); 
   GHAssertTrue( [ pagedItems_ itemForIndex: 3 ] == nil, @"OK" ); 
   
   //parent
   GHAssertTrue( [ parent_.displayName isEqualToString: @"Lenses" ], @"OK" );
   GHAssertTrue( parent_.allFieldsByName == nil, @"OK" );
   GHAssertTrue( [ parent_.readFieldsByName count ] == 0, @"OK" );
   
   GHAssertTrue( [ parent_.readChildren count ] == 1, @"OK" );
   GHAssertTrue( [ parent_.readChildren objectAtIndex: 0 ] == self_, @"OK" );
   GHAssertTrue( parent_.parent == nil, @"OK" );
   
   //self
   GHAssertTrue( [ self_.displayName isEqualToString: @"Normal" ], @"OK" );
   GHAssertTrue( self_.allFieldsByName == nil, @"OK" );
   GHAssertTrue( [ self_.readFieldsByName count ] == 0, @"OK" );
   
   GHAssertTrue( [ self_.readChildren count ] == 1, @"OK" );
   GHAssertTrue( [ self_.readChildren objectAtIndex: 0 ] == child_, @"OK" );
   GHAssertTrue( self_.parent == parent_, @"OK" );
   
   //child
   GHAssertTrue( child_.parent  == self_, @"OK" );
   GHAssertTrue( child_.readChildren == nil, @"OK" );
   
   GHAssertTrue( child_.allFieldsByName == nil, @"OK" );
   GHAssertTrue( [ child_.readFieldsByName count ] == 0, @"OK" );
}

-(void)RtestPagedItemWithQueryWithSomeFields
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    //__block NSArray* lenses_items_ = nil;
    __block NSNumber* items_count_ = 0;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
      
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestQuery;
        request_.request = @"/sitecore/content/Nicam/child::*[@@templatename='Site Section']";
        request_.flags = SCItemReaderRequestReadFieldsValues;
        request_.fieldNames = [ NSSet setWithObjects: @"Title", @"Tab Icon", nil ];
        request_.pageSize = 3;

        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        if ( !pagedItems_ )
        {
            didFinishCallback_();
            return;
        }
        [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
        {
            items_count_ = result_;
            [ pagedItems_ itemReaderForIndex: 1 ]( ^( id result_, NSError* error_ )
            {
                [ pagedItems_ itemReaderForIndex: 6 ]( ^( id result_, NSError* error_ )
                {
                    didFinishCallback_();
                } );
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"items_count_: %@", items_count_ );
    for ( int i = 0; i < 3; i++ )
    {
        GHAssertTrue( [ pagedItems_ itemForIndex: i ] != nil, @"OK" );
    }
    for ( int i = 3; i < 6; i++ )
    {
        GHAssertTrue( [ pagedItems_ itemForIndex: i ] == nil, @"OK" );
    }
    SCItem* item_ = [ pagedItems_ itemForIndex: 2 ];
   
    GHAssertTrue( item_.parent  == nil, @"OK" );
    GHAssertTrue( item_.readChildren  == nil, @"OK" );

    GHAssertTrue( [ item_ fieldValueWithName: @"Title" ] != nil, @"OK" );
    GHAssertTrue( [ item_ fieldValueWithName: @"Tab Icon" ] != nil, @"OK" );
}

-(void)testPagedItemWithQueryWithNoFields
{
   __block SCPagedItems* pagedItems_;
   __weak __block SCApiContext* apiContext_ = nil;
   __block NSNumber* items_count_ = 0;
   
   void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
   {
       apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
      
       SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
       request_.requestType = SCItemReaderRequestQuery;
       request_.request = @"/sitecore/content/Nicam/Products/descendant::*[@@templatename='Product Group']"
       "/child::*[@@templatename!='Product Group' and @@templatename!='RSSTwitterReader']";
       request_.flags = SCItemReaderRequestReadFieldsValues;
       request_.fieldNames = [ NSSet new ];
       request_.pageSize = 3;
      
       pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                    request: request_ ];
       if ( !pagedItems_ )
       {
           didFinishCallback_();
           return;
       }
       [ pagedItems_ itemsTotalCountReader ]( ^( id result_, NSError* error_ )
       {
           items_count_ = result_;
           [ pagedItems_ itemReaderForIndex: 1 ]( ^( id result_, NSError* error_ )
           {
               [ pagedItems_ itemReaderForIndex: 6 ]( ^( id result_, NSError* error_ )
               {
                   didFinishCallback_();
               } );
            } );
        } );
    };
   
   [ self performAsyncRequestOnMainThreadWithBlock: block_
                                          selector: _cmd ];
   
   GHAssertTrue( apiContext_ != nil, @"OK" );
   NSLog( @"items_count_: %@", items_count_ );
   for ( int i = 0; i < 3; i++ )
   {
      GHAssertTrue( [ pagedItems_ itemForIndex: i ] != nil, @"OK" );
   }
   for ( int i = 3; i < 6; i++ )
   {
      GHAssertTrue( [ pagedItems_ itemForIndex: i ] == nil, @"OK" );
   }
   for ( int i = 6; i < 9; i++ )
   {
      GHAssertTrue( [ pagedItems_ itemForIndex: i ] != nil, @"OK" );
      SCItem* item_ = [ pagedItems_ itemForIndex: i ];
      NSLog( @"item_.itemTemplate: %@", item_.itemTemplate );
      GHAssertTrue( item_.parent  == nil, @"OK" );
      GHAssertTrue( item_.readChildren  == nil, @"OK" );
      GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
   }

   //GHAssertTrue( [ items_count_ unsignedIntValue ] == 7, @"OK" );
}

@end
