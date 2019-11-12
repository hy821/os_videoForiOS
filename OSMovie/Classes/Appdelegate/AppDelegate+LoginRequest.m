//
//  AppDelegate+LoginRequest.m
//
//

#import "AppDelegate+LoginRequest.h"

@interface AppDelegate()

@end

@implementation AppDelegate (LoginRequest)

- (void)updateUserAgent {
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    [USERDEFAULTS setObject:userAgent forKey:@"webUserAgent"];
    [USERDEFAULTS synchronize];
}

@end
