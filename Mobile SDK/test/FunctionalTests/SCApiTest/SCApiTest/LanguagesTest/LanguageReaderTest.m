#import "SCAsyncTestCase.h"

@interface LanguageReaderPositiveTest : SCAsyncTestCase
@end

@implementation LanguageReaderPositiveTest

-(void)testSystemLanguagesReader
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSSet* result_languages_ = nil;
        
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ systemLanguagesReader ]( ^( NSSet *languages_, NSError *error_ )
            {
                result_languages_ = languages_;
                didFinishCallback_();
            } );         
        }

    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ == nil, @"Should be nil" );
    GHAssertTrue( result_languages_ != nil, @"OK" );
    GHAssertTrue( [ result_languages_ count ] == 2, @"OK" );
    GHAssertTrue( [ result_languages_ containsObject: @"en" ] == TRUE, @"OK" );
    GHAssertTrue( [ result_languages_ containsObject: @"da" ] == TRUE, @"OK" );
}

-(void)testContextDefaultLanguageSameItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block BOOL isDanishItem_ = false;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            apiContext_.defaultLanguage = @"da";
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: @"/sitecore/content/nicam/products/lenses" 
                                                                            fieldsNames: [ NSSet setWithObject: @"Title" ] ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
            {
                if ( [ da_result_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = [ da_result_ objectAtIndex: 0 ];
                SCField* field_ = [ item_ fieldWithName: @"Title" ];
                isDanishItem_ = [ field_.rawValue isEqualToString: @"Objektiver" ];
                apiContext_.defaultLanguage = @"en";
                [ apiContext_ itemReaderWithFieldsNames: [ NSSet setWithObject: @"Title" ]
                                               itemPath: @"/sitecore/content/nicam/products/lenses" ]( ^( id en_result_, NSError* error_ )
                {
                    item_ = en_result_;
                    didFinishCallback_();
                });
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( item_ != nil, @"OK" );
    //Test danish item
    GHAssertTrue( isDanishItem_, @"OK" );
    //Test english item
    SCField* field_ = [ item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Lenses" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == item_, @"OK" );
}

-(void)testContextDefaultLanguageDifferentItems
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* da_item_ = nil;
    __block SCItem* en_item_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            apiContext_.defaultLanguage = @"da";
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: @"/sitecore/content/nicam/products/lenses" 
                                                                            fieldsNames: [ NSSet setWithObject: @"Title" ] ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
            {
                if ( [ da_result_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                da_item_ = [ da_result_ objectAtIndex: 0 ];
                apiContext_.defaultLanguage = @"en";
                [ apiContext_ itemReaderWithFieldsNames: [ NSSet setWithObject: @"Menu title" ]
                                               itemPath: @"/sitecore/content/nicam/products/" ]( ^( id en_result_, NSError* error_ )
                {
                    en_item_ = en_result_;
                    didFinishCallback_();
                });
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //Test danish item
    GHAssertTrue( da_item_ != nil, @"OK" );
    SCField* field_ = [ da_item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Objektiver" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == da_item_, @"OK" );
    //Test english item
    GHAssertTrue( en_item_ != nil, @"OK" );
    field_ = [ en_item_ fieldWithName: @"Menu title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Products" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == en_item_, @"OK" );
}

-(void)testRequestLanguageOneItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* da_item_ = nil;
    __block SCItem* en_item_ = nil;
    __block NSSet* field_names_ = [ NSSet setWithObject: @"Menu title" ];
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: @"/sitecore/content/nicam/products/lenses" 
                                                                            fieldsNames: [ NSSet setWithObject: @"Title" ] ];
            request_.language = @"da";
            apiContext_.defaultLanguage = @"en";
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
            {
                if ( [ da_result_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                da_item_ = [ da_result_ objectAtIndex: 0 ];
                [ apiContext_ itemReaderWithFieldsNames: field_names_
                                                itemPath:@"/sitecore/content/nicam/" ]( ^( id en_result_, NSError* error_ )
                {
                    en_item_ = en_result_;
                    didFinishCallback_();
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //Test danish item
    GHAssertTrue( da_item_ != nil, @"OK" );
    SCField* field_ = [ da_item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Objektiver" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == da_item_, @"OK" );
    //Test english item
    GHAssertTrue( en_item_ != nil, @"OK" );
    field_ = [ en_item_ fieldWithName: @"Menu title" ];
    NSLog( @"field_.rawValue: %@", field_.rawValue );
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Home" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == en_item_, @"OK" );
}

@end
