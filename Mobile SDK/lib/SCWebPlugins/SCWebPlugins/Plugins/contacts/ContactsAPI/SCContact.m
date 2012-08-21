#import "SCContact.h"

#import "SCContactDateField.h"
#import "SCContactStringField.h"
#import "SCContactStringArrayField.h"
#import "SCContactEmailsField.h"
#import "SCContactPhotoField.h"
#import "SCContactDictionaryArrayField.h"

#import "NSArray+kABMultiValue.h"


#import "SCAddressBook.h"
#import <AddressBook/AddressBook.h>

static ABRecordRef createOrGetContactPerson( ABRecordID contactInternalId_
                                            , ABAddressBookRef addressBook_ )
{
    if ( contactInternalId_ != 0 )
    {
        ABRecordRef result_ = ABAddressBookGetPersonWithRecordID( addressBook_
                                                                 , contactInternalId_ );

        if ( result_ )
        {
            CFRetain( result_ );
            return result_;
        }
    }

    return ABPersonCreate();
}

@interface SCContact ()

@property ( nonatomic ) BOOL newContact;
-(ABRecordRef)rawPerson CF_RETURNS_NOT_RETAINED;
-(void)setRawPerson:( ABRecordRef )person_;


@end

@implementation SCContact
{
    NSMutableDictionary* _fieldByName;
    SCAddressBook* _addressBookWrapper;
}

@synthesize contactInternalId = _contactInternalId;
@synthesize person            = _person;
@synthesize newContact        = _newContact;

@dynamic addressBook;

@dynamic firstName
, lastName
, company
, emails
, phones
, sites
, birthday
, photo;
//, address;

-(id)forwardingTargetForSelector:( SEL )selector_
{
    NSString* selectorName_ = NSStringFromSelector( selector_ );
    SCContactField* field_ = [ _fieldByName objectForKey: selectorName_ ];
    if ( !field_ )
    {
        field_ = [ _fieldByName objectForKey: [ selectorName_ propertyGetNameFromPropertyName ] ];
    }
    return field_ ?: self;
}

-(void)dealloc
{
    self.rawPerson = nil;
}

-(void)addField:( SCContactField* )field_
{
    [ _fieldByName setObject: field_ forKey: field_.name ];
}

-(void)initializeDynamicFields
{
    _fieldByName = [ NSMutableDictionary new ];

    [ self addField: [ SCContactStringField contactFieldWithName: @"firstName"
                                                      propertyID: kABPersonFirstNameProperty ] ];
    [ self addField: [ SCContactStringField contactFieldWithName: @"lastName" 
                                                      propertyID: kABPersonLastNameProperty ] ];
    [ self addField: [ SCContactStringField contactFieldWithName: @"company" 
                                                      propertyID: kABPersonOrganizationProperty ] ];
    [ self addField: [ SCContactDateField contactFieldWithName: @"birthday" 
                                                    propertyID: kABPersonBirthdayProperty ] ];
    [ self addField: [ SCContactPhotoField contactFieldWithName: @"photo" ] ];

    NSArray* labels_ = [ NSArray arrayWithObjects: @"home", @"work", nil ];
    [ self addField: [ SCContactEmailsField contactFieldWithName: @"emails" 
                                                      propertyID: kABPersonEmailProperty
                                                          labels: labels_ ] ];

    labels_ = [ NSArray arrayWithObjects: @"mobile"
               , @"iPhone"
               , @"home"
               , @"work"
               , @"main"
               , @"home fax"
               , @"work fax"
               , @"other fax"
               , @"pager"
               , @"other"
               , nil ];
    [ self addField: [ SCContactStringArrayField contactFieldWithName: @"phones" 
                                                           propertyID: kABPersonPhoneProperty
                                                               labels: labels_ ] ];

    labels_ = [ NSArray arrayWithObjects: @"home page"
               , @"home"
               , @"work"
               , @"other"
               , nil ];
    [ self addField: [ SCContactStringArrayField contactFieldWithName: @"websites" 
                                                           propertyID: kABPersonURLProperty
                                                               labels: labels_ ] ];

    labels_ = [ NSArray arrayWithObjects: @"home"
               , @"work"
               , @"other"
               , nil ];
    [ self addField: [ SCContactDictionaryArrayField contactFieldWithName: @"addresses" 
                                                               propertyID: kABPersonAddressProperty
                                                                   labels: labels_ ] ];
}

-(id)initWithPerson:( ABRecordRef )person_
        addressBook:( SCAddressBook* )addressBook_
{
    self = [ super init ];

    if ( self )
    {
        NSParameterAssert( person_ );
        NSParameterAssert( nil != addressBook_ );
        self->_addressBookWrapper = addressBook_;
        
        [ self initializeDynamicFields ];

        _contactInternalId = ABRecordGetRecordID( person_ );

        [ _fieldByName enumerateKeysAndObjectsUsingBlock: ^( id key, SCContactField* field_, BOOL* stop )
        {
            [ field_ readPropertyFromRecord: person_ ];
        } ];

        self.rawPerson = person_;
    }

    return self;
}

-(id)initWithArguments:( NSDictionary* )args_
           addressBook:( SCAddressBook* )addressBook_
{
    self = [ super init ];

    NSParameterAssert( nil != addressBook_ );
    
    if ( self )
    {
        self->_addressBookWrapper = addressBook_;
        
        [ self initializeDynamicFields ];

        _contactInternalId = [ [ args_ firstValueIfExsistsForKey: @"contactInternalId" ] longLongValue ];
        self.newContact = ( _contactInternalId == 0 );

        ABRecordRef person_ = self.person;
        [ _fieldByName enumerateKeysAndObjectsUsingBlock: ^( id key, SCContactField* field_, BOOL* stop )
        {
            [ field_ setPropertyFromValues: args_
                                  toRecord: person_ ];
        } ];
    }

    return self;
}


-(ABAddressBookRef)addressBook
{
    return self->_addressBookWrapper.rawBook;
}

-(ABRecordRef)person
{
    if ( !_person )
    {
        _person = createOrGetContactPerson( self.contactInternalId, self.addressBook );
    }
    return _person;
}

-(ABRecordRef)rawPerson
{
    return self->_person;
}

-(void)setRawPerson:( ABRecordRef )person_
{
    if ( person_ == self->_person )
    {
        return;
    }
    
    
    if ( NULL != self->_person )
    {
        CFRelease( self->_person );
    }
    self->_person = NULL;

    if ( NULL != person_ )
    {
        self->_person = CFRetain( person_ );
    }
}


-(NSDictionary*)toDictionary
{
    NSMutableDictionary* result_ = [ [ NSMutableDictionary alloc ] initWithObjectsAndKeys:
            [ NSNumber numberWithLongLong: _contactInternalId ], @"contactInternalId"
            , nil ];

    [ _fieldByName enumerateKeysAndObjectsUsingBlock: ^( id key, SCContactField* field_, BOOL* stop )
    {
        [ result_ setObject: field_.jsonValue forKey: field_.name ];
    } ];

    return result_;
}

-(void)save
{
    CFErrorRef error_ = NULL;

    if ( self.newContact )
    {
        bool didAdded = ABAddressBookAddRecord( self.addressBook, self.person, &error_ );
        if (!didAdded) { NSLog( @"can not add Person" ); }
    }

    bool saved_ = ABAddressBookSave( self.addressBook, &error_ );
    if (!saved_) { NSLog( @"can not save Person" ); }

    _contactInternalId = ABRecordGetRecordID( self.person );
}

@end
