//
//  ABSUrlManager.h

#ifndef ABSUrlManager_h
#define ABSUrlManager_h

#define ServerURL_Normal            @"http://dev.api.vrg.51tv.com/"

#define PUBLIC_KEY_Normal         @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCYca51zjCcmC4s6V75H+TpdEI4BG9UzpOippjeTObFAYTLF7btxCmddtbJ9w7R9vsW+AQ6uqWqBLn8Fhxp2NfEPLsEZh5IeO1UyKffAC0FrvkVctay4JGbbrQ0w+Ju3a5Vc7oifx/fC47cVXRxpFOc1MMrSMYgLahUUxLVncAzjQIDAQAB"

//--------- 接口Url -----------//
//首页顶部分类接口
#define HomeCategoryUrl           @"api/module/lst/1"
//频道list内容
#define HomePageListUrl           @"api/prog/lst/1"
//举报
#define ReportUrl   @"accuse/ins/1"

//-----视频详情------//
//公有: 视频详情
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

#endif /* ABSUrlManager_h */
