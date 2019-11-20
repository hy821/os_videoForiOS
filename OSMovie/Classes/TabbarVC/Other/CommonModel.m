//
//  CommonModel.m
//  OSMovie
//
//    Created by Rb on 2019/10/30.

//

#import "CommonModel.h"

@implementation CommonModel

@end

@implementation HomeCategoryModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"categoryID" : @"id"};
}
@end

@implementation ImgModel

- (void)setUrl:(NSString *)url {
    _url = url;
    if (url.length==0) {
        _url = self.src;
    }
}

- (void)setSrc:(NSString *)src {
    _src = src;
    if (!_url) {
        _url = src;
    }else if (_url.length==0) {
        _url = src;
    }
}

@end

@implementation StarsModel
@end

//DirectorsModel  // AuthorsModel
@implementation DirectorsModel

@end

@implementation ProgramResultListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"descriptionForModel" : @"description",@"idForModel" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"directors" : @"DirectorsModel",@"stars" : @"StarsModel",@"authors":@"DirectorsModel"};
}
- (void)setType:(NSString *)type {
    _type = type;
    _videoType = VideoType_UnKnow;
    switch ([type integerValue]) {
        case 1:
            self.videoType = VideoType_TV;
            break;
        case 2:
            self.videoType = VideoType_Movie;
            break;
        case 3:
            self.videoType = VideoType_Variety;
            break;
        case 4:
            self.videoType = VideoType_Anime;
            break;
        case 5:
            self.videoType = VideoType_Short;
            break;
        default:
            break;
    }
}

- (void)setDirectors:(NSArray<DirectorsModel *> *)directors {
    _directors = directors;
    if (directors.count>0) {
        NSMutableArray *arr = [NSMutableArray array];
        [directors enumerateObjectsUsingBlock:^(DirectorsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject:obj.name];
        }];
        _directorArray = [arr copy];
    }else {
        _directorArray = [NSArray array];
    }
}

- (void)setStars:(NSArray<StarsModel *> *)stars {
    _stars = stars;
    if (stars.count>0) {
        NSMutableArray *arr = [NSMutableArray array];
        [stars enumerateObjectsUsingBlock:^(StarsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject:obj.name];
        }];
        _starsArray = [arr copy];
    }else {
        _starsArray = [NSArray array];
    }
}

- (void)setName:(NSString *)name {
    _name = name;
    
    if ([name containsString:@"<1>"] || [name containsString:@"</1>"]) {
        name = [name stringByReplacingOccurrencesOfString:@"<1>" withString:@""];
        _name = [name stringByReplacingOccurrencesOfString:@"</1>" withString:@""];
    }
    
    CGFloat videoHeight = ScreenWidth*13/24;
    
    CGFloat titleHeight = [Helper heightOfString:_name font:Font_Size(14) width:(ScreenWidth-self.sizeW(90))];
    if(titleHeight>self.sizeH(20)) {  //2行
//        if (titleHeight>self.sizeH(34)) { //大于2行的, 控制在2行内
//            titleHeight = self.sizeH(34);
//        }
        _shortVideoCellHeight = videoHeight + self.sizeH(75);
    }else {  //1行
        _shortVideoCellHeight = videoHeight + self.sizeH(65);
    }
}

- (void)setPlayPageCount:(NSString *)playPageCount {
    _playPageCount = playPageCount;
    if ([playPageCount integerValue]) {
        if ([playPageCount integerValue] > 9999) {
            _playPageCount = [NSString stringWithFormat:@" · %.1fw次播放",[playPageCount integerValue]/10000.0];
        }else {
            _playPageCount = [NSString stringWithFormat:@" · %ld次播放",(long)[playPageCount integerValue]];
        }
    }else {
        NSInteger ran = 3000 + arc4random()%10000;
        if (ran > 9999) {
            _playPageCount = [NSString stringWithFormat:@" · %.1fw次播放",ran/10000.0];
        }else {
            _playPageCount = [NSString stringWithFormat:@" · %ld次播放",(long)ran];
        }
    }
}

