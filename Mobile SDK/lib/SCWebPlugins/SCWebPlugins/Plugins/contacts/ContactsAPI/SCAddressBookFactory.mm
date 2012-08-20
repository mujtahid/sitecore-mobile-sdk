#import "SCAddressBookFactory.h"

#import "SCAddressBook.h"

using namespace ::Utils;

@implementation SCAddressBookFactory

+(void)asyncAddressBookWithOnCreatedBlock:( SCAddressBookOnCreated )callback_
{
    if ( kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_5_1 )
    {
        [ self asyncLegacyAddressBookWithOnCreatedBlock: callback_ ];
        return;
    }

    
    CFErrorRef error_ = NULL;
    ABAddressBookRef result_ = ::ABAddressBookCreateWithOptions( 0, &error_ );
    SCAddressBook* bookWrapper_ = [ [ SCAddressBook alloc ] initWithRawBook: result_ ];
    
    if ( NULL != error_ )
    {
        NSLog( @"[!!!ERROR!!!] - ABAddressBookCreateWithOptions : %@", (__bridge NSError*)error_ );
        return;
    }
    

    ABAddressBookRequestAccessCompletionHandler onAddressBookAccess_ =
        ^( bool blockGranted_, CFErrorRef blockError_ )
        {
            NSError* retError_ = (__bridge NSError* )(blockError_);

            callback_( bookWrapper_, ::ABAddressBookGetAuthorizationStatus(), retError_ );
        };

    ::ABAddressBookRequestAccessWithCompletion( result_, onAddressBookAccess_ );
}



+(void)asyncLegacyAddressBookWithOnCreatedBlock:( SCAddressBookOnCreated )callback_
{
    ABAddressBookRef result_ = ::ABAddressBookCreate();
    SCAddressBook* bookWrapper_ = [ [ SCAddressBook alloc ] initWithRawBook: result_ ];

    callback_( bookWrapper_, kABAuthorizationStatusAuthorized, nil );
}

@end
