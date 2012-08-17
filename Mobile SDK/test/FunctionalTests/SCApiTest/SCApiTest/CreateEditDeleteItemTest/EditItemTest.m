#import "SCAsyncTestCase.h"

@interface EditItemTest : SCAsyncTestCase
@end

@implementation EditItemTest

static NSString* webPath_    = @"/sitecore/layout/Layouts/Test Data/Create Edit Delete Tests";
static NSString* corePath_   = @"/sitecore/layout/Layouts/Test Data/Create Edit Delete Tests";
static NSString* masterPath_ = @"/sitecore/content/Test Data/Create Edit Delete Tests/Positive";

-(void)testCreateAndEditItemInWeb
{
    __weak __block SCApiContext* apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                                        login: SCWebApiAdminLogin
                                                                     password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";
    __block SCItem* edited_item_ = nil;

    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: webPath_ ];

        request_.itemName     = @"Tweet Item";
        request_.itemTemplate = @"Mobile SDK/Mobile Tweet";

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            edited_item_ = result;
            didFinishCallback_();
        } );
    };

    void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* fieldNames_  = [ NSSet setWithObjects: @"Text", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                      fieldsNames: fieldNames_ ];

        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            if ( [ items_ count ] != 0 )
            {
                SCItem* item_ = [ items_ objectAtIndex: 0 ];
                NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                SCField* field_ = [ item_.readFieldsByName objectForKey: @"Text" ];
                field_.rawValue = @"Text2";
                [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                {
                    edited_item_ = editedItem_;
                    NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"Text" ] fieldValue ] );
                    didFinishCallback_();
                } );
            }
            else 
            {
                didFinishCallback_();
            }
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );

    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"Tweet Item" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"Mobile SDK/Mobile Tweet" ], @"OK" );

    NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"Text" ] fieldValue ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"Text" ] rawValue ] isEqualToString: @"Text2" ], @"OK" );
}

-(void)testCreateAndEditItemInMaster
{
    __weak __block SCApiContext* apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                                        login: SCWebApiAdminLogin
                                                                     password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"master";
    __block SCItem* edited_item_ = nil;
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: masterPath_ ];
        
        request_.itemName     = @"Empty Item";
        request_.itemTemplate = @"Mobile SDK/Mobile Tweet";
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            edited_item_ = result;
            didFinishCallback_();
        } );
    };
    
    void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* fieldNames_  = [ NSSet setWithObjects: @"Text", @"Urls", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                      fieldsNames: fieldNames_ ];
        
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            if ( [ items_ count ] != 0 )
            {
                SCItem* item_ = [ items_ objectAtIndex: 0 ];
                NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                SCField* field_ = [ item_.readFieldsByName objectForKey: @"Text" ];
                field_.rawValue = @"Text22__";
                SCField* field2_ = [ item_.readFieldsByName objectForKey: @"Urls" ];
                field2_.rawValue = @"urla22__";
                [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                {
                    edited_item_ = editedItem_;
                    didFinishCallback_();
                } );
            }
            else 
            {
                didFinishCallback_();
            }
        } );
    };
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* fieldNames_  = [ NSSet setWithObjects: @"Text", @"Urls", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                      fieldsNames: fieldNames_ ];
        request_.flags = SCItemReaderRequestIngnoreCache;
        
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            if ( [ items_ count ] > 0 )
            {
                edited_item_ = [ items_ objectAtIndex: 0 ];
                didFinishCallback_();
            }
            else 
            {
                didFinishCallback_();
            }
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"Empty Item" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"Mobile SDK/Mobile Tweet" ], @"OK" );
    
    NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"Text" ] fieldValue ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 2, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"Text" ] fieldValue ] isEqualToString: @"Text22__" ], @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"Urls" ] rawValue ] isEqualToString: @"urla22__" ], @"OK" );
}


