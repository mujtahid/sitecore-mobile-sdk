#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderSelfScope | SCItemReaderChildrenScope;

@interface ReadItemsSCTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsSCTestAuth

-(void)testReadItemSCWithAllowedItemNotAllowedChildren
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam";
    
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
    GHAssertTrue( [ items_ count ] == 9, @"OK" );
    SCItem* self_item_ = nil;
    //test item relations
    {
        self_item_ = [ items_ objectAtIndex: 0 ];  
        GHAssertTrue( self_item_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( self_item_.allChildren != nil, @"OK" );
        GHAssertTrue( self_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_.readChildren count ] == 8, @"OK" );
        SCItem* child_item_ = [ items_ objectAtIndex: 2 ];
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_, @"OK" );
    }
     
    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 12, @"OK" );
    SCItem* self_item_auth_ = [ apiContext_ itemWithPath: path_ ];  
    //test item relations
    {    
        GHAssertTrue( self_item_auth_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( self_item_auth_.allChildren != nil, @"OK" );
        GHAssertTrue( self_item_auth_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_auth_.allChildren count ] == 11, @"OK" );
        SCItem* child_item_ = [ items_auth_ objectAtIndex: 2 ];
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_auth_, @"OK" );
    }
}

-(void)testReadItemSCWithNotAllowedItemAndChildren
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam/My_Nicam";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        request_.fieldNames = [ NSSet new ];
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
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
    
    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 6, @"OK" );
    SCItem* self_item_auth_ = [ apiContext_ itemWithPath: path_ ];  
    //test item relations
    {    
        GHAssertTrue( self_item_auth_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( self_item_auth_.allChildren != nil, @"OK" );
        GHAssertTrue( self_item_auth_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_auth_.allChildren count ] == 5, @"OK" );
        SCItem* child_item_ = [ items_auth_ objectAtIndex: 2 ];
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_auth_, @"OK" );
    }
}

//Item Security: access to Item is deny, access to Children is Deny for not authorized user
-(void)testReadItemSCAuthWithQuery
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;

    NSString* path_ = @"/sitecore/content/Nicam/*[@@key='my_nicam']/*[@Menu title='Edit profile']";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [SCItemsReaderRequest new ];
        request_.fieldNames = [ NSSet new ];
        request_.requestType = SCItemReaderRequestQuery;
        request_.scope = scope_;
        request_.request = path_;
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

    GHAssertTrue( apiContext_ != nil, @"OK" );

    //test get items (without auth)
    GHAssertTrue( [ items_ count ] == 0, @"OK" );

    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 1, @"OK" );
    SCItem* self_item_auth_ = [ items_auth_ objectAtIndex: 0 ];     
    GHAssertTrue( self_item_auth_.allFieldsByName == nil, @"OK" );
    GHAssertTrue( [ self_item_auth_.displayName isEqualToString: @"Edit your profile" ], @"OK" );
}

@end