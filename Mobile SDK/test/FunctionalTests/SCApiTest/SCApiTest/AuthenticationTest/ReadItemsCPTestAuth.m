#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderChildrenScope | SCItemReaderParentScope;

@interface ReadItemsCPTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsCPTestAuth

-(void)testReadItemCPWithAllowedItemNotAllowedChildrenParent
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            request_.request = path_;
            apiContext_ = [SCApiContext contextWithHost: SCWebApiHostName 
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
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    
    //test get items (without auth)
    GHAssertTrue( items_ != nil, @"OK" );
        GHAssertTrue( [ items_ count ] == 3, @"OK" );
    //test item relations
    for (SCItem* item_ in items_ )
    { 
        GHAssertTrue( item_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.parent == nil, @"OK" );
    }
    
    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 7, @"OK" );
    //test item relations
    for (SCItem* item_ in items_auth_ )
    {    
        GHAssertTrue( item_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.parent == nil, @"OK" );
    }
}

-(void)testReadItemCPWithAllowedItemParentNotAllowedChildren
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: [ NSSet new ] ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            request_.request = path_;
            apiContext_ = [SCApiContext contextWithHost: SCWebApiHostName 
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
    
    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", items_auth_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ items_auth_ count ] );
    
    //test get items (without auth)
    GHAssertTrue( items_ != nil, @"OK" );

     GHAssertTrue( [ items_ count ] == 9, @"OK" );
     //test item relations
     for (SCItem* item_ in items_ )
     { 
         GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
         GHAssertTrue( item_.readChildren == nil, @"OK" );
         GHAssertTrue( item_.parent == nil, @"OK" );
     }
    
    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 12, @"OK" );
    //test item relations
    for (SCItem* item_ in items_auth_ )
    {    
        GHAssertTrue( item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( item_.readChildren == nil, @"OK" );
        GHAssertTrue( item_.parent == nil, @"OK" );
    }
}

-(void)testReadItemCPWithNotAllowedItemAllowedChildrenParent
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam/My_Nicam";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: [ NSSet new ] ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            request_.request = path_;
            didFinishCallback_();
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    NSLog( @"items_: %@", items_ );

    GHAssertTrue( apiContext_ == nil, @"OK" );
    //test get items (without auth)
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
}

@end