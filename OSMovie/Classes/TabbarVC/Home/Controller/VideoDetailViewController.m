//
//  VideoDetailViewController.m
//  OSMovie
//

#import "VideoDetailViewController.h"
#import "UIButton+Category.h"
#import "HorizenButton.h"
#import "HJTabViewControllerPlugin_TabViewBar.h"
#import "HJDefaultTabViewBar.h"
#import "LCActionSheet.h"
#import "KSBaseWebViewController.h"
#import <zhPopupController.h>
#import "LEEAlert.h"
#import "UIControl+recurClick.h"

#import "VideoDetailMsgController.h"
#import "ReportViewController.h"
#import "ErrorReportViewController.h"
#import "UILabel+Category.h"
#import "GoWebCountDownView.h"

//#import "VideoPlayViewController.h"
//#import "ReportViewController.h"

@interface VideoDetailViewController ()<
HJTabViewControllerDataSource,
HJTabViewControllerDelagate,
HJDefaultTabViewBarDelegate,
LCActionSheetDelegate>
{
    dispatch_group_t _group;
}

@property (nonatomic,strong) NSMutableArray * vcArr;
@property (nonatomic, weak) UIImageView *topContainerView;
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UIButton *moreBtn;  //右上角

@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,copy) NSString *pi;
@property (nonatomic,copy) NSString *pt;
@property (nonatomic,assign) VideoType videoType;
//Common数据源
@property (nonatomic,strong) VDCommonModel *modelCommon;
@property (nonatomic,assign) BOOL isOff;  //请求成功但返回model为空时, 为下架
//GuessULikeData
@property (nonatomic, strong) NSMutableArray<ProgramResultListModel *> *likeDataArray;

@property (nonatomic,assign) VideoPlayType videoPlayType;
@property (nonatomic,copy) NSString *urlPlay;  //播放Url

@property (nonatomic,strong) HJDefaultTabViewBar *tabViewBar;
@property (nonatomic,strong) HJTabViewControllerPlugin_TabViewBar *tabViewBarPlugin;
@end

@implementation VideoDetailViewController

- (void)setModel:(ProgramResultListModel *)model {
    _model = model;
    self.pi = model.idForModel;
    self.pt = model.type;
    self.videoType = model.videoType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.tabDataSource = self;
    self.tabDelegate = self;
    
    HJDefaultTabViewBar *tabViewBar = [[HJDefaultTabViewBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tabViewBar.delegate = self;
    self.tabViewBar = tabViewBar;
    HJTabViewControllerPlugin_TabViewBar *tabViewBarPlugin = [[HJTabViewControllerPlugin_TabViewBar alloc] initWithTabViewBar:tabViewBar delegate:nil];
    self.tabViewBarPlugin = tabViewBarPlugin;
    [self enablePlugin:self.tabViewBarPlugin];
    
    [self initUI];
    self.tabViewBar.mj_h = 0;
    [self firstLoadWithHud:YES];
}

- (void)firstLoadWithHud:(BOOL)isShowHud {
    _group = dispatch_group_create();
    if (isShowHud) {SSGifShow(MainWindow, @"加载中");}
    
    [self loadDateWithAnimation:NO];
    [self loadYouLikeData];
    
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        if (isShowHud) {SSDissMissAllGifHud(MainWindow, YES);}
        //刷新VideoHeaderView
        [self refreshPlayerWithIsChangeEpisode:NO];
        
        //给MsgVC赋值 刷新UI
        if (self.vcArr.firstObject) {
            VideoDetailMsgController *vc = self.vcArr.firstObject;
            self.modelCommon.likeDataArray = [self.likeDataArray copy];
            [vc loadDataWithCommonModel:self.modelCommon isOff:self.isOff];
        }
    });
}

