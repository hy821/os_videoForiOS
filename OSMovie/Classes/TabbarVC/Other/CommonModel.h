//
//  CommonModel.h
//  OSMovie
//
//  Created by young He on 2019/10/30.
//  Copyright © 2019 youngHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonModel : NSObject

@end

//首页分类model
@interface HomeCategoryModel : NSObject
@property (nonatomic,copy) NSString *categoryID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *audit; // 1:ck
@end

//ImgModel
@interface ImgModel : NSObject
@property (nonatomic,copy) NSString *format;
@property (nonatomic,copy) NSString *height;
@property (nonatomic,copy) NSString *imageKey;
@property (nonatomic,copy) NSString *src;
@property (nonatomic,copy) NSString *url;   //没有url的话,用src
@property (nonatomic,copy) NSString *width;
@end

//StarsModel
@interface StarsModel : NSObject
@property (nonatomic,copy) NSString *displayUrl;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *personId;
@end

#pragma mark - 视频详情页Model
@interface SecretInfoModel : NSObject
@property (nonatomic,copy) NSString *assetType;
@property (nonatomic,copy) NSString *mediaId;
@property (nonatomic,copy) NSString *programId;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *url;
@end

@interface MediaTipResultModel : NSObject   //每一集的Model
@property (nonatomic,copy) NSString *analysisPolicy;
@property (nonatomic,strong) ImgModel *coverInfo;
@property (nonatomic,copy) NSString *diversityId;
@property (nonatomic,copy) NSString *mediaId;
@property (nonatomic,copy) NSString *mediaIndex;
@property (nonatomic,copy) NSString *originLink;  //直接播放url
@property (nonatomic,strong) SecretInfoModel *secretInfo;  //??

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *trailer;  //是否是预告片

@property (nonatomic,assign) BOOL isSelect;  //默认 index = 1 的 YES
@property (nonatomic,copy) NSString *index;  //自己赋值, 显示数字第几集, 有的是番外篇,所以mediaIndex不是数字.


@property (nonatomic,assign) BOOL isCacheView;  //是否是缓存View的展示
@property (nonatomic,assign) BOOL isCache;  //是否缓存了


//播放页 传进去这个Model, 需要pi pt , 用券时用,  所以赋值pi pt, 这两个值不一定有
@property (nonatomic,copy) NSString *pi;   //观看历史用,记录时间          下载完成, 播放用 for埋点
@property (nonatomic,copy) NSString *pt;  //观看历史用,记录时间           下载完成, 播放用 for埋点
@property (nonatomic,assign) VideoType videoType;  //观看历史用, VDModel赋值的

//记录播放时间. 默认0
@property (nonatomic, assign) NSTimeInterval saveTime;

//进入播放页前赋值, 观看历史显示用
@property (nonatomic,strong) ImgModel *poster;

//进入播放页, 查找本地如果有缓存好的url, 播放本地缓存好的url, 并且存进来
@property (nonatomic,copy) NSString *localPlayUrl;
@end

@interface MediaSourceResultModel : NSObject
@property (nonatomic,copy) NSString *downMode;
@property (nonatomic,copy) NSString *engine;
@property (nonatomic,copy) NSString *idForModel;   //si
@property (nonatomic,copy) NSArray<MediaTipResultModel*> *mediaTipResultList;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *pay;
@property (nonatomic,copy) NSString *playMode;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *trailer;  //是否是预告片
@property (nonatomic,copy) NSString *url;

//Add
@property (nonatomic,assign) BOOL isSelect;
//@property (nonatomic,assign) NSInteger indexSelect;  //选中的集数, mediaTipResultList[indexSelect]  默认为0
@end

@interface MediaResultModel : NSObject
@property (nonatomic,copy) NSArray<MediaSourceResultModel*> *mediaSourceResultList;
@end

