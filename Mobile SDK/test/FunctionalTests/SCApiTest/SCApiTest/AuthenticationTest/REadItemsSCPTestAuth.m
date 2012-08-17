#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderSelfScope | SCItemReaderChildrenScope | SCItemReaderParentScope;

@interface ReadItemsSCPTestAuth : SCAsyncTestCase
@end

@implementation ReadItemsSCPTestAuth

-(void)testReadItemSCPWithAllowedItemNotAllowedChildrenParent
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSArray* items_auth_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community";
    
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
    GHAssertTrue( [ items_ count ] == 4, @"OK" );
    //test item relations
    { 
        SCItem* self_item_ = [ items_ objectAtIndex: 0 ];
        SCItem* child_item_ = [ items_ objectAtIndex: 2 ];

        GHAssertTrue( [ self_item_.readFieldsByName count ] == 0, @"OK" );
        GHAssertTrue( [ child_item_.readFieldsByName count ] == 0, @"OK" );

        GHAssertTrue( self_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_.readChildren count ] == 3, @"OK" );
        GHAssertTrue( self_item_.parent == nil, @"OK" );
        NSLog( @"self_item_.parent: %@", self_item_.parent );
        GHAssertTrue( child_item_.readChildren == nil, @"OK" );
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_, @"OK" );
    }

    //test get items (with auth)
    GHAssertTrue( items_auth_ != nil, @"OK" );
    GHAssertTrue( [ items_auth_ count ] == 8, @"OK" );
    //test item relations
    {    
        SCItem* self_item_ = [ apiContext_ itemWithPath: path_ ];
        SCItem* parent_item_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam/Community" ];
        SCItem* child_item_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Forum" ];
        
        GHAssertTrue( self_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( parent_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( child_item_.allFieldsByName == nil, @"OK" );
        
        GHAssertTrue( self_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_.readChildren count ] == 6, @"OK" );
        GHAssertTrue( self_item_.parent != nil, @"OK" );
        GHAssertTrue( self_item_.parent == parent_item_, @"OK" );
        
        GHAssertTrue( parent_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ parent_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( parent_item_.parent == nil, @"OK" );
        
        GHAssertTrue( child_item_.readChildren == nil, @"OK" );
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_, @"OK" );
    }
}

-(void)testReadItemSCPWithNotAllowedItemAllowedChildrenParent
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    
    NSString* path_ = @"/sitecore/content/Nicam/Community";
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [SCApiContext contextWithHost: SCWebApiHostName 
                                              login: SCWebApiLogin 
                                           password: SCWebApiPassword ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                        fieldsNames: [ NSSet new ] ];
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
    
        //test get items (with auth)
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ items_ count ] == 6, @"OK" );
    //test item relations
    {    
        SCItem* self_item_ = [ apiContext_ itemWithPath: path_ ];
        SCItem* parent_item_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam" ];
        SCItem* child_item_ = [ apiContext_ itemWithPath: @"/sitecore/content/Nicam/Community/Macro_Community" ];
        
        GHAssertTrue( self_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( parent_item_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( child_item_.allFieldsByName == nil, @"OK" );
        
        GHAssertTrue( self_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ self_item_.readChildren count ] == 4, @"OK" );
        GHAssertTrue( self_item_.parent != nil, @"OK" );
        GHAssertTrue( self_item_.parent == parent_item_, @"OK" );
        
        GHAssertTrue( parent_item_.readChildren != nil, @"OK" );
        GHAssertTrue( [ parent_item_.readChildren count ] == 1, @"OK" );
        GHAssertTrue( parent_item_.parent == nil, @"OK" );
        
        GHAssertTrue( child_item_.readChildren == nil, @"OK" );
        GHAssertTrue( child_item_.parent != nil, @"OK" );
        GHAssertTrue( child_item_.parent == self_item_, @"OK" );
    }
}


@end