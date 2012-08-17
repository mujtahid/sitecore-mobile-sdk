#import "SCAsyncTestCase.h"

@interface GetFieldValueFromFieldTest : SCAsyncTestCase
@end

@implementation GetFieldValueFromFieldTest

-(void)testStringField
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            NSString* path_ = @"/sitecore/content/Nicam/";
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                NSSet* fields_ = [ NSSet setWithObject: @"Menu title" ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"Menu title" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    [ field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    } );
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    NSLog( @"[ field_ type ]: %@", [ field_ type ] );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Single-Line Text" ], @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"Home" ], @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( [ [ field_ fieldValue ] isKindOfClass: [ NSString class ] ] == TRUE, @"OK" );
    NSLog( @"[ field_ fieldValue ]: %@", [ field_ fieldValue ] );
    GHAssertTrue( [ [ field_ fieldValue ] isEqualToString: @"Home" ], @"OK" );
}

-(void)testImageField
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                NSSet* fields_ = [ NSSet setWithObject: @"Footer Logo" ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"Footer Logo" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }

                    [ field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    } );
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Image" ], @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCImageField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ [ field_ fieldValue ] isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
}

-(void)testCheckBoxField
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObject: @"CheckBoxField" ] ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"CheckBoxField" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }

                    [ field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    } );
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"1" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Checkbox" ], @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCCheckboxField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( [ [ field_ fieldValue ] boolValue ] == TRUE, @"OK" );
}

-(void)testColorPickerField
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObject: @"ColorPickerField" ] ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"ColorPickerField" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    [ field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    } );
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"#FFFF00" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Color Picker" ], @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCColorPickerField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
}

