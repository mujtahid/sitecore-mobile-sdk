#import "SCAsyncTestCase.h"

@interface GetFieldsFromItemReaderTest : SCAsyncTestCase
@end

@implementation GetFieldsFromItemReaderTest

-(void)testMultilistCheckboxImageStringFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* result_items_           = nil;
    __block SCField* checklist_field_        = nil;
    __block SCField* multilist_field_        = nil;
    __block SCField* checkbox_field_         = nil;
    __block SCField* image_field_            = nil;
    __block SCField* sinlgeline_field_       = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = @"/sitecore/content/Nicam";
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"CheckListField"
                                    , @"MultiListField"
                                    , @"CheckBoxField"
                                    , @"Footer Logo"
                                    , @"Menu title", nil ];

            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_     = items_;
                checklist_field_  = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"CheckListField" ];
                multilist_field_  = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"MultiListField" ];
                checkbox_field_   = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"CheckBoxField"  ];
                image_field_      = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"Footer Logo"    ];
                sinlgeline_field_ = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"Menu title"     ];

                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ result_items_ objectAtIndex: 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    // Checklist test
    GHAssertTrue( checklist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checklist_field_ rawValue ] isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}|{F27FCB87-0CE6-4455-815F-F25310A51D0B}" ], @"OK" );
    GHAssertTrue( [ [ checklist_field_ type ] isEqualToString: @"Checklist" ], @"OK" );
    GHAssertTrue( [ checklist_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"CheckListField" ] == checklist_field_, @"OK" );
    NSArray* values_ = [ checklist_field_ fieldValue ];
    GHAssertTrue( [ values_ count ] == 0, @"OK" );
    //Multilist test
    GHAssertTrue( multilist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ multilist_field_ rawValue ] isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}|{F27FCB87-0CE6-4455-815F-F25310A51D0B}" ], @"OK" );
    GHAssertTrue( [ [ multilist_field_ type ] isEqualToString: @"Multilist" ], @"OK" );
    GHAssertTrue( [ multilist_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"MultiListField" ] == multilist_field_, @"OK" );
    values_ = [ multilist_field_ fieldValue ];
    GHAssertTrue( [ values_ count ] == 0, @"OK" );
    // Checkbox test
    GHAssertTrue( checkbox_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checkbox_field_ rawValue ] isEqualToString: @"1" ], @"OK" );
    GHAssertTrue( [ [ checkbox_field_ type ] isEqualToString: @"Checkbox" ], @"OK" );
    GHAssertTrue( [ checkbox_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"CheckBoxField" ] == checkbox_field_, @"OK" );
    id value_ = [ checkbox_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ boolValue ] == TRUE, @"OK" );
    // Image test
    GHAssertTrue( image_field_ != nil, @"OK" );
    GHAssertTrue( [ image_field_ rawValue ] != nil , @"OK" );
    GHAssertTrue( [ [ image_field_ type ] isEqualToString: @"Image" ], @"OK" );
    GHAssertTrue( [ image_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Footer Logo" ] == image_field_, @"OK" );
    value_ = [ image_field_ fieldValue ];
    GHAssertTrue( value_ == nil, @"OK" );
    // Single-Line test
    GHAssertTrue( sinlgeline_field_ != nil, @"OK" );
    GHAssertTrue( [ [ sinlgeline_field_ rawValue ] isEqualToString: @"Home" ], @"OK" );
    GHAssertTrue( [ [ sinlgeline_field_ type ] isEqualToString: @"Single-Line Text" ], @"OK" );
    GHAssertTrue( [ sinlgeline_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Menu title" ] == sinlgeline_field_, @"OK" );
    value_ = [ sinlgeline_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ isEqualToString: @"Home" ] == TRUE, @"OK" );
}

-(void)testTreelistColorPickerDateTimeFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* result_items_           = nil;
    __block SCField* treelist_field_         = nil;
    __block SCField* date_field_             = nil;
    __block SCField* datetime_field_         = nil;
    __block SCField* colorpicker_field_      = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login:SCWebApiLogin 
                                                password:SCWebApiPassword];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = path_;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"TreeListField"
                                    , @"DateField"
                                    , @"DateTimeField"
                                    , @"ColorPickerField"
                                    , nil ];

            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_      = items_;
                treelist_field_    = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"TreeListField" ];
                date_field_        = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"DateField" ];
                datetime_field_    = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"DateTimeField" ];
                colorpicker_field_ = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"ColorPickerField" ];

                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ result_items_ objectAtIndex: 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    // Treelist test
    GHAssertTrue( treelist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ treelist_field_ rawValue ] isEqualToString: @"{110D559F-DEA5-42EA-9C1C-8A5DF7E70EF9}|{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}" ], @"OK" );
    GHAssertTrue( [ [ treelist_field_ type ] isEqualToString: @"Treelist" ], @"OK" );
    GHAssertTrue( [ treelist_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"TreeListField" ] == treelist_field_, @"OK" );
    NSArray* values_ = [ treelist_field_ fieldValue ];
    GHAssertTrue( [ values_ count ] == 0, @"OK" );
    // ColorPicker test
    GHAssertTrue( colorpicker_field_ != nil, @"OK" );
    GHAssertTrue( [ [ colorpicker_field_ rawValue ] isEqualToString: @"#FFFF00" ], @"OK" );
    GHAssertTrue( [ [ colorpicker_field_ type ] isEqualToString: @"Color Picker" ], @"OK" );
    GHAssertTrue( [ colorpicker_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"ColorPickerField" ] == colorpicker_field_, @"OK" );
    id value_ = [ colorpicker_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ isKindOfClass: [ UIColor class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ value_ isEqual: [ UIColor yellowColor ] ], @"OK" );
    // Date field
    GHAssertTrue( date_field_ != nil, @"OK" );
    GHAssertTrue( [ date_field_ rawValue ] != nil , @"OK" );
    GHAssertTrue( [ [ date_field_ rawValue ] isEqualToString: @"20120201T000000" ], @"OK" );
    GHAssertTrue( [ [ date_field_ type ] isEqualToString: @"Date" ], @"OK" );
    GHAssertTrue( [ date_field_ isKindOfClass: [ SCDateField class ] ] == TRUE, @"OK" );
    id date_ = [ date_field_ fieldValue ];
    GHAssertTrue( [ date_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    [ dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss ZZ" ];
    NSDate* dateToCompare = [ dateFormatter dateFromString: @"01 Feb 2012 00:00:00 -0000" ];
    GHAssertTrue( [ date_ isEqualToDate: dateToCompare ] == TRUE, @"OK" );

    // DateTime field
    GHAssertTrue( datetime_field_ != nil, @"OK" );
    GHAssertTrue( [ datetime_field_ rawValue ] != nil , @"OK" );
    GHAssertTrue( [ [ datetime_field_ rawValue ] isEqualToString: @"20120201T120000" ], @"OK" );
    GHAssertTrue( [ [ datetime_field_ type ] isEqualToString: @"Datetime" ], @"OK" );
    GHAssertTrue( [ datetime_field_ isKindOfClass: [ SCDateField class ] ] == TRUE, @"OK" );
    date_ = [ datetime_field_ fieldValue ];
    GHAssertTrue( [ date_ isKindOfClass: [ NSDate class ] ] == TRUE, @"OK" );
    [ dateFormatter setDateFormat:@"dd MMM yyyy HH:mm:ss ZZ" ];
    dateToCompare = [ dateFormatter dateFromString: @"01 Feb 2012 12:00:00 -0000" ];
    GHAssertTrue( [ date_ isEqualToDate: dateToCompare ] == TRUE, @"OK" );
}

-(void)testFieldsValuesCheckMultilistCheckboxImageStringFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* result_items_           = nil;
    __block SCField* checklist_field_        = nil;
    __block SCField* multilist_field_        = nil;
    __block SCField* checkbox_field_         = nil;
    __block SCField* image_field_            = nil;
    __block SCField* sinlgeline_field_       = nil;
    __block SCItem* field_value_item_        = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];

            request_.request     = @"/sitecore/content/Nicam";
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"CheckListField"
                                    , @"MultiListField"
                                    , @"CheckBoxField"
                                    , @"Footer Logo"
                                    , @"Menu title"
                                    , nil ];
            request_.flags = SCItemReaderRequestReadFieldsValues;

            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                SCItem* item_     = [ items_ objectAtIndex: 0 ];
                result_items_     = items_;
                checklist_field_  = [ item_ fieldWithName: @"CheckListField" ];
                multilist_field_  = [ item_ fieldWithName: @"MultiListField" ];
                field_value_item_ = [ [ multilist_field_ fieldValue ] objectAtIndex: 0 ];
                checkbox_field_   = [ item_ fieldWithName: @"CheckBoxField" ];
                image_field_      = [ item_ fieldWithName: @"Footer Logo" ];
                sinlgeline_field_ = [ item_ fieldWithName: @"Menu title" ];

                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ result_items_ objectAtIndex: 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ readFieldsByName ] count ] == 5, @"OK" );
    // Checklist test
    GHAssertTrue( checklist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checklist_field_ rawValue ] isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}|{F27FCB87-0CE6-4455-815F-F25310A51D0B}" ], @"OK" );
    GHAssertTrue( [ [ checklist_field_ type ] isEqualToString: @"Checklist" ], @"OK" );
    GHAssertTrue( [ checklist_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"CheckListField" ] == checklist_field_, @"OK" );

    //Multilist test
    GHAssertTrue( multilist_field_ != nil, @"OK" );
    GHAssertTrue( [ [ multilist_field_ rawValue ] isEqualToString: @"{812D47A0-4ED8-4E55-B2F7-9D64FBBF391D}|{F27FCB87-0CE6-4455-815F-F25310A51D0B}" ], @"OK" );
    GHAssertTrue( [ [ multilist_field_ type ] isEqualToString: @"Multilist" ], @"OK" );
    GHAssertTrue( [ multilist_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"MultiListField" ] == multilist_field_, @"OK" );
    GHAssertTrue( field_value_item_ == nil, @"OK" );

    // Checkbox test
    GHAssertTrue( checkbox_field_ != nil, @"OK" );
    GHAssertTrue( [ [ checkbox_field_ rawValue ] isEqualToString: @"1" ], @"OK" );
    GHAssertTrue( [ [ checkbox_field_ type ] isEqualToString: @"Checkbox" ], @"OK" );
    GHAssertTrue( [ checkbox_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"CheckBoxField" ] == checkbox_field_, @"OK" );
    id value_ = [ checkbox_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ boolValue ] == TRUE, @"OK" );
    // Image test
    GHAssertTrue( image_field_ != nil, @"OK" );
    GHAssertTrue( [ image_field_ rawValue ] != nil , @"OK" );
    GHAssertTrue( [ [ image_field_ type ] isEqualToString: @"Image" ], @"OK" );
    GHAssertTrue( [ image_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Footer Logo" ] == image_field_, @"OK" );
    value_ = [ image_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
    // Single-Line test
    GHAssertTrue( sinlgeline_field_ != nil, @"OK" );
    GHAssertTrue( [ [ sinlgeline_field_ rawValue ] isEqualToString: @"Home" ], @"OK" );
    GHAssertTrue( [ [ sinlgeline_field_ type ] isEqualToString: @"Single-Line Text" ], @"OK" );
    GHAssertTrue( [ sinlgeline_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Menu title" ] == sinlgeline_field_, @"OK" );
    value_ = [ sinlgeline_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ isEqualToString: @"Home" ] == TRUE, @"OK" );
}

-(void)testFieldsValuesDroplinkDroptreeFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* result_items_           = nil;
    __block SCField* droplink_normal_field_  = nil;
    __block SCField* droplink_empty_field_   = nil;
    __block SCField* droplink_invalid_field_ = nil;
    __block SCField* droptree_normal_field_  = nil;
    __block SCField* droptree_empty_field_   = nil;
    __block SCField* droptree_invalid_field_ = nil;
    __block SCItem* droplink_normal_value_   = nil;
    __block SCItem* droplink_empty_value_    = nil;
    __block SCItem* droplink_invalid_value_  = nil;
    __block SCItem* droptree_normal_value_   = nil;
    __block SCItem* droptree_empty_value_    = nil;
    __block SCItem* droptree_invalid_value_  = nil;

    NSSet* fields_ = [ NSSet setWithObjects: @"DropLinkFieldNormal"
                      , @"DropLinkFieldEmpty"
                      , @"DropLinkFieldInvalid"
                      , @"DropTreeFieldNormal"
                      , @"DropTreeFieldEmpty"
                      , @"DropTreeFieldInvalid"
                      , nil ];

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: SCWebApiLogin 
                                                password: SCWebApiPassword ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = path_;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = fields_;
            request_.flags       = SCItemReaderRequestReadFieldsValues;

            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                NSLog( @"error:%@", error_ );
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                }
                else
                {
                    SCItem* item_ = [ items_ objectAtIndex: 0 ];
                    result_items_ = items_;

                    droplink_normal_field_  = [ item_ fieldWithName: @"DropLinkFieldNormal"  ];
                    droplink_empty_field_   = [ item_ fieldWithName: @"DropLinkFieldEmpty"   ];
                    droplink_invalid_field_ = [ item_ fieldWithName: @"DropLinkFieldInvalid" ];
                    droptree_normal_field_  = [ item_ fieldWithName: @"DropTreeFieldNormal"  ];
                    droptree_empty_field_   = [ item_ fieldWithName: @"DropTreeFieldEmpty"   ];
                    droptree_invalid_field_ = [ item_ fieldWithName: @"DropTreeFieldInvalid" ];
                    droplink_normal_value_  = [ droplink_normal_field_  fieldValue ];
                    droplink_empty_value_   = [ droplink_empty_field_   fieldValue ];
                    droplink_invalid_value_ = [ droplink_invalid_field_ fieldValue ];
                    droptree_normal_value_  = [ droptree_normal_field_  fieldValue ];
                    droptree_empty_value_   = [ droptree_empty_field_   fieldValue ];
                    droptree_invalid_value_ = [ droptree_invalid_field_ fieldValue ];

                    didFinishCallback_();
                }
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ result_items_ objectAtIndex: 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ readFieldsByName ] count ] == [ fields_ count ], @"OK" );
    // droplink_normal test
    GHAssertTrue( droplink_normal_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droplink_normal_field_ rawValue ] isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" ], @"OK" );
    GHAssertTrue( [ [ droplink_normal_field_ type ] isEqualToString: @"Droplink" ], @"OK" );
    GHAssertTrue( [ droplink_normal_field_ isKindOfClass: [ SCDroplinkField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droplink_normal_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"DropLinkFieldNormal" ] == droplink_normal_field_, @"OK" );
    //test value
    GHAssertTrue( droplink_normal_value_ != nil, @"OK" );
    GHAssertTrue( [ droplink_normal_field_ fieldValue ] == droplink_normal_value_, @"OK" );
    GHAssertTrue( [ [ droplink_normal_value_ itemId ] isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" ], @"OK" );
    // droplink_empty test
    GHAssertTrue( droplink_empty_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droplink_empty_field_ rawValue ] isEqualToString: @"" ], @"OK" );
    GHAssertTrue( [ [ droplink_empty_field_ type ] isEqualToString: @"Droplink" ], @"OK" );
    GHAssertTrue( [ droplink_empty_field_ isKindOfClass: [ SCDroplinkField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droplink_empty_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"DropLinkFieldEmpty" ] == droplink_empty_field_, @"OK" );
    //test value
    GHAssertTrue( droplink_empty_value_ == nil, @"OK" );
    // droplink_invalid test
    GHAssertTrue( droplink_invalid_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droplink_invalid_field_ rawValue ] isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E80003}!test" ], @"OK" );
    GHAssertTrue( [ [ droplink_invalid_field_ type ] isEqualToString: @"Droplink" ], @"OK" );
    GHAssertTrue( [ droplink_invalid_field_ isKindOfClass: [ SCDroplinkField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droplink_invalid_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"DropLinkFieldInvalid" ] == droplink_invalid_field_, @"OK" );
    //test value
    GHAssertTrue( droplink_invalid_value_ == nil, @"OK" );
    
    // droptree_normal test
    GHAssertTrue( droptree_normal_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droptree_normal_field_ rawValue ] isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" ], @"OK" );
    GHAssertTrue( [ [ droptree_normal_field_ type ] isEqualToString: @"Droptree" ], @"OK" );
    GHAssertTrue( [ droptree_normal_field_ isKindOfClass: [ SCDroptreeField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droptree_normal_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"DropTreeFieldNormal" ] == droptree_normal_field_, @"OK" );
    //test value
    GHAssertTrue( droptree_normal_value_ != nil, @"OK" );
    GHAssertTrue( [ droptree_normal_field_ fieldValue ] == droptree_normal_value_, @"OK" );
    GHAssertTrue( [ [ droptree_normal_value_ itemId ] isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" ], @"OK" );
    // droptree_empty test
    GHAssertTrue( droptree_empty_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droptree_empty_field_ rawValue ] isEqualToString: @"" ], @"OK" );
    GHAssertTrue( [ [ droptree_empty_field_ type ] isEqualToString: @"Droptree" ], @"OK" );
    GHAssertTrue( [ droptree_empty_field_ isKindOfClass: [ SCDroptreeField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droptree_empty_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"DropTreeFieldEmpty" ] == droptree_empty_field_, @"OK" );
    //test value
    GHAssertTrue( droptree_empty_value_ == nil, @"OK" );
    // droptree_empty test
    GHAssertTrue( droptree_empty_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droptree_empty_field_ rawValue ] isEqualToString: @"" ], @"OK" );
    GHAssertTrue( [ [ droptree_empty_field_ type ] isEqualToString: @"Droptree" ], @"OK" );
    GHAssertTrue( [ droptree_empty_field_ isKindOfClass: [ SCDroptreeField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droptree_empty_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"DropTreeFieldEmpty" ] == droptree_empty_field_, @"OK" );
    //test value
    GHAssertTrue( droptree_empty_value_ == nil, @"OK" );
    // droptree_invalid test
    GHAssertTrue( droptree_invalid_field_ != nil, @"OK" );
    GHAssertTrue( [ [ droptree_invalid_field_ rawValue ] isEqualToString: @"{D3FD1A1C-775C-446E-0000-29B6B6CF94E4}" ], @"OK" );
    GHAssertTrue( [ [ droptree_invalid_field_ type ] isEqualToString: @"Droptree" ], @"OK" );
    GHAssertTrue( [ droptree_invalid_field_ isKindOfClass: [ SCDroptreeField class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ droptree_invalid_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"DropTreeFieldInvalid" ] == droptree_invalid_field_, @"OK" );
    //test value

    NSLog ( @"droptree_invalid_value_: %@", droptree_invalid_value_ );
    GHAssertTrue( droptree_invalid_value_ == nil, @"OK" );
}

-(void)testGeneralLinkLinkFields
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* result_items_            = nil;
    __block SCGeneralLinkField* field_normal_ = nil;
    __block SCGeneralLinkField* field_empty_  = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: SCWebApiLogin 
                                                password: SCWebApiPassword];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = path_;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldLinkNormal", @"GeneralLinkFieldLinkEmpty", nil ];
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                field_normal_ = (SCGeneralLinkField*)[ [ items_ objectAtIndex: 0 ] fieldWithName: @"GeneralLinkFieldLinkNormal" ];
                field_empty_  = (SCGeneralLinkField*)[ [ items_ objectAtIndex: 0 ] fieldWithName: @"GeneralLinkFieldLinkEmpty" ];

                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ result_items_ objectAtIndex: 0 ];
    GHAssertTrue( item_ != nil, @"OK" );

    // normal field test
    GHAssertTrue( field_normal_ != nil, @"OK" );
    GHAssertTrue( [ field_normal_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_normal_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_normal_ linkData ] isKindOfClass: [ SCInternalFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_normal_ item ] == item_, @"OK" );
    //test link data
    SCInternalFieldLinkData* link_data_ = (SCInternalFieldLinkData*)[ field_normal_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"internal" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"/Nicam/Products/Digital_SLR/Tweets.aspx" ], @"OK" );
    GHAssertTrue( [ [ link_data_ anchor ] isEqualToString: @"Anchor" ], @"OK" );
    GHAssertTrue( [ [ link_data_ queryString ] isEqualToString: @"/*" ], @"OK" );
    GHAssertTrue( [ [ link_data_ itemId ] isEqualToString: @"{02C6B148-BC77-4FD6-A13C-03B410E84103}" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_normal_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
    
    // empty field test
    GHAssertTrue( field_empty_ != nil, @"OK" );
    GHAssertTrue( [[ field_empty_ rawValue ] isEqualToString: @""], @"OK" );
    NSLog(@"[ field_empty_ rawValue ]:%@", [ field_empty_ rawValue ]);
    GHAssertTrue( [ [ field_empty_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_empty_ linkData ] isKindOfClass: [ SCFieldLinkData class ] ] == TRUE, @"OK" );
    link_data_ = (SCInternalFieldLinkData*)[ field_empty_ linkData ];
    GHAssertTrue( [ link_data_ linkDescription ] == nil, @"OK" );
    GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
    GHAssertTrue( [ link_data_ url ] == nil, @"OK" );
    //test field value
    GHAssertTrue( [ field_empty_ fieldValue ] == link_data_, @"OK" );
    GHAssertTrue( [ field_empty_ item ] == item_, @"OK" );
}

-(void)testGeneralLinkExtLinkFields
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* result_items_            = nil;
    __block SCGeneralLinkField* field_normal_ = nil;
    __block SCGeneralLinkField* field_empty_  = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: SCWebApiLogin 
                                                password: SCWebApiPassword];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = path_;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldExtLinkNormal", @"GeneralLinkFieldExtLinkInvalid", nil ];

            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                field_normal_ = (SCGeneralLinkField*)[ [ items_ objectAtIndex: 0 ] fieldWithName: @"GeneralLinkFieldExtLinkNormal" ];
                field_empty_  = (SCGeneralLinkField*)[ [ items_ objectAtIndex: 0 ] fieldWithName: @"GeneralLinkFieldExtLinkInvalid" ];

                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ result_items_ objectAtIndex: 0 ];
    GHAssertTrue( item_ != nil, @"OK" );

    // normal field test
    GHAssertTrue( field_normal_ != nil, @"OK" );
    GHAssertTrue( [ field_normal_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_normal_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_normal_ linkData ] isKindOfClass: [ SCExternalFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_normal_ item ] == item_, @"OK" );
    //test link data
    SCExternalFieldLinkData* link_data_ = (SCExternalFieldLinkData*)[ field_normal_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"external" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"http://google.com" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_normal_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );

    // invalid field test
    GHAssertTrue( field_empty_ != nil, @"OK" );
    GHAssertTrue( [ field_empty_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_empty_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_empty_ linkData ] isKindOfClass: [ SCExternalFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_empty_ item ] == item_, @"OK" );
    //test link data
    link_data_ = (SCExternalFieldLinkData*)[ field_empty_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"78  78" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"external" ], @"OK" );
    GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"//&&@" ], @"OK" );
    //test field value
    value_item_ = [ field_empty_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGeneralLinkMediaFields
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* result_items_            = nil;
    __block SCGeneralLinkField* field_normal_ = nil;
    __block SCGeneralLinkField* field_empty_  = nil;
    __block id media_value_normal_ = nil;
    __block id media_value_empty_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: SCWebApiLogin 
                                                password: SCWebApiPassword];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = path_;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldMediaNormal", @"GeneralLinkFieldMediaInvalid", nil ];
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                field_normal_ = (SCGeneralLinkField*)[ [ items_ objectAtIndex: 0 ] fieldWithName: @"GeneralLinkFieldMediaNormal" ];
                field_empty_  = (SCGeneralLinkField*)[ [ items_ objectAtIndex: 0 ] fieldWithName: @"GeneralLinkFieldMediaInvalid" ];
                if ( !field_normal_ )
                {
                    didFinishCallback_();
                    return;
                }
                [ (SCMediaFieldLinkData*)[ field_normal_ linkData ] imageReader ]( ^( id result_, NSError* error_ )
                {
                    media_value_normal_ = result_;
                    if ( !field_empty_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    [ (SCMediaFieldLinkData*)[ field_empty_ linkData ] imageReader ]( ^( id result_, NSError* error_ )
                    {
                        media_value_empty_ = result_;
                        didFinishCallback_();                     
                    } );                   
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ result_items_ objectAtIndex: 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    
    // normal field test
    GHAssertTrue( field_normal_ != nil, @"OK" );
    GHAssertTrue( [ field_normal_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_normal_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_normal_ linkData ] isKindOfClass: [ SCMediaFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_normal_ item ] == item_, @"OK" );
    //test link data
    SCMediaFieldLinkData* link_data_ = (SCMediaFieldLinkData*)[ field_normal_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"media" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"/Mobile SDK/mobile_tweet" ], @"OK" );
    GHAssertTrue( [ [ link_data_ itemId ] isEqualToString: @"{C74A5229-ED73-49A8-A5D8-A834E90F2D8A}" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_normal_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
    //test image reader
    GHAssertTrue( media_value_normal_ != nil, @"OK" );
    GHAssertTrue( [ media_value_normal_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );
    
    // invalid field test
    GHAssertTrue( field_empty_ != nil, @"OK" );
    GHAssertTrue( [ field_empty_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_empty_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_empty_ linkData ] isKindOfClass: [ SCMediaFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_empty_ item ] == item_, @"OK" );
    //test link data
    link_data_ = (SCMediaFieldLinkData*)[ field_empty_ linkData ];
    GHAssertTrue( [ link_data_ linkDescription ] == nil, @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"media" ], @"OK" );
    GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"/Mobile SDK/mobile_tweet1" ], @"OK" );
    //test field value
    value_item_ = [ field_empty_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
    //test image reader
    GHAssertTrue( media_value_empty_ == nil, @"OK" );

}

-(void)testGeneralLinkJavascriptFields
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* result_items_            = nil;
    __block SCGeneralLinkField* field_normal_ = nil;
    __block SCGeneralLinkField* field_empty_  = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: SCWebApiLogin 
                                                password: SCWebApiPassword];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = path_;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldJavascript", @"GeneralLinkFieldJavascriptEmpty", nil ];
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                field_normal_ = (SCGeneralLinkField*)[ [ items_ objectAtIndex: 0 ] fieldWithName: @"GeneralLinkFieldJavascript" ];
                field_empty_  = (SCGeneralLinkField*)[ [ items_ objectAtIndex: 0 ] fieldWithName: @"GeneralLinkFieldJavascriptEmpty" ];

                didFinishCallback_();
                } );
            }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ result_items_ objectAtIndex: 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    
    // normal field test
    GHAssertTrue( field_normal_ != nil, @"OK" );
    GHAssertTrue( [ field_normal_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_normal_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_normal_ linkData ] isKindOfClass: [ SCJavascriptFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_normal_ item ] == item_, @"OK" );
    //test link data
    SCFieldLinkData* link_data_ = (SCJavascriptFieldLinkData*)[ field_normal_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"javascript" ], @"OK" );
    NSLog( @"link_data_: %@", link_data_ );
    GHAssertTrue( [ link_data_ alternateText ] == nil, @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"javascript:document.write('Test javascript field')" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_normal_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
    
    // empty field test
    GHAssertTrue( field_empty_ != nil, @"OK" );
    GHAssertTrue( [ field_empty_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_empty_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_empty_ linkData ] isKindOfClass: [ SCFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_empty_ item ] == item_, @"OK" );
    //test link data
    link_data_ = (SCFieldLinkData*)[ field_empty_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @" " ], @"OK" );
    NSLog( @"link_data_: %@", link_data_ );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @" " ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"javascript:" ], @"OK" );
    //test field value
    value_item_ = [ field_empty_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGeneralLinkAnchorField
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* result_items_            = nil;
    __block SCGeneralLinkField* field_normal_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: SCWebApiLogin 
                                                password: SCWebApiPassword];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = path_;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldAnchor", nil ];
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                field_normal_ = (SCGeneralLinkField*)[ [ items_ objectAtIndex: 0 ] fieldWithName: @"GeneralLinkFieldAnchor" ];

                didFinishCallback_();
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ result_items_ objectAtIndex: 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    
    // normal field test
    GHAssertTrue( field_normal_ != nil, @"OK" );
    GHAssertTrue( [ field_normal_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_normal_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_normal_ linkData ] isKindOfClass: [ SCAnchorFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_normal_ item ] == item_, @"OK" );
    //test link data
    SCAnchorFieldLinkData* link_data_ = (SCAnchorFieldLinkData*)[ field_normal_ linkData ];
    
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"anchor" ], @"OK" );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"header1" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_normal_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );

}

