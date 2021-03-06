#import "SCDateField.h"

@implementation SCDateField

@dynamic fieldValue;

-(id)createFieldValue
{
    NSDateFormatter* formatter_ = [ NSDateFormatter new ];
    [ formatter_ setDateFormat: @"yyyyMMdd'T'HHmmss" ];
    [ formatter_ setLocale: [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US" ] ];
    NSTimeZone* utc_ = [ NSTimeZone timeZoneWithAbbreviation: @"UTC" ];
    [ formatter_ setTimeZone: utc_ ];
    return [ formatter_ dateFromString: self.rawValue ];
}

@end
