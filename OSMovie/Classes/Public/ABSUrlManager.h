//
//  ABSUrlManager.h

#ifndef ABSUrlManager_h
#define ABSUrlManager_h

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

#define DevPUBLIC_KEY_Login           @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCaHX6vCr9x3KLQMmHIsPnVTh1UrD/dPPXPNk9sIfqDlBofUuylT2aEa0Z63oX54pnUkudfO87skgl+fzoHh9JAVhv0vpl69YhrqiYhg5+7W5DeNdDjYGb+eonaIHu94UF4cL1uWt+LSYy9xdkyknVLOehyJOg/sduvZ7NggHqveQIDAQAB"

#define DevPUBLIC_KEY_Normal         @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCYca51zjCcmC4s6V75H+TpdEI4BG9UzpOippjeTObFAYTLF7btxCmddtbJ9w7R9vsW+AQ6uqWqBLn8Fhxp2NfEPLsEZh5IeO1UyKffAC0FrvkVctay4JGbbrQ0w+Ju3a5Vc7oifx/fC47cVXRxpFOc1MMrSMYgLahUUxLVncAzjQIDAQAB"

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