-(void)testGeneralLinkEmailField
{
    __weak __block SCApiContext* apiContext_  = nil;
    __block NSArray* result_items_            = nil;
    __block SCGeneralLinkField* field_normal_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            NSString* path_ = @"/sitecore/content/Nicam/Community/Macro_Community/Macro_Calendar";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                                   login: SCWebApiLogin 
                                                password: SCWebApiPassword];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = path_;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet setWithObjects: @"GeneralLinkFieldEmail", nil ];
            
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                field_normal_ = (SCGeneralLinkField*)[ [ items_ objectAtIndex: 0 ] fieldWithName: @"GeneralLinkFieldEmail" ];

                didFinishCallback_();
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = [ result_items_ objectAtIndex: 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    
    // normal field test
    GHAssertTrue( field_normal_ != nil, @"OK" );
    GHAssertTrue( [ field_normal_ rawValue ] != nil, @"OK" );
    GHAssertTrue( [ [ field_normal_ type ] isEqualToString: @"General Link" ], @"OK" );
    GHAssertTrue( [ [ field_normal_ linkData ] isKindOfClass: [ SCEmailFieldLinkData class ] ] == TRUE, @"OK" );
    GHAssertTrue( [ field_normal_ item ] == item_, @"OK" );
    //test link data
    SCEmailFieldLinkData* link_data_ = (SCEmailFieldLinkData*)[ field_normal_ linkData ];
    GHAssertTrue( [ [ link_data_ linkDescription ] isEqualToString: @"Link Description" ], @"OK" );
    GHAssertTrue( [ [ link_data_ linkType ] isEqualToString: @"mailto" ], @"OK" );
    NSLog( @"link_data_: %@", link_data_ );
    GHAssertTrue( [ [ link_data_ alternateText ] isEqualToString: @"Alternate Text" ], @"OK" );
    GHAssertTrue( [ [ link_data_ url ] isEqualToString: @"mailto:rundueva@gmail.com" ], @"OK" );
    //test field value
    SCItem* value_item_ = [ field_normal_ fieldValue ];
    GHAssertTrue( [ value_item_ isEqual: link_data_ ], @"OK" );
}

-(void)testGetAllFieldsIncludingStandardFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            NSString* path_ = @"/sitecore/content/Nicam/Community";
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                                   login: SCWebApiAdminLogin
                                                password: SCWebApiAdminPassword];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                            fieldsNames: nil ];
            request_.scope = SCItemReaderSelfScope;
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* result_, NSError* error_ )
                                                             {
                                                                 if ( [ result_ count ] > 0 )
                                                                 {
                                                                     item_ = [ result_ objectAtIndex: 0 ];
                                                                 }
                                                                 didFinishCallback_();
                                                             } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    //fields test
    GHAssertTrue( [ item_ readFieldsByName ] != nil, @"OK" );
    NSLog( @"[ [ item_ readFieldsByName ] count ]: %d", [ [ item_ readFieldsByName ] count ] );
    NSLog( @"fields: %@", [ item_ readFieldsByName ] );
    GHAssertTrue( [ [ item_ readFieldsByName ] count ] > SCCommunityAllAdminFieldsCount, @"OK" );
    SCField* field_ = [ item_ fieldWithName: @"__Display name" ];
    GHAssertTrue( [ field_ rawValue ] == [ item_ displayName ], @"OK" );
    
}

@end
