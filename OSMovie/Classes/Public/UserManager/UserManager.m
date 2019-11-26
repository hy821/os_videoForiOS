//
//  UserManager.m
//  NewTarget
//  Copyright © 2016年  rw. All rights reserved.
//

#import "UserManager.h"
#import "AFNetworkReachabilityManager.h"
#import "LoginViewController.h"
#import "LEEAlert.h"
#import "MineViewController.h"
#import "SimulateIDFA.h"

@implementation UserManager

+(id)shareManager {
    static UserManager * manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
    }return self;
}

-(BOOL)isLogin {
    NSString *login = [USERDEFAULTS objectForKey:@"isLogin"];
    if(login && [login intValue]>0) {
        return YES;
    }else {
        return NO;
    }
}

- (void)loginSuccess {
    [USERDEFAULTS setObject:@"999" forKey:@"isLogin"];
    [USERDEFAULTS synchronize];
    [NOTIFICATION postNotificationName:RefreshUserMsgNoti object:nil];

}

- (void)removeUserAllData {
    [USERDEFAULTS removeObjectForKey:@"isLogin"];
    [USERDEFAULTS synchronize];
    [NOTIFICATION postNotificationName:RefreshUserMsgNoti object:nil];
}

- (NSString *)getUserID {
    NSString * userID = [USERDEFAULTS objectForKey:[USER_ID copy]];
    return userID ? userID : @"";
}

-(NSString *)getUserIcon {
  return [self isLogin] ? @"user_icon" : @"";
}

-(NSString *)getUserNickName {
    return [self isLogin] ? @"LuckyDog" : @"";
}

- (void)gotoLogin {
    LoginViewController * login = [[LoginViewController alloc]init];
    login.hidesBottomBarWhenPushed = YES;
    [SelectVC pushViewController:login animated:YES];
}

-(BOOL)isDevStatus {
    return YES;
}

-(NSString*)isCK {
    NSString *isIR = [USERDEFAULTS objectForKey:isCK];
    if (isIR && isIR.length>0) {
        return isIR;
    }else {
        return @"";
    }
}

-(NSString*)serverAddress {
    return [self isDevStatus] ? DevServerURL_Normal : ServerURL_Normal;
}

-(NSString*)serverAddressWithLogin {
    return [self isDevStatus] ? DevServerURL_Login : ServerURL_Login;
}

-(NSString*)getUserAgent {
    if([USERDEFAULTS objectForKey:@"webUserAgent"]) {
        return [USERDEFAULTS objectForKey:@"webUserAgent"];
    }else {
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        [USERDEFAULTS setObject:userAgent forKey:@"webUserAgent"];
        [USERDEFAULTS synchronize];
        return userAgent;
    }
}

- (NSString *)getVersionStr {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    return infoDic[@"CFBundleShortVersionString"];
}

- (NSNumber *)getOSType {
    return @(2);
}

- (NSString *)getSimType {
    return @"02";
}

- (NSString *)getNetWorkType {
    return @"01";
}

- (NSString *)getCredential {
    NSString *cre = [USERDEFAULTS objectForKey:[CREDENTIAL copy]];
    return cre ? cre : @"";
}

- (NSString*)getUUID {
    return @"lajdhaksdasdfhaksdfhlkads";
}

- (NSString*)getDeviceName {
    return @"iPhone X";
}

- (NSString*)getAppPubChannel {
    return @"AppStore";
}

// (单位毫秒)  当前时间 + (上次请求开始请求时的时间 - 上次请求成功时的时间)
- (NSString *)getTimeForToken {
    NSNumber *str = [USERDEFAULTS objectForKey:LastRequestDurTime];
    long long lastTime = 0;
    if (str) {
        lastTime = [str longLongValue];
    }
    
    NSString *timeStr = [NSString stringWithFormat:@"%llu",[Tool getCurrentTimeMillsNum] + lastTime];
    return timeStr;
}

-(NSString*)publicKey {
    return [self isDevStatus] ? DevPUBLIC_KEY_Normal: PUBLIC_KEY_Normal;
}

-(NSString*)publicKeyWithLogin {
    return [self isDevStatus] ? DevPUBLIC_KEY_Login : PUBLIC_KEY_Login;
}

- (NSString *)getIDFA {
    NSString *idfaSave =[USERDEFAULTS objectForKey:@"IDFA_Creat"];
    if(idfaSave && idfaSave.length>0) {
        return idfaSave;
    }else {
        NSString *idfa = [SimulateIDFA createSimulateIDFA];
        [USERDEFAULTS setObject:idfa forKey:@"IDFA_Creat"];
        [USERDEFAULTS synchronize];
        return idfa;
    }
}

- (void)callBackAdvWithUrls:(NSArray*)urls {
    if (urls.count==0) {
        return;
    }
    for (NSString *url in urls) {
        [[ABSRequest request]AdvReportGET:url success:^(ABSRequest *request, id response) {
            
        } failure:^(ABSRequest *request, NSString *errorMsg) {
            
        }];
    }
}

@end