//短视频自动播放列表cell高度  shortVideoRecomListCellHeight
- (void)refreshModelForShortVideo {
    
    //根据 height width 以及 name 等
    CGFloat minVideoHeight = (ScreenWidth-self.sizeW(20))*585/1008;
    CGFloat maxVideoHeight = ScreenHeight*0.6;
    
    CGFloat topIconHeight = self.sizeH(38+10+10);
    CGFloat bottomToolHeight = self.sizeH(30+15+15);
    
    CGFloat titleHeight = [Helper heightOfString:self.name font:Font_Size(17) width:(ScreenWidth-self.sizeW(20))];
    titleHeight = titleHeight + self.sizeH(20);
    
    if (self.height>0 && self.width>0) {
        CGFloat ratio = self.width/self.height;
        _shortVideoHeight = ScreenWidth/ratio;
        if (_shortVideoHeight<minVideoHeight) {
            _shortVideoHeight = minVideoHeight;
        }else if (_shortVideoHeight>maxVideoHeight){
            _shortVideoHeight = maxVideoHeight;
        }
        
        _svRecomListCellHeight = titleHeight + _shortVideoHeight + topIconHeight + bottomToolHeight;
        
    }else {
        _shortVideoHeight = minVideoHeight;
        _svRecomListCellHeight = titleHeight + _shortVideoHeight + topIconHeight + bottomToolHeight;
        
        _height = _shortVideoHeight;
        _width = ScreenWidth;
    }
    
    //realUrl--->url
    NSString *URLString = [self.realUrl ? self.realUrl : @"" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    self.urlFromRealUrl = [NSURL URLWithString:URLString];
}

- (BOOL)isVerticalVideo {
    return _width < _height;
}
@end

@implementation GuideResultModel
@end

@implementation SecretInfoModel
@end

@implementation MediaTipResultModel
@end

@implementation MediaSourceResultModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idForModel" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"mediaTipResultList" : @"MediaTipResultModel"
             };
}

- (void)setMediaTipResultList:(NSArray<MediaTipResultModel *> *)mediaTipResultList {
    _mediaTipResultList = mediaTipResultList;
    if (mediaTipResultList.count>0) {
        [mediaTipResultList enumerateObjectsUsingBlock:^(MediaTipResultModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.index = String_Integer(idx+1);
            obj.isSelect = (idx==0);
        }];
        //        _indexSelect = 0;
    }
}

@end

@implementation MediaResultModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"mediaSourceResultList" : @"MediaSourceResultModel"};
}
@end

@implementation MineTVCellModel
@end

@implementation SettingCellModel
@end

@implementation PermissionSettingCellModel
@end

@implementation ReportCellModel
@end

@implementation VDCommonModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"descriptionForModel" : @"description",
             @"idForModel" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"authors" : @"DirectorsModel",
             @"directors" : @"DirectorsModel",
             @"stars" : @"StarsModel",
             @"mediaSourceResultList" : @"MediaSourceResultModel",
             @"categoryResults" : @"CategoryFilterModel"
             };
}

- (void)setType:(NSString *)type {
    _type = type;
    NSString *des = [NSString stringWithFormat:@"简介:%@",_descriptionForModel];
    CGFloat hForIntro = [Helper heightOfString:des font:Font_Size(13) width:ScreenWidth-self.sizeW(24)];
    _isShowFoldBtn = hForIntro > self.sizeH(35);
    _isOpen = NO;
    _videoType = VideoType_UnKnow;
    
    CGFloat guessItemH = ((ScreenWidth-2*self.sizeW(3)-2*self.sizeW(10))/3)*155/110 + self.sizeH(50);
    CGFloat shortGuessItemH = ((ScreenWidth-self.sizeW(3)*2-2*self.sizeW(10))/3)*80/123 + self.sizeH(45);
        
    switch ([type integerValue]) {
        case 1:
        {
            self.videoType = VideoType_TV;
            self.cellHeight_Msg = self.sizeH(223);
            self.cellHeight_Intro = _isShowFoldBtn ? (self.sizeH(87) + hForIntro) : (self.sizeH(57) + hForIntro);
            self.cellHeight_Episode = self.sizeH(60+35);
            self.cellHeight_GuessULike = self.sizeH(70)+guessItemH*2;
        }
            break;
        case 2:
        {
            self.videoType = VideoType_Movie;
            self.cellHeight_Msg = self.sizeH(223);
            self.cellHeight_Intro = _isShowFoldBtn ? (self.sizeH(87) + hForIntro + self.sizeH(10)) : (self.sizeH(57) + hForIntro + self.sizeH(10));
            self.cellHeight_Episode = 0;
            self.cellHeight_GuessULike = self.sizeH(70)+guessItemH*2;
        }
            break;
        case 3:
        {
            self.videoType = VideoType_Variety;
            self.cellHeight_Msg = self.sizeH(223);
            self.cellHeight_Intro = _isShowFoldBtn ? (self.sizeH(87) + hForIntro) : (self.sizeH(57) + hForIntro);
            self.cellHeight_Episode = self.sizeH(60+120);
            self.cellHeight_GuessULike = self.sizeH(70)+guessItemH*2;
        }
            break;
        case 4:
        {
            self.videoType = VideoType_Anime;
            self.cellHeight_Msg = self.sizeH(223);
            self.cellHeight_Intro = _isShowFoldBtn ? (self.sizeH(87) + hForIntro) : (self.sizeH(57) + hForIntro);
            self.cellHeight_Episode = self.sizeH(60+35);
            self.cellHeight_GuessULike = self.sizeH(70)+guessItemH*2;
        }
            break;
        case 5:
        {
            self.videoType = VideoType_Short;
            CGFloat hForTitle = [Helper heightOfString:_name font:Font_Size(20) width:ScreenWidth-self.sizeW(24)];
            self.cellHeight_Msg = self.sizeH(88)+hForTitle;
            self.cellHeight_Intro = 0;
            self.cellHeight_Episode = 0;
            self.cellHeight_GuessULike = self.sizeH(77)+shortGuessItemH*2;
        }
            break;
        default:
            break;
    }
    
    //无播放源,剧集高度 调整
    if (self.mediaSourceResultList.count==0) {
        switch ([self.type integerValue]) {
                   case 1:
                   case 3:
                   case 4:
                   {
                       self.cellHeight_Episode = self.sizeH(60);
                   }
                       break;
                   default:
                       break;
               }
    }
}

