//
//  UserManager.h
//  NewTarget
//  Copyright © 2016年  rw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserManager : NSObject

+(id)shareManager;
- (void)saveUserDataWithDic:(NSDictionary *)dic andToken:(NSString *)token;
- (void)saveHomeCategoryWithDic:(NSDictionary *)dic;
- (NSString *)getUserIcon;
-(NSString *)getUserNickName;
-(NSString *)getUserName;
-(NSString*)getUserPhone;
-(NSString *)getUserToken;
- (void)removeUserAllData;
-(BOOL)isLogin;
- (void)gotoLogin;
-(BOOL)isDevStatus;
- (NSString *)getUserAgent;
- (NSString *)getVersionStr;
- (NSNumber *)getOSType;
- (NSString *)getSimType;
- (NSString *)getNetWorkType;
- (NSString *)getCredential;
- (NSString *)getUserID;
- (NSString*)getUUID;
- (NSString*)getDeviceName;
- (NSString*)getAppPubChannel;
- (NSString *)getIDFA;

- (void)loginSuccess;
- (NSString*)isCK;

// (单位毫秒)  当前时间 + (上次请求开始请求时的时间 - 上次请求成功时的时间)
- (NSString *)getTimeForToken;

- (void)callBackAdvWithUrls:(NSArray*)urls;

typedef NS_ENUM(NSUInteger, DomainType) {
    DomainType_Cl = 0,
    DomainType_Api,
    DomainType_Ad,
    DomainType_Cdn,
};

- (void)configAndUpdateHosts;

//H5解析播放地址
- (void)parsedUrlForH5WithUrl:(NSString*)urlParsing success:(void (^)(id response))success failure:(void(^)(NSString* errMsg))failure;

//H5解密自上传视频
- (void)decodeH5VideoUrlWithUrl:(NSString*)urlParsing success:(void (^)(id response))success;

@end
