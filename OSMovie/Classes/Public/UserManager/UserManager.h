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
-(id)dataStrForKey:(NSString*)key;
- (void)gotoLogin;
-(BOOL)isDevStatus;
-(NSString*)serverAddress;
-(NSString*)serverAddressWithLogin;
-(NSString*)publicKey;
-(NSString*)publicKeyWithLogin;
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

@end
