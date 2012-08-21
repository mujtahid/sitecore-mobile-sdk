#import "SCAsyncTestCase.h"

@interface CreateItemPositiveTest : SCAsyncTestCase
@end

@implementation CreateItemPositiveTest

static NSString* parent_path_ = @"/sitecore/content/Test Data/Create Edit Delete Tests/Positive";
static NSString* web_path_ = @"/sitecore/layout/Layouts/Test Data/Create Edit Delete Tests";

-(void)testCreateNormalItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSArray* delete_response_ = nil;
    __block NSDictionary* read_fields_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];

        apiContext_.defaultDatabase = @"master";

        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: parent_path_ ];

        request_.itemName     = @"Normal Item";
        request_.itemTemplate = @"Mobile SDK/Mobile Email";
        NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"Subject", @"Subject"
                                                                               , @"Message Body, la-la-la :P", @"Message Body"
                                                                               , nil ];
        request_.fieldsRawValuesByName = fields_;
        request_.fieldNames = [ NSSet setWithObjects: @"Subject", @"Message Body", nil ];

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            item_ = result;
            NSLog( @"items fields: %@", item_.readFieldsByName );
            read_fields_ = item_.readFieldsByName;
            didFinishCallback_();
        } );
    };
    
    void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];

        apiContext_.defaultDatabase = @"master";
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId ];
        item_request_.flags = SCItemReaderRequestIngnoreCache;
        [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* read_items_, NSError* read_error_ )
        {
            if ( [ read_items_ count ] > 0 )
            {
                SCItem* item_to_delete_ = [ read_items_ objectAtIndex: 0 ];
                SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: item_to_delete_.path ];
                [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                {
                    delete_response_ = response_;
                    didFinishCallback_();
                } );
            }
            else
            {
                NSLog( @"Can't find item to delete: %@", read_error_ );
                didFinishCallback_();
            }
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"Normal Item" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"Mobile SDK/Mobile Email" ], @"OK" );
    GHAssertTrue( [ read_fields_ count ] == 2, @"OK" );
    GHAssertTrue( [ [ read_fields_ objectForKey: @"Message Body" ] rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ [ read_fields_ objectForKey: @"Subject" ] rawValue ] isEqualToString: @"Subject" ], @"OK" );
    
    GHAssertTrue( [ delete_response_ count ] == 1, @"OK" );
}

-(void)testCreateItemWithoutFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSArray* deleteResponse_ = nil;
    __block NSString* deletedItemId_ = @"";
    
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];

        request_.itemName     = @"Item Without Fields";
        request_.itemTemplate = @"Mobile SDK/Mobile Map";

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result_, NSError* error )
        {
            item_ = result_;
            didFinishCallback_();
        } );
    };

    void (^deleteBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {

        [ apiContext_ itemReaderForItemId: item_.itemId ]( ^( id readItem_, NSError* read_error_ )
        {
            if ( readItem_ != nil )
            {
                item_ = readItem_;
                deletedItemId_ = item_.itemId;
                SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId ];
                [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                {
                    deleteResponse_ = response_;
                    didFinishCallback_();
                } );
            }
            else
            {
                NSLog( @"Can't find item to delete: %@", read_error_ );
                didFinishCallback_();
            }
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: deleteBlock_
                                           selector: _cmd ];
    GHAssertTrue( apiContext_ != nil, @"OK" );

    GHAssertTrue( item_ != nil, @"OK" );
    NSLog(@"[ item_ response ]: %@", deleteResponse_ );
    GHAssertTrue( [ [ item_ displayName ] isEqualToString: @"Item Without Fields" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"Mobile SDK/Mobile Map" ], @"OK" );

    GHAssertTrue( [ item_.readFieldsByName count ] == 0, @"OK" );
    GHAssertTrue( [ deleteResponse_ count ] == 1, @"OK" );
    GHAssertTrue( [ deleteResponse_ containsObject: deletedItemId_ ], @"OK" );
}

-(void)testCreateSpecialDeviceItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSArray* delete_response_ = nil;
    __block NSDictionary* read_fields_ = nil;

    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiCreatorLogin
                                        password: SCWebApiCreatorPassword ];
    
    apiContext_.defaultDatabase = @"web";
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];

        request_.itemName     = @"Device Item";
        request_.itemTemplate = @"System/Layout/Device";
        NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"device_name", @"__Display name", nil ];
        request_.fieldsRawValuesByName = fields_;
        request_.fieldNames = [ NSSet setWithObject: @"__Display name" ];

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            item_ = result;
            read_fields_ = [ item_ readFieldsByName ];
            didFinishCallback_();
        } );
    };

    void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSString* item_id = item_.itemId;

        [ apiContext_ itemReaderForItemId: item_id ]( ^( id read_item_, NSError* read_error_ )
        {
            if ( read_item_ != nil )
            {
                item_ = read_item_;
                SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: item_.path ];
                [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                {
                    delete_response_ = response_;
                    didFinishCallback_();
                } );
            }
            else
            {
                NSLog( @"Can't find item to delete: %@", read_error_ );
                didFinishCallback_();
            }
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );

    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"device_name" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Device" ], @"OK" );

    GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );
    NSLog( @"read_fields_: %@", read_fields_);
    GHAssertTrue( [ [ [ read_fields_ objectForKey: @"__Display name" ] rawValue ] isEqualToString: @"device_name" ], @"OK" );

    GHAssertTrue( [ delete_response_ count ] == 1, @"OK" );
}

