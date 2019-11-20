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

- (void)loginSuccess;
- (NSString*)isCK;

/** 短视频交互: 赞 踩 */
- (void)shortVideoInteractWithPar:(NSDictionary *)par success:(void (^)(id))success failure:(void (^)(NSString *))failure;

/** 视频收藏, 取消收藏 */
- (void)videoCollectionWithPar:(NSDictionary *)par andIsCollection:(BOOL)isCollection success:(void (^)(id))success failure:(void (^)(NSString *))failure;

//分享模块弹框创建前, 根据判断显示弹框高度
- (NSInteger)getShareNumBeforeShowShareViewWithNotInterest:(BOOL)isInterest;

// (单位毫秒)  当前时间 + (上次请求开始请求时的时间 - 上次请求成功时的时间)
- (NSString *)getTimeForToken;

@end
