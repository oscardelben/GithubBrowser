#import "NSMutableURLRequest+BasicAuth.h"
#import "NSData+Additions.h"

@implementation NSMutableURLRequest (BasicAuth)

- (void)addBasicAuth:(NSString *)username andPassword:(NSString *)password
{
    NSString *authString = [[[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
    
    authString = [NSString stringWithFormat: @"Basic %@", authString];
    
    [self setValue:authString forHTTPHeaderField:@"Authorization"];
}

@end