-(void)testCreateSpecialFolderItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    
    __block NSArray* delete_response_ = nil;
    __block NSDictionary* read_fields_ = nil;

    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiCreatorLogin
                                        password: SCWebApiCreatorPassword ];

    apiContext_.defaultDatabase = @"web";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];

        request_.itemName     = @"Folder Item";
        request_.itemTemplate = @"Common/Folder";
        NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"Folder Display Name", @"__Display name", nil ];
        request_.fieldsRawValuesByName = fields_;
        request_.fieldNames = [ NSSet setWithObject: @"__Display name" ];

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            item_ = result;
            read_fields_ = [ item_ readFieldsByName ];
            didFinishCallback_();
        } );
    };
    
    void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSString* item_id = item_.itemId;
        
        [ apiContext_ itemReaderForItemId: item_id ]( ^( id read_item_, NSError* read_error_ )
        {
            if ( read_item_ != nil )
            {
                item_ = read_item_;
                SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId ];
                [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                {
                    delete_response_ = response_;
                    didFinishCallback_();
                } );
            }
            else
            {
                NSLog( @"Can't find item to delete: %@", read_error_ );
                didFinishCallback_();
            }
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"Folder Display Name" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"Common/Folder" ], @"OK" );

    NSLog( @"items field value: %@", [ [ read_fields_ objectForKey: @"__Display name" ] rawValue ] );
    GHAssertTrue( [ read_fields_ count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ read_fields_ objectForKey: @"__Display name" ] rawValue ] isEqualToString: @"Folder Display Name" ], @"OK" );
    GHAssertTrue( [ delete_response_ count ] == 1, @"OK" );
}

-(void)testCreateSpecialLayoutInWebItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block NSArray* deleteResponse_ = nil;
    __block NSString* deletedItemId_ = @"";
    __block NSDictionary* readFields_ = nil;
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];

    apiContext_.defaultDatabase = @"web";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];

        request_.itemName     = @"Layout Item";
        request_.itemTemplate = @"System/Layout/Layout";
        request_.fieldNames = [ NSSet setWithObjects: @"Path", nil ];
        NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
                                 @"/xsl/test_layout.aspx"
                                 , @"Path"
                                 , nil ];
        request_.fieldsRawValuesByName = fields_;

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            item_ = result;
            readFields_ = item_.readFieldsByName;
            didFinishCallback_();
        } );
    };

    void (^deleteBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemId: item_.itemId ];
        item_request_.flags = SCItemReaderRequestIngnoreCache;
        [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* readItems_, NSError* read_error_ )
        {
            if ( [ readItems_ count ] != 0 )
            {
                SCItem* itemToDelete_ = [ readItems_ objectAtIndex: 0 ];
                deletedItemId_ = itemToDelete_.itemId;
                SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: itemToDelete_.itemId ];
                [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                {
                    deleteResponse_ = response_;
                    didFinishCallback_();
                } );
            }
            else
            {
                NSLog( @"Can't find item to delete: %@", read_error_ );
                didFinishCallback_();
            }
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: deleteBlock_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );

    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"Layout Item" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );

    NSLog( @"items field value: %@", [ [ readFields_ objectForKey: @"Path" ] fieldValue ] );
    NSLog( @"item_.readFieldsByName: %@", readFields_ );
    GHAssertTrue( [ readFields_ count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ readFields_ objectForKey: @"Path" ] fieldValue ] isEqualToString: @"/xsl/test_layout.aspx" ], @"OK" );
    NSLog( @"delete_response: %@", deleteResponse_ );
    NSLog( @"deleteResponse_: %@", deleteResponse_ );
    GHAssertTrue( [ deleteResponse_ containsObject: deletedItemId_ ], @"OK" );
}



