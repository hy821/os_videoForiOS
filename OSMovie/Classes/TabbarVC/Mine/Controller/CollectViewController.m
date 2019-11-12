//
//  CollectViewController.m
//



#import "CollectViewController.h"
#import "UIButton+Category.h"
#import "CollectAndHistoryCell.h"
#import "VideoDetailViewController.h"
#import "MYHRocketHeader.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic,weak) UIView *bottomView;
@property (nonatomic,weak) UIButton *navEditBtn;
@property (nonatomic,weak) UIButton *selectedBtn;
@property (nonatomic,weak) UIButton *deleteBtn;

@property (strong, nonatomic) NSMutableArray<ProgramResultListModel*> *dataArr;
@property (strong, nonatomic) NSMutableArray<ProgramResultListModel*> *deleteArr;
@property (assign, nonatomic) NSInteger deleteNum;

@property (nonatomic,copy) NSString *cursor; //-1 or liastObject.cursor

@end

@implementation CollectViewController

static NSString * const cellID = @"CollectAndHistoryCell";

#define BottomViewH self.sizeH(50)

- (NSMutableArray<ProgramResultListModel*>*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏";
    self.deleteArr = [NSMutableArray array];
    self.navEditBtn = [self setNavWithTitle:@"编辑" Font:14 andTextColor:@"#4A4A4A" andIsLeft:NO andTarget:self andAction:@selector(editAction:)];
    [self.navEditBtn setTitle:@"取消" forState:UIControlStateSelected];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([self contentOffset]);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
    }];
    [self initBottomView];
    
    self.cursor = @"-1";
//    [self loadDateWithAnimation:YES];
    
}

- (void)loadDateWithAnimation:(BOOL)isAnimation {
    if (isAnimation) {
        SSGifShow(MainWindow, @"加载中");
    }
    NSDictionary *dic = @{
                          @"cursor" : self.cursor,
                          @"size" : @(PageCount_Normal)
                          };
    [[SSRequest request]GET:MyCollectionListUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
        
        if (isAnimation) {
            SSDissMissAllGifHud(MainWindow, YES);
        }
        
        self.isNetError = SSNetNormal_state;
        [self.mainTableView.mj_header endRefreshing];
        
        if([self.cursor isEqualToString:@"-1"] && (self.dataArr.count>0)) {
            [self.dataArr removeAllObjects];
        }
        
        NSArray *arr = [ProgramResultListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        
        [self.dataArr addObjectsFromArray:arr];
        
        if (arr.count == 0) {
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.mainTableView.mj_footer endRefreshing];
        }
        
        [self.mainTableView reloadData];
        
    } failure:^(SSRequest *request, NSString *errorMsg) {
        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
        SSMBToast(errorMsg, MainWindow);
        self.isNetError = SSNetError_state;
        [self.mainTableView reloadData];
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
    }];
}

- (void)getCollectionMsg {
    
}

- (void)initBottomView {
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(BottomViewH);
        make.top.equalTo(self.view.mas_bottom);
    }];
    
    UIView *middleLine = [[UIView alloc]init];
    middleLine.backgroundColor = KCOLOR(@"#EEEDED");
    [self.bottomView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(10);
        make.bottom.equalTo(self.bottomView).offset(-10);
        make.centerX.equalTo(self.bottomView);
        make.width.equalTo(1);
    }];
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = KCOLOR(@"#EEEDED");
    [self.bottomView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.bottomView);
        make.height.equalTo(1);
    }];
    
    //    全选
    UIButton *selectedBtn = [UIButton buttonWithTitle:@"全选" titleColor:KCOLOR(@"#4A4A4A") bgColor:White_Color highlightedColor:KCOLOR(@"#4A4A4A")];
    [self.bottomView addSubview:selectedBtn];
    [selectedBtn setTitle:@"取消全选" forState:UIControlStateSelected];
    [selectedBtn addTarget:self action:@selector(selectedBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.selectedBtn = selectedBtn;
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self.bottomView);
        make.right.equalTo(middleLine.mas_left);
    }];
    
    //    删除
    UIButton *deleteBtn = [UIButton buttonWithTitle:@"删除" titleColor:KCOLOR(@"#FF5C3E") bgColor:White_Color highlightedColor:KCOLOR(@"#FF5C3E")];
    [self.bottomView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    [deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.bottomView);
        make.left.equalTo(middleLine.mas_right);
    }];
    
    [self.bottomView bringSubviewToFront:topLine];
}