@interface GuideResultModel : NSObject
@property (nonatomic,copy) NSString *circulate;
@property (nonatomic,copy) NSString *cash;
@property (nonatomic,copy) NSString *configId;
@property (nonatomic,copy) NSString *expireAt;
@property (nonatomic,copy) NSString *expireAtStr;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *lookAt;
@property (nonatomic,copy) NSString *policyId;
@property (nonatomic,copy) NSString *times;
@property (nonatomic,copy) NSString *scene;
@end

//DirectorsModel  // AuthorsModel
@interface DirectorsModel : NSObject
@property (nonatomic,copy) NSString *displayUrl;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *personId;
@end

//CurrentInfoModel
@interface CurrentInfoModel : NSObject
@property (nonatomic,copy) NSString *PRAISE;
@property (nonatomic,copy) NSString *STEPON;
@end

//interactResultModel
@interface InteractResultModel : NSObject
@property (nonatomic,strong) CurrentInfoModel *currentInfo;
@property (nonatomic,copy) NSString *type;
@end

@interface ProgramResultListModel : NSObject
@property (nonatomic,copy) NSString *areas;
@property (nonatomic,copy) NSArray<DirectorsModel*> *authors;  //作者
@property (nonatomic,copy) NSString *briefIntroduction;
@property (nonatomic,copy) NSArray *categoryIds;
@property (nonatomic,copy) NSArray<NSString*> *categoryNames;
@property (nonatomic,copy) NSString *commentCount;
@property (nonatomic,copy) NSString *cursor;  //光标, 排行榜第几  +1
@property (nonatomic,copy) NSString *bucket;  //推荐Cell点击更多时 进入更多页面 分页需要 本来没这个字段
@property (nonatomic,copy) NSString *descriptionForModel;
@property (nonatomic,copy) NSArray<DirectorsModel*> *directors;
@property (nonatomic,copy) NSArray *directorArray;  //根据directors
@property (nonatomic,copy) NSString *episodes;  //总剧集数
@property (nonatomic,copy) NSString *finished;   //1 已完结 0 连载中
@property (nonatomic,strong) GuideResultModel *guideResult;
@property (nonatomic,copy) NSString *idForModel;
@property (nonatomic,strong) InteractResultModel *interactResult;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) ImgModel *playImg;
@property (nonatomic,copy) NSString *playPageCount;
@property (nonatomic,copy) NSString *points;
@property (nonatomic,strong) ImgModel *poster;  //海报
@property (nonatomic,copy) NSArray<StarsModel*> *stars;
@property (nonatomic,copy) NSArray *starsArray;  //根据stars获取
@property (nonatomic,copy) NSString *summary;
@property (nonatomic,copy) NSString *shareLink;
@property (nonatomic,copy) NSString *trailer;  //预告片
@property (nonatomic,copy) NSString *type;   // 5 短视频
@property (nonatomic,assign) VideoType videoType;  //根据type

@property (nonatomic,strong) MediaResultModel *mediaResult; //...服气

//------Short Video
@property (nonatomic,copy) NSString *realUrl;
@property (nonatomic,copy) NSURL *urlFromRealUrl;  //根据realUrl

@property (nonatomic, assign) BOOL isVerticalVideo; //For ZF
@property (nonatomic,assign) CGFloat height;  //短视频高
@property (nonatomic,assign) CGFloat width;   //短视频宽

@property (nonatomic,assign) CGFloat shortVideoCellHeight; //根据name判断  外部高度

@property (nonatomic,assign) CGFloat shortVideoHeight;  //短视频等比例缩放后的高度
@property (nonatomic,assign) CGFloat svRecomListCellHeight;  // shortVideoHeight + 其他控件的高度

- (void)refreshModelForShortVideo;  // shortVideoRecomListCellHeight  短视频自动播放列表cell高度

@property (nonatomic,copy) NSString *keyWord;
@property (nonatomic,assign) NSInteger keyWordCount;
@property (nonatomic,copy) NSString *keyWordId;
@property (nonatomic,copy) NSString *keyWordAliasType;

//停留时长
@property (nonatomic,assign) NSInteger stayTime;

//推荐页Top排行榜, 需要记录Cell的IndexPath,显示1~10
@property (nonatomic,copy) NSString *indexForTop;

