//
//  MacroDefineConfig.h

#ifndef MacroDefineConfig_h
#define MacroDefineConfig_h

#define ScreenWidth           [[UIScreen mainScreen]bounds].size.width
#define ScreenHeight          [[UIScreen mainScreen]bounds].size.height

//iPhoneX / iPhoneXS
#define  isIphoneX_XS     (ScreenWidth == 375.f && ScreenHeight == 812.f ? YES : NO)
//iPhoneXR / iPhoneXSMax
#define  isIphoneXR_XSMax    (ScreenWidth == 414.f && ScreenHeight == 896.f ? YES : NO)
//异性全面屏
#define   isFullScreenX    (isIphoneX_XS || isIphoneXR_XSMax)

//// Status bar height.
//#define  StatusBarHeight     (isFullScreenX ? 44.f : 20.f)

#import "AppDelegate.h"
#define g_App               ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define SelectVC          (KSBaseNavViewController*)g_App.tabBarVC.selectedViewController
#define NSValueToString(a)  [NSString stringWithFormat:@"%@",a]

/** 获取系统版本 */
#define SYSTEM_VERSION        ([UIDevice currentDevice].systemVersion.floatValue)

#define iOS7Later (SYSTEM_VERSION >= 7.0f)
#define iOS8Later (SYSTEM_VERSION >= 8.0f)
#define iOS9Later (SYSTEM_VERSION >= 9.0f)
#define iOS9_1Later (SYSTEM_VERSION >= 9.1f)
#define iOS10Later (SYSTEM_VERSION >= 10.0f)
#define iOS11Later (SYSTEM_VERSION >= 11.0f)

#define MainWindow [UIApplication sharedApplication].keyWindow
#define KCOLOR(str) [Tool colorConvertFromString:str]
#define Image_Named(str)      [UIImage imageNamed:str]

//用户管理类
#define IS_LOGIN [[UserManager shareManager] isLogin]
#define USER_MANAGER [UserManager shareManager]

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alphaValue]
#define UIColorRGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

/** Common-----默认数据 */
//人物头像默认图
#define img_placeHolderIcon [UIImage imageNamed:@"img_placeHolderIcon"]
//图片占位图
#define img_placeHolder [UIImage imageNamed:@"img_user_bg"]
//默认字体颜色
#define color_defaultText [Tool colorConvertFromString:@"#545454"]  //淡灰色

//视频详情页顶部高度
#define VDTopViewH (ScreenWidth*422/750)
//视频详情页Tab高度
#define VDTabHeight self.sizeH(30)

//设备型号
#define MOBILE_TYPE  [[[UIDevice currentDevice] identifierForVendor] UUIDString]

//-----------UtilsMacro--------\\

// 打印
#ifdef DEBUG
# define SSLog(fmt, ...) NSLog((@"📍[函数名:%s]" "🎈[行号:%d]" fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
# define SSLog(...)
#endif

/**  常用设备型号 */
/** iPad */
#define IS_IPad               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
/** iPhone */
#define IS_IPhone             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/** iPhone4 */
#define IS_IPhone4            ([[UIScreen mainScreen] bounds].size.height == 480)
/** iPhone5 */
#define IS_IPhone5            ([[UIScreen mainScreen] bounds].size.height == 568)
/** iPhone6 */
#define IS_IPhone6            ([[UIScreen mainScreen] bounds].size.width == 375)
/** iPhonePlus */
#define IS_IPhonePlus         ([[UIScreen mainScreen] bounds].size.width == 414)
/** iPhoneX Xs */
#define IS_IPhoneXorXs        ([[UIScreen mainScreen] bounds].size.width == 375 && [[UIScreen mainScreen] bounds].size.height == 812)
/** iPhoneXs Max */
#define Is_IPhoneXSMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)


/** 获取设备ID */
#define DEVICE_ID             [[UIDevice currentDevice].identifierForVendor UUIDString]
/** 获取类名 */
#define ClassString NSStringFromClass([self class])

/** 通知中心 */
#define NOTIFICATION          [NSNotificationCenter defaultCenter]
/** NsUserDefault替换 */
#define USERDEFAULTS          [NSUserDefaults standardUserDefaults]
/** 应用程序 */
#define APPLICATION           [UIApplication sharedApplication]
/** URL */
#define URL(url)              [NSURL URLWithString:url]
#define SSStr(a,b)               [NSString stringWithFormat:@"%@%@",a,b]
/** NSInteger 转 NSString */
#define String_Integer(x)     [NSString stringWithFormat:@"%ld",(long)x]

