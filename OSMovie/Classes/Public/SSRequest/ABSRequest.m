//
//  ABSRequest.m
//  Osss
//
//  Created by Lff_OsDeveloper on 2017/3/29.
//  Copyright © 2017年    asdfghjkl. All rights reserved.
//

#import "ABSRequest.h"
#import "Tool.h"
#import "LEEAlert.h"
#import "RSAUtil.h"
#import "NSString+AES.h"
#import "NSData+GZIP.h"
#import "GTMBase64.h"
#import "NSData+KKAES.h"

@interface ABSRequest ()
@end

@implementation ABSRequest

static AFHTTPSessionManager * extracted(ABSRequest *object) {
    return object.sessionManager;
}

-(NSString *)URLEncodedString:(NSString *)str {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)str,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return encodedString;
}

-(NSString *)URLDecodedString:(NSString *)str {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

static ABSRequest *absRequest = nil;

+ (instancetype)request {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        absRequest = [[ABSRequest alloc]init];
    });
    return absRequest;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (absRequest == nil) {
            absRequest = [super allocWithZone:zone];
        }
    });
    return absRequest;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName =NO;    //是否验证域名，默认YES
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.securityPolicy = securityPolicy;
        self.sessionManager = manager;

        AFJSONResponseSerializer *JsonSerializer = [AFJSONResponseSerializer serializer];
        JsonSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        JsonSerializer.removesKeysWithNullValues=YES;
        self.sessionManager.responseSerializer = JsonSerializer;
        
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.sessionManager.requestSerializer.timeoutInterval = 10.f;
        [self.sessionManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    }return self;
}

- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(ABSRequest *request, NSDictionary *response))success failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure {
    self.operationQueue = self.sessionManager.operationQueue;
    
    NSString *requestUrlString = SSStr([USER_MANAGER serverAddress], URLString);
    
    [self.sessionManager.requestSerializer setValue:[self getUserAgentStrWithUrlStr:URLString IsLogin:NO] forHTTPHeaderField:@"UserAgent"];
    
    [self.sessionManager GET:requestUrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        long long endTime = [Tool getCurrentTimeMillsNum];
        long long startTime = [responseObject[@"requestStartTime"] longLongValue];
        long long durationTime = startTime - endTime;
        [USERDEFAULTS setObject:[NSNumber numberWithLong:durationTime] forKey:LastRequestDurTime];
        [USERDEFAULTS synchronize];
        
        if([responseObject[@"code"] integerValue] == 10000) {
            success(self,responseObject);
        }else {
            failure(self,responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error.code == -1009) {
            failure(self,@"网络连接中断,请检查网络");
        }else {
            failure(self,error.localizedDescription);
        }
    }];
}

