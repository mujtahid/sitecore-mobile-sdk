#import "SCAsyncTestCase.h"

@interface DeleteItemTest : SCAsyncTestCase
@end

@implementation DeleteItemTest

static NSString* normal_path_ = @"/sitecore/content/Test Data/Create Edit Delete Tests/Positive";
static NSString* system_path_ = @"/sitecore/system/Settings/Workflow/Test Data/Create Edit Delete Tests";

-(void)testDeleteParentItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* item2_ = nil;
    __block int read_items_count_ = 0;
    __block NSArray* delete_response_ = nil;
    __block NSString* path_ = system_path_;

    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";


    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: path_ ];

        request_.itemName     = @"ItemToDelete";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.flags = SCItemReaderRequestReadFieldsValues;
        NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"{239F9CF4-E5A0-44E0-B342-0F32CD4C6D8B}", @"__Source", nil ];
        request_.fieldsRawValuesByName = fields_;

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            item_ = result;
            request_.request = item_.path;
            request_.itemName     = @"ChildItem";
            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
            {
                item2_ = result;
                didFinishCallback_();
            } );
        } );
    };

    void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item2_.itemId ];
        item_request_.flags = SCItemReaderRequestIngnoreCache;
        item_request_.scope = SCItemReaderParentScope;
        [ apiContext_ removeItemsWithRequest: item_request_ ]( ^( id response_, NSError* read_error_ )
        {
            delete_response_ = response_;
            didFinishCallback_();                                                  
        } );
    };

    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item2_.itemId ];
        item_request_.flags = SCItemReaderRequestIngnoreCache;
        item_request_.scope = SCItemReaderParentScope | SCItemReaderSelfScope;
        [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            read_items_count_ = [ read_items_ count ];
            didFinishCallback_();                                                  
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );

    //first item:
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );

    //second item:
    GHAssertTrue( item2_ != nil, @"OK" );
    GHAssertTrue( [ [ item2_ displayName ] hasPrefix: @"ChildItem" ], @"OK" );
    GHAssertTrue( [ [ item2_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );

    //removed items:
    GHAssertTrue( read_items_count_ == 0, @"OK" );
    
    NSLog( @"deleteResponse_: %@", delete_response_ );
    GHAssertTrue( [ delete_response_ count ] == 1, @"OK" );
}

-(void)testDeleteItemsIerarchy
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* item2_ = nil;
    __block int read_items_count_ = 0;
    __block NSArray* deleteResponse_ = nil;
    __block NSString* deletedItemId_ = @"";
    __block NSString* path_ = @"/sitecore/layout/Layouts/Test Data/Create Edit Delete Tests";

    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];

    apiContext_.defaultDatabase = @"web";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: path_ ];
        
        request_.itemName     = @"ItemToDelete";
        request_.itemTemplate = @"System/Layout/Renderings/Xsl Rendering";
        request_.flags = SCItemReaderRequestReadFieldsValues;
        NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"/xsl/sample rendering.xslt", @"Path", nil ];
        request_.fieldsRawValuesByName = fields_;

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            item_ = result;
            request_.request = item_.path;
            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
            {
                item2_ = result;
                didFinishCallback_();
            } );
        } );
    };

    void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        deletedItemId_ = item_.itemId;
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId ];
        item_request_.flags = SCItemReaderRequestIngnoreCache;
        item_request_.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;
        [ apiContext_ removeItemsWithRequest: item_request_ ]( ^( id response_, NSError* read_error_ )
        {
            deleteResponse_ = response_;
            didFinishCallback_();                                                  
        } );
    };

    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item2_.itemId ];
        item_request_.flags = SCItemReaderRequestIngnoreCache;
        item_request_.scope = SCItemReaderParentScope | SCItemReaderSelfScope;
        [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            read_items_count_ = [ read_items_ count ];
            didFinishCallback_();                                                  
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );

    //first item:
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Renderings/Xsl Rendering" ], @"OK" );

    NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
    GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );

    //second item:
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item2_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
    GHAssertTrue( [ [ item2_ itemTemplate ] isEqualToString: @"System/Layout/Renderings/Xsl Rendering" ], @"OK" );

    NSLog( @"item2_.readFieldsByName: %@", item2_.readFieldsByName );
    GHAssertTrue( [ item2_.readFieldsByName count ] == 0, @"OK" );

    //removed items:
    GHAssertTrue( read_items_count_ == 0, @"OK" );
    NSLog( @"deleteResponse_: %@", deleteResponse_ );
    NSLog( @"deletedItemId_: %@", deletedItemId_ );
    GHAssertTrue( [ deleteResponse_ containsObject: deletedItemId_ ], @"OK" );
}

