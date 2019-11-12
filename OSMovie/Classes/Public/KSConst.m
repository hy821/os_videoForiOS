//
//  KSConst.m
//
//  存放常量

#import "KSConst.h"

@implementation KSConst

NSString *const USER_TOKEN = @"USER_TOKEN";
NSString *const USER_DATA = @"USER_DATA";
NSString *const USER_ID = @"USER_ID";

NSString *const isCK = @"isCK";
NSString *const DragShowAdvCount = @"DragShowAdvCount";
NSString *const USER_NickName = @"USER_NickName";
NSString *const USER_ICON = @"USER_ICON";
NSString *const USER_PHONE = @"USER_PHONE;";
NSString *const USER_UserName = @"USER_UserName";
NSString * const LocationLongitude = @"LocationLongitude";  /** 定位---经度 */
NSString * const LocationLatitude = @"LocationLatitude";  /** 定位---纬度 */
NSString *const LastRequestDurTime = @"LastRequestDurTime";  //拼接token用
NSString *const CREDENTIAL = @"CREDENTIAL";  //证书,拼接token用
NSString *const HomeCategoryVer = @"HomeCategoryVer"; //首页请求分类时传的版本
NSString *const HomeCategoryDic = @"HomeCategoryDic"; //首页分类频道,字典,保存起来,在片库里取出转模型用
NSString *const CanSeeVideoNoWifi = @"CanSeeVideoNoWifi"; //允许使用流量看视频
//--------->允许使用流量下载视频   LJDownloadAllowsCellularAccessKey
NSString *const FIRSTRegisterSuccess = @"FIRSTRegisterSuccess"; //首次安装, 首次登录时, 没网, 记录是否注册成功

NSString *const CODE = @"verifycode"; //验证码参数
NSString *const QD = @"qd";//渠道
NSString *const TYPE = @"type";//验证码类型 1登录注册 3找回密码
NSString *const Code_Type = @"dxtype";//0:语音 ,1:普通短信
NSString *const Nick_name = @"nickname";//用户昵称
NSString *const Sex = @"sex";//性别（0：未知， 1： 男 ， 2：女）
NSString *const Avatar = @"headimg";//用户头像
NSString *const City = @"city";//用户所在城市
NSString *const District = @"district";//用户所在的区
NSString *const Province = @"province";//用户所在省份
NSString *const Lon = @"lon";//纬度,获取不到时传10000
NSString *const Lat = @"lat";//纬度,获取不到时传10000
NSString *const RegistCode = @"code";//0表示带有注册信息，1表示跳过跳过时，用户昵称、头像、性别、出生年代传空
NSString *const Uid = @"uid";//第三方登录获取的uid

/******************统一常用参数***************************/
NSString *const  Authorization = @"Authorization"; //token
NSString *const  Version = @"Version";//版本号
NSString *const Device = @"Device";//设备
NSString *const Timestamp = @"Timestamp";//时间戳 10位
NSString *const Sign = @"Sign";//参数签名
/******************其他常用参数***************************/
NSString *const Mobile = @"mobile";//手机号
NSString *const Type = @"type";//型号

/******************  通知Noti  ***************************/
NSString *const AnonymousSuccessNoti = @"AnonymousSuccessNoti";  //注册成功,通知首页加载数据
NSString *const PageViewScrollNoti = @"PageViewScrollNoti";
NSString *const LOGIN_IN_Noti = @"LOGIN_IN_Noti";
NSString *const LOGIN_OUT_Noti = @"LOGIN_OUT_Noti";
NSString *const RefreshUserMsgNoti = @"RefreshUserMsgNoti";
NSString *const TabBarRefresh = @"TabBarRefresh";
NSString *const SEARCH_HotWord_Noti = @"SEARCH_HotWord_Noti";
NSString *const FIRSTRegisterFailNoti = @"FIRSTRegisterFailNoti"; //首次注册失败, 通知首页显示按钮
NSString *const LoginAndRefreshNoti = @"LoginAndRefreshNoti";

/******************  通知类型 是否开启对应通知  ***************************/
NSString *const NotiTypeAll = @"NotiTypeAll";
NSString *const NotiTypeSystem = @"NotiTypeSystem";
NSString *const NotiTypeVideo = @"NotiTypeVideo";
NSString *const NotiTypeComment = @"NotiTypeComment";
NSString *const NotiTypeLike = @"NotiTypeLike";
NSString *const NotiTypeSignOrActivity = @"NotiTypeSignOrActivity";

@end
