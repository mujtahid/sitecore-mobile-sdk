#import "SCContactField.h"

#include <objc/runtime.h>

@interface SCContactField ()

@property ( nonatomic ) NSString* name;
@property ( nonatomic ) ABPropertyID propertyID;

@end

@implementation SCContactField

-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return self;
}

-(id)initWithName:( NSString* )name_
       propertyID:( ABPropertyID )propertyID_
{
    self = [ super init ];

    if ( self )
    {
        NSParameterAssert( [ name_ length ] > 0 );
        self.name       = name_;
        self.propertyID = propertyID_;

        [ [ self class ] addInstanceMethodIfNeedWithSelector: @selector( value )
                                                     toClass: [ self class ]
                                           newMethodSelector: NSSelectorFromString( self.name ) ];
        [ [ self class ] addInstanceMethodIfNeedWithSelector: @selector( setValue: )
                                                     toClass: [ self class ]
                                           newMethodSelector: NSSelectorFromString( [ self.name propertySetNameForPropertyName ] ) ];
    }

    return self;
}

+(id)contactFieldWithName:( NSString* )name_
               propertyID:( ABPropertyID )propertyID_
{
    return [ [ self alloc ] initWithName: name_
                              propertyID: propertyID_ ];
}

-(void)readPropertyFromRecord:( ABRecordRef )record_
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-(void)setPropertyFromValues:( NSDictionary* )components_
                    toRecord:( ABRecordRef )record_
{
    [ self doesNotRecognizeSelector: _cmd ];
}

-(NSString*)jsonValue
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

@end
