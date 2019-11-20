//
//  SettingViewController.m
//



#import "SettingViewController.h"
#import "SettingCell.h"
#import "UILabel+Category.h"
#import "NSObject+ClearCrash.h"
#import "LEEAlert.h"
#import "LCActionSheet.h"
#import <zhPopupController.h>
#import "UIButton+Category.h"
#import "KSBaseWebViewController.h"
#import <UIImageView+WebCache.h>

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray<SettingCellModel *> *dataArr;
@property (nonatomic,weak) SettingBottomLoginView *bottomLoginView;
@end

@implementation SettingViewController

static NSString * const cellID = @"SettingCell";
#define CrashNum 1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([self contentOffset]);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self loadData];
    [NOTIFICATION addObserver:self selector:@selector(refreshLoginView) name:RefreshUserMsgNoti object:nil];
}

- (void)refreshLoginView {
    [self.bottomLoginView refreshUI];
}

-(NSMutableArray<SettingCellModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];

        NSString *versionStr = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *str = [NSString stringWithFormat:@"版本信息: v%@",versionStr];

        NSArray *nameA = @[@"清除应用缓存",str];
        // 1无 任何sub     2subTitle    3箭头    4switch
        NSArray *typeA = @[@"2",@"1"];
        
        BOOL canSeeNoWifi = NO;
        if([USERDEFAULTS objectForKey:CanSeeVideoNoWifi]) {
            canSeeNoWifi = [[USERDEFAULTS objectForKey:CanSeeVideoNoWifi] boolValue];
        }else {
            [USERDEFAULTS setObject:CanSeeVideoNoWifi forKey:@"0"];
            [USERDEFAULTS synchronize];
        }
        
        for (int i = 0; i<nameA.count; i++) {
            SettingCellModel *m = [[SettingCellModel alloc]init];
            m.type = [typeA[i] integerValue];
            m.title = nameA[i];
            [_dataArr addObject:m];
        }
    }return _dataArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCell *cell = [SettingCell cellForTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:  //清缓存
        {
            WS()
            [LEEAlert alert].config
            .LeeContent(@"是否确定清除缓存？").LeeAddAction(^(LEEAction *action) {
                action.type = LEEActionTypeDefault;
                action.title = @"取消";
                action.font = Font_Size(16);
                action.titleColor = KCOLOR(@"#666666");
                action.height = 40.0f;
                action.clickBlock = ^{
                    // 点击事件Block
                }; 
            })
            .LeeAddAction(^(LEEAction *action) {
                action.type = LEEActionTypeDefault;
                action.title = @"确定";
                action.titleColor = Orange_ThemeColor;
                action.font = Font_Size(16);
                action.height = 40.0f;
                action.clickBlock = ^{
                    [weakSelf clearCatch];
                };
            })
            .LeeShow();
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.sizeH(50);
}

#pragma mark - lazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = White_Color;
        [_mainTableView registerClass:[SettingCell class] forCellReuseIdentifier:cellID];
        _mainTableView.rowHeight = self.sizeH(50);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        SettingBottomLoginView *bottomLoginView = [[SettingBottomLoginView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.sizeH(50))];
        self.bottomLoginView = bottomLoginView;
        _mainTableView.tableFooterView = self.bottomLoginView;
    }return _mainTableView;
}

-(void)loadData {
    //异步线程计算，界面不卡顿
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
    WS()
    [NSObject getFileCacheSizeWithPath:documentDirectory completion:^(NSInteger total) {
    
        NSUInteger intg = [[SDImageCache sharedImageCache] getSize]+total;
        NSString * catch ;
        if (total>1024.0&&total<1024.0*1024.0) {
            catch =  [NSString stringWithFormat:@"%.fKB",intg/1024.0];
        }else if (total>1024.0*1024.0&&total<1024.0*1024.0*1024.0){
            catch = [NSString stringWithFormat:@"%.fMB",intg/(1024.0*1024.0)];
        }else if (total>1024.0*1024.0*1024.0){
            catch = [NSString stringWithFormat:@"%.fG",intg/(1024.0*1024.0*1024.0)];
        }else{
            catch = @"0KB";
        }
        
        SettingCellModel * model = self.dataArr[CrashNum];
        model.subTitle = catch;
        [weakSelf.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:CrashNum inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

-(void)clearCatch {
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WS()
    [NSObject removeCacheWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            SettingCellModel * model = self.dataArr[CrashNum];
            model.subTitle = @"0KB";
            [weakSelf.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:CrashNum inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            SSMBToast(@"缓存清除成功", MainWindow);
        });
    }];
}

@end

@interface SettingBottomLoginView()
@property (nonatomic,strong) UILabel *loginLab;
@end

@implementation SettingBottomLoginView

//登录登出后刷新UI
- (void)refreshUI {
    self.loginLab.text = IS_LOGIN ? @"退出登录" : @"登录";
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *loginLab = [UILabel labelWithTitle:IS_LOGIN ? @"退出登录" : @"登录" font:15 textColor:KCOLOR(@"#D96139") textAlignment:1];
        [loginLab setFont:Font_Bold(15)];
        [self addSubview:loginLab];
        self.loginLab = loginLab;
        [self.loginLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LoginInOrOutAction)];
        [self addGestureRecognizer:tap];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = KCOLOR(@"#F8F8F8");
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(0.9f);
        }];
    }return self;
}

- (void)LoginInOrOutAction {
    if (IS_LOGIN) {
        SSMBToast(@"退出登录成功",MainWindow);
        [USER_MANAGER removeUserAllData];
        self.loginLab.text = @"登录";
    }else {
        [USER_MANAGER gotoLogin];
    }
}

@end
