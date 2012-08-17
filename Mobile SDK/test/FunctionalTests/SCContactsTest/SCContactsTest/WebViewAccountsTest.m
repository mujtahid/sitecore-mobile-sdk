#import "SCAsyncTestCase.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@interface WebViewAccountsTest : SCAsyncTestCase
@end

@implementation WebViewAccountsTest

-(void)testCreateContactWithFirstNameWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testCreateContactWithFirstName('fTest')" ];
}

-(void)testFindContactWithFirstNameWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testFindContactWithFirstName('fTest')" ];
}

-(void)testCreateContactWithFirstLastNameWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testCreateContactWithFirstLastName('fTest', 'lTest')" ];
}

-(void)testFindContactWithFirstLastNameWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testFindContactWithFirstLastName('fTest', 'lTest')" ];
}

-(void)testCreateContactWithPhonesAndEmailsWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testCreateContactWithPhonesAndEmails('+38(066)555 44 33', '380776665544', 'mail1@mail.ru', 'mail2@mail.ru')" ];
}

-(void)testFindContactWithPhonesAndEmailsWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testFindContactWithPhonesAndEmails('+38(066)555 44 33', '380776665544', 'mail1@mail.ru', 'mail2@mail.ru')" ];
}

-(void)testCreateContactWithCompanyWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testCreateContactWithCompany('Company1')" ];
}

-(void)testFindContactWithCompanyWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testFindContactWithCompany('Company1')" ];
}

-(void)testCreateContactWithSitesWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testCreateContactWithSites('google.com.ua', '11%89,gmail.com')" ];
}

-(void)testFindContactWithSitesWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testFindContactWithSites('google.com.ua', '11%89,gmail.com')" ];
}

//"21 May 2012 10:12"
-(void)testCreateContactWithBithdayWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testCreateContactWithBirthday('21 May 2012 10:12')" ];
}

-(void)testFindContactWithBithdayWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testFindContactWithBirthday('21 May 2012 10:12')" ];
}


-(void)testCreateContactWithPhotoWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testCreateContactWithPhoto('http://www.sitecore.net/images/_interface/logo.gif')" ];
}

-(void)testCreateContactWithAddressesWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testCreateContactWithAddresses('street1', 'city1', 'state1', 'zip1', 'country1', '', ' ', '$@@', '_.,', '<>& II')" ];
}

-(void)testFindContactWithAddressesWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testFindContactWithAddresses('street1', 'city1', 'state1', 'zip1', 'country1')" ];
}


//------
-(void)testCreateContactWithAllFieldsWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testCreateContactWithAllFields('fTest', 'lTest', 'SomeCompanyName', '666-55-44', 'mail1@mail.ru', 'sitecore.net')" ];
}

-(void)testEditContactWithAllFieldsWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testEditContactWithAllFields('fTest', 'newFTest', 'newLTest', 'newCompany1', '77-66-55', 'mail2@mail.ru', 'google.com')" ];
}

-(void)findAllAndRemoveContactsWithSelector:( SEL )sel_
{
    [ self runTestWithSelector: sel_
                     testsPath: @"contacts_tests"
                     javasript: @"testFindAllAndRemoveContacts()" ];
}

-(void)testCreateFindContactFName
{
    [ self findAllAndRemoveContactsWithSelector: _cmd ];
    [ self testCreateContactWithFirstNameWithSelector: _cmd ];
    [ self testFindContactWithFirstNameWithSelector: _cmd ];
}

-(void)testCreateFindContactFLName  
{
    [ self findAllAndRemoveContactsWithSelector: _cmd ];
    [ self testCreateContactWithFirstLastNameWithSelector: _cmd ];
    [ self testFindContactWithFirstLastNameWithSelector: _cmd ];
}

-(void)testCreateFindContactPhoneEmail
{
    [ self findAllAndRemoveContactsWithSelector: _cmd ];
    [ self testCreateContactWithPhonesAndEmailsWithSelector: _cmd ];
    [ self testFindContactWithPhonesAndEmailsWithSelector: _cmd ];
}

-(void)testCreateFindContactCompany
{
    [ self findAllAndRemoveContactsWithSelector: _cmd ];
    [ self testCreateContactWithCompanyWithSelector: _cmd ];
    [ self testFindContactWithCompanyWithSelector: _cmd ];
}

-(void)testCreateFindContactSites
{
    [ self findAllAndRemoveContactsWithSelector: _cmd ];
    [ self testCreateContactWithSitesWithSelector: _cmd ];
    [ self testFindContactWithSitesWithSelector: _cmd ];
}

-(void)testCreateFindContactBirthday
{
    [ self findAllAndRemoveContactsWithSelector: _cmd ];
    [ self testCreateContactWithBithdayWithSelector: _cmd ];
    [ self testFindContactWithBithdayWithSelector: _cmd ];
}

-(void)testCreateFindContactPhoto
{
    [ self findAllAndRemoveContactsWithSelector: _cmd ];
    [ self testCreateContactWithPhotoWithSelector: _cmd ];
}

-(void)testCreateFindContactAddresses
{
    [ self findAllAndRemoveContactsWithSelector: _cmd ];
    [ self testCreateContactWithAddressesWithSelector: _cmd ];
    [ self testFindContactWithAddressesWithSelector: _cmd ];
}

-(void)testEditAllFields
{
    [ self findAllAndRemoveContactsWithSelector: _cmd ];
    [ self testCreateContactWithAllFieldsWithSelector: _cmd ];
    [ self testEditContactWithAllFieldsWithSelector: _cmd ];
}

@end
