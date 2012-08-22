#import "SCAsyncTestCase.h"

@interface GetFieldFromItemTest : SCAsyncTestCase
@end

@implementation GetFieldFromItemTest

-(void)testAfterValueReadString
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_  = nil;
    __block id fieldValue_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath: @"/sitecore/content/Nicam/" ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                [ item_ fieldValueReaderForFieldName: @"Footer Logo" ]( ^( id result_, NSError* error_ )
                {
                    fieldValue_ = [ item_ fieldValueWithName: @"Footer Logo" ];
                    didFinishCallback_();
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( fieldValue_ != nil, @"OK" );
    GHAssertTrue( [ fieldValue_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
}

-(void)testAfterValueReadColorPicker
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id field_value_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                [ item_ fieldValueReaderForFieldName: @"ColorPickerField" ]( ^( id result_, NSError* error_ )
                {
                    field_value_ = [ item_ fieldValueWithName: @"ColorPickerField" ];
                    didFinishCallback_();
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_value_ != nil, @"OK" );
    NSLog(@"color: %@",(UIColor*)field_value_);
    GHAssertTrue( [ field_value_ isKindOfClass: [ UIColor class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_value_ isEqual: [ UIColor yellowColor ] ], @"OK" );
}

-(void)testAfterFieldReadCheckbox
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id field_value_ = nil;
    __block SCField* field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/" ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* fields_ = [ NSSet setWithObject: @"CheckBoxField" ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"CheckBoxField" ];
                    field_value_ = [ item_ fieldValueWithName: @"CheckBoxField" ];
                    didFinishCallback_();
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
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( field_value_ != nil, @"OK" );
    GHAssertTrue( [ (NSNumber*)field_value_ intValue ] == 1, @"OK" );
    GHAssertTrue( [ [ field_ fieldValue ] boolValue ] == TRUE, @"OK" );
}

-(void)testAfterFieldReadDateTimeAndDate
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id date_value_ = nil;
    __block SCField* date_field_ = nil;
    __block id datetime_value_ = nil;
    __block SCField* datetime_field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath: path_ ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* fields_ = [ NSSet setWithObjects: @"DateField", @"DateTimeField", nil ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    date_field_ = [ item_ fieldWithName: @"DateField" ];
                    date_value_ = [ item_ fieldValueWithName: @"DateField" ];
                    datetime_field_ = [ item_ fieldWithName: @"DateTimeField" ];
                    datetime_value_ = [ item_ fieldValueWithName: @"DateTimeField" ];
                    didFinishCallback_();
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //Date field
    GHAssertTrue( date_field_ != nil, @"OK" );
    GHAssertTrue( [ [ date_field_ rawValue ] isEqualToString: @"20120201T000000" ], @"OK" );
    GHAssertTrue( [ [ date_field_ type ] isEqualToString: @"Date" ], @"OK" );
    GHAssertTrue( [ date_field_ item ] == item_, @"OK" );
    GHAssertTrue( date_value_ != nil, @"OK" );
    GHAssertTrue( [ date_value_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    [ dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss ZZ" ];
    NSDate* dateToCompare = [ dateFormatter dateFromString: @"01 Feb 2012 00:00:00 -0000" ];
    GHAssertTrue( [ date_value_ isEqualToDate: dateToCompare ] == TRUE, @"OK" );
    //Datetime field
    GHAssertTrue( datetime_field_ != nil, @"OK" );
    GHAssertTrue( [ [ datetime_field_ rawValue ] isEqualToString: @"20120201T120000" ], @"OK" );
    GHAssertTrue( [ [ datetime_field_ type ] isEqualToString: @"Datetime" ], @"OK" );
    GHAssertTrue( [ datetime_field_ item ] == item_, @"OK" );
    GHAssertTrue( datetime_value_ != nil, @"OK" );
    GHAssertTrue( [ datetime_value_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    [ dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss ZZ" ];
    dateToCompare = [ dateFormatter dateFromString: @"01 Feb 2012 12:00:00 -0000" ];
    GHAssertTrue( [ datetime_value_ isEqualToDate: dateToCompare ] == TRUE, @"OK" );

}


-(void)testAfterFieldReadMultilist
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id field_value_ = nil;
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
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObject: @"MultiListField" ] ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"MultiListField" ];
                    field_value_ = [ item_ fieldValueWithName: @"MultiListField" ];
                    didFinishCallback_();
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ != nil, @"OK" );
    GHAssertTrue( [ [ field_ rawValue ] isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}|{F27FCB87-0CE6-4455-815F-F25310A51D0B}" ], @"OK" );
    GHAssertTrue( [ [ field_ type ] isEqualToString: @"Multilist" ], @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( field_value_ == nil, @"OK" );
    GHAssertTrue( [ field_ fieldValue ] == nil, @"OK" );
}

-(void)testAfterFieldReadTreelist
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_   = nil;
    __block id fieldValue_  = nil;
    __block SCField* field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  path_ ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObject: @"TreeListField" ] ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName: @"TreeListField" ];
                    fieldValue_ = [ item_ fieldValueWithName: @"TreeListField" ];
                    didFinishCallback_();
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
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    GHAssertTrue( fieldValue_ == nil, @"OK" );
    GHAssertTrue( [ field_ fieldValue ] == nil, @"OK" );
}

-(void)testNoReadFieldString
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id field_value_ = nil;
    __block SCField* field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/" ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                field_ = [ item_ fieldWithName: @"Menu title" ];
                field_value_ = [ item_ fieldValueWithName: @"Menu title" ];
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ == nil, @"OK" );
    GHAssertTrue( field_value_ == nil, @"OK" );
}

//STODO alr uncomment please test
/*-(void)testCheckAndMultiList
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id checklistValue_ = nil;
    __block id multilistValue_ = nil;

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
                NSSet* fieldNames_ = [ NSSet setWithObjects: @"MultiListField", @"CheckListField", nil ];
                [ item_ fieldsValuesReaderForFieldsNames: fieldNames_ ]( ^( id result_, NSError* error_ )
                {
                    checklistValue_ = [ item_ fieldValueWithName: @"CheckListField" ];
                    multilistValue_ = [ item_ fieldValueWithName: @"MultiListField" ];
                    didFinishCallback_();
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //Checklist test
    GHAssertTrue( checklistValue_ != nil, @"OK" );
    GHAssertTrue( [ checklistValue_ count ] == 2, @"OK" );
    SCItem* value_item_ = [ checklistValue_ objectAtIndex: 0 ];
    GHAssertTrue( value_item_ != nil, @"OK" );
    GHAssertTrue( [ value_item_.itemId isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}" ] == TRUE, @"OK" );

    //Multilist test
    GHAssertTrue( multilistValue_ != nil, @"OK" );
    GHAssertTrue( [ multilistValue_ count ] == 2, @"OK" );
    value_item_ = [ multilistValue_ objectAtIndex: 0 ];
    GHAssertTrue( value_item_ != nil, @"OK" );
    GHAssertTrue( [ value_item_.itemId isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}" ] == TRUE, @"OK" );
}*/

-(void)testDroplinkAndDroptree
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
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
                NSSet* fieldNames_ = [ NSSet setWithObjects: @"DropLinkFieldEmpty", @"DropTreeFieldNormal", nil ];
                [ item_ fieldsValuesReaderForFieldsNames: fieldNames_ ]( ^( id result_, NSError* error_ )
                {
                    droplink_value_ = [ item_ fieldValueWithName: @"DropLinkFieldEmpty" ];
                    droptree_value_ = [ item_ fieldValueWithName: @"DropTreeFieldNormal" ];
                    didFinishCallback_();
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //droplink test
    GHAssertTrue( droplink_value_ == nil, @"OK" );

    //droptree test
    GHAssertTrue( droptree_value_ != nil, @"OK" );
    SCItem* value_item_ = droptree_value_;
    GHAssertTrue( value_item_ != nil, @"OK" );
    GHAssertTrue( [ value_item_.itemId isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" ] == TRUE, @"OK" );
}

-(void)testImageLoaderForSCMediaPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block id value_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ imageLoaderForSCMediaPath:  @"~/media/Mobile SDK/Contacts" ]( ^( id result_, NSError* error_ )
            {
                value_ = result_;
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    //GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
}

-(void)testGeneralLinkMediaNormal
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block id mediaValue_ = nil;
    __block SCGeneralLinkField* field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  path_ ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* fields_ = [ NSSet setWithObject: @"GeneralLinkFieldMediaNormal" ] ;
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldMediaNormal" ];
                    if ( ![ field_ linkData ] )
                    {
                        didFinishCallback_();
                        return;
                    }

                    SCMediaFieldLinkData* linkData_ = (SCMediaFieldLinkData*)[ field_ linkData ];
                    [ linkData_ imageReader ]( ^( id result_, NSError* error_ )
                    {
                        mediaValue_ = result_;
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
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"media" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"/Mobile SDK/mobile_tweet" ], @"OK" );
    GHAssertTrue( [ [ link_data_ itemId ] isEqualToString: @"{C74A5229-ED73-49A8-A5D8-A834E90F2D8A}" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
    //test image reader
    GHAssertTrue( mediaValue_ != nil, @"OK" );
    GHAssertTrue( [ mediaValue_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
}

-(void)testGeneralLinkLinkEmpty
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  path_ ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObject: @"GeneralLinkFieldLinkEmpty" ] ]( ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldLinkEmpty" ];
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
     SCFieldLinkData* link_data_ = (SCInternalFieldLinkData*)[ field_ linkData ];
     GHAssertTrue( [ link_data_ linkDescription ] == nil, @"OK" );
     GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
     GHAssertTrue( [ link_data_ url ] == nil, @"OK" );
     //test field value
     GHAssertTrue( [ field_ fieldValue ] == link_data_, @"OK" );

    GHAssertTrue( [ field_ item ] == item_, @"OK" );
}

-(void)testGeneralLinkExtLinkInvalid
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  path_ ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                [ item_ fieldsReaderForFieldsNames: [ NSSet setWithObject: @"GeneralLinkFieldExtLinkInvalid" ] ]( ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldExtLinkInvalid" ];
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
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCExternalFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCExternalFieldLinkData* link_data_ = (SCExternalFieldLinkData*)[ field_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"78  78" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"external" ], @"OK" );
    GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"//&&@" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGeneralLinkEmail
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  path_ ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* fields_ = [ NSSet setWithObject: @"GeneralLinkFieldEmail" ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldEmail" ];
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
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCEmailFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCEmailFieldLinkData* link_data_ = (SCEmailFieldLinkData*)[ field_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"mailto" ], @"OK" );
    NSLog( @"link_data_: %@", link_data_ );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"mailto:rundueva@gmail.com" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGeneralLinkJavascriptNormal
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCGeneralLinkField* field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  path_ ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* fields_ = [ NSSet setWithObject: @"GeneralLinkFieldJavascript" ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    field_ = (SCGeneralLinkField*)[ item_ fieldWithName: @"GeneralLinkFieldJavascript" ];
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
    GHAssertTrue( [ [ field_ linkData ] isKindOfClass: [ SCJavascriptFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_ item ] == item_, @"OK" );
    //test link data
    SCJavascriptFieldLinkData* link_data_ = (SCJavascriptFieldLinkData*)[ field_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"javascript" ], @"OK" );
    NSLog( @"link_data_: %@", link_data_ );
    GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"javascript:document.write('Test javascript field')" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGetStandardField
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block SCField* field_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  path_ ]( ^( id result_, NSError* error_ )
            {
                item_ = result_;
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                NSSet* fields_ = [ NSSet setWithObject: @"__Display name" ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    field_ = [ item_ fieldWithName:  @"__Display name" ];
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
    GHAssertTrue( [ field_ rawValue ] == [ item_ displayName ], @"OK" );
    
}



@end