-(void)testDateField
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObject: @"DateField" ] ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"DateField" ];
                    if ( !field_ )
                    {
                       didFinishCallback_();
                       return;
                    }

                    [ field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    } );
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"20120201T000000" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Date" ], @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCDateField class ] ] == TRUE, @"OK" );
    id date_ = [ field_ fieldValue ];
    GHAssertTrue( [ date_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
}

-(void)testDateTimeField
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            NSString* path_ =@"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObject: @"DateTimeField" ] ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"DateTimeField" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    [ field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    } );
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    NSLog( @"[ field_ rawValue ]: %@", [ field_ rawValue ] );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"20120201T120000" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Datetime" ], @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCDateTimeField class ] ] == TRUE, @"OK" );
    id date_ = [ field_ fieldValue ];
    GHAssertTrue( [ date_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
}

//STODO alr uncomment please this test
/*-(void)testCheckListMultiListSavedFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* checklist_field_ = nil;
    __block SCField* multilist_field_ = nil;
    __block NSArray* checklist_values_ = nil;
    __block NSArray* multilist_values_ = nil;
 
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObjects: @"CheckListField", @"MultiListField", nil ] ]( ^( id result_, NSError* error_ )
                {
                    checklist_field_ = [ item_ fieldWithName: @"CheckListField" ];
                    multilist_field_ = [ item_ fieldWithName: @"MultiListField" ];
                    if ( !checklist_field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    [ checklist_field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        checklist_values_ = [ checklist_field_ fieldValue ];
                        if ( !multilist_field_ )
                        {
                            didFinishCallback_();
                            return;
                        }
                        [ multilist_field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                        {
                            multilist_values_ = [ multilist_field_ fieldValue ];
                            didFinishCallback_();
                        } );                        
                    } );
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //Checklist test
    GHAssertTrue( checklist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checklist_field_ rawValue ] isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}|{F27FCB87-0CE6-4455-815F-F25310A51D0B}" ], @"OK" );
    GHAssertTrue( [ [ checklist_field_ type ] isEqualToString: @"Checklist" ], @"OK" );
    GHAssertTrue( [ checklist_field_ isKindOfClass: [ SCChecklistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ checklist_field_ item ] == item_, @"OK" );
    //test saved field value
    GHAssertTrue( [ checklist_values_ count ] == 2, @"OK" );
    NSLog( @"[ values_ ]: %@", checklist_values_ );
    SCItem* value_item_ = [ checklist_values_ objectAtIndex: 0 ];
    GHAssertTrue( value_item_ != nil, @"OK" );
    GHAssertTrue( [ value_item_.itemId isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}" ] == TRUE, @"OK" );
    
    //Multilist test
    GHAssertTrue( multilist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ multilist_field_ rawValue ] isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}|{F27FCB87-0CE6-4455-815F-F25310A51D0B}" ], @"OK" );
    GHAssertTrue( [ [ multilist_field_ type ] isEqualToString: @"Multilist" ], @"OK" );
    GHAssertTrue( [ multilist_field_ isKindOfClass: [ SCMultilistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ multilist_field_ item ] == item_, @"OK" );
    //test saved field value
    GHAssertTrue( [ multilist_values_ count ] == 2, @"OK" );
    NSLog( @"[ values_ ]: %@", multilist_values_ );
    value_item_ = [ multilist_values_ objectAtIndex: 0 ];
    GHAssertTrue( value_item_ != nil, @"OK" );
    NSLog( @"[ value_item_.itemId ]: %@", value_item_.itemId );
    GHAssertTrue( [ value_item_.itemId isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}" ] == TRUE, @"OK" );
}*/

//STODO alt please uncomment test
/*
-(void)testTreeListSavedFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    __block NSArray* values_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObjects: @"TreeListField", nil ] ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"TreeListField" ];
                    if ( !field_ )
                    {
                      didFinishCallback_();
                      return;
                    }

                    [ field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        values_ = [ field_ fieldValue ];
                        didFinishCallback_();                       
                    } );
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );

    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}|{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Treelist" ], @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCTreelistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test saved field value
    GHAssertTrue( [ values_ count ] == 2, @"OK" );
    NSLog( @"[ values_ ]: %@", values_ );
    SCItem* value_item_ = [ values_ objectAtIndex: 0 ];
    GHAssertTrue( value_item_ != nil, @"OK" );
    GHAssertTrue( [ value_item_.itemId isEqualToString: @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}" ] == TRUE, @"OK" );
}*/

-(void)testCheckListMultiListUnSavedFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* checklist_field_ = nil;
    __block SCField* multilist_field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                NSSet* fields_ = [ NSSet setWithObjects: @"CheckListField", @"MultiListField", nil ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    checklist_field_ = [ item_ fieldWithName: @"CheckListField" ];
                    multilist_field_ = [ item_ fieldWithName: @"MultiListField" ];
                    if ( !checklist_field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    [ checklist_field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        if ( !multilist_field_ )
                        {
                            didFinishCallback_();
                            return;
                        }
                        [ multilist_field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                        {
                            didFinishCallback_();
                        } );
                    } );
                } );
            } );
         }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    // Checklist test
    GHAssertTrue( checklist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checklist_field_ rawValue ] isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}|{F27FCB87-0CE6-4455-815F-F25310A51D0B}" ], @"OK" );
    GHAssertTrue( [ [ checklist_field_ type ] isEqualToString: @"Checklist" ], @"OK" );
    GHAssertTrue( [ checklist_field_ isKindOfClass: [ SCChecklistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ checklist_field_ item ] == item_, @"OK" );
    NSArray* values_ = [ checklist_field_ fieldValue ];
    //test if field does not retain items of it's value
    GHAssertTrue( values_ == nil, @"OK" );
    //Multilist test
    GHAssertTrue( multilist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ multilist_field_ rawValue ] isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}|{F27FCB87-0CE6-4455-815F-F25310A51D0B}" ], @"OK" );
    GHAssertTrue( [ [ multilist_field_ type ] isEqualToString: @"Multilist" ], @"OK" );
    GHAssertTrue( [ multilist_field_ isKindOfClass: [ SCMultilistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ multilist_field_ item ] == item_, @"OK" );
    values_ = [ multilist_field_ fieldValue ];
    //test if field does not retain items of it's value
    GHAssertTrue( values_ == nil, @"OK" );
}

//STODO alt please uncomment test
/*
-(void)testTreeListUnSavedField
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath: @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObjects: @"TreeListField", nil ] ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"TreeListField" ];
                    if ( !field_ )
                    {
                      didFinishCallback_();
                      return;
                    }
                    [ field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        didFinishCallback_();
                    } );
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}|{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Treelist" ], @"OK" );
    GHAssertTrue( [ field_ isKindOfClass: [ SCTreelistField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    NSArray* values_ = [ field_ fieldValue ];
    //test if field does not retain items of it's value
    GHAssertTrue( values_ == nil, @"OK" );
}*/

-(void)testDroplinkDroptreeSavedNormalFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* droplink_field_ = nil;
    __block SCField* droptree_field_ = nil;
    __block id droplink_value_ = nil;
    __block id droptree_value_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObjects: @"DropLinkFieldNormal", @"DropTreeFieldNormal", nil ] ]( ^( id result_, NSError* error_ )
                {
                    droplink_field_ = [ item_ fieldWithName: @"DropLinkFieldNormal" ];
                    droptree_field_ = [ item_ fieldWithName: @"DropTreeFieldNormal" ];
                    if ( !droplink_field_ )
                    {
                        didFinishCallback_();
                        return;
                    }

                    [ droplink_field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        droplink_value_ = [ droplink_field_ fieldValue ];
                        if ( !droptree_field_ )
                        {
                            didFinishCallback_();
                            return;
                        }
                        [ droptree_field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                        {
                            droptree_value_ = [ droptree_field_ fieldValue ];
                            didFinishCallback_();
                        } );                        
                    } );
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //droplink_field_ test
    GHAssertTrue( droplink_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droplink_field_ rawValue ] isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" ], @"OK" );
    GHAssertTrue( [ [ droplink_field_ type ] isEqualToString: @"Droplink" ], @"OK" );
    GHAssertTrue( [ droplink_field_ isKindOfClass: [ SCDroplinkField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droplink_field_ item ] == item_, @"OK" );
    //test saved field value
    GHAssertTrue( droplink_value_ != nil, @"OK" );
    NSLog( @"[ value_ ]: %@", droplink_value_ );
    SCItem* value_item_ = droplink_value_;
    GHAssertTrue( value_item_ != nil, @"OK" );
    GHAssertTrue( [ value_item_.itemId isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" ] == TRUE, @"OK" );
    
    //droptree_field_ test
    GHAssertTrue( droptree_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droptree_field_ rawValue ] isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" ], @"OK" );
    GHAssertTrue( [ [ droptree_field_ type ] isEqualToString: @"Droptree" ], @"OK" );
    GHAssertTrue( [ droptree_field_ isKindOfClass: [ SCDroptreeField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droptree_field_ item ] == item_, @"OK" );
    //test saved field value
    GHAssertTrue( droptree_value_ != nil, @"OK" );
    NSLog( @"[ value_ ]: %@", droptree_value_ );
    value_item_ = droptree_value_;
    GHAssertTrue( value_item_ != nil, @"OK" );
    GHAssertTrue( [ value_item_.itemId isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" ] == TRUE, @"OK" );
}

-(void)testDroplinkDroptreeSavedInvalidFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* droplink_field_ = nil;
    __block SCField* droptree_field_ = nil;
    __block id droplink_value_ = nil;
    __block id droptree_value_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObjects: @"DropLinkFieldInvalid", @"DropTreeFieldEmpty", nil ] ]( ^( id result_, NSError* error_ )
                {
                    droplink_field_ = [ item_ fieldWithName: @"DropLinkFieldInvalid" ];
                    droptree_field_ = [ item_ fieldWithName: @"DropTreeFieldEmpty" ];
                    if ( !droplink_field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    [ droplink_field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        droplink_value_ = [ droplink_field_ fieldValue ];
                        if ( !droptree_field_ )
                        {
                            didFinishCallback_();
                            return;
                        }
                        [ droptree_field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                        {
                            droptree_value_ = [ droptree_field_ fieldValue ];
                            didFinishCallback_();
                        } );                        
                    } );
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //droplink_field_ test
    GHAssertTrue( droplink_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droplink_field_ rawValue ] isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E80003}!test" ], @"OK" );
    GHAssertTrue( [ [ droplink_field_ type ] isEqualToString: @"Droplink" ], @"OK" );
    GHAssertTrue( [ droplink_field_ isKindOfClass: [ SCDroplinkField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droplink_field_ item ] == item_, @"OK" );
    //test saved field value
    NSLog( @"[ value_ ]: %@", droplink_value_ );
    GHAssertTrue( droplink_value_ == nil, @"OK" );
    
    //droptree_field_ test
    GHAssertTrue( droptree_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droptree_field_ rawValue ] isEqualToString: @"" ], @"OK" );
    GHAssertTrue( [ [ droptree_field_ type ] isEqualToString: @"Droptree" ], @"OK" );
    GHAssertTrue( [ droptree_field_ isKindOfClass: [ SCDroptreeField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droptree_field_ item ] == item_, @"OK" );
    //test saved field value
    NSLog( @"[ value_ ]: %@", droptree_value_ );
    GHAssertTrue( droptree_value_ == nil, @"OK" );
}


-(void)testDroplinkDroptreeUnsavedFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* droplink_field_ = nil;
    __block SCField* droptree_field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObjects: @"DropLinkFieldEmpty", @"DropTreeFieldInvalid", nil ] ]( ^( id result_, NSError* error_ )
                {
                    droplink_field_ = [ item_ fieldWithName: @"DropLinkFieldEmpty" ];
                    droptree_field_ = [ item_ fieldWithName: @"DropTreeFieldInvalid" ];
                    if ( !droplink_field_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    
                    [ droplink_field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        if ( !droptree_field_ )
                        {
                            didFinishCallback_();
                            return;
                        }
                        [ droptree_field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                        {
                            didFinishCallback_();
                        } );                        
                    } );
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //droplink_field_ test
    GHAssertTrue( droplink_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droplink_field_ rawValue ] isEqualToString: @"" ], @"OK" );
    GHAssertTrue( [ [ droplink_field_ type ] isEqualToString: @"Droplink" ], @"OK" );
    GHAssertTrue( [ droplink_field_ isKindOfClass: [ SCDroplinkField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droplink_field_ item ] == item_, @"OK" );
    //test field value
    SCItem* value_item_ = [ droplink_field_ fieldValue ];
    GHAssertTrue( value_item_ == nil, @"OK" );
    
    //droptree_field_ test
    GHAssertTrue( droptree_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droptree_field_ rawValue ] isEqualToString: @"{D3FD1A1C-775C-446E-0000-29B6B6CF94E4}" ], @"OK" );
    GHAssertTrue( [ [ droptree_field_ type ] isEqualToString: @"Droptree" ], @"OK" );
    GHAssertTrue( [ droptree_field_ isKindOfClass: [ SCDroptreeField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droptree_field_ item ] == item_, @"OK" );
    //test saved field value
    value_item_ = [ droptree_field_ fieldValue ];
    GHAssertTrue( value_item_ == nil, @"OK" );
}

-(void)testGeneralLinkLinkNormal
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar" ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObjects: @"GeneralLinkFieldLinkNormal", nil ] ]( ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldLinkNormal" ];
                    didFinishCallback_();
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //field_ test
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ field_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCInternalFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCInternalFieldLinkData* link_data_ = (SCInternalFieldLinkData*)[ field_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"internal" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"/Nicam/Products/Digital_SLR/Tweets.aspx" ], @"OK" );
    GHAssertTrue( [ [ link_data_ anchor ] isEqualToString: @"Anchor" ], @"OK" );
    GHAssertTrue( [ [ link_data_ queryString ] isEqualToString: @"/*" ], @"OK" );
    GHAssertTrue( [ [ link_data_ itemId ] isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

//STODO fix test
-(void)testGeneralLinkExtLinkNormal
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar" ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* fields_ = [ NSSet setWithObject: @"GeneralLinkFieldExtLinkNormal" ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldExtLinkNormal" ];
                    if ( !field_ )
                    {
                        didFinishCallback_();
                        return;
                    }

                    [ field_ fieldValueReader ]( ^( id result_, NSError* error_ )
                    {
                        /// where result ???
                        didFinishCallback_();
                    } );
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //field_ test
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ field_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCExternalFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCExternalFieldLinkData* link_data_ = (SCExternalFieldLinkData*)[ field_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"external" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"http://google.com" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGeneralLinkMediaInvalid
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;
    __block UIImage* media_value_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* filds_ = [ NSSet setWithObject: @"GeneralLinkFieldMediaInvalid" ];
                [ item_ fieldsReaderForFieldsNames: filds_ ]( ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldMediaInvalid" ];
                    if ( ![ field_ linkData ] )
                    {
                        didFinishCallback_();
                        return;
                    }

                    [ (SCMediaFieldLinkData*)[ field_ linkData ] imageReader ]( ^( id result_, NSError* error_ )
                    {  
                        media_value_ = result_;
                        didFinishCallback_();                     
                    } );
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //field_ test
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ field_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCMediaFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCMediaFieldLinkData* link_data_ = (SCMediaFieldLinkData*)[ field_ linkData ];
    GHAssertTrue( [ link_data_ linkDescription ] == nil, @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"media" ], @"OK" );
    GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"/Mobile SDK/mobile_tweet1" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
    //test image reader
    GHAssertTrue( media_value_ == nil, @"OK" );
    //GHAssertTrue( [ media_value_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
}

-(void)testGeneralLinkJavascriptEmpty
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar" ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* fields_ = [ NSSet setWithObject: @"GeneralLinkFieldJavascriptEmpty" ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldJavascriptEmpty" ];
                    didFinishCallback_();
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //field_ test
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ field_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCFieldLinkData* link_data_ = (SCFieldLinkData*)[ field_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @" " ], @"OK" );
    //GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"javascript" ], @"OK" );
    NSLog( @"link_data_: %@", link_data_ );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @" " ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"javascript:" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGeneralLinkAnchor
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* fields_ = [ NSSet setWithObjects: @"GeneralLinkFieldAnchor", nil ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldAnchor" ];
                    didFinishCallback_();
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //field_ test
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ field_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCAnchorFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCAnchorFieldLinkData* link_data_ = (SCAnchorFieldLinkData*)[ field_ linkData ];

    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"anchor" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"header1" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

@end
