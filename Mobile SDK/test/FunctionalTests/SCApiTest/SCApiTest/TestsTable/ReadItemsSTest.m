#import "SCAsyncTestCase.h"

static SCItemReaderScopeType scope_ = SCItemReaderSelfScope;

typedef SCAsyncOp (^SCTestedReader)( SCApiContext* itemReader_
                                    , NSString* queryData_
                                    , NSSet* fieldsNames_ );

@interface ReadItemsSTest : SCAsyncTestCase
@end

@implementation ReadItemsSTest

-(void)testReadItemWithAllFieldsWithReader:( SCTestedReader )testedReader_
                                  selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block SCItem* product_item_ = nil;

    __block BOOL calledInstantly_ = NO;

    testedReader_ = [ testedReader_ copy ];

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSString* path_ = @"/sitecore/content/nicam/products";

        __block BOOL was_called_ = NO;

        testedReader_( apiContext_, path_, nil )( ^( NSArray* items_, NSError* error_ )
        {
            was_called_     = YES;
            products_items_ = items_;
            didFinishCallback_();
        } );

        calledInstantly_ = was_called_;
    };

    void (^resultTest_)(void) = ^void( void )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );
        GHAssertTrue( products_items_ != nil, @"OK" );
        GHAssertTrue( [ products_items_ count ] == 1, @"OK" );

        product_item_ = [ products_items_ objectAtIndex: 0 ];

        GHAssertTrue( product_item_ != nil, @"OK" );
        GHAssertTrue( product_item_.parent == nil, @"OK" );
        GHAssertTrue( [ product_item_.displayName isEqualToString: @"Products" ], @"OK" );
        GHAssertTrue( product_item_.allChildren == nil, @"OK" );
        GHAssertTrue( product_item_.allFieldsByName != nil, @"OK" );

        GHAssertTrue( SCProductsAllFieldsCount <= [ product_item_.allFieldsByName count ], @"OK" );
        GHAssertTrue( [ product_item_.allFieldsByName count ] == [ product_item_.readFieldsByName count ], @"OK" );
    };

    //test first call
    {
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: selector_ ];

        resultTest_();
    }

    //test cached call
    {
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: selector_ ];

        GHAssertTrue( calledInstantly_, @"OK" );
        resultTest_();
    }
}

//by relative path
// 0(+),1(+),2(-),3(-),4(+),5(-),6(-),7(-)
-(void)testReadItemWithAllFields
{
    @autoreleasepool
    {
        SCTestedReader testedReader_ = ^SCAsyncOp( SCApiContext* itemReader_
                                                  , NSString* path_
                                                  , NSSet* fieldsNames_ )
        {
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: path_
                                                                            fieldsNames: nil
                                                                                  scope: scope_ ];
            return [ itemReader_ itemsReaderWithRequest: request_ ];
        };
        [ self testReadItemWithAllFieldsWithReader: testedReader_
                                          selector: _cmd ];
    }

    SCTestedReader testedReader_ = ^SCAsyncOp( SCApiContext* itemReader_
                                              , NSString* queryData_
                                              , NSSet* fieldsNames_ )
    {
        return [ self resultIntoArrayReader: [ itemReader_ itemReaderWithFieldsNames: nil
                                                                            itemPath: queryData_ ] ];
    };
    [ self testReadItemWithAllFieldsWithReader: testedReader_
                                      selector: _cmd ];
}

-(void)testReadItemWithSomeFieldsWithReader:( SCTestedReader )testedReader_
                                   selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* lenses_items_ = nil;
    __block SCItem* lenses_item_ = nil;
    __block BOOL called_instantly_ = NO;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSString* itemId_ = @"{0E1BB3F7-7C3A-4DD9-8041-50B68689E6A2}";
        NSSet* fieldsNames_ = [ NSSet setWithObjects: @"Title", @"Image", nil ];

        __block BOOL was_called_ = NO;

        testedReader_( apiContext_, itemId_, fieldsNames_ )( ^( NSArray* items_, NSError* error_ )
        {
            was_called_ = YES;
            lenses_items_ = items_;
            didFinishCallback_();
        } );

        called_instantly_ = was_called_;
    };

    void (^resultTest_)(void) = ^void( void )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );
        GHAssertTrue( lenses_items_ != nil, @"OK" );
        GHAssertTrue( [ lenses_items_ count ] == 1, @"OK" );

        lenses_item_ = [ lenses_items_ objectAtIndex: 0 ];

        GHAssertTrue( lenses_item_ != nil, @"OK" );
        GHAssertTrue( lenses_item_.parent == nil, @"OK" );
        GHAssertTrue( [ lenses_item_.displayName isEqualToString: @"Lenses" ], @"OK" );
        GHAssertTrue( lenses_item_.allChildren == nil, @"OK" );
        GHAssertTrue( lenses_item_.allFieldsByName == nil, @"OK" );

        GHAssertTrue( 2 == [ lenses_item_.readFieldsByName count ], @"OK" );
    };

    //test first call
    {
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: selector_ ];

        resultTest_();
    }

    //test cached call
    {
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: selector_ ];

        GHAssertTrue( called_instantly_, @"OK" );
        resultTest_();
    }
}

