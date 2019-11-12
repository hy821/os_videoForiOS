//
//  HomeViewController.m
//  OSMovie
//
//  Created by young He on 2019/10/30.
//  Copyright © 2019 youngHe. All rights reserved.
//

#import "HomeViewController.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "UILabel+Category.h"
#import "HomeListViewController.h"
#import "UIButton+Category.h"
#import "UIControl+recurClick.h"
#import "LoginViewController.h"

@interface HomeViewController ()<
TYTabPagerBarDataSource,
TYTabPagerBarDelegate,
TYPagerControllerDataSource,
TYPagerControllerDelegate>

@property (nonatomic,strong) HomeNavBar *topNavBar;
@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) NSMutableArray<HomeCategoryModel*> *categoryArr;
@property (nonatomic,weak) UIButton *reloadBtn;  //第一次进来, 没有网络时, 重新加载按钮

@end

@implementation HomeViewController

#define ID_HomeList @"ID_HomeList"

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray<HomeCategoryModel *> *)categoryArr {
    if(!_categoryArr) {
        _categoryArr = [NSMutableArray array];
    }return _categoryArr;
}

-(HomeNavBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[HomeNavBar alloc] init];
        WS()
        _topNavBar.loginBlock = ^{
            LoginViewController *vc = [[LoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }return _topNavBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"OS影院";
    self.view.backgroundColor = KCOLOR(@"#f8f8f8");
    self.fd_prefersNavigationBarHidden = YES;
    [self initUI];
    
    [NOTIFICATION addObserver:self selector:@selector(refreshUserMsg) name:RefreshUserMsgNoti object:nil];
}

- (void)refreshUserMsg {
    [self.topNavBar refreshMsg];
}

- (void)initUI {
    [self.view addSubview:self.topNavBar];
    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo([self statusBarHeight]+self.sizeH(49));
    }];
    [self addTabPageBar];
    [self addPagerController];
    
    [self requestData];
//    [self getPageBarCategory];
}

- (void)requestData {
    NSString *ver = @"-1";
    if([USERDEFAULTS objectForKey:HomeCategoryVer]) {
        ver = [USERDEFAULTS objectForKey:HomeCategoryVer];
    }
    
    SSGifShow(self.view, @"加载中");
    [[SSRequest request]GET:HomeCategoryUrl parameters:@{@"ver":ver} success:^(SSRequest *request, NSDictionary *response) {
        
        SSDissMissAllGifHud(self.view, NO);
        
        NSDictionary *attachedDic = response[@"attached"];
        if (attachedDic[@"version"]) {
            [USERDEFAULTS setObject:attachedDic[@"version"] forKey:HomeCategoryVer];
            [USERDEFAULTS synchronize];
        }
        
        if (response[@"data"]) {
            [USERDEFAULTS setObject:response[@"data"] forKey:HomeCategoryDic];
            [USERDEFAULTS synchronize];
        }
        
        self.categoryArr = [NSMutableArray array];
        self.categoryArr = [HomeCategoryModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        if (self.categoryArr.count==0) {
            self.reloadBtn.hidden = NO;
        }else {
            //推荐 6 //短视频 5 //电影 2 //电视剧 1 //综艺 3 //动漫 4 //游戏 7
            
            [self.categoryArr enumerateObjectsUsingBlock:^(HomeCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.categoryID isEqualToString:@"7"]) {  //游戏
                    [self.categoryArr removeObject:obj];
                }
            }];
            
            self.tabBar.layout.cellWidth = ScreenWidth/self.categoryArr.count;
            self.reloadBtn.hidden = YES;
            [self reloadData];
        }
        
    } failure:^(SSRequest *request, NSString *errorMsg) {
        SSDissMissAllGifHud(self.view, NO);
        SSMBToast(errorMsg, self.view);
        //失败的话, 查看是否有存储的, 有的话, 取出来用
        [self getPageBarCategory];
    }];
}

#pragma mark - 查看是否有存储的, 有的话, 取出来用
- (void)getPageBarCategory {
    if ([USERDEFAULTS objectForKey:HomeCategoryDic]) {
        NSDictionary *dic = [USERDEFAULTS objectForKey:HomeCategoryDic];
        self.categoryArr = [HomeCategoryModel mj_objectArrayWithKeyValuesArray:dic];
        if (self.categoryArr.count==0) {
            _reloadBtn.hidden = NO;
        }else {
            [self.categoryArr enumerateObjectsUsingBlock:^(HomeCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.categoryID isEqualToString:@"7"]) {  //游戏
                    [self.categoryArr removeObject:obj];
                }
            }];
            _tabBar.layout.cellWidth = ScreenWidth/self.categoryArr.count;
            _reloadBtn.hidden = YES;
            [self reloadData];
        }
    }else {
        _reloadBtn.hidden = NO;
    }
}

- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.backgroundColor = White_Color;
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.layout.cellWidth = ScreenWidth/3;
    tabBar.layout.cellEdging = 0;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
    [_tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topNavBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.sizeH(36));
    }];
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    //预加载左右的个数,默认0. 设置为1时,有点小问题,点击回到推荐,会重新加载
    pagerController.layout.prefetchItemCount = 0;
    pagerController.layout.prefetchItemWillAddToSuperView = YES;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [pagerController registerClass:[HomeListViewController class] forControllerWithReuseIdentifier:ID_HomeList];
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    self.pagerController = pagerController;
    
    [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIButton *reloadBtn = [UIButton buttonWithTitle:@"重新加载" titleColor:LightGray_Color bgColor:White_Color highlightedColor:LightGray_Color];
    reloadBtn.layer.masksToBounds = YES;
    reloadBtn.layer.cornerRadius = self.sizeH(20);
    reloadBtn.layer.borderColor = LightGray_Color.CGColor;
    reloadBtn.layer.borderWidth = 1.f;
    reloadBtn.uxy_acceptEventInterval = 1.f;
    [reloadBtn.titleLabel setFont:Font_Slim(15)];
    reloadBtn.hidden = YES;
    [reloadBtn addTarget:self action:@selector(reloadBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.pagerController.view addSubview:reloadBtn];
    self.reloadBtn = reloadBtn;
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.pagerController.view);
        make.width.equalTo(self.sizeW(120));
        make.height.equalTo(self.sizeH(40));
    }];
}

- (void)reloadData {
    
    [_tabBar reloadData];
    [_pagerController reloadData];
}

#pragma mark - TYTabPagerBarDataSource
- (NSInteger)numberOfItemsInPagerTabBar {
    return _categoryArr.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = _categoryArr[index].name;
    return cell;
}

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _categoryArr[index].name;
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return _categoryArr.count;
}

/* 1.viewController at index in pagerController
 2.if prefetching is YES,the controller is preload,not display.
 3.if controller will display,will call viewWillAppear.
 4.you can register && dequeue controller, usage like tableView
 */
- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching
{
    HomeListViewController *vc = [[HomeListViewController alloc]init];
    vc.model = self.categoryArr[index];
    return vc;
}

#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadBtnAction {
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2f;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.9];
    pulse.toValue= [NSNumber numberWithFloat:1.1];
    [[_reloadBtn layer] addAnimation:pulse forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.reloadBtn.hidden = YES;
        //        [g_App checkLogin];
        [self requestData];
        
    });
}

@end


@interface HomeNavBar ()
@property (nonatomic,weak) UIImageView *iconIV;
@property (nonatomic,weak) UILabel *nameLab;
@end

@implementation HomeNavBar


- (void)refreshMsg {
    self.iconIV.image = IS_LOGIN ? Image_Named([USER_MANAGER getUserIcon]) : img_placeHolderIcon;
    self.nameLab.text = IS_LOGIN ? [USER_MANAGER getUserNickName] : @"点击登录";
}

- (instancetype)init {
    if ([super init]) {
        [self initUI];
    }return self;
}

- (void)initUI {
    self.backgroundColor = White_Color;
    UILabel *lab = [UILabel labelWithTitle:@"OS影院" font:18 textColor:Black_Color textAlignment:1];
    lab.font = Font_Bold(18);
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset([self statusBarHeight]);
        make.bottom.equalTo(self);
    }];
    
    UIImageView *iconIV = [[UIImageView alloc]init];
    iconIV.userInteractionEnabled = YES;
    iconIV.layer.masksToBounds = YES;
    iconIV.contentMode = UIViewContentModeScaleAspectFill;
    if ([USER_MANAGER getUserIcon].length>0) {
        iconIV.image = Image_Named([USER_MANAGER getUserIcon]);
    }else {
        iconIV.image = img_placeHolderIcon;
    }
    [self addSubview:iconIV];
    self.iconIV = iconIV;
    self.iconIV.layer.cornerRadius = self.sizeH(15);
    self.iconIV.layer.borderColor = LightGray_Color.CGColor;
    self.iconIV.layer.borderWidth = 2;
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab);
        make.width.height.equalTo(self.sizeH(30));
        make.left.equalTo(self).offset(self.sizeW(12));
    }];
    
    UILabel *nameLab = [UILabel labelWithTitle:@"" font:12 textColor:KCOLOR(@"#181818") textAlignment:1];
    nameLab.userInteractionEnabled = YES;
    if ([USER_MANAGER getUserNickName].length>0) {
        nameLab.text = [USER_MANAGER getUserNickName];
    }else {
        nameLab.text = @"点击登录";
    }
    [self addSubview:nameLab];
    self.nameLab = nameLab;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(3);
        make.centerY.equalTo(self.iconIV);
        make.right.lessThanOrEqualTo(lab.mas_left).offset(-2);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.nameLab addGestureRecognizer:tap];
    
//    UIButton *historyBtn = [UIButton buttonWithImage:Image_Named(@"ic_history") selectedImage:Image_Named(@"ic_history")];
//    historyBtn.showsTouchWhenHighlighted = YES;
//    [historyBtn addTarget:self action:@selector(historyAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:historyBtn];
//    historyBtn = historyBtn;
//    [historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-self.sizeH(10));
//        make.centerY.equalTo(lab);
//    }];
    
    //    UIView *line = [[UIView alloc]init];
    //    line.backgroundColor = LightGray_Color; //KCOLOR(@"#F8F8F8");
    //    [self addSubview:line];
    //    [line mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.bottom.equalTo(self);
    //        make.height.equalTo(0.9f);
    //    }];
}


//- (void)historyAction {
//    if (self.historyBlock) {
//        self.historyBlock();
//    }
//}

- (void)tapAction:(UITapGestureRecognizer*)gesture {
    if (!IS_LOGIN) {
        if (self.loginBlock) {
            self.loginBlock();
        }
    }
}

@end
