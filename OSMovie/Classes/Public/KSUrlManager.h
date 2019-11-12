//
//  KSUrlManager.h

#ifndef KSUrlManager_h
#define KSUrlManager_h

/** 正式---服务器地址 */
#define ServerURL_Login              @"http://dev.api.vrg.51tv.com/"
#define ServerURL_Normal            @"http://dev.api.vrg.51tv.com/"
#define ServerURL_H5                  @"http://dev.api.vrg.51tv.com/"

#define PUBLIC_KEY_Login           @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDeTIi5tHOFpNV7hVKMx6ZoTr1Mk89FYYIfMg8iiEyFiEnf8q06QI/cS8dZUJWZ7CSRmCN48OxVUgCMdfuOGOEV1cqi6HIavrVJi2/8mqS8cTS8ZCogGZHWcbJ0GWFjKng1mDA+Za7aIX/enGGwNwEVCQB9zUzQTcIwLolg2QL0VwIDAQAB"

#define PUBLIC_KEY_Normal         @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDRn8NDdOOlchhOM7AtgrL3wo8+8U3bgXwDdZeovMUYJFKBKBCPaVErwHS5AhGuhLbU4tIYDDQ6lkbxLrx9oQVB+zn/jXMwhzGndEugX2rWv1sgNNmNTj488dCAYeuwmlG6ht7T2NFuuNHS27pEQNxXPxuQd4BGv+B4dLpQnBlahQIDAQAB"

/** 开发---服务器地址 */
#define DevServerURL_Login            @"http://dev.api.vrg.51tv.com/"
#define DevServerURL_Normal          @"http://dev.api.vrg.51tv.com/"
#define DevServerURL_H5                @"http://dev.api.vrg.51tv.com/"

//sign私钥
#define KEY_SKEY         @"bcb0c1736ab6eda5ad816fcc1204d885"

#define DevPUBLIC_KEY_Login           @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCaHX6vCr9x3KLQMmHIsPnVTh1UrD/dPPXPNk9sIfqDlBofUuylT2aEa0Z63oX54pnUkudfO87skgl+fzoHh9JAVhv0vpl69YhrqiYhg5+7W5DeNdDjYGb+eonaIHu94UF4cL1uWt+LSYy9xdkyknVLOehyJOg/sduvZ7NggHqveQIDAQAB"

#define DevPUBLIC_KEY_Normal         @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCYca51zjCcmC4s6V75H+TpdEI4BG9UzpOippjeTObFAYTLF7btxCmddtbJ9w7R9vsW+AQ6uqWqBLn8Fhxp2NfEPLsEZh5IeO1UyKffAC0FrvkVctay4JGbbrQ0w+Ju3a5Vc7oifx/fC47cVXRxpFOc1MMrSMYgLahUUxLVncAzjQIDAQAB"



//--------- H5_Url -----------//
#define QQFansH5_Url     @"fansGroupPage"
#define ConnectUsH5_Url     @"ContactUs"
#define VIPFAQH5_Url     @"usualquestion"
#define LotteryH5_Url     @"newlottery"
#define SignRuleH5_Url     @"ActivityRules"


//--------- 登录 ---------//
//FirstUrl_获取版本信息, 通用:app启动时调用接口
#define CheckVersionStateUrl @"v1/app/init"
//用户微信登录
#define WXLoginUrl  @"v1/user/wx/auth"
//绑定手机号
#define BindPhoneUrl @"v1/user/bindphone"
//获取短信验证码
#define GetPhoneCodeUrl                 @"v1/user/verfcode"
//短信验证码 (登录及注册)
#define CodeLoginRegisterUrl                 @"v1/user/login"



//--------- 接口Url -----------//
//首页顶部分类接口
#define HomeCategoryUrl           @"api/module/lst/1"
//频道list内容
#define HomePageListUrl           @"api/prog/lst/1"




//拖拽显示adv次数
#define DragShowAdvCountUrl @"ads/media/count/1"
//长片播放总时长的百分比, 弹出视频广告
#define FullScreenAdvPercentUrl @"ads/video/control/1"

//匿名注册
#define AnonymousRegisterUrl   @"user/register/device/1"
//匿名登录
#define AnonymousLoginUrl       @"user/login/device/1"
//密码登录
#define Login_PassWordUrl         @"user/login/mobile/1/1"
//手机注册
#define PhoneRegisterUrl       @"user/register/mobile/1"
//重置密码
#define ResetPasswordUrl      @"user/reset/mobile/1"

//首页轮播图
#define HomeCycleShowUrl         @"carousel/lst/3"
//首页 推荐页 的 List
#define HomeListMsgUrl              @"subject/lst/3"
//换一换
#define ChangeAGroupUrl            @"prog/lst/4"
//看点
#define WatchPointUrl                 @"subject/lst/4"
//看点详情页
#define WatchPointDetailUrl                 @"prog/lst/5"
//首页: 电影,电视剧,动漫,综艺 顶部 的 推荐接口
#define OtherHomeListTopRecomUrl    @"prog/lst/pik/1"
//首页: 电影,电视剧,动漫,综艺 的 list接口
#define OtherHomeListMsgUrl              @"subject/lst/2"
//首页: 热门
#define HomeHotChannelUrl_Old                @"prog/lst/pik/1"
//发现模块(发现)   --->最早使用的发现模块接口, 安卓现在用这个
#define DiscoverShortVideoUrl_Old             @"prog/lst/3"
//发现模块(发现)   ---DYC   现用, 发现模块接口
#define DiscoverShortVideoUrl             @"prog/ios/shortVideo/list"