- (void)setCategoryResults:(NSArray<CategoryFilterModel *> *)categoryResults {
    _categoryResults = categoryResults;
    if (categoryResults.count>0) {
        NSMutableArray *arr = [NSMutableArray array];
        [_categoryResults enumerateObjectsUsingBlock:^(CategoryFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.name.length>0) {[arr addObject:obj.name];}
        }];
        _categoryArr = [arr copy];
    }else {
        _categoryArr = [NSArray array];
    }
}

- (void)setDirectors:(NSArray<DirectorsModel *> *)directors {
    _directors = directors;
    if (directors.count>0) {
        NSMutableArray *arr = [NSMutableArray array];
        [_directors enumerateObjectsUsingBlock:^(DirectorsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.name.length>0) {
                [arr addObject:obj.name];
            }
        }];
        _directorArr = [arr copy];
    }else {
        _directorArr = [NSArray array];
    }
}

- (void)setStars:(NSArray<StarsModel *> *)stars {
    _stars = stars;
    if (stars.count>0) {
        NSMutableArray *arr = [NSMutableArray array];
        [stars enumerateObjectsUsingBlock:^(StarsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject:obj.name];
        }];
        _starsArray = [arr copy];
    }else {
        _starsArray = [NSArray array];
    }
}

- (void)setMediaSourceResultList:(NSArray<MediaSourceResultModel *> *)mediaSourceResultList {
    _mediaSourceResultList = mediaSourceResultList;
    if (mediaSourceResultList.count>0) {
        NSMutableArray *arr = [NSMutableArray array];
        [mediaSourceResultList enumerateObjectsUsingBlock:^(MediaSourceResultModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject:obj.name];
        }];
        _mediaSourceArr = [arr copy];
        _siCurrent = mediaSourceResultList.firstObject.idForModel;
        _indexSelectForSource = 0;
    }else {
        _mediaSourceArr = [NSArray array];
        _siCurrent = @"";
        
        //无播放源时, 剧集 高度调整
        switch ([self.type integerValue]) {
            case 1:
            case 3:
            case 4:
            {
                self.cellHeight_Episode = self.sizeH(60);
            }
                break;
            default:
                break;
        }
    }
}

- (void)setEpisodeDataArray:(NSArray<MediaTipResultModel *> *)episodeDataArray {
    _episodeDataArray = episodeDataArray;
    switch ([_type integerValue]) {
        case 1:
        case 4:
        {
            self.cellHeight_Episode = episodeDataArray.count>0 ? self.sizeH(60+35) : self.sizeH(60);
        }
            break;
        case 3:
        {
            self.cellHeight_Episode = episodeDataArray.count>0 ? self.sizeH(60+120) : self.sizeH(60);
        }
            break;
        default:
            break;
    }
    [episodeDataArray enumerateObjectsUsingBlock:^(MediaTipResultModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.index = String_Integer(idx+1);
        obj.isSelect = (idx == 0);
        obj.saveTime = 0;
    }];
    _indexSelectForEpisode = 0;
}

@end

@implementation EpisodeIntroModel : NSObject
- (void)refreshData {
    CGFloat titleHeightName = [Helper heightOfString:_title font:Font_Size(12) width:(ScreenWidth-self.sizeW(24))];
    CGFloat titleHeightSub = [Helper heightOfString:_summary font:Font_Size(12) width:(ScreenWidth-self.sizeW(24))];
    _cellHeight = titleHeightName + self.sizeH(20) + titleHeightSub;
}
@end
