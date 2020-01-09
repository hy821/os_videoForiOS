//
//  UserManager.m
//  NewTarget
//  Copyright © 2016年  rw. All rights reserved.
//

#import "UserManager.h"
#import <AdSupport/AdSupport.h>
#import "AFNetworkReachabilityManager.h"
#import "LoginViewController.h"
#import "LEEAlert.h"
#import "MineViewController.h"
#import "SimulateIDFA.h"
#import "RealReachability.h"
#import "STDPingManager.h"
#import "NSData+KKAES.h"
#import "GTMBase64.h"

@implementation UserManager

+(id)shareManager {
    static UserManager * manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });return manager;
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

-(NSString*)isCK {
    NSString *isIR = [USERDEFAULTS objectForKey:isCK];
    if (isIR && isIR.length>0) {
        return isIR;
    }else {
        return @"";
    }
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

- (NSString *)getIDFA {
    NSString *idfa = @"";
    if (iOS10Later) {
        if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }else {
            idfa = [SimulateIDFA createSimulateIDFA];
        }
    }else {
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    return idfa;
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

-(void)checkValidDomainWithType:(DomainType)type {
    
    if (![self checkNetWorkState]) {
        SSLog(@"网络异常,pingCheck失败");
        return;
    }
    
//    //Tmp
//    NSDictionary *dicc = @{
//        @"apis":@[
//                @{
//                    @"adApiUrl":@"dev.sspapi.51tv.com",
//                    @"apiUrl":@"dev.api.vrg.51tv.com"
//                },
//        ],
//        @"clapi":@[
//                @"120.77.243.186"
//        ]
//    };
//
//    [USERDEFAULTS setObject:dicc forKey:NetWorkAddress];
//    [USERDEFAULTS synchronize];
//
    NSDictionary *dicCache = [USERDEFAULTS objectForKey:NetWorkAddress];
    NSArray *arrApis = (NSArray*)dicCache[@"apis"];
    __block NSMutableArray *arrCache = [NSMutableArray array];
    
//    WS()
    if (type==DomainType_Cl) {
        NSArray *arrCl = (NSArray*)dicCache[@"clapi"];
        NSSet *set = [NSSet setWithArray:arrCl];
        arrCl = [set allObjects];
        SSLog(@"去重后arrCL:%@",arrCl);
        if (arrCl.count>0) {
            [STDPingManager getFastIPwith:arrCl andWithCount:10 withFastIP:^(NSString *ipAddress) {
                SSLog(@"--->CheckBackCL:%@",ipAddress);
                if (ipAddress.length>0) {
                    [USERDEFAULTS setObject:ipAddress forKey:HOST_cl];
                }
            }];
        }
        
    }else if (type==DomainType_Api) {
        if (arrApis.count>0) {
            [arrApis enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj[@"apiUrl"]) {
                    NSString *urlCheck = obj[@"apiUrl"];
                    if (![arrCache containsObject:urlCheck]) {
                        [arrCache addObject:urlCheck];
                    }
                }
            }];
            if (arrCache.count>0) {
                SSLog(@"去重后arrApi:%@",arrCache);
                [STDPingManager getFastIPwith:arrCache andWithCount:10 withFastIP:^(NSString *ipAddress) {
                    SSLog(@"--->CheckBackApi:%@",ipAddress);
                    [USERDEFAULTS setObject:ipAddress forKey:HOST_api];
                }];
            }
        }
        
    }else if (type==DomainType_Ad) {
        if (arrApis.count>0) {
            [arrApis enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj[@"adApiUrl"]) {
                    NSString *urlCheck = obj[@"adApiUrl"];
                    if (![arrCache containsObject:urlCheck]) {
                        [arrCache addObject:urlCheck];
                    }
                }
            }];
            if (arrCache.count>0) {
                SSLog(@"去重后arrAd:%@",arrCache);
                [STDPingManager getFastIPwith:arrCache andWithCount:10 withFastIP:^(NSString *ipAddress) {
                    SSLog(@"--->CheckBackAd:%@",ipAddress);
                    [USERDEFAULTS setObject:ipAddress forKey:HOST_ad];
                }];
            }
        }
        
    }else if (type==DomainType_Cdn) {

    }
    
    [USERDEFAULTS synchronize];
}

