//
//  ErrorReportViewController.m
//


#import "ErrorReportViewController.h"
#import "ErrorReportCell.h"
#import "UIButton+Category.h"
#import "OOSBaseWebViewController.h"
#import "PubTextView.h"
#import "UILabel+Category.h"

@interface ErrorReportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray<ReportCellModel*> *selVideoErrorArr;  //视频问题 Section==0
@property (strong, nonatomic) NSMutableArray<ReportCellModel*> *selAppErrorArr;  //App问题 Section==1
@property (nonatomic,weak) ErrorReportBottomView *bottomView;

@end

@implementation ErrorReportViewController

static NSString * const ErrorReportVideoFooter_ID = @"ErrorReportVideoFooter_ID";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([self contentOffset]);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ErrorReportCell *cell = [ErrorReportCell cellForTableView:tableView];
    NSArray *arr = self.dataArr[indexPath.section];
    ReportCellModel *m = arr[indexPath.row];
    cell.model = m;
    WS()
    cell.selectBlock = ^(BOOL isSel) {
        [weakSelf selectWithIndexPath:indexPath andIsSel:isSel];
    };
    return cell;
}

- (void)selectWithIndexPath:(NSIndexPath *)indexPath andIsSel:(BOOL)isSel{
    BOOL isReload = (self.selVideoErrorArr.count==0);
    
    NSArray *arr = self.dataArr[indexPath.section];
    ReportCellModel *m = [arr objectAtIndex:indexPath.row];
    m.isSelect = isSel;
    if (indexPath.section==0) {
        if (isSel) {
            [self.selVideoErrorArr addObject:m];
            if(self.selVideoErrorArr.count>0 && isReload) {
                [self.mainTableView reloadData];
            }
        }else {
            [self.selVideoErrorArr removeObject:m];
            if(self.selVideoErrorArr.count==0) {
                [self.mainTableView reloadData];
            }
        }
    }else if (indexPath.section==1) {
        if (isSel) {
            [self.selAppErrorArr addObject:m];
        }else {
            [self.selAppErrorArr removeObject:m];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc]init];
    header.backgroundColor = White_Color;
    UILabel *lab = [UILabel labelWithTitle:(section == 0) ? @"视频问题反馈" : @"App问题反馈" font:15 textColor:Black_Color textAlignment:0];
    [header addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header);
        make.left.equalTo(header).offset(self.sizeW(12));
        make.top.bottom.equalTo(header);
    }];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.sizeH(40);
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
        NSArray *arr = @[@"1，视频无法播放;",@"2，视频内容、字幕、剧集缺失;",@"3，视频播放异常、有声音无画面、声画不同步等;"];
        
        NSMutableArray *arrModel = [NSMutableArray array];
        for (int i = 0; i < arr.count; ++i) {
            ReportCellModel *m = [[ReportCellModel alloc]init];
            m.title = arr[i];
            m.isSelect = NO;
            [arrModel addObject:m];
        }
        [_dataArr addObject:arrModel];
        
        NSArray *arr2 = @[@"1，图片、页面加载失败;",@"2，闪退卡顿，程序出错;"];
        NSMutableArray *arrModel2 = [NSMutableArray array];
        for (int i = 0; i < arr2.count; ++i) {
            ReportCellModel *m = [[ReportCellModel alloc]init];
            m.title = arr2[i];
            m.isSelect = NO;
            [arrModel2 addObject:m];
        }
        [_dataArr addObject:arrModel2];
        
    } return _dataArr;
}

#pragma mark - lazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = White_Color;
        _mainTableView.rowHeight = self.sizeH(50);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        ErrorReportBottomView *bottomView = [[ErrorReportBottomView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.sizeH(200+20 + 50))];
        _mainTableView.tableFooterView = bottomView;
        self.bottomView = bottomView;
        WS()
        self.bottomView.sendBlock = ^(NSString *textSend) {
            [weakSelf sendActionWithText:textSend];
        };
    }return _mainTableView;
}

- (void)sendActionWithText:(NSString*)str {
    if (!IS_LOGIN) {
        [USER_MANAGER gotoLogin];
        return;
    }
    if (str.length==0 && self.selVideoErrorArr.count == 0 && self.selAppErrorArr.count == 0) {
        SSMBToast(@"请选择或输入要反馈的内容", MainWindow);
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SSMBToast(@"反馈成功", MainWindow);
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (NSMutableArray<ReportCellModel *> *)selVideoErrorArr {
    if (!_selVideoErrorArr) {
        _selVideoErrorArr = [NSMutableArray array];
    }return _selVideoErrorArr;
}

- (NSMutableArray<ReportCellModel *> *)selAppErrorArr {
    if (!_selAppErrorArr) {
        _selAppErrorArr = [NSMutableArray array];
    }return _selAppErrorArr;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


@interface ErrorReportBottomView()
@property (nonatomic,weak) PubTextView *textView;
@property (nonatomic,weak) UIButton *qqFansBtn;
@property (nonatomic,weak) UIButton *reportBtn;
@end

@implementation ErrorReportBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        [self createUI];
    }return self;
}

- (void)createUI {
    UILabel *lab = [UILabel labelWithTitle:@"其他问题反馈" font:15 textColor:Black_Color textAlignment:0];
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.sizeW(12));
        make.height.equalTo(self.sizeH(40));
        make.top.equalTo(self);
    }];
    
    PubTextView *textView = [[PubTextView alloc]init];
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = KCOLOR(@"#F7F7F7").CGColor;
    textView.font = Font_Size(15);
    textView.textColor = Black_Color;
    textView.backgroundColor = White_Color;
    textView.placeTextFont = Font_Size(15);
    textView.placeTextColor = LightGray_Color;
    textView.placeText = @"请描述问题的具体场景, 便于我们更好地为您解决问题~";
    [self addSubview:textView];
    self.textView = textView;
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom);
        make.left.equalTo(self).offset(self.sizeW(12));
        make.right.equalTo(self).offset(self.sizeW(-12));
        make.height.equalTo(self.sizeH(130));
    }];
    
    UIButton *reportBtn = [UIButton buttonWithTitle:@"提交" titleColor:White_Color bgColor:ThemeColor highlightedColor:White_Color];
    [reportBtn.titleLabel setFont:Font_Size(16)];
    [reportBtn addTarget:self action:@selector(reportAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reportBtn];
    self.reportBtn = reportBtn;
    self.reportBtn.layer.cornerRadius = self.sizeH(20);
    self.reportBtn.layer.masksToBounds = YES;
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(self.sizeH(10));
        make.centerX.equalTo(self);
        make.height.equalTo(self.sizeH(40));
        make.width.equalTo(self.sizeW(160));
    }];
    
}

- (void)reportAction {
    if (self.sendBlock) {
        self.sendBlock(self.textView.text);
    }
}

@end
