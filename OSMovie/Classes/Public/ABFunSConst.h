//
//  ABFunSConst.h
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SSNetState) {
    SSNetNormal_state = 0,
    SSNetError_state,
    SSNetLoading_state,
};

typedef enum : NSUInteger {
    VideoType_UnKnow = 0,
    VideoType_TV = 1,
    VideoType_Movie = 2,
    VideoType_Variety = 3,
    VideoType_Anime = 4,
    VideoType_Short = 5
} VideoType;

typedef enum : NSUInteger {
    VideoPlayType_NoSource,
    VideoPlayType_SafariPlay,
    VideoPlayType_WebViewPlay
} VideoPlayType;

@interface ABFunSConst : NSObject

extern NSString * const USER_TOKEN;
extern NSString * const USER_DATA;
extern NSString * const isCK;
extern NSString * const DragShowAdvCount;
extern NSString * const USER_NickName;
extern NSString * const USER_ICON;
extern NSString * const USER_PHONE;
extern NSString * const USER_UserName;
extern NSString * const USER_ID;
extern NSString * const LastRequestDurTime;
extern NSString * const LocationLongitude;
extern NSString * const LocationLatitude;
extern NSString * const CREDENTIAL;
extern NSString * const HomeCategoryVer;
extern NSString * const HomeCategoryDic;
extern NSString * const CanSeeVideoNoWifi;
extern NSString * const FIRSTRegisterSuccess;

extern NSString * const Nick_name;
extern NSString * const Sex;
extern NSString * const Avatar;
extern NSString * const Lon;
extern NSString * const Lat;

extern NSString * const  Authorization;
extern NSString * const  Version;
extern NSString * const Device;
extern NSString * const Timestamp;
extern NSString * const Sign;
extern NSString * const Mobile;
extern NSString * const Type;

extern NSString *const RefreshUserMsgNoti;
extern NSString *const TabBarRefresh;

extern NSString *const NetWorkAddress;

extern NSString *const HOST_cl;
extern NSString *const HOST_ad;
extern NSString *const HOST_api;

@end
