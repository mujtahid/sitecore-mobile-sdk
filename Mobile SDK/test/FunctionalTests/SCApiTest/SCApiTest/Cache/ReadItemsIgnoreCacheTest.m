#import "SCAsyncTestCase.h"

@interface ReadItemsIgnoreCacheTest : SCAsyncTestCase
@end

@implementation ReadItemsIgnoreCacheTest

-(void)testReadItemsWithCache
{
    __block BOOL testPassed = NO;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* context = [ SCApiContext contextWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword];
        
        SCItemsReaderRequest* request = [ SCItemsReaderRequest new ];
        request.request = @"/sitecore/content/Nicam";
        request.requestType = SCItemReaderRequestItemPath;
        request.fieldNames = [ NSSet new ];

        [ context itemsReaderWithRequest: request ]( ^( id result, NSError* error )
        {
            if ( [ result count ] == 0 )
            {
                didFinishCallback_();
                return;
            }
            SCItem* item = [ result objectAtIndex:0 ];
            SCAsyncOp childrenReader = [ item childrenReader ];
            //load children here
            childrenReader( ^( id result, NSError *error )
            {
                if ( error )
                {
                    didFinishCallback_();
                    return;
                }
                NSUInteger previousCount = [ result count ];
                NSLog( @"children Items count: %d", previousCount );
                //the flag to check that the block is already finish loading
                __block BOOL wasLoadImmediately = NO;
                //load children again
                childrenReader( ^( id result, NSError *error )
                {
                    NSLog( @"children Items count 2: %d", [ result count ] );
                    wasLoadImmediately = ( previousCount == [ result count ] );
                } );
                
                //Check that the childrenReader block's handler was already called with a result
                testPassed = wasLoadImmediately == YES;
                didFinishCallback_();
            });
        } );
    };
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    NSAssert( testPassed, @"wasLoadImmediately should be YES here" );
}

-(void)testReadItemsIgnoreCache
{
    __block BOOL testPassed = NO;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* context = [ SCApiContext contextWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword];
        
        SCItemsReaderRequest* request = [ SCItemsReaderRequest new ];
        request.request = @"/sitecore/content/Nicam/child::*";
        request.requestType = SCItemReaderRequestQuery;
        request.fieldNames  = [ NSSet new ];
        request.flags = SCItemReaderRequestIngnoreCache;
        
        [ context itemsReaderWithRequest: request ]( ^( NSArray* result, NSError* error )
        {
            if ( error )
            {
                didFinishCallback_();
                return;
            }
            NSUInteger previousCount = [ result count ];
            //the flag to check that the block is already finish loading
            __block BOOL wasLoadImmediately = NO;
                //load items again
            [ context itemsReaderWithRequest: request ]( ^( NSArray* result, NSError* error )
            {
                wasLoadImmediately = ( previousCount == [ result count ] );

            } );
                //Check that the childrenReader block's handler was already called with a result
                testPassed = !wasLoadImmediately;
                didFinishCallback_();
        } );
    };
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    NSAssert( testPassed, @"wasLoadImmediately should be NO here" );
}

@end