-(void)testDeleteItemsWithQuery
{
    __block SCApiContext* apiContext_ = nil;
    __block int readItemsCount_ = 0;
    __block NSString* request1_ = nil;
    __block NSString* request2_ = nil;
    __block NSString* request3_ = nil;
    __block NSArray* deleteResponse_ = nil;
    __block NSString* path_ = @"/sitecore/layout/Layouts/Test Data/Create Edit Delete Tests";
    __block SCItem* rootItem_;
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];

    apiContext_.defaultDatabase = @"web";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: path_ ];
        request_.itemName     = @"ItemToDelete";
        request_.itemTemplate = @"System/Layout/Renderings/Xsl Rendering";
        request_.flags = SCItemReaderRequestReadFieldsValues;
        NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"/xsl/sample rendering.xslt", @"Path", nil ];
        request_.fieldsRawValuesByName = fields_;

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            request1_ = [ result itemId ];
            rootItem_ = result;
            request_.request = [ result path ];
            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
            {
                request2_ = [ result itemId ];
                request_.request = [ result path ];
                [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
                {
                    [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
                     {
                         request3_ = [ result itemId ];
                         didFinishCallback_();
                     } );
                } );
            } );
        } );
    };

    void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];
        apiContext_.defaultDatabase = @"web";
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest new ];
        item_request_.request = 
            [ rootItem_.path stringByAppendingString: @"/parent::*/descendant::*[@@key='itemtodelete']" ];
        item_request_.flags = SCItemReaderRequestIngnoreCache;
        item_request_.requestType = SCItemReaderRequestQuery;
        item_request_.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;
        [ apiContext_ removeItemsWithRequest: item_request_ ]( ^( id response_, NSError* read_error_ )
        {
            deleteResponse_ = response_;
            NSLog( @"deleteResponse_: %@", deleteResponse_ );
            didFinishCallback_();                                                  
        } );
    };

    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];
        apiContext_.defaultDatabase = @"web";
        SCItemsReaderRequest* itemRequest_ = [ SCItemsReaderRequest requestWithItemPath: request2_ ];
        itemRequest_.flags = SCItemReaderRequestIngnoreCache;
        itemRequest_.scope = SCItemReaderParentScope | SCItemReaderSelfScope | SCItemReaderChildrenScope;
        [ apiContext_ itemsReaderWithRequest: itemRequest_ ]( ^( NSArray* readItems_, NSError* read_error_ )
        {
            readItemsCount_ = [ readItems_ count ];
            didFinishCallback_();                                                  
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );

    //first item:
    SCItem* item_ = [ apiContext_ itemWithId: request1_ ];
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Renderings/Xsl Rendering" ], @"OK" );

    //second item:
    SCItem* item2_ = [ apiContext_ itemWithId: request2_ ];
    GHAssertTrue( item2_ != nil, @"OK" );
    GHAssertTrue( [ [ item2_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
    
    //third item:
    SCItem* item3_ = [ apiContext_ itemWithId: request3_ ];
    GHAssertTrue( item3_ != nil, @"OK" );
    GHAssertTrue( [ [ item3_ displayName ] hasPrefix: @"ItemToDelete" ], @"OK" );
    
    [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    //remove response:
    GHAssertTrue( readItemsCount_ == 0, @"OK" );
    NSLog( @"deleteResponse_: %@", deleteResponse_ );
    GHAssertTrue( [ deleteResponse_ count ] == 3, @"OK" );
    
    //deleted items
    item_ = [ apiContext_ itemWithId: request1_ ];
    GHAssertNil( item_, @"OK" );
    
    item2_ = [ apiContext_ itemWithId: request2_ ];
    GHAssertNil( item2_, @"OK" );
    
    item3_ = [ apiContext_ itemWithId: request3_ ];
    GHAssertNil( item3_, @"OK" );


}

-(void)testDeleteItemsWithChildren
{
    __weak __block SCApiContext* weakApiContext_   = nil;
    __weak __block SCApiContext* strongApiContext_ = nil;

    __block BOOL itemsWasCreated_ = NO;
    __block NSString* itemId1_;
    __block NSString* itemId2_;
    __block NSString* itemId3_;
    __block SCItem* rootItem_;

    NSString* path_ = @"/sitecore/layout/Layouts/Test Data/Create Edit Delete Tests";
    __block NSString* currentPath_ = path_;

    strongApiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                 login: SCWebApiAdminLogin
                                              password: SCWebApiAdminPassword ];

    weakApiContext_ = strongApiContext_;

    strongApiContext_.defaultDatabase = @"web";

    __block BOOL itemsWasRemoved_ = NO;

    void (^deleteBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongApiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                                     login: SCWebApiAdminLogin
                                                  password: SCWebApiAdminPassword ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemId1_ ];
        [ strongApiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
        {
            itemsWasRemoved_ = response_ != nil;
            didFinishCallback_();
        } );
    };

//    [ self performAsyncRequestOnMainThreadWithBlock: deleteBlock_
//                                           selector: _cmd ];

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: path_ ];
        request_.itemName     = @"ItemToDelete";
        request_.itemTemplate = @"System/Layout/Renderings/Xsl Rendering";

        [ strongApiContext_ itemCreatorWithRequest: request_ ]( ^( SCItem* result1_, NSError* error_ )
        {
            if ( !result1_ )
            {
                didFinishCallback_();
                return;
            }
            rootItem_ = result1_;

            itemId1_ = result1_.itemId;
            currentPath_ = [ currentPath_ stringByAppendingPathComponent: result1_.displayName ];
            request_.request = currentPath_;
            [ strongApiContext_ itemCreatorWithRequest: request_ ]( ^( SCItem* result2_, NSError* error )
            {
                if ( !result2_ )
                {
                    didFinishCallback_();
                    return;
                }
                itemId2_ = result2_.itemId;
                currentPath_ = [ currentPath_ stringByAppendingPathComponent: result2_.displayName ];
                request_.request = currentPath_;
                [ strongApiContext_ itemCreatorWithRequest: request_ ]( ^( SCItem* result3_, NSError* error )
                {
                    itemId3_ = result3_.itemId;
                    itemsWasCreated_ = ( result3_ != nil );
                    didFinishCallback_();
                } );
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( itemsWasCreated_, @"OK" );

    GHAssertNotNil( strongApiContext_, @"OK" );

    SCItem* item1_ = [ strongApiContext_ itemWithId: itemId1_ ];
    GHAssertNotNil( item1_, @"OK" );

    SCItem* item2_ = [ strongApiContext_ itemWithId: itemId2_ ];
    GHAssertNotNil( item2_, @"OK" );

    SCItem* item3_ = [ strongApiContext_ itemWithId: itemId3_ ];
    GHAssertNotNil( item3_, @"OK" );

    itemsWasRemoved_ = NO;

    [ self performAsyncRequestOnMainThreadWithBlock: deleteBlock_
                                           selector: _cmd ];

    GHAssertTrue( itemsWasRemoved_, @"OK" );
    GHAssertNotNil( strongApiContext_, @"OK" );

    item1_ = [ strongApiContext_ itemWithId: itemId1_ ];
    GHAssertNil( item1_, @"OK" );

    item2_ = [ strongApiContext_ itemWithId: itemId2_ ];
    GHAssertNil( item2_, @"OK" );

    item3_ = [ strongApiContext_ itemWithId: itemId3_ ];
    GHAssertNil( item3_, @"OK" );
}

@end