//更新播放相关: 第一次数据请求结束 or 切换剧集后
- (void)refreshPlayerWithIsChangeEpisode:(BOOL)isChange {
    if (!isChange) {  //非切换剧集
        //无数据时的占位处理
        if (self.modelCommon && self.modelCommon.videoType != VideoType_UnKnow) {
            [self layoutContainerViewWithEdgeInsets:UIEdgeInsetsMake(VDTopViewH, 0, 0, 0)];
            [self.topContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.view);
                make.height.equalTo(VDTopViewH);
            }];
        }else {
            //UIEdgeInsetsMake 在原先的rect上内切出另一个rect出来，-为变大，+为变小
            [self layoutContainerViewWithEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [self.topContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self.view);
                make.height.equalTo(0);
            }];
        }
        [self.topContainerView sd_setImageWithURL:URL(self.modelCommon.poster.url) placeholderImage:Image_Named(@"img_user_bg") options:SDWebImageRetryFailed];
    }
    
    [self upBackAndMoreBtnUI];
}

- (void)loadDateWithAnimation:(BOOL)isAnimation {
    dispatch_group_enter(_group);
    if (isAnimation) {SSGifShow(MainWindow, @"加载中");}
    NSDictionary *dic = @{@"pt" : self.pt ? self.pt : @"",@"pi" : self.pi ? self.pi : @""};
    [[SSRequest request]GET:VideoDetail_CommonUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
        self.modelCommon = [VDCommonModel mj_objectWithKeyValues:response[@"data"]];
        self.isOff = !self.modelCommon;
        self.modelCommon.programId = self.pi;
        if (self.videoType == 1 || self.videoType == 3 || self.videoType == 4) {
            if (self.modelCommon.mediaSourceResultList.count>0) {
                [self loadEpisodeDataWithSi:self.modelCommon.siCurrent];
            }else {
                dispatch_group_leave(_group);
            }
        }else {
            if (self.modelCommon.mediaSourceResultList.count>0) {
                self.modelCommon.episodeDataArray = self.modelCommon.mediaSourceResultList.firstObject.mediaTipResultList;
            }
            dispatch_group_leave(_group);
        }
        
    } failure:^(SSRequest *request, NSString *errorMsg) {
        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
        SSMBToast(errorMsg, MainWindow);
        self.isOff = NO;  //请求失败, 不是下架, 要显示网络失败
        dispatch_group_leave(_group);
    }];
}

- (void)loadYouLikeData {
    dispatch_group_enter(_group);
    NSDictionary *dic = @{@"si" : self.pt ? self.pt : @"", @"id" : self.pi ? self.pi : @"", @"size" : @(6)};
    [[SSRequest request]GET:VideoDetail_GuessULikeUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
        self.likeDataArray = [ProgramResultListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        dispatch_group_leave(_group);
    } failure:^(SSRequest *request, NSString *errorMsg) {
        SSMBToast(errorMsg, MainWindow);
        dispatch_group_leave(_group);
    }];
}

- (void)loadEpisodeDataWithSi:(NSString*)si {
    NSDictionary *dic = @{@"pt" : self.pt ? self.pt : @"",
                          @"pi" : self.pi ? self.pi : @"",
                          @"size" : @(1000),
                          @"index" : @(0),
                          @"si" : si,  //来源 默认传
    };
    [[SSRequest request]GET:VideoDetail_NumberOfEpisodeUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
        self.modelCommon.episodeDataArray = [MediaTipResultModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        dispatch_group_leave(_group);
        
    } failure:^(SSRequest *request, NSString *errorMsg) {
        SSMBToast(errorMsg, MainWindow);
        dispatch_group_leave(_group);
    }];
}