-(void)testCreateAndEditSystemItemInWeb
{
    __block SCApiContext* apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";
    __block SCItem* edited_item_ = nil;

    void (^createBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: webPath_ ];

        request_.itemName     = @"Language Item";
        request_.itemTemplate = @"System/Language";

        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            edited_item_ = result;
            didFinishCallback_();
        } );
    };

    void (^editBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* fieldNames_  = [ NSSet setWithObjects: @"Dictionary", @"Iso", @"Display name", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                      fieldsNames: fieldNames_ ];

        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            if ( [ items_ count ] != 0 )
            {
                SCItem* item_ = [ items_ objectAtIndex: 0 ];
                NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                SCField* field_ = [ item_.readFieldsByName objectForKey: @"Dictionary" ];
                field_.rawValue = @"en-US.tdf";
                SCField* field2_ = [ item_.readFieldsByName objectForKey: @"Iso" ];
                field2_.rawValue = @"en";
                SCField* field3_ = [ item_.readFieldsByName objectForKey: @"Display name" ];
                field3_.rawValue = @"Display_name";
                [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                {
                    edited_item_ = editedItem_;
                    didFinishCallback_();
                } );
            }
            else 
            {
                didFinishCallback_();
            }
        } );
    };
    void (^readBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* fieldNames_  = [ NSSet setWithObjects: @"Dictionary", @"Iso", @"Display name", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                        fieldsNames: fieldNames_ ];
        request_.flags = SCItemReaderRequestIngnoreCache;

        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            if ( [ items_ count ] > 0 )
            {
                NSLog( @"items fields: %@", [ [ items_ objectAtIndex: 0 ] readFieldsByName ] );
                edited_item_ = [ items_ objectAtIndex: 0 ];
                didFinishCallback_();
            }
            else 
            {
                didFinishCallback_();
            }
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: createBlock_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: editBlock_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: readBlock_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( edited_item_ != nil, @"OK" );
    //GHAssertTrue( [ [ edited_item_ displayName ] isEqualToString: @"Display_name" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"System/Language" ], @"OK" );
    
    NSLog( @"items fields: %@", [ edited_item_ readFieldsByName ] );
    //GHAssertTrue( [ edited_item_.readFieldsByName count ] == 3, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"Dictionary" ] rawValue ]  isEqualToString: @"en-US.tdf" ], @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"Iso" ] rawValue ] isEqualToString: @"en" ], @"OK" );
    //GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"Display name" ] rawValue ] isEqualToString: @"Display_name" ], @"OK" );
}

-(void)testCreateAndEditItemNotSave
{
    __weak __block SCApiContext* apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                                        login: SCWebApiAdminLogin
                                                                     password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";
    __block SCItem* edited_item_ = nil;

    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: webPath_ ];
        
        request_.itemName     = @"Not Saved Item";
        request_.itemTemplate = @"Mobile SDK/Mobile Tweet";
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
                                                         {
                                                             edited_item_ = result;
                                                             didFinishCallback_();
                                                         } );
    };
    
    void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* fieldNames_  = [ NSSet setWithObjects: @"Text", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                        fieldsNames: fieldNames_ ];
        
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            if ( [ items_ count ] != 0 )
            {
                SCItem* item_ = [ items_ objectAtIndex: 0 ];
                NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                SCField* field_ = [ item_.readFieldsByName objectForKey: @"Text" ];
                field_.rawValue = @"Text2";
                edited_item_ = item_;
                didFinishCallback_();
            }
            else 
            {
                didFinishCallback_();
            }
        } );
    };
    
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* fieldNames_  = [ NSSet setWithObjects: @"Text", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                        fieldsNames: fieldNames_ ];
        request_.flags = SCItemReaderRequestIngnoreCache;
        
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            if ( [ items_ count ] > 0 )
            {
                edited_item_ = [ items_ objectAtIndex: 0 ];
                didFinishCallback_();
            }
            else 
            {
                didFinishCallback_();
            }
        } );
    };

    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"Not Saved Item" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"Mobile SDK/Mobile Tweet" ], @"OK" );
    
    NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"Text" ] fieldValue ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"Text" ] fieldValue ] isEqualToString: @"" ], @"OK" );
    
}

