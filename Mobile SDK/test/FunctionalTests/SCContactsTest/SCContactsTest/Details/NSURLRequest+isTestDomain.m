#import "NSURLRequest+isTestDomain.h"

@implementation NSURLRequest (isTestDomain)

-(BOOL)isTestDomain
{
    BOOL domainOk_ = [ self.URL.host isEqualToString: @"ws-alr1.dk.sitecore.net" ];
    BOOL schemeOk_ = domainOk_ && [ self.URL.scheme isEqualToString: @"http" ];
    BOOL pathOk_   = schemeOk_ && [ self.URL.path isEqualToString: @"/mobilesdk-test-path" ];
    return pathOk_;
}

@end
