#import "SCAsyncTestCase.h"

@interface ReadFieldsWithSecurityTest : SCAsyncTestCase
@end

@implementation ReadFieldsWithSecurityTest

-(void)testReadSecurityDenyFieldValue
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* result_item_ = nil;
    __block id deny_field_value_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath: @"/sitecore/content/Nicam" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                result_item_ = result_;
                [ result_item_ fieldValueReaderForFieldName: @"Security Field" ]( ^( id result_, NSError* error_ )
                {
                    deny_field_value_ = result_;
                    didFinishCallback_();
                } );
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( result_item_ != nil, @"OK" );
    NSLog(@"result_item_.displayName: %@", result_item_.displayName);
    GHAssertTrue( [ result_item_.displayName isEqualToString: @"Nicam" ], @"OK" );
    // Deny field test
    GHAssertTrue( deny_field_value_ == nil, @"OK" );
    GHAssertTrue( [ result_item_ fieldWithName: @"Security Field" ] == nil, @"OK" );
}

-(void)testReadSecurityDenyField
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* result_item_ = nil;
    __block SCField* deny_field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath: @"/sitecore/content/Nicam" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                  didFinishCallback_();
                  return;
                }
                result_item_ = result_;
                NSSet* fields_ = [ NSSet setWithObject: @"Security Field" ];
                [ result_item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result, NSError* error_ )
                {
                    deny_field_ = [ result_item_ fieldWithName: @"Security Field" ];
                    didFinishCallback_();
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( result_item_ != nil, @"OK" );
    NSLog(@"result_item_.displayName: %@", result_item_.displayName);
    GHAssertTrue( [ result_item_.displayName isEqualToString: @"Nicam" ], @"OK" );
    // Deny field test
    GHAssertTrue( deny_field_ == nil, @"OK" );
    GHAssertTrue( [ result_item_ fieldWithName: @"Security Field" ] == nil, @"OK" );
}


-(void)testReadSecurityAllowAndDenyFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* result_items_ = nil;
    __block SCField* allow_field_ = nil;
    __block SCField* deny_field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request = @"/sitecore/content/Nicam";
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames = [ NSSet setWithObjects: @"Menu title", @"Security Field", nil ];

            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                     didFinishCallback_();
                     return;
                }
                result_items_ = items_;
                allow_field_ = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"Menu title" ];
                deny_field_ = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"Security Field" ];

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
    // Fields test
    GHAssertTrue( [ item_.readFieldsByName count ] == 1, @"OK" );
    // Allow field test
    GHAssertTrue( allow_field_ != nil, @"OK" );
    GHAssertTrue( [ [ allow_field_ rawValue ] isEqualToString: @"Home" ], @"OK" );
    GHAssertTrue( [ [ allow_field_ type ] isEqualToString: @"Single-Line Text" ], @"OK" );
    GHAssertTrue( [ allow_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Menu title" ] == allow_field_, @"OK" );
    // Deny field test
    GHAssertTrue( deny_field_ == nil, @"OK" );
}

-(void)testReadSecurityAllowAndDenyFieldsWithValues
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* result_items_ = nil;
    __block SCField* allow_field_ = nil;
    __block SCField* deny_field_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request = @"/sitecore/content/Nicam";
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames = [ NSSet setWithObjects: @"Footer Logo", @"Security Field", nil ];
            request_.flags = SCItemReaderRequestReadFieldsValues;

            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                allow_field_ = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"Footer Logo" ];
                deny_field_ = [ [ items_ objectAtIndex: 0 ] fieldWithName: @"Security Field" ];

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
    // Fields test
    GHAssertTrue( [ item_.readFieldsByName count ] == 1, @"OK" );
    // Allow field test
    GHAssertTrue( allow_field_ != nil, @"OK" );
    GHAssertTrue( [ allow_field_ rawValue ] != nil , @"OK" );
    GHAssertTrue( [ [ allow_field_ type ] isEqualToString: @"Image" ], @"OK" );
    GHAssertTrue( [ allow_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Footer Logo" ] == allow_field_, @"OK" );
    id value_ = [ allow_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );    
    // Deny field test
    GHAssertTrue( deny_field_ == nil, @"OK" );
}

@end