-(void)testCreateAndEditItemInCore
{
    __weak __block SCApiContext* apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                                        login: SCWebApiAdminLogin
                                                                     password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"core";
    __block SCItem* edited_item_ = nil;
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: corePath_ ];
        
        request_.itemName     = @"Folder Item";
        request_.itemTemplate = @"Common/Folder";
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            edited_item_ = result;
            didFinishCallback_();
        } );
    };
    
    void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* fieldNames_  = [ NSSet setWithObjects: @"__Display name", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                      fieldsNames: fieldNames_ ];
        
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            if ( [ items_ count ] != 0 )
            {
                SCItem* item_ = [ items_ objectAtIndex: 0 ];
                NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                SCField* field_ = [ item_.readFieldsByName objectForKey: @"__Display name" ];
                field_.rawValue = @"Text2";
                [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                {
                    edited_item_ = editedItem_;
                    didFinishCallback_();
                } );
            }
            else 
            {
                didFinishCallback_();
            }
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"Text2" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"Common/Folder" ], @"OK" );
    
    NSLog( @"items field value: %@", [ [ edited_item_ fieldWithName: @"__Display name" ] fieldValue ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 1, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"__Display name" ] fieldValue ] isEqualToString: @"Text2" ], @"OK" );
    
}


-(void)testCreateAndEditSeveralItemsAtOnce
{
    __block SCApiContext* apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword ];
    apiContext_.defaultDatabase = @"web";
    __block SCItem* edited_item_ = nil;
    __block int items_count_ = 0;
    
    void (^create_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCCreateItemRequest* request_ = [ SCCreateItemRequest requestWithItemPath: webPath_ ];
        
        request_.itemName     = @"Several Items";
        request_.itemTemplate = @"System/Language";
        
        [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
        {
            edited_item_ = result;
            request_.request = [ (SCItem*)result path ];
            [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
            {
                [ apiContext_ itemCreatorWithRequest: request_ ]( ^( id result, NSError* error )
                {
                    didFinishCallback_();
                } );
            } );
        } );
    };
    
    void (^edit_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* fieldNames_  = [ NSSet setWithObjects: @"Dictionary", @"Iso", @"__Display name", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                        fieldsNames: fieldNames_ ];
        request_.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            if ( [ items_ count ] > 0 )
            {
                __block int i = 0;
                for (SCItem* curr_item_ in items_) 
                {
                    SCItem* item_ = curr_item_;
                    item_ = [ items_ objectAtIndex: 0 ];
                    NSLog( @"item_.readFieldsByName: %@", item_.readFieldsByName );
                    SCField* field_ = [ item_.readFieldsByName objectForKey: @"Dictionary" ];
                    field_.rawValue = @"en-US.tdf";
                    SCField* field2_ = [ item_.readFieldsByName objectForKey: @"Iso" ];
                    field2_.rawValue = @"en";
                    SCField* field3_ = [ item_.readFieldsByName objectForKey: @"__Display name" ];
                    field3_.rawValue = @"__Display name new";
                    [ item_ saveItem ]( ^( SCItem* editedItem_, NSError* error_ )
                    {
                        i++;
                        edited_item_ = editedItem_;
                        if ( i == items_.count ) 
                        {
                            didFinishCallback_();
                        }
                    } );
                }
            }
            else 
            {
                didFinishCallback_();
            }
        } );
    };
    void (^read_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSSet* fieldNames_  = [ NSSet setWithObjects: @"Dictionary", @"Iso", @"__Display name", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: edited_item_.itemId
                                                                      fieldsNames: fieldNames_ ];
        request_.flags = SCItemReaderRequestIngnoreCache;
        request_.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            if ( [ items_ count ] > 0 )
            {
                items_count_ = [ items_ count ];
                edited_item_ = [ items_ objectAtIndex: 0 ];
                didFinishCallback_();
            }
            else 
            {
                didFinishCallback_();
            }
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: create_block_
                                           selector: _cmd ];
        
    [ self performAsyncRequestOnMainThreadWithBlock: edit_block_
                                           selector: _cmd ];
    
    [ self performAsyncRequestOnMainThreadWithBlock: read_block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( items_count_ == 3, @"OK" );
    GHAssertTrue( edited_item_ != nil, @"OK" );
    GHAssertTrue( [ [ edited_item_ displayName ] hasPrefix: @"__Display name new" ], @"OK" );
    GHAssertTrue( [ [ edited_item_ itemTemplate ] isEqualToString: @"System/Language" ], @"OK" );
    
    NSLog( @"items fields: %@", [ edited_item_ readFieldsByName ] );
    GHAssertTrue( [ edited_item_.readFieldsByName count ] == 3, @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"Dictionary" ] fieldValue ] isEqualToString: @"en-US.tdf" ], @"OK" );
    GHAssertTrue( [ [ [ edited_item_ fieldWithName: @"Iso" ] rawValue ] isEqualToString: @"en" ], @"OK" );
}


@end