#pragma mark-监听网络回调
//检测当前网络是否可用
-(BOOL)checkNetWorkState {
    ReachabilityStatus status = [RealReachability sharedInstance].currentReachabilityStatus;
    WWANAccessType type = [RealReachability sharedInstance].currentWWANtype;
    if (status==RealStatusViaWiFi) {
        return YES;
    }else if (status==RealStatusUnknown || status==RealStatusNotReachable) {
        return NO;
    }else if (status==RealStatusViaWWAN) {
        switch (type) {
            case WWANTypeUnknown:
                return NO;
                break;
            case WWANType2G:
            case WWANType3G:
            case WWANType4G:
                return YES;
                break;
            default:
                break;
        }
    }
    return YES;
}

- (void)configAndUpdateHosts {
    NSString *cl = [USERDEFAULTS objectForKey:HOST_cl];
    NSString *ad = [USERDEFAULTS objectForKey:HOST_ad];
    NSString *api = [USERDEFAULTS objectForKey:HOST_api];
    
    NSDictionary *apiDic = [self getLaunchDicWithKey:@"defaultHost"];
    NSString *cl_def = apiDic[@"cl"];
    NSString *ad_def = apiDic[@"ad"];
    NSString *api_def = apiDic[@"api"];
    
    if (!cl) {[USERDEFAULTS setObject:cl_def forKey:HOST_cl];}
    if (!ad) {[USERDEFAULTS setObject:ad_def forKey:HOST_ad];}
    if (!api) {[USERDEFAULTS setObject:api_def forKey:HOST_api];}
    [USERDEFAULTS synchronize];
    
    WS()
     [[ABSRequest request] getNetWorkAddWithUrl:[USERDEFAULTS objectForKey:HOST_cl] success:^(ABSRequest *request, id response) {
         SSLog(@"--->Host:%@",response);
       
         if (response) {
             [weakSelf checkValidDomainWithType:DomainType_Cl];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf checkValidDomainWithType:DomainType_Api];
             });
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf checkValidDomainWithType:DomainType_Ad];
             });
         }
         
     } failure:^(ABSRequest *request, NSString *errorMsg) {
         SSLog(@"--->HostError:%@",errorMsg);
     }];
}

//H5解析播放地址
- (void)parsedUrlForH5WithUrl:(NSString*)urlParsing success:(void (^)(id response))success failure:(void(^)(NSString* errMsg))failure {

    NSDictionary *parseDic = [self getLaunchDicWithKey:@"parseUrlData"];
    NSString *HOST = parseDic[@"HOST"];
    NSString *APPID = parseDic[@"APPID"];
    NSString *APPKEY = parseDic[@"APPKEY"];
    
    NSString *timeStr = [Tool getCurrentTimeSecsString];
    NSString *signStr = [Tool md5:[NSString stringWithFormat:@"%@%@%@%@",APPID,APPKEY,urlParsing,timeStr]];
    NSString *uurl = [NSString stringWithFormat:@"%@type=vod&url=%@&t=%@&appid=%@&sign=%@",HOST,urlParsing,timeStr,APPID,signStr];
    
    [[ABSRequest request]AdvReportGET:uurl success:^(ABSRequest *request, NSDictionary *response) {
        success(response);
    } failure:^(ABSRequest *request, NSString *errorMsg) {
        success(@"");
    }];
}

- (NSDictionary*)getLaunchDicWithKey:(NSString*)key {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"launchConfig" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *launchDic = [NSJSONSerialization JSONObjectWithData:data                   options:NSJSONReadingMutableContainers error:nil];
    return (NSDictionary*)launchDic[key];
}

//H5解密自上传视频
- (void)decodeH5VideoUrlWithUrl:(NSString*)urlParsing success:(void (^)(id response))success {
    NSString *originUrl = urlParsing;
    NSArray *arr = [urlParsing componentsSeparatedByString:@"/"];
    if (arr.count>0) {
        urlParsing = arr.lastObject;
        NSData *urlData = [Tool safeUrlBase64Decode:urlParsing];
        NSData *keyData = [@"aGVsbG8tdmlkZW8t" dataUsingEncoding:NSUTF8StringEncoding];
        NSData *dealData = [urlData AES_ECB_DecryptWith:keyData];
        NSString *dealStr = [[NSString alloc] initWithData:dealData encoding:NSUTF8StringEncoding];
        if ([dealStr componentsSeparatedByString:@"-"].count>0) {
            dealStr = [dealStr componentsSeparatedByString:@"-"].firstObject;
            originUrl = [originUrl stringByReplacingOccurrencesOfString:urlParsing withString:dealStr];
            SSLog(@"解密:%@",originUrl);
            success(originUrl);
        }else {
            success(@"");
        }
    }else {
        success(@"");
    }
}

@end
