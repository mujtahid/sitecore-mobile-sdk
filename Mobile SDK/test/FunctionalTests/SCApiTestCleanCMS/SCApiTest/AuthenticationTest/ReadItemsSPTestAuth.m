#import "SCAsyncTestCase.h"
static SCItemReaderScopeType scope_ = SCItemReaderSelfScope |SCItemReaderParentScope;

@interface ReadItemsSPTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsSPTestAuth

-(void)testReadItemSPWithAllowedItemNotAllowedParent
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiLogin 
                                            password: SCWebApiPassword ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: nil ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            didFinishCallback_();
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    NSLog( @"items_: %@", items_ );
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    
    //test get items (without auth)
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 2, @"OK" );

    SCItem* self_item_auth_ = [ apiContext_ itemWithPath: path_ ];  
    //test item relations
    {    
        GHAssertTrue( self_item_auth_.allFieldsByName != nil, @"OK" );
        GHAssertTrue( self_item_auth_.readChildren == nil, @"OK" );
        SCItem* parent_item_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam/Community" ];
        GHAssertTrue( parent_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ parent_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( self_item_auth_.parent != nil, @"OK" );
        GHAssertTrue( self_item_auth_.parent == parent_item_, @"OK" );
    }
}

-(void)testReadItemSPWithNotAllowedItemAndParent
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* itemsAuth_ = nil;

    NSString* path_ = @"/sitecore/content/Nicam/My_Nicam/Edit_your_profile/Update_your_profile";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: [ NSSet new ] ];
        request_.scope = scope_;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
        {
            items_ = result_items_;
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: SCWebApiLogin 
                                                password: SCWebApiPassword ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_items_, NSError* error_ )
            {
                itemsAuth_ = result_items_;
                didFinishCallback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    NSLog( @"items_: %@", items_ );
    NSLog( @"items_auth_: %@", itemsAuth_ );

    GHAssertTrue( apiContext_ != nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    NSLog( @"[ items_auth_ count ]: %d", [ itemsAuth_ count ] );

    //test get items (without auth)
    GHAssertTrue( [ items_ count ] == 0, @"OK" );

    //test get items (with auth)
    GHAssertTrue( itemsAuth_ != nil, @"OK" );
    GHAssertTrue( [ itemsAuth_ count ] == 2, @"OK" );
    SCItem* self_item_ = [ apiContext_ itemWithPath: path_ ]; 
    SCItem* parent_item_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam/My_Nicam/Edit_your_profile" ];
    //test item relations
    {   
        GHAssertTrue( [ self_item_.readFieldsByName count ] == 0, @"OK" );
        GHAssertTrue( [ parent_item_.readFieldsByName count ] == 0, @"OK" );
        GHAssertTrue( parent_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ parent_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( self_item_.parent != nil, @"OK" );
        GHAssertTrue( self_item_.parent == parent_item_, @"OK" );
    }
}

-(void)testReadItemSPWithNotAllowedItemAllowedParent
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
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* resultItems_, NSError* error_ )
        {
            items_ = resultItems_;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ == nil, @"OK" );
    NSLog( @"[ items_ count ]: %d", [ items_ count ] );
    
    //test get items (without auth)
    GHAssertTrue( [ items_ count ] == 0, @"OK" );
}

@end