//by item id
// 0(+),1(+),2(-),3(-),4(-),5(-),6(-),7(-)
-(void)testReadItemWithSomeFields
{
    SCTestedReader testedReader_ = ^SCAsyncOp( SCApiContext* itemReader_
                                              , NSString* queryData_
                                              , NSSet* fieldsNames_ )
    {
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemId: queryData_
                                                                      fieldsNames: fieldsNames_
                                                                            scope: scope_ ];
        return [ itemReader_ itemsReaderWithRequest: request_ ];
    };
    [ self testReadItemWithSomeFieldsWithReader: testedReader_
                                       selector: _cmd ];

    /*testedReader_ = ^SCAsyncOp( id< SCItemReader > itemReader_, NSString* queryData_ )
    {
        return [ self resultIntoArrayReader: [ itemReader_ itemReaderForItemWithPath: queryData_ ] ];
    };
    [ self testReadItemWithAllFieldsWithReader: testedReader_
                                       selector: _cmd ];*/
}

-(void)testReadItemWithNoFieldsWithReader:( SCTestedReader )testedReader_
                                 selector:( SEL )selector_
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* productsItems_ = nil;
    __block BOOL calledInstantly_ = NO;
    __block SCItem* productItem_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        NSString* path_ = @"/sitecore/content/nicam/products";
        NSSet* fieldsNames_ = [ NSSet new ];

        __block BOOL was_called_ = NO;

        testedReader_( apiContext_, path_, fieldsNames_ )( ^( NSArray* items_, NSError* error_ )
        {
            was_called_ = YES;
            productsItems_ = items_;
            didFinishCallback_();
        } );

        calledInstantly_ = was_called_;
    };

    void (^resultTest_)(void) = ^void( void )
    {
        GHAssertTrue( apiContext_ != nil, @"OK" );
        GHAssertTrue( productsItems_ != nil, @"OK" );
        GHAssertTrue( [ productsItems_ count ] == 1, @"OK" );

        productItem_ = [ productsItems_ objectAtIndex: 0 ];

        GHAssertTrue( productItem_ != nil, @"OK" );
        GHAssertTrue( productItem_.parent == nil, @"OK" );
        GHAssertTrue( [ productItem_.displayName isEqualToString: @"Products" ], @"OK" );
        GHAssertTrue( productItem_.allChildren == nil, @"OK" );
        GHAssertTrue( productItem_.allFieldsByName == nil, @"OK" );
        GHAssertTrue( [ productItem_.readFieldsByName count ] == 0, @"OK" );
    };

    //test first call
    {
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: selector_ ];

        resultTest_();
    }

    //test cached call
    {
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: selector_ ];

        GHAssertTrue( calledInstantly_, @"OK" );
        resultTest_();
    }
}

//by absolute path
// 0(+),1(+),2(-),3(-),4(+),5(-),6(-),7(-)
-(void)testReadItemWithNoFields
{
    @autoreleasepool
    {
        SCTestedReader testedReader_ = ^SCAsyncOp( SCApiContext* itemReader_
                                                  , NSString* requestData_
                                                  , NSSet* fieldsNames_ )
        {
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: requestData_
                                                                            fieldsNames: [ NSSet new ]
                                                                                  scope: scope_ ];
            return [ itemReader_ itemsReaderWithRequest: request_ ];
        };
        [ self testReadItemWithNoFieldsWithReader: testedReader_
                                         selector: _cmd ];
    }

    SCTestedReader testedReader_ = ^SCAsyncOp( SCApiContext* itemReader_
                                              , NSString* queryData_
                                              , NSSet* fieldsNames_ )
    {
        return [ self resultIntoArrayReader: [ itemReader_ itemReaderForItemPath: queryData_ ] ];
    };
    [ self testReadItemWithNoFieldsWithReader: testedReader_
                                     selector: _cmd ];
}

@end