-(void)testCreateTwoItemsInWeb
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* item2_ = nil;
    __block int readItemsCount_ = 0;
    __block NSDictionary* fieldsByName_ = nil;
    __block NSDictionary* fields2ByName_ = nil;

    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];

    apiContext_.defaultDatabase = @"web";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];

        request_.itemName     = @"Two Layout Items";
        request_.itemTemplate = @"System/Layout/Layout";
        NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys:
                                 @"/xsl/test_layout.aspx"
                                 , @"Path"
                                 , nil ];
        request_.fieldsRawValuesByName = fields_;
        request_.fieldNames = [ NSSet setWithObjects: @"Path", nil ];
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            item_ = result;
            fieldsByName_ = [ item_ readFieldsByName ];
            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
            {
                item2_ = result;
                fields2ByName_ = [ item_ readFieldsByName ];
                didFinishCallback_();
            } );
        } );
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemPath: web_path_ ];
        item_request_.flags = SCItemReaderRequestIngnoreCache;
        item_request_.scope = SCItemReaderChildrenScope;
        [ apiContext_ itemsReaderWithRequest: item_request_ ]( ^( NSArray* readItems_, NSError* read_error_ )
        {
            readItemsCount_ = [ readItems_ count ];
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );

    //first item
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"Two Layout Items" ], @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );

    NSLog( @"items field value: %@", [ [ fieldsByName_ objectForKey: @"Path" ] fieldValue ] );

    GHAssertTrue( [ fieldsByName_ count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ fieldsByName_ objectForKey: @"Path" ] fieldValue ] isEqualToString: @"/xsl/test_layout.aspx" ], @"OK" );

    //second item
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item2_ displayName ] hasPrefix: @"Two Layout Items 1" ], @"OK" );
    GHAssertTrue( [ [ item2_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
    
    NSLog( @"items field value: %@", [ [ fields2ByName_ objectForKey: @"Path" ] fieldValue ] );
    
    GHAssertTrue( [ fields2ByName_ count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ fields2ByName_ objectForKey: @"Path" ] fieldValue ] isEqualToString: @"/xsl/test_layout.aspx" ], @"OK" );
}

-(void)testCreateItemsIerarhyInWeb
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCItem* item2_ = nil;
    
    apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                           login: SCWebApiAdminLogin
                                        password: SCWebApiAdminPassword ];
    
    apiContext_.defaultDatabase = @"web";

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        __block SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: web_path_ ];

        request_.itemName     = @"Layout Items Ierarchy";
        request_.itemTemplate = @"System/Layout/Layout";
        NSDictionary* fields_ = [ [ NSDictionary alloc ] initWithObjectsAndKeys: @"Layout Display", @"__Display name", nil ];
        request_.fieldsRawValuesByName = fields_;
        request_.fieldNames = [ NSSet setWithObject: @"__Display name" ];

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result_, NSError* error )
        {
            item_ = result_;
            request_.request = item_.path;
            NSLog( @"readFieldsByName: %@", [item_ readFieldsByName ] );
            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
            {
                item2_ = result;
                NSLog( @"readFieldsByName: %@", [item_ readFieldsByName ] );
                NSLog( @"readFieldsByName2: %@", [item2_ readFieldsByName ] );
                didFinishCallback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];


    GHAssertTrue( apiContext_ != nil, @"OK" );

    //first item
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );

    NSLog( @"readFieldsByName: %@", [item_ readFieldsByName ] );
    NSLog( @"readFieldsByName2: %@", [item2_ readFieldsByName ] );
    GHAssertTrue( [ item_.readFieldsByName count ] == 1, @"OK" );
    GHAssertTrue( [ [ item_ displayName ] hasPrefix: @"Layout Display" ], @"OK" );
    GHAssertTrue( [ [ [ item_ fieldWithName: @"__Display name" ] fieldValue ] isEqualToString: @"Layout Display" ], @"OK" );

    //second item
    GHAssertTrue( item2_ != nil, @"OK" );
    GHAssertTrue( [ [ item2_ itemTemplate ] isEqualToString: @"System/Layout/Layout" ], @"OK" );
    GHAssertTrue( [ item2_.readFieldsByName count ] == 1, @"OK" );
    GHAssertTrue( [ [ item2_ displayName ] hasPrefix: @"Layout Display" ], @"OK" );
    GHAssertTrue( [ [ [ item2_ fieldWithName: @"__Display name" ] fieldValue ] isEqualToString: @"Layout Display" ], @"OK" );
}

@end

