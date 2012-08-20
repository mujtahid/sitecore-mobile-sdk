#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderChildrenScope;

@interface ReadItemsCTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsCTestAuth

-(void)testReadItemCWithAllFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_parent_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam/Community";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            request_.request = @"/sitecore/content/Nicam";
            apiContext_ = [SCApiContext contextWithHost: SCWebApiHostName 
                                                  login: SCWebApiLogin 
                                               password: SCWebApiPassword ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_parent_ = result_items_;
                didFinishCallback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    NSLog( @"items_: %@", items_ );
    NSLog( @"items_parent_: %@", items_parent_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );

    //test get item parent (with auth)
    GHAssertTrue( items_parent_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_parent_ count ] );
    GHAssertTrue( [ items_parent_ count ] == 11, @"OK" );
    SCItem* item_parent_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam/Community" ];  
    //test item
    {   
        GHAssertTrue( item_parent_.parent == nil, @"OK" );
        GHAssertTrue( [ item_parent_.displayName isEqualToString: @"Community" ], @"OK" );
        
        GHAssertTrue( item_parent_.allChildren == nil, @"OK" );
        GHAssertTrue( item_parent_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( [ item_parent_.readFieldsByName count ] == 
                     [ item_parent_.allFieldsByName count ], @"OK" );
    }
}

-(void)testReadItemCWithSomeFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        NSSet* field_names_ = [ NSSet setWithObjects: @"Title", @"Tab Icon", nil];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: field_names_ ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: SCWebApiLogin 
                                                password: SCWebApiPassword ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_auth_ = result_items_;
                didFinishCallback_();
            } );
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    NSLog( @"products_items_: %@", items_ );
    NSLog( @"products_items_auth_: %@", items_auth_ );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //test get item with auth
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 11, @"OK" );
    SCItem* item_ = nil;
    //test product item
    {
        item_ = [ items_auth_ objectAtIndex: 0 ];      
        GHAssertTrue( item_.parent == nil, @"OK" );
        GHAssertTrue( item_.allChildren == nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 2, @"OK" );
        GHAssertTrue( [ [ [ item_ fieldWithName: @"Title" ] rawValue ] isEqualToString: @"Products" ], @"OK" );
        GHAssertTrue( [ item_ fieldWithName: @"Tab Icon" ] != nil, @"OK" );
        GHAssertTrue( [ [ item_ fieldWithName: @"Tab Icon" ] isKindOfClass: [ SCImageField class ] ], @"OK" );
    }
    
    //test get item without auth
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 8, @"OK" );
    SCItem* item_without_auth_ = [ items_auth_ objectAtIndex: 0 ]; 
    GHAssertTrue( [ item_without_auth_ isEqual: item_ ], @"OK" );
}

-(void)testReadItemCWithNoFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;

    NSString* path_ = @"/sitecore/content";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiLogin 
                                            password: SCWebApiPassword ];
        NSSet* field_names_ = [ NSSet new ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: field_names_ ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            request_.request = @"/sitecore/content/Nicam";
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_auth_ = result_items_;
                didFinishCallback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    NSLog( @"products_items_: %@", items_ );
    NSLog( @"products_items_auth_: %@", items_auth_ );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    GHAssertTrue( apiContext_ != nil, @"OK" );

    //test get item without auth
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 9, @"OK" );
    SCItem* item_without_auth_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam" ]; 
    //test parent item
    {
        GHAssertTrue( item_without_auth_.parent == nil, @"OK" );
        GHAssertTrue( item_without_auth_.allChildren != nil, @"OK" );
        GHAssertTrue( [ item_without_auth_.readChildren count ] == 11, @"OK" );
        GHAssertTrue( item_without_auth_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ item_without_auth_.readFieldsByName count ] == 0, @"OK" );
    }
    //test get item with auth
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 11, @"OK" );
    SCItem* item_ = nil;
    //test parent item
    {
        item_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam/Community" ];      
        GHAssertTrue( item_.parent != nil, @"OK" );
        GHAssertTrue( item_.parent == item_without_auth_, @"OK" );
        GHAssertTrue( item_.allChildren == nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
    } 
}

-(void)testReadItemCWithQuery
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam/*[@@key='community']";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        NSSet* field_names_ = [ NSSet new ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.fieldNames = field_names_;
        request_.request = path_;
        request_.requestType = SCItemReaderRequestQuery;
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            request_.request = @"/sitecore/content/*[@@key='nicam']/*[contains(@Title, 'Commun')]";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                                   login: SCWebApiLogin 
                                                password: SCWebApiPassword ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                items_auth_ = result_items_;
                didFinishCallback_();
            } );
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    NSLog( @"products_items_: %@", items_ );
    NSLog( @"products_items_auth_: %@", items_auth_ );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    //test get item without auth
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    //test get item with auth
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 1, @"OK" );
    SCItem* item_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam/Community" ];  
    //test parent item
    {
        GHAssertTrue( [item_.displayName isEqualToString: @"Community" ], @"OK" );
        GHAssertTrue( item_.allChildren == nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
    } 
}

@end