#pragma mark - 编辑
- (void)editAction:(UIButton*)sender {
    if (sender.selected) {  //取消编辑
        sender.selected = NO;
        [self.mainTableView setEditing:NO animated:YES];
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(BottomViewH);
            make.top.equalTo(self.view.mas_bottom);
        }];
        [self.mainTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset([self contentOffset]);
            make.left.right.bottom.equalTo(self.view);
        }];
    }else { //进入编辑状态
        sender.selected = YES;
        [self.mainTableView setEditing:YES animated:YES];
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(BottomViewH);
            make.bottom.equalTo(self.view);
        }];
        [self.mainTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset([self contentOffset]);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-BottomViewH);
        }];
        
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 全选or取消全选
- (void)selectedBtnAction {
    if (!self.selectedBtn.selected) {
        self.selectedBtn.selected = YES;
        for (int i = 0; i < self.dataArr.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        }
        [self.deleteArr addObjectsFromArray:self.dataArr];
        self.deleteNum = self.dataArr.count;
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.deleteNum] forState:UIControlStateNormal];
    }else{
        self.selectedBtn.selected = NO;
        [self.deleteArr removeAllObjects];
        for (int i = 0; i < self.dataArr.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.mainTableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        self.deleteNum = 0;
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.deleteNum] forState:UIControlStateNormal];
    }
}

#pragma mark - 删除
- (void)deleteBtnAction {
    if (self.mainTableView.editing) {
        //删除
        [self.dataArr removeObjectsInArray:self.deleteArr];
        [self.mainTableView reloadData];
        self.deleteNum = 0;
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.deleteNum] forState:UIControlStateNormal];
        self.selectedBtn.selected = NO;
        //收起BottomView
        [self editAction:self.navEditBtn];
        
        if (self.deleteArr.count>0) {
            NSMutableArray *parArr = [NSMutableArray array];
            [self.deleteArr enumerateObjectsUsingBlock:^(ProgramResultListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = @{@"assetType" : obj.type,
                                          @"programId" : obj.idForModel
                                      };
                [parArr addObject:dic];
            }];
            
            //   ignore
            [[SSRequest request]POST:DeleteCollectionListUrl parameters:parArr success:^(SSRequest *request, id response) {
                
            } failure:^(SSRequest *request, NSString *errorMsg) {
                SSMBToast(errorMsg, MainWindow);
                
            }];
            
        }
        
    }
}

#pragma mark - 全选按钮被点击
- (void)selectedBtnClick {
    if (!self.selectedBtn.selected) {
        self.selectedBtn.selected = YES;
        
        for (int i = 0; i < self.dataArr.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        }
        [self.deleteArr addObjectsFromArray:self.dataArr];
        self.deleteNum = self.dataArr.count;
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.deleteNum] forState:UIControlStateNormal];
    }else{
        self.selectedBtn.selected = NO;
        [self.deleteArr removeAllObjects];
        for (int i = 0; i < self.dataArr.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.mainTableView deselectRowAtIndexPath:indexPath animated:NO];
            //            cell.selected = NO;
        }
        self.deleteNum = 0;
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.deleteNum] forState:UIControlStateNormal];
    }
}

#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectAndHistoryCell *cell = [CollectAndHistoryCell cellForTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - tableViewDelegate
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mainTableView.editing) {
        [self.deleteArr addObject:[self.dataArr objectAtIndex:indexPath.row]];
        self.deleteNum += 1;
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.deleteNum] forState:UIControlStateNormal];
    }else {
        ProgramResultListModel *m = self.dataArr[indexPath.item];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        VideoDetailViewController *vc = [[VideoDetailViewController alloc]init];
        vc.model = m;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mainTableView.editing) {
        [self.deleteArr removeObject:[self.dataArr objectAtIndex:indexPath.row]];
        self.deleteNum -= 1;
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",self.deleteNum] forState:UIControlStateNormal];
    }
}

#pragma mark - lazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.backgroundColor = White_Color;
        _mainTableView.allowsMultipleSelectionDuringEditing = YES;
        [_mainTableView registerClass:[CollectAndHistoryCell class] forCellReuseIdentifier:cellID];
        _mainTableView.rowHeight = self.sizeH(100);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WS()
        _mainTableView.mj_header = [MYHRocketHeader headerWithRefreshingBlock:^{
            if (self.mainTableView.isEditing) {
                [self.mainTableView.mj_header endRefreshing];
                return;
            }
            weakSelf.cursor = @"-1";
            [weakSelf loadDateWithAnimation:NO];
            
        }];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (self.mainTableView.isEditing) {
                [self.mainTableView.mj_footer endRefreshing];
                return;
            }
            weakSelf.cursor = self.dataArr.count>0 ? self.dataArr.lastObject.cursor : @"-1";
            [weakSelf loadDateWithAnimation:NO];
        }];
    }return _mainTableView;
}

#pragma mark--DZ
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return Image_Named(@"netError");
}

-(NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无收藏";
    NSDictionary *attribute =@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: KCOLOR(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.dataArr.count==0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
