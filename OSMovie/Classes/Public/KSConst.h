//
//  KSConst.h
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SSNetState) {
    SSNetNormal_state = 0,//正常网络
    SSNetError_state,//网络错误
    SSNetLoading_state,//加载数据
};

typedef enum : NSUInteger {
    TZAssetCellTypePhoto = 0,
    TZAssetCellTypeLivePhoto,
    TZAssetCellTypePhotoGif,
    TZAssetCellTypeVideo,
    TZAssetCellTypeAudio,
} TZAssetCellType;

typedef enum : NSUInteger {
    VideoType_UnKnow = 0,  //未知
    VideoType_TV = 1,  //电视剧
    VideoType_Movie = 2,  //电影
    VideoType_Variety = 3, //综艺
    VideoType_Anime = 4, //动漫
    VideoType_Short = 5 //短视频
} VideoType;

typedef enum : NSUInteger {
    VideoPlayType_NoSource,
    VideoPlayType_SafariPlay,
    VideoPlayType_WebViewPlay
} VideoPlayType;


@interface KSConst : NSObject

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
extern NSString * const LocationLongitude; /** 定位---经度 */
extern NSString * const LocationLatitude;  /** 定位---纬度 */
extern NSString * const CREDENTIAL;  //证书,拼接token用
extern NSString * const HomeCategoryVer; //首页请求分类时传的版本
extern NSString * const HomeCategoryDic; //首页分类频道,字典,保存起来,在片库里取出转模型用
extern NSString * const CanSeeVideoNoWifi; //允许使用流量看视频
extern NSString * const FIRSTRegisterSuccess; //首次安装, 首次登录时, 没网, 记录是否注册成功



extern NSString * const CODE; //验证码参数
extern NSString * const QD;//渠道
extern NSString * const TYPE;//验证码类型 1登录注册 3找回密码
extern NSString * const Code_Type;//0:语音 ,1:普通短信
extern NSString * const Nick_name;//用户昵称
extern NSString * const Sex;//性别（0：未知， 1： 男 ， 2：女）
extern NSString * const Avatar;//用户头像
extern NSString * const Birth;//用户出生年代（例：1980）
extern NSString * const City;//用户所在城市
extern NSString * const District;//用户所在的区
extern NSString * const Province;//用户所在省份
extern NSString * const Lon;//纬度,获取不到时传10000
extern NSString * const Lat;//纬度,获取不到时传10000
extern NSString * const RegistCode;//0表示带有注册信息，1表示跳过跳过时，用户昵称、头像、性别、出生年代传空
extern NSString * const Uid;//第三方登录获取的uid

/******************统一常用参数***************************/
extern NSString * const  Authorization; //token
extern NSString * const  Version;//版本号
extern NSString * const Device;//设备
extern NSString * const Timestamp;//时间戳 10位
extern NSString * const Sign;//参数签名
/******************统一常用参数***************************/
/******************其他常用参数***************************/
extern NSString * const Mobile;//手机号
extern NSString * const Type;//型号


/******************  通知Noti  ***************************/
extern NSString *const AnonymousSuccessNoti;  //注册成功,通知首页加载数据
extern NSString *const PageViewScrollNoti; //点击更多,跳转到对应pageView
extern NSString *const LOGIN_IN_Noti;
extern NSString *const LOGIN_OUT_Noti;
extern NSString *const RefreshUserMsgNoti;
extern NSString *const TabBarRefresh;
extern NSString *const SEARCH_HotWord_Noti;  //搜索热词通知, 更新topSearchView的placeHolder
extern NSString * const FIRSTRegisterFailNoti; //首次注册失败, 通知首页显示按钮
extern NSString *const LoginAndRefreshNoti;  //从某个页面进去了登录页面, 登录成功后, 通知进来的页面, 刷新

/******************  通知类型 是否开启对应通知  ***************************/
extern NSString *const NotiTypeAll;
extern NSString *const NotiTypeSystem;
extern NSString *const NotiTypeVideo;
extern NSString *const NotiTypeComment;
extern NSString *const NotiTypeLike;
extern NSString *const NotiTypeSignOrActivity;

@end
