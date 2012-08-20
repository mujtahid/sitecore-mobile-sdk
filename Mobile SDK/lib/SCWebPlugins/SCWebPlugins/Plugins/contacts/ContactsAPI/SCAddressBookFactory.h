#import <Foundation/Foundation.h>
#include <AddressBook/ABAddressBook.h>


#ifndef __IPHONE_6_0
    enum ABAuthorizationStatusEnum
    {
        kABAuthorizationStatusNotDetermined = 0,
        kABAuthorizationStatusRestricted,
        kABAuthorizationStatusDenied,
        kABAuthorizationStatusAuthorized
    };
    typedef CFIndex ABAuthorizationStatus;
#endif //__IPHONE_6_


@class SCAddressBook;
typedef void(^SCAddressBookOnCreated)(SCAddressBook* book_, ABAuthorizationStatus status_, NSError* error_);


@interface SCAddressBookFactory : NSObject

+(void)asyncAddressBookWithOnCreatedBlock:( SCAddressBookOnCreated )callback_;

@end