//短视频赞 踩
#define ShortVideoInterationUrl             @"interact/ins/1"
//片库 顶部分类
#define VideoLibCategoryUrl             @"label/lst/1"
//片库 进入片库 获取list数据
#define VideoLibFirstLoadListUrl             @"prog/lst/2"
//片库 选择分类后的搜索 获取list数据
#define VideoLibSearchListUrl             @"search/prog/2"
//更多页: 首页的推荐页顶部轮播图跳  首页 非推荐页顶部轮播图跳 以及 cell里更多按钮跳 (除了推荐cell)
#define MoreListVCUrl  @"prog/lst/1"
//更多页: 首页 非推荐页顶部 推荐cell 的 更多按钮跳
#define MoreListVCFromRecomCellMoreBtnUrl  @"prog/lst/pik/1"
//意见反馈 & IAP支付失败
#define SendSuggestionUrl @"feedback/ins/1"
//搜索热词推荐
#define SearchHotWordUrl      @"search/word/1"
//搜索结果      推荐 GET       其他 POST
#define SearchLinkingOrResultUrl        @"search/prog/1"
//举报
#define ReportUrl   @"accuse/ins/1"

//-----视频播放详情页------//
//公有: 视频播放详情页
#define VideoDetail_CommonUrl   @"api/media/info/1"
//公有: 猜您喜欢
#define VideoDetail_GuessULikeUrl @"api/prog/like/1"
//请求集数
#define VideoDetail_NumberOfEpisodeUrl @"api/media/tip/1"




//全部剧集里的剧集介绍
#define AllEpisodeIntroUrl @"media/story/1"
//视频收藏
#define VideoCollectUrl @"collect/ins/1"
//取消收藏
#define VideoCancelCollectUrl @"collect/del/1"





//-------我-----------//
//修改头像和昵称
#define ModifyUerMsgUrl     @"user/attribute/ups/1"
//获取Token 七牛上传图片时使用
#define GetImgUpdateTokenUrl @"security/7niu/token/1"
//VIP页面: 用户VIP信息
#define VIPUserMsgUrl         @"user/detail/result/1"
//用户下载信息: 用户当前最多同时下载个数
#define DownloadMaxCountMsgUrl      @"user/download/result/1"
//VIP页面: VIP售卖信息
#define VIPSellMsgUrl           @"trade/1001/config/detail"
//VIP页面: VIP影片速递
#define VIPVideoRecomUrl     @"trade/1002/recommend/1"
//VIP页面: 观影券页面
#define VideoTicketUrl           @"trade/1003/buy/record/1"
//VIP页面: 购影记录页面
#define VideoPurchaseHistoryUrl           @"trade/1002/buy/record/1"
//自有源 获取最新下载地址
#define NewestDownloadUrl  @"analysis/url/1"
//我的收藏页面
#define MyCollectionListUrl   @"collect/lst/2"
//批量删除我的收藏
#define DeleteCollectionListUrl    @"collect/del/multiple/1"

//有券  用券 购买影片
#define UseTicketBuyVideoUrl    @"trade/1002/buy/ticket/1"

//付费影片, IAP前先 生成订单号
#define OrderForBuyVideoUrl  @"trade/1002/order/buffer/1"
//VIP购买,   IAP前先 生成订单号
#define OrderForBuyVIPUrl  @"trade/1001/order/buffer/1"

//验证购买凭证  IAP
#define CheckInAppPurchaseUrl   @"iosPay/auth/1"

//消息中心
#define MsgCenterUrl     @"notice/res/all/2"
//消息中心详情页 非评论点赞接口
#define MsgCenterSubListUrl  @"notice/res/2"
//消息中心详情页 评论点赞接口
#define MsgCenterComLikeListUrl  @"notice/res/user/2"
//消息中心子页面 清空消息
#define MsgCenterClearUrl  @"notice/control/clear/1"

//-----------签到---提现--------//
#define SignViewUserMsgUrl     @"activity/task/all/1"
#define SignViewSignMsgUrl     @"activity/sign/get/3"
#define SignViewTaskUrl    @"activity/task/get/1"
#define SignOrSupplyUrl     @"activity/task/execute/2"
#define ZFBBindingMsgUrl  @"cash/user/info/1"
#define WithdrawUrl           @"cash/draw/cash/1"

//----------我的钱包-------//
#define MyWalletUrl     @"cash/user/home/1"
#define WithdrawListUrl  @"cash/user/draw/list/1"
#define WithdrawZFBMsgUrl  @"cash/bind/id/1"

//-----------Advertisement_API-----------//
//App启动_开屏
#define Adv_SplashUrl  @"ads/call/1"

//--------DYC New_Interface新接口      _Old deprecated 弃用
//首页: 热门 (弃用,智推接口替代)
#define HomeHotChannelUrl_Old2                @"prog/ios/pik/list"

//首页: 热门 (智推接口)
#define HomeHotChannelUrl            @"prog/lst/uar/listPage/2"

//Old  短视频 播放 列表    GET
#define ShortVideoRecomListUrl_Old           @"prog/lst/updateRel/1"
// NSDictionary *dic = @{
//@"pi" : self.model.idForModel,
//@"pt" : self.model.type,
//@"pageIndex" : @(self.page),
//@"pageSize" : @(5)
//};

// 短视频 播放 列表页 & 详情页短视频的 更多精彩 , 用智能推荐接口
#define ShortVideoRecomListUrl            @"prog/lst/uar/playDetailPage/2"

//每日弹框
#define DailyPopOutUrl  @"activity/dynamic/1"

//-----埋点------//
#define BuryingPointUrl                        @"logger/submit/offline/1"

//媒体警报日志上报
#define MonitorLogUrl @"logger/submit/monitorLog"

//智推 短视频用户播放情况上报
#define UserVideoPlayMsgReportUrl @"logger/submit/dauserInfo"

#endif /* KSUrlManager_h */