#pragma mark - 跳webView
- (void)goWebViewWithBannerUrl:(NSString *)bannerUrl {
    KSBaseWebViewController *webVC = [[KSBaseWebViewController alloc]init];
    webVC.bannerUrl = bannerUrl;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)initUI {
    UIImageView * topContainerView = [[UIImageView alloc]init];
    topContainerView.clipsToBounds = YES;
    topContainerView.contentMode = UIViewContentModeScaleAspectFill;
    topContainerView.userInteractionEnabled = YES;
    [self.view addSubview:topContainerView];
    self.topContainerView = topContainerView;
    self.topContainerView.clipsToBounds = YES;
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(VDTopViewH);
    }];
    
    UIButton *backBtn = [UIButton buttonWithImage:Image_Named(@"backWhite") selectedImage:Image_Named(@"backWhite")];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topContainerView addSubview:backBtn];
    self.backBtn = backBtn;
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContainerView).offset([self contentOffset]-44);
        make.left.equalTo(self.topContainerView).offset(self.sizeW(12));
    }];
    UIButton *moreBtn = [UIButton buttonWithImage:Image_Named(@"ic_detail_share") selectedImage:Image_Named(@"ic_detail_share")];
    [moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topContainerView addSubview:moreBtn];
    self.moreBtn = moreBtn;
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backBtn);
        make.right.equalTo(self.topContainerView).offset(self.sizeW(-12));
    }];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"playLogo"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    playBtn.uxy_acceptEventInterval = 2.f;
    [self.topContainerView addSubview:playBtn];
    self.playBtn = playBtn;
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topContainerView);
    }];
}

- (void)playAction {
    self.videoPlayType = VideoPlayType_NoSource;

    if(self.videoType==1 || self.videoType==3 || self.videoType==4) {  //综艺,动漫,电视剧
        
        MediaTipResultModel *mTip = self.modelCommon.episodeDataArray[self.modelCommon.indexSelectForEpisode];
        self.videoPlayType = VideoPlayType_WebViewPlay;
        self.urlPlay = mTip.originLink;
        
    }else if (self.videoType==VideoType_Movie) {
        
        if(self.modelCommon.mediaSourceResultList.count>0) {
            MediaSourceResultModel *mSource = self.modelCommon.mediaSourceResultList.firstObject;
            if (mSource.mediaTipResultList.count>0) {
                MediaTipResultModel *mTip = mSource.mediaTipResultList.firstObject;
                self.videoPlayType = VideoPlayType_WebViewPlay;
                self.urlPlay = mTip.originLink;
            }
        }
    }
    switch (self.videoPlayType) {
        case VideoPlayType_WebViewPlay:
        {
            if (self.urlPlay.length>0) {
                [self showCountDownViewWithType:VideoPlayType_WebViewPlay];
            }else {
                SSMBToast(@"暂无播放源", MainWindow);
            }
        }
            break;
        case VideoPlayType_NoSource:
        {
            SSMBToast(@"暂无播放源", MainWindow);
        }
            break;
        default:
        {
            SSMBToast(@"暂无播放源", MainWindow);
        }
            break;
    }
}

- (void)showCountDownViewWithType:(VideoPlayType)type {
    NSString *tip = @"秒后跳转为您播放";
    if (self.modelCommon.videoType != VideoType_Short) { //长片
        tip = [NSString stringWithFormat:@"秒后跳转到%@为您播放",self.modelCommon.mediaSourceArr[self.modelCommon.indexSelectForSource]];
    }
    
    GoWebCountDownView * tool = [[GoWebCountDownView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/1.5, ScreenWidth/3.5) TitleName:tip AndCount:3];
    tool.layer.cornerRadius = self.sizeH(8);
    tool.layer.masksToBounds = YES;
    WS()
    tool.closeBlock = ^{
        [weakSelf.zh_popupController dismissWithDuration:0.3 springAnimated:NO];
    };
    tool.goWebBlock = ^{
        [weakSelf.zh_popupController dismissWithDuration:0.2 springAnimated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf goWebViewWithBannerUrl:weakSelf.urlPlay];
        });
    };
    
    weakSelf.zh_popupController = [zhPopupController new];
    weakSelf.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    weakSelf.zh_popupController.dismissOnMaskTouched = NO;
    [weakSelf.zh_popupController presentContentView:tool];
}