@end

@interface MineTVCellModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imgName;
@property (nonatomic,assign) BOOL isShowRedPoint;
@end

@interface SettingCellModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;
@property (nonatomic,assign) NSInteger type;  // 1无 任何sub     2subTitle    3箭头    4switch
@property (nonatomic,assign) BOOL isSwitchOn;
@property (nonatomic,assign) BOOL isSubNoti;  //设置title位置靠右一些
@end

@interface PermissionSettingCellModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,assign) BOOL isOpen;  //权限设置状态:已开启&去设置
@end

@interface ReportCellModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BOOL isSelect;
@end

@interface CategoryFilterModel : NSObject
@property (nonatomic,copy) NSString *name;
@end

//视频详情页主要数据
@interface VDCommonModel : NSObject
@property (nonatomic,copy) NSString *areas;
@property (nonatomic,copy) NSArray<DirectorsModel*> *authors;  //作者
@property (nonatomic,copy) NSArray<CategoryFilterModel*> *categoryResults;
@property (nonatomic,copy) NSArray *categoryArr; 
@property (nonatomic,copy) NSString *collected;
@property (nonatomic,copy) NSString *commentTotalCount;
@property (nonatomic,copy) NSString *copyright;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *descriptionForModel;
@property (nonatomic,copy) NSArray<DirectorsModel*> *directors;
@property (nonatomic,copy) NSArray *directorArr; //导演数组,根据directors
@property (nonatomic,copy) NSString *downMode;
@property (nonatomic,copy) NSString *finished;
@property (nonatomic,copy) NSString *idForModel;
@property (nonatomic,copy) NSArray<MediaSourceResultModel*> *mediaSourceResultList;
@property (nonatomic,copy) NSArray *mediaSourceArr; //来源数组,根据mediaSourceResultList
//add 当前的源
@property (nonatomic,copy) NSString *siCurrent;     //和indexSelect 应该是一致的
@property (nonatomic,assign) NSInteger indexSelectForSource;  //选中的播放源, mediaSourceResultList[indexSelect]  默认为0

@property (nonatomic,copy) NSString *modifyTime;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *originPoints;
@property (nonatomic,copy) NSString *pay;
@property (nonatomic,copy) NSString *playMode;
@property (nonatomic,strong) ImgModel *poster;  //海报
@property (nonatomic,copy) NSString *releaseDate;
@property (nonatomic,strong) GuideResultModel *sceneResult;
@property (nonatomic,copy) NSString *sensitive;
@property (nonatomic,copy) NSString *shareLink;
@property (nonatomic,copy) NSArray<StarsModel*> *stars;
@property (nonatomic,copy) NSArray *starsArray;  //根据stars获取
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) VideoType videoType;  //根据type

@property (nonatomic,assign) CGFloat cellHeight_Msg;
@property (nonatomic,assign) CGFloat cellHeight_Intro;
@property (nonatomic,assign) CGFloat cellHeight_Episode;
@property (nonatomic,assign) CGFloat cellHeight_GuessULike;

@property (nonatomic,assign) BOOL isShowFoldBtn;  //根据简介长短,判断是否需要显示(更多,收起)按钮
@property (nonatomic,assign) BOOL isOpen;  //默认NO,标识没Open,也就是fold状态

//根据当前选中的视频源, 请求得到视频集数dataArr  EpisodeData
@property (nonatomic, copy) NSArray<MediaTipResultModel*> *episodeDataArray;
@property (nonatomic,assign) NSInteger indexSelectForEpisode;  //标记选中的播放的剧集数, 从0开始

@property (nonatomic, copy) NSArray<ProgramResultListModel*> *likeDataArray;

@property (nonatomic,copy) NSString *programId;  //pi

@end

@interface EpisodeIntroModel : NSObject
@property (nonatomic,copy) NSString * index;
@property (nonatomic,copy) NSString * summary;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,assign) CGFloat cellHeight;
- (void)refreshData; 
@end

NS_ASSUME_NONNULL_END
