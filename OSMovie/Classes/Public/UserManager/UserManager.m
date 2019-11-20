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

// 判断是否登录
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

//UserID
- (NSString *)getUserID {
    NSString * userID = [USERDEFAULTS objectForKey:[USER_ID copy]];
    return userID ? userID : @"";
}

//用户头像UrlString
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

//是否是测试服
//YES测试服
//NO正式服
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

//服务器地址, 非登录类接口
-(NSString*)serverAddress {
    return [self isDevStatus] ? DevServerURL_Normal : ServerURL_Normal;
}

//服务器地址, 登录类接口
-(NSString*)serverAddressWithLogin {
    return [self isDevStatus] ? DevServerURL_Login : ServerURL_Login;
}

//获取User-Agent
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

//获取版本号
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

//获取证书--->拼接token用
- (NSString *)getCredential {
    NSString *cre = [USERDEFAULTS objectForKey:[CREDENTIAL copy]];
    return cre ? cre : @"";
}

//获取设备序列号
- (NSString*)getUUID {
    return @"lajdhaksdasdfhaksdfhlkads";
}

//获取手机型号
- (NSString*)getDeviceName {
    return @"iPhone X";
}

//应用发布渠道
- (NSString*)getAppPubChannel {
    return @"AppStore";
}

/** 短视频交互: 赞 踩 */
-(void)shortVideoInteractWithPar:(NSDictionary *)par success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [[SSRequest request]POST:ShortVideoInterationUrl parameters:par.mutableCopy success:^(SSRequest *request, id response) {
        
        SSLog(@"%@",response);
        if(success) {
            success(response);
        }
    } failure:^(SSRequest *request, NSString *errorMsg) {
        if(failure) {
            failure(errorMsg);
        }
    }];
}

/** 视频收藏, 取消收藏 */
- (void)videoCollectionWithPar:(NSDictionary *)par andIsCollection:(BOOL)isCollection success:(void (^)(id))success failure:(void (^)(NSString *))failure {
    [[SSRequest request]POST:isCollection ? VideoCollectUrl : VideoCancelCollectUrl parameters:par.mutableCopy success:^(SSRequest *request, id response) {
        
        SSLog(@"%@",response);
        if(success) {
            success(response);
        }
    } failure:^(SSRequest *request, NSString *errorMsg) {
        if(failure) {
            failure(errorMsg);
        }
    }];
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

@end