/** 常用颜色 */
#define Orange_ThemeColor           KCOLOR(@"#FF5C3E")  //主橙色
#define ThemeColor           KCOLOR(@"#ffcc00")  //主题颜色
#define Black_Color           [UIColor blackColor]
#define Blue_Color            [UIColor blueColor]
#define Brown_Color           [UIColor brownColor]
#define Clear_Color           [UIColor colorWithRed:0 green:0 blue:0 alpha:0]
#define DarkGray_Color        [UIColor darkGrayColor]
#define DarkText_Color        [UIColor darkTextColor]
#define White_Color           [UIColor whiteColor]
#define Yellow_Color          [UIColor yellowColor]
#define Red_Color             [UIColor redColor]
#define Orange_Color          [UIColor orangeColor]
#define Purple_Color          [UIColor purpleColor]
#define LightText_Color       [UIColor lightTextColor]
#define LightGray_Color       [UIColor lightGrayColor]
#define Green_Color           [UIColor greenColor]
#define Gray_Color            [UIColor grayColor]
#define Magenta_Color         [UIColor magentaColor]

/** 动态设定字体大小 */
#define Get_Size(x)           IS_IPhonePlus ? ((x) + 1) : IS_IPhone6 ? (x) : (x) - 1

#define Font_Size(x)          [UIFont systemFontOfSize:Get_Size(x)]
#define Font_Bold(y)          [UIFont boldSystemFontOfSize:Get_Size(y)]
#define Font_Slim(y)          [UIFont fontWithName:@"STHeitiTC-Light" size:Get_Size(y)]
#define Font_Name(x,y)        [UIFont fontWithName:(x) size:(y)];

#define WS() typeof(self) __weak weakSelf = self;
#define SS() typeof(weakSelf) __strong strongSelf = weakSelf;

#define MWeakSelf(type)  __weak typeof(type) weak##type = type;
#define MStrongSelf(type)  __strong typeof(type) type = weak##type;

/** 手机正则 */
#define RegextestMobile       @"^1(3[0-9]|4[579]|5[0-35-9]|7[01356]|8[0-9])\\d{8}$"
/** 密码正则 */
#define RegextestPassword     @"^[@A-Za-z0-9!#$%^&*.~_(){},?:;]{6,20}$"
/** 验证码 */
#define kRegexVerCode         @"^[0-9]{6}$"
/** 邮箱 */
#define RegexestEmail         @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}"

//------------ appKey ------------//
#define WXAppID                      @"wx4c5db2735a6cc501"
#define WXAppSecret                @""
#define WX_ACCESS_TOKEN     @"WX_ACCESS_TOKEN "
#define WX_OPEN_ID                @"WX_OPEN_ID"
#define WX_REFRESH_TOKEN   @"refresh_token"
#define WX_BASE_URL             @"https://api.weixin.qq.com/sns"
#define WX_UNION_ID               @"unionid"

// 过期提醒
#define HZAddititonsDeprecated(instead) NS_DEPRECATED(1_0, 1_0, 2_0, 2_0, instead)

// -------------------------------- 用户 ---------------------------------\\
/** 用户id */
#define NowUserID                    @"userid"
/** 用户token */
#define UserToken                    @"token"
/** 用户头像 */
#define UserHeaderImg                @"headerImg"
/** 用户名 */
#define UserNickName                 @"userNickName"
/* 实名认证 */
#define RealName                    @"bcertid"

//键盘弹起来通知
#define KEYBOARD_SHOW @"keyboard_show"

//token过期
#define OverDateToken @"outDate_token"

//数据处理码
#define ErrorCode @"errCode"
#define ErrorMsg  @"errMsg"
#define Succeed   @"succeed"

#define FIRST_IN_KEY            @"FIRST_IN_KEY"

#define Tmp_VideoUrl @"[NSURL URLWithString:@"http://flv3.bn.netease.com/tvmrepo/2018/6/H/9/EDJTRBEH9/SD/EDJTRBEH9-mobile.mp4"]"

#define kVideoCover @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"

#define PageCount_Normal 10
#define PageCount_Recom 3
#define PageCount_VideoLib 15



//表名  缓存表 存 LJDownloadModel
#define CACHE_Table @"HistoryCACHE_Table"

#define AdvClickPercentCacheKey @"AdvClickPercentCacheKey"


#endif /* MacroDefineConfig_h */
