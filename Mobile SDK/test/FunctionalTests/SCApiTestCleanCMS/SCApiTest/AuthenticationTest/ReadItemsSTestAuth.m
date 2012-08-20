#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderSelfScope;

@interface ReadItemsSTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsSTestAuth

-(void)testReadItemSWithAllFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block NSArray* products_items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam/Community";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiLogin 
                                            password: SCWebApiPassword ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_auth_ = items_;
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                products_items_ = items_;
                didFinishCallback_();
            });
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    NSLog( @"products_items_: %@", products_items_ );
    NSLog( @"products_items_auth_: %@", products_items_auth_ );
    GHAssertTrue( apiContext_ == nil, @"OK" );

    //test get item with auth
    GHAssertTrue( products_items_auth_ != nil, @"OK" );
    GHAssertTrue( [ products_items_auth_ count ] == 1, @"OK" );
    SCItem* product_item_ = nil;
    //test product item
    {
        product_item_ = [ products_items_auth_ objectAtIndex: 0 ];      
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( [ product_item_.displayName isEqualToString: @"Community" ], @"OK" );

        GHAssertTrue( product_item_.allChildren == nil, @"OK" );
        GHAssertTrue( product_item_.readChildren == nil, @"OK" );

        GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );
        NSLog( @"products_items count: %d", [ product_item_.allFieldsByName count ] );
        GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );
        GHAssertTrue( [ product_item_.readFieldsByName count ] == SCCommunityAllFieldsCount, @"OK" );
    }
    
    //test get item without auth
    GHAssertTrue( [ products_items_ count ] == 0, @"OK" );
}

-(void)testReadItemSWithSomeFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_         = nil;
    __block NSArray* products_items_auth_    = nil;

    NSString* path_ = @"/sitecore/content/Nicam/Products";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiLogin 
                                            password: SCWebApiPassword ];
        NSSet* field_names_ = [ NSSet setWithObjects: @"Title", @"Tab Icon", nil];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: field_names_ ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_auth_ = items_;
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                products_items_ = items_;
                didFinishCallback_();
            });
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    NSLog( @"products_items_: %@", products_items_ );
    NSLog( @"products_items_auth_: %@", products_items_auth_ );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //test get item with auth
    GHAssertTrue( products_items_auth_ != nil, @"OK" );
    GHAssertTrue( [ products_items_auth_ count ] == 1, @"OK" );
    SCItem* product_item_ = nil;
    //test product item
    {
        product_item_ = [ products_items_auth_ objectAtIndex: 0 ];      
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( [ product_item_.displayName isEqualToString: @"Products" ], @"OK" );
        
        GHAssertTrue( product_item_.allChildren == nil, @"OK" );
        GHAssertTrue( product_item_.readChildren == nil, @"OK" );
        
        GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ product_item_.readFieldsByName count ] == 2, @"OK" );
        GHAssertTrue( [ [ [ product_item_ fieldWithName: @"Title" ] rawValue ] isEqualToString: @"Products" ], @"OK" );
        GHAssertTrue( [ product_item_ fieldWithName: @"Tab Icon" ] != nil, @"OK" );
        GHAssertTrue( [ [ product_item_ fieldWithName: @"Tab Icon" ] isKindOfClass: [ SCImageField class ] ], @"OK" );
    }
    
    //test get item without auth
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 1, @"OK" );
    SCItem* product_item_without_auth_ = [ products_items_auth_ objectAtIndex: 0 ]; 
    GHAssertTrue( [ product_item_without_auth_ isEqual: product_item_ ], @"OK" );
}

-(void)testReadItemSWithNoFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block NSArray* products_items_parent_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: [ NSSet new ] ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            SCItemsReaderRequest* parent_request_ = [ SCItemsReaderRequest requestWithItemPath: @"/sitecore/content/Nicam/Community/"
                                                                                   fieldsNames: [ NSSet new ] ];
            [ apiContext_ itemsReaderWithRequest: parent_request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                products_items_parent_ = items_;
                didFinishCallback_();
            });
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    NSLog( @"products_items_: %@", products_items_ );
    NSLog( @"products_items_auth_: %@", products_items_parent_ );
    GHAssertTrue( apiContext_ != nil, @"OK" );

    //test get item with auth
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 1, @"OK" );
    SCItem* product_item_ = nil;
    //test product item
    {
        product_item_ = [ products_items_ objectAtIndex: 0 ];      
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( [ product_item_.displayName isEqualToString: @"Macro Community" ], @"OK" );
        
        GHAssertTrue( product_item_.allChildren == nil, @"OK" );
        GHAssertTrue( product_item_.readChildren == nil, @"OK" );
        
        GHAssertTrue( product_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ product_item_.readFieldsByName count ] == 0, @"OK" );
    }
    
    //test get item parent
    GHAssertTrue( [ products_items_parent_ count ] == 0, @"OK" );

}

-(void)testReadItemSWithQuery
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_children_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [SCApiContext contextWithHost: SCWebApiHostName 
                                              login: SCWebApiLogin 
                                           password: SCWebApiPassword ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.scope       = scope_;
        request_.request     = path_;
        request_.fieldNames  = [ NSSet new ];
        request_.requestType = SCItemReaderRequestQuery;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            request_.request = @"/sitecore/content/Nicam/*[@@key='community']";
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_children_ = result_items_;
                didFinishCallback_();
            } );
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    NSLog( @"products_items_: %@", items_ );
    NSLog( @"products_items_auth_: %@", items_children_);
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //test get item without auth
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 1, @"OK" );
    SCItem* item_ = nil;
    //test item
    {
        item_ = [ items_ objectAtIndex: 0 ];      
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( [ item_.displayName isEqualToString: @"Nicam" ], @"OK" );
        
        GHAssertTrue( item_.allChildren == nil, @"OK" );
        //!!STODO: resolve relations in query request
        //GHAssertTrue( item_.readChildren != nil, @"OK" );
        //GHAssertTrue( [ item_.readChildren count ] == 1, @"OK" );
        
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
    }
    
    //test get item children (with auth)
    GHAssertTrue( items_children_ != nil, @"OK" );
    GHAssertTrue( [ items_children_ count ] == 1, @"OK" );
    SCItem* item_children = [ items_children_ objectAtIndex: 0 ];  
    //test item
    {   
        //!!STODO: resolve relations in query request
        //GHAssertTrue( item_children.parent != nil, @"OK" );
        GHAssertTrue( [ item_children.displayName isEqualToString: @"Community" ], @"OK" );
        
        GHAssertTrue( item_children.allChildren == nil, @"OK" );
        GHAssertTrue( item_children.readChildren == nil, @"OK" );
        
        GHAssertTrue( item_children.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ item_children.readFieldsByName count ] == 0, @"OK" );
    }
    //test relations //!!STODO: resolve relations in query request
    /*
    {
        GHAssertTrue( item_children.parent == item_, @"OK" );
        GHAssertTrue( [ item_children.readChildren objectAtIndex: 0 ] == item_children, @"OK" );
    }*/
    
}

@end
