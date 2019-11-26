//
//  MineViewController.m
//  OSMovie
//
//    Created by Rb_Developer on 2019/10/30.

//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "MineTableViewHeaderView.h"
#import "MineSectionHeaderView.h"
#import "CollectViewController.h"
#import "ErrorReportViewController.h"
#import "OOSBaseWebViewController.h"
#import "LoginViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, copy) NSMutableArray<MineTVCellModel*> *dataArray;
@property (nonatomic, weak) MineTableViewHeaderView *headerView;
@end

@implementation MineViewController

static NSString * const cellID = @"MineTableViewCell";
static NSString * const cellHeader_ID = @"cellHeader_ID";

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:5];
        NSArray *nameArr = @[@"我的收藏",@"意见反馈"];
        NSArray *imgNameArr = @[@"ic_collect_mine",@"ic_advice"];
        for (int i = 0; i<nameArr.count; i++) {
            MineTVCellModel *m = [[MineTVCellModel alloc]init];
            m.imgName = imgNameArr[i];
            m.title = nameArr[i];
            [_dataArray addObject:m];
        }
    }return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self createUI];
    [NOTIFICATION addObserver:self selector:@selector(refreshUserMsg) name:RefreshUserMsgNoti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)refreshUserMsg {
    [self.headerView refresh];
}

- (void)createUI {
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MineSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellHeader_ID];
    if(!header) {
        header = [[MineSectionHeaderView alloc] initWithReuseIdentifier:cellHeader_ID];
    }
    header.model = self.dataArray[section];
    header.section = section;
    WS()
    header.tapBlock = ^(NSInteger section) {
        switch (section) {
            case 0:  //我的收藏
            {
                CollectViewController *vc = [[CollectViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
          
            case 1: //意见反馈
            {
                ErrorReportViewController *vc = [[ErrorReportViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2: //QQ粉丝群
            {
                OOSBaseWebViewController *webView = [[OOSBaseWebViewController alloc]init];
                webView.webType = WKType;
                webView.isHaveInteration = YES;
                webView.titleStr = @"影视部落交流群";
                webView.bannerUrl = @"https://www.baidu.com";
                //[USER_MANAGER isDevStatus] ? SSStr(DevServerURL_H5, QQFansH5_Url) : SSStr(ServerURL_H5, QQFansH5_Url);
                webView.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:webView animated:YES];
            }
                break;
            default:
                break;
        }
    };
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.sizeH(50);
}

#pragma mark - lazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.bounces = NO;
        _mainTableView.backgroundColor = White_Color;
        [_mainTableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:cellID];
        [_mainTableView registerClass:[MineSectionHeaderView class] forHeaderFooterViewReuseIdentifier:cellHeader_ID];
        _mainTableView.rowHeight = self.sizeH(60);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MineTableViewHeaderView *headerView = [[MineTableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.sizeH(230))];
        self.headerView = headerView;
        WS()
        headerView.modifyMsgBlock = ^{
            if (!IS_LOGIN) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else {
            }
        };
        _mainTableView.tableHeaderView = self.headerView;
    }return _mainTableView;
}

@end
