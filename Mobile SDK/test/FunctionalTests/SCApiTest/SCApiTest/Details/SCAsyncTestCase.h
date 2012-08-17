#import <JFFUtils/Blocks/JFFUtilsBlockDefinitions.h>

#import <Foundation/Foundation.h>

@interface SCAsyncTestCase : GHAsyncTestCase

-(NSString*)defaultLogin;
-(NSString*)defaultPassword;

-(void)performAsyncRequestOnMainThreadWithBlock:( void (^)(JFFSimpleBlock) )block_
                                       selector:( SEL )selector_;

-(SCAsyncOp)resultIntoArrayReader:( SCAsyncOp )reader_;

@end
