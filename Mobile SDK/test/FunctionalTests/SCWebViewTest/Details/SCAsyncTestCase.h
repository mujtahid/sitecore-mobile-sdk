#import <JFFUtils/Blocks/JFFUtilsBlockDefinitions.h>

#import <Foundation/Foundation.h>

typedef void (^PerformNativeTests)( void (^finishTestsWithResult_)( BOOL ) );

@interface SCAsyncTestCase : GHAsyncTestCase

-(void)performAsyncRequestOnMainThreadWithBlock:( void (^)(JFFSimpleBlock) )block_
                                       selector:( SEL )selector_;

-(void)runTestWithSelector:( SEL )sel_
                 testsPath:( NSString* )js_path_
                 javasript:( NSString* )javasript_
               nativeTests:( PerformNativeTests )nativeTests_;

@end