-(NSMutableArray  *)vcArr {
    if(_vcArr == nil) {
        _vcArr = @[].mutableCopy;
        VideoDetailMsgController * other = [[VideoDetailMsgController alloc]initWithStyle:UITableViewStyleGrouped];
        WS()
        other.loadDataBlock = ^{
            [weakSelf firstLoadWithHud:YES];
        };
        //切换数据源
        other.updateDataWhenChangeSourceBlock = ^(VDCommonModel *model) {
            weakSelf.modelCommon = model;
        };
        //切换剧集, 只有有剧集的长片才会切换剧集, 所以直接播放
        other.changeEpisodeBlock = ^(VDCommonModel *model) {
            weakSelf.modelCommon = model;
            [weakSelf refreshPlayerWithIsChangeEpisode:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf playAction];
            });
        };
        //点击 更多精彩, 刷新本页
        other.refreshNewVideoBlock = ^(ProgramResultListModel *model) {
            weakSelf.model = model;
            [weakSelf firstLoadWithHud:YES];
        };
        other.playBlock = ^{
            [weakSelf playAction];
        };
        
        [_vcArr addObjectsFromArray:@[other]];
    }return _vcArr;
}

#pragma mark - HJDefaultTabViewBarDelegate
- (NSInteger)numberOfTabForTabViewBar:(HJDefaultTabViewBar *)tabViewBar {
    return [self numberOfViewControllerForTabViewController:self];
}

- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return self.vcArr.count;
}

- (id)tabViewBar:(HJDefaultTabViewBar *)tabViewBar titleForIndex:(NSInteger)index {
    return @"";
}

- (void)tabViewBar:(HJDefaultTabViewBar *)tabViewBar didSelectIndex:(NSInteger)index {
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    return  self.vcArr[index];
}

- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
    return UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame), 0, 0, 0);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    SSLog(@"  VideoDetailViewController  视频详情页Dealloc, timer销毁, 关闭数据库");
}

- (void)upBackAndMoreBtnUI {
    [self.topContainerView bringSubviewToFront:self.backBtn];
    [self.topContainerView bringSubviewToFront:self.moreBtn];
}

- (NSMutableArray<ProgramResultListModel *> *)likeDataArray {
    if (!_likeDataArray) {
        _likeDataArray = [NSMutableArray array];
    }return _likeDataArray;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreAction {
    ProgramResultListModel *m = [[ProgramResultListModel alloc]init];
    m.name = self.modelCommon.name;
    m.shareLink = self.modelCommon.shareLink;
    m.poster = self.modelCommon.poster;
    [self showMoreShareViewWithModel:m];
}

- (void)showMoreShareViewWithModel:(ProgramResultListModel *)model {
    //    __block KSBaseViewController *vc = (KSBaseViewController *)SelectVC.childViewControllers.lastObject;
    //    vc.zh_popupController = [zhPopupController new];
    //    vc.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    //    vc.zh_popupController.dismissOnMaskTouched = YES;
    //
    //    BOOL isShortVideo = (self.modelCommon.videoType == VideoType_Short);
    //    NSInteger lineNum = [USER_MANAGER getShareNumBeforeShowShareViewWithNotInterest:isShortVideo];
    //    CGFloat toolHeight = self.sizeH(90*lineNum+50);
    //    ShortVideoShareView * tool =  [[ShortVideoShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, toolHeight) andModel:model andIsFromShort:isShortVideo];
    //    vc.zh_popupController.popupView.layer.mask = tool.layer.mask;
    //    __weak typeof(vc) weakVC = vc;
    //    tool.dissmissBlock = ^{
    //        [weakVC.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
    //    };
    //
    //    WS()
    //    tool.dissmissAndPushBlock = ^(NSInteger type) {
    //        [weakVC.zh_popupController dismiss];
    //        switch (type) {
    //            case 1001:
    //            {
    //                [weakSelf goReportVC];
    //            }
    //                break;
    //            case 1002:
    //            {
    //                [weakSelf goErrorReportVC];
    //            }
    //                break;
    //            default:
    //                break;
    //        }
    //    };
    //    [vc.zh_popupController presentContentView:tool];
}

- (void)goReportVC {
    ReportViewController *vc = [[ReportViewController alloc]init];
    vc.model = self.modelCommon;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goErrorReportVC {
    ErrorReportViewController *vc = [[ErrorReportViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end


