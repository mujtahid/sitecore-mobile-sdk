#import "SCItemIdPathAndLanguage.h"

@implementation SCItemIdPathAndLanguage

-(NSString*)itemIdPath
{
    return self->_itemIdPath ? self->_itemIdPath : @"";
}

-(BOOL)isEqual:( SCItemIdPathAndLanguage* )other_
{
    if ( other_ == self )
        return YES;

    if ( !other_ || ![ other_ isKindOfClass: [ self class ] ] )
        return NO;

    return [ self isEqualToItemIdPathAndLanguage: other_ ];
}

-(BOOL)isEqualToItemIdPathAndLanguage:( SCItemIdPathAndLanguage* )other_
{
    if ( self == other_ )
        return YES;

    return [ self.itemIdPath isEqualToString: other_.itemIdPath ]
        && [ self.language   isEqualToString: other_.language ];
}

-(NSUInteger)hash
{
    return [ self.itemIdPath hash ];
}

-(id)copyWithZone:(NSZone *)zone_
{
    SCItemIdPathAndLanguage* result_ = [ [ [ self class ] allocWithZone: zone_ ] init ];

    result_->_itemIdPath = [ self->_itemIdPath copyWithZone: zone_ ];
    result_->_language   = [ self->_language   copyWithZone: zone_ ];

    return result_;
}

-(NSString*)description
{
    return [ [ NSString alloc ] initWithFormat: @"<SCItemIdPathAndLanguage itemIdPath:\"%@\" language:\"%@\" >"
            , self.itemIdPath
            , self.language ];
}

@end