- (void)GETAboutLogin:(NSString *)URLString
           parameters:(NSDictionary *)parameters
              success:(void (^)(ABSRequest *request, NSDictionary *response))success
              failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure {
    
    self.operationQueue = self.sessionManager.operationQueue;
    
    NSString *requestUrlString = SSStr([USER_MANAGER serverAddressWithLogin], URLString);

    [self.sessionManager.requestSerializer setValue:[self getUserAgentStrWithUrlStr:URLString IsLogin:YES] forHTTPHeaderField:@"UserAgent"];
    
    [self.sessionManager GET:requestUrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        long long endTime = [Tool getCurrentTimeMillsNum];
        long long startTime = [responseObject[@"requestStartTime"] longLongValue];
        long long durationTime = startTime - endTime;

        [USERDEFAULTS setObject:[NSNumber numberWithLong:durationTime] forKey:LastRequestDurTime];
        [USERDEFAULTS synchronize];
        
        if([responseObject[@"code"] integerValue] == 10000) {
            success(self,responseObject);
        }else {
            failure(self,responseObject[@"message"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error.code == -1009) {
            failure(self,@"网络连接中断,请检查网络");
        }else {
            failure(self,error.localizedDescription);
        }
    }];
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(ABSRequest *request, id response))success
     failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure{
    
    self.operationQueue = self.sessionManager.operationQueue;
   
    NSString *requestUrlString = SSStr([USER_MANAGER serverAddress], URLString);

    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.requestSerializer.timeoutInterval = 10.f;
    [self.sessionManager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.sessionManager.requestSerializer setValue:[self getUserAgentStrWithUrlStr:URLString IsLogin:NO] forHTTPHeaderField:@"UserAgent"];
        
    [self.sessionManager POST:requestUrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        long long endTime = [Tool getCurrentTimeMillsNum];
        long long startTime = [responseObject[@"requestStartTime"] longLongValue];
        long long durationTime = startTime - endTime;

        [USERDEFAULTS setObject:[NSNumber numberWithLong:durationTime] forKey:LastRequestDurTime];
        [USERDEFAULTS synchronize];
        
        if([responseObject[@"code"] integerValue] == 10000) {
            success(self,responseObject);
        }else {
            failure(self,responseObject[@"message"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(error.code == -1009) {
            failure(self,@"网络连接中断,请检查网络");
        }else {
            failure(self,error.localizedDescription);
        }
    }];
}

- (void)POSTAboutLogin:(NSString *)URLString
  parameters:(NSMutableDictionary*)parameters
     success:(void (^)(ABSRequest *request, id response))success
     failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure{
    
    self.operationQueue = self.sessionManager.operationQueue;
    
    NSString *requestUrlString = SSStr([USER_MANAGER serverAddressWithLogin], URLString);

    [self.sessionManager.requestSerializer setValue:[self getUserAgentStrWithUrlStr:URLString IsLogin:YES] forHTTPHeaderField:@"UserAgent"];
    
    [self.sessionManager POST:requestUrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        long long endTime = [Tool getCurrentTimeMillsNum];
        long long startTime = [responseObject[@"requestStartTime"] longLongValue];
        long long durationTime = startTime - endTime;
        [USERDEFAULTS setObject:[NSNumber numberWithLong:durationTime] forKey:LastRequestDurTime];
        [USERDEFAULTS synchronize];

        if([responseObject[@"code"] integerValue] == 10000) {
            success(self,responseObject);
        }else {
            failure(self,responseObject[@"message"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(error.code == -1009) {
            failure(self,@"网络连接中断,请检查网络");
        }else {
            failure(self,error.localizedDescription);
        }
        
    }];
}

//广告反馈用的GET请求
- (void)AdvReportGET:(NSString *)URLString success:(void (^)(ABSRequest *request, NSDictionary *response))success failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure {
    
    self.operationQueue = self.sessionManager.operationQueue;
    [self.sessionManager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        if([responseObject[@"code"] integerValue] == 10000) {
//            success(self,responseObject);
//        }else {
//            failure(self,responseObject[@"message"]);
//        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        if(error.code == -1009) {
//            failure(self,@"网络连接中断,请检查网络");
//        }else {
//            failure(self,error.localizedDescription);
//        }
        
    }];
}

- (void)cancelAllOperations {
    [self.operationQueue cancelAllOperations];
}

- (NSString *)getUserAgentStrWithUrlStr:(NSString *)urlStr IsLogin:(BOOL)isLogin {
//Old
//    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    NSString *ver = [infoDic objectForKey:@"CFBundleShortVersionString"];
//    //正确的: osTypeId:01
//    //改成osTypeId:02试试
//    NSString *ua = [NSString stringWithFormat:@"%@ ss2/%@ (agent:s;channel:%@;credential:%@;deviceId:%@;osTypeId:01;detailInfo:iOS;simTypeId:%@;netTypeId:%@;deviceTypeId:02;osVersion:%@;token:%@)",[USER_MANAGER getUserAgent],[USER_MANAGER getVersionStr],[USER_MANAGER getAppPubChannel],[USER_MANAGER getCredential],[USER_MANAGER getUUID],[USER_MANAGER getSimType],[USER_MANAGER getNetWorkType],ver,[self getTokenWithUrlStr:urlStr IsLogin:isLogin]];
    
    //Temp
    NSString *userID = [USER_MANAGER getUserID];
    NSString *ua = [NSString stringWithFormat:@"%@@1.0.0@02@official",userID];
    return ua;
}

- (NSString *)getTokenWithUrlStr:(NSString *)urlStr IsLogin:(BOOL)isLogin {
    NSString *userID = [USER_MANAGER getUserID];
    if (userID && userID.length>8) {
        userID = [NSString stringWithFormat:@"%@*%@#%@!%@$%@",[userID substringWithRange:NSMakeRange(0, 1)],[userID substringWithRange:NSMakeRange(1, 1)],[userID substringWithRange:NSMakeRange(2, 1)],[userID substringWithRange:NSMakeRange(4, 1)],[userID substringWithRange:NSMakeRange(7, 1)]];
    }
    
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *token = [NSString stringWithFormat:@"/%@-%@-%@-",urlStr,[USER_MANAGER getTimeForToken],app_Version];
    NSString * md5Str = [Tool md5:SSStr(token, userID)];
    NSString *rsaStr = [RSAUtil encryptString:SSStr(token, md5Str) publicKey: isLogin ? [USER_MANAGER publicKeyWithLogin] : [USER_MANAGER publicKey]];
    return rsaStr;
}

//NetWorkA
- (void)getNetWorkAddWithUrl:(NSString*)requestUrl success:(void (^)(ABSRequest *request, id response))success failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure {
    
    if (![requestUrl containsString:@"http"]) {
        requestUrl = [NSString stringWithFormat:@"http://%@/cc/fst?t=gp",requestUrl];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
    [request setHTTPMethod:@"POST"];
    request.timeoutInterval= 10.f;
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters = @{
        @"userId" : [USER_MANAGER getUserID],
        @"did" : [USER_MANAGER getIDFA],
        @"ts" : @([Tool getCurrentTimeSecsNum])
    };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *aesKey = @"2f69bfe8265f8faf1d29c721fa2c1ba6";
    NSString *aesIV = @"dDUcnZ9ZlS0rwF3R";
    NSData*aesKeyData = [aesKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData*aesIVData = [aesIV dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData* aesData = [jsonData AES_CBC_EncryptWith:aesKeyData iv:aesIVData];
    aesData = [GTMBase64 encodeData:aesData];
    
    [request setHTTPBody:aesData];
    
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask * tesk = [requestManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            //responseObject   _NSInlineData
            NSString *base64DecodeStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *d = [GTMBase64 decodeString:base64DecodeStr];
            NSData *decryptData = [d AES_CBC_DecryptWith:aesKeyData iv:aesIVData];
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:decryptData options:NSJSONReadingMutableLeaves error:nil];
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            SSLog(@"\n\nresponseDic--->\n%@",dic);
            if (dic[@"clapi"]) {
                NSArray *clArr = dic[@"clapi"];
                NSMutableArray *newArr = [NSMutableArray array];
                if(clArr.count>0) {
                    [clArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *newStr = [NSString stringWithFormat:@"http://%@/cc/fst?t=gp",obj];
                        [newArr addObject:newStr];
                    }];
                }
                [newDic setObject:[newArr copy] forKey:@"clapi"];
                SSLog(@"\n\ndealAndSaveDic--->\n%@",newDic);
            }
            [USERDEFAULTS setObject:dic forKey:NetWorkAddress];
            [USERDEFAULTS synchronize];
            success(self,response);
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
        }else {
            failure(self,error.description);
        }
    }];
    [tesk resume];
    
}

- (void)getAdvDataWithUrl:(NSString*)requestUrlString positionID:(NSString*)positionID
                  success:(void (^)(ABSRequest *request, id response))success
                  failure:(void (^)(ABSRequest *request, NSString *errorMsg))failure {
    NSDictionary *par = @{
        @"slot_id": positionID,
        @"slot_w": @(ScreenWidth),
        @"slot_h": @(ScreenHeight),
        @"media_type": @(1),
        @"app_version": @"1.0.0",
        @"app_pkg": @"com.os.os",
        @"os_type": @(2), //1-安卓 2-iOS
        @"Idfa": [USER_MANAGER getIDFA],
        @"brand": @"",
        @"model": @"",
        @"os_version": @"1.0.0",
        @"sheight": @(1920),
        @"swidth": @(1080),
        @"ua": [USER_MANAGER getUserAgent],
        @"sdensity": @(441),
        @"imei": @"910166037841305",
        @"android_id": @"",
        @"mac": @"00:01:6C:06:A6:29",
        @"net_ip": @"116.226.214.2",
        @"imsi": @"460018471603447",
        @"net_type": @(1),
        @"net_op": @(46000),
        @"client_type": @(4),
        @"client_version": @"1.1.0"
    };

    if (![requestUrlString containsString:@"http"]) {
        requestUrlString = [NSString stringWithFormat:@"http://%@/api/req",requestUrlString];
    }
//    requestUrlString = @"http://dev.sspapi.51tv.com/api/req";
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.operationQueue = sessionManager.operationQueue;
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.requestSerializer.timeoutInterval = 10.f;
    [sessionManager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [sessionManager POST:requestUrlString parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            NSDictionary*advDic = [Tool dictionaryForJsonData:responseObject];
            if (advDic[@"success"] && advDic[@"admeta"]) {
                NSArray *arr = advDic[@"admeta"];
                success(self,arr.firstObject);
            }else {
                failure(self,@"广告请求失败");
            }
        }else {
            failure(self,@"广告请求失败");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(self,error.localizedDescription);
    }];
}

@end

@implementation BaseModel
@end
