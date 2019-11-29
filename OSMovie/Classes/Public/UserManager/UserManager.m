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
#import "RealReachability.h"

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

- (void)pingWithUrl:(NSString*)checkUrl completeBlock:(void(^)(BOOL isValid))completeBlock {
    __block STDPingServices *service = [STDPingServices startPingAddress:checkUrl callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        
        SSLog(@"Ping结果:%@",pingItem);
        if (pingItem.status == STDPingStatusDidTimeout) {
            if (pingItem.ICMPSequence == 2) {
                completeBlock(NO);
                service = nil;
            }
        }else if (pingItem.status == STDPingStatusDidReceivePacket) {
            //            numYes +=1;
            //            if (numYes==3) {
            //                completeBlock(YES);
            //            }else if (numYes>3) {
            //                service = nil;
            //            }
        }
    }];
}

-(void)checkValidDomainWithType:(DomainType)type completeBlock:(getValidDomainBlock)block {
    
    if (![self checkNetWorkState]) {
        SSLog(@"网络异常");
        if (block) {block(@"");}
        return;
    }
    
    NSDictionary *dicCache = [USERDEFAULTS objectForKey:NetWorkAddress];
    BOOL haveCache = dicCache;
    
    WS()
    if (type==DomainType_Cl) {
        //        NSString *mainDomain = @"120.77.243.186";
        NSString *mainDomain = @"123.23.234.186";
        
        [weakSelf pingWithUrl:mainDomain completeBlock:^(BOOL isValid) {
            if (isValid) {
                if (block) {block(mainDomain);}
            }else {
                NSArray *arrCache = [NSArray array];
                if (haveCache) {
                    arrCache = (NSArray*)dicCache[@"clapi"];
                    if (arrCache.count>0) {
                        __block NSString *validDomain = @"";
                        [arrCache enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [weakSelf pingWithUrl:obj completeBlock:^(BOOL isValid) {
                                if (isValid) {
                                    validDomain = obj;
                                    if (block) {block(validDomain);}
                                    *stop = YES;
                                    return;
                                }
                            }];
                        }];
                    }else{
                        if (block) {block(@"");}
                    }
                }else {
                    if (block) {block(@"");}
                }
            }
        }];
    }else if (type==DomainType_Api) {
        NSString *apiMainDomain = @"120.77.243.186";
        [weakSelf pingWithUrl:apiMainDomain completeBlock:^(BOOL isValid) {
            if (isValid) {
                if (block) {block(apiMainDomain);}
            }else {
                NSArray *arrCache = [NSArray array];
                if (haveCache) {
                    arrCache = (NSArray*)dicCache[@"apis"];
                    if (arrCache.count>0) {
                        __block NSString *validDomain = @"";
                        [arrCache enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (obj && obj[@"apiUrl"]) {
                                NSString*checkUrl = obj[@"apiUrl"];
                                [weakSelf pingWithUrl:checkUrl completeBlock:^(BOOL isValid) {
                                    if (isValid) {
                                        validDomain = checkUrl;
                                        *stop = YES;
                                        return;
                                    }
                                }];
                            }
                        }];
                        if (block) {block(validDomain);}
                    }else{
                        if (block) {block(@"");}
                    }
                }else {
                    if (block) {block(@"");}
                }
            }
        }];
        
    }else if (type==DomainType_Ad) {
        NSString *apiMainDomain = @"dev.sspapi.51tv.com";
        [weakSelf pingWithUrl:apiMainDomain completeBlock:^(BOOL isValid) {
            if (isValid) {
                if (block) {block(apiMainDomain);}
            }else {
                NSArray *arrCache = [NSArray array];
                if (haveCache) {
                    arrCache = (NSArray*)dicCache[@"apis"];
                    if (arrCache.count>0) {
                        __block NSString *validDomain = @"";
                        [arrCache enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (obj && obj[@"adApiUrl"]) {
                                NSString*checkUrl = obj[@"adApiUrl"];
                                [weakSelf pingWithUrl:checkUrl completeBlock:^(BOOL isValid) {
                                    if (isValid) {
                                        validDomain = checkUrl;
                                        *stop = YES;
                                        return;
                                    }
                                }];
                            }
                        }];
                        if (block) {block(validDomain);}
                    }else{
                        if (block) {block(@"");}
                    }
                }else {
                    if (block) {block(@"");}
                }
            }
        }];
        
    }else if (type==DomainType_Cdn) {
        NSString *apiMainDomain = @"120.77.243.186";
        [weakSelf pingWithUrl:apiMainDomain completeBlock:^(BOOL isValid) {
            if (isValid) {
                if (block) {block(apiMainDomain);}
            }else {
                NSArray *arrCache = [NSArray array];
                if (haveCache) {
                    arrCache = (NSArray*)dicCache[@"apis"];
                    if (arrCache.count>0) {
                        __block NSString *validDomain = @"";
                        [arrCache enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (obj && obj[@"cdnApiUrl"]) {
                                NSString*checkUrl = obj[@"cdnApiUrl"];
                                [weakSelf pingWithUrl:checkUrl completeBlock:^(BOOL isValid) {
                                    if (isValid) {
                                        validDomain = checkUrl;
                                        *stop = YES;
                                        return;
                                    }
                                }];
                            }
                        }];
                        if (block) {block(validDomain);}
                    }else{
                        if (block) {block(@"");}
                    }
                }else {
                    if (block) {block(@"");}
                }
            }
        }];
    }
    
    /*
     {
     apis =     (
     {
     adApiUrl = "39.105.88.24";
     apiUrl = "39.105.88.24";
     cdnApiUrl = "";
     },
     {
     adApiUrl = "39.105.88.24";
     apiUrl = "39.105.88.24";
     cdnApiUrl = "";
     }
     );
     clapi =     (
     "120.77.243.186",
     "120.77.243.186"
     );
     code = 0;
     }
     */
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

@end
