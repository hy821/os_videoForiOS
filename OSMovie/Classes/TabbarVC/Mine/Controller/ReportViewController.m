//
//  ReportViewController.m
//


#import "ReportViewController.h"
#import "ReportCell.h"
#import "UIButton+Category.h"
#import "KSBaseWebViewController.h"

@interface ReportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray<ReportCellModel*> *dataArr;
@property (strong, nonatomic) NSMutableArray<ReportCellModel*> *selectArr;
@property (strong, nonatomic) UIButton *bottomBtn;
@end

@implementation ReportViewController

static NSString * const cellID = @"ReportCell";

- (void)dealloc {
//    if (self.backSVDetailBlock) {
//        self.backSVDetailBlock();
//    }
}

- (void)reportAction {
    if (self.selectArr.count==0) {
        SSMBToast(@"请选择举报类型",self.view);
        return;
    }else {
        /*
         
         map.put("key", key);
         map.put("type", type);
         map.put("mediaId", mediaId);
         map.put("assetType", assetType);
         map.put("programId", programId);
         map.put("reasons", reasons);
         
         */
        
        NSMutableArray *selectArr = [NSMutableArray array];
        [self.selectArr enumerateObjectsUsingBlock:^(ReportCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [selectArr addObject:obj.title];
        }];
        
        NSString *mediaIdStr = @"";
        NSString *assetTypeStr = @"";
        NSString *programIdStr = @"";
        if(self.model.mediaSourceResultList.count>0) {
            MediaTipResultModel *mTip = self.model.episodeDataArray[self.model.indexSelectForEpisode];
            mediaIdStr = mTip.mediaId;
            assetTypeStr = self.model.type ? self.model.type : @"";
            programIdStr = self.model.programId ? self.model.programId : @"";
        }
        
        if (self.fromShortVideo) {
            MediaSourceResultModel *mS = self.modelShortVideo.mediaResult.mediaSourceResultList.firstObject;
            MediaTipResultModel *mTip = mS.mediaTipResultList.firstObject;
            mediaIdStr = mTip.mediaId;
            mediaIdStr = self.modelShortVideo.idForModel;
            assetTypeStr = self.modelShortVideo.type ? self.modelShortVideo.type : @"";
            programIdStr = self.modelShortVideo.idForModel ? self.modelShortVideo.idForModel : @"";
        }
        
        NSDictionary *dic = @{@"key" : self.model.programId ? self.model.programId : @"",
                              @"type" : @"AT002",  //AT001  评论
                              @"mediaId" : mediaIdStr,
                              @"assetType" : assetTypeStr,
                              @"programId" : programIdStr,
                              @"reasons" : selectArr
                              };
        [[SSRequest request]POST:ReportUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
            SSMBToast(@"举报成功",MainWindow);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(SSRequest *request, NSString *errorMsg) {
            SSMBToast(errorMsg, MainWindow);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }
    
}

- (void)goToH5Report {
    KSBaseWebViewController *webView = [[KSBaseWebViewController alloc]init];
    webView.webType = WKType;
    webView.bannerUrl = @"http://www.shjbzx.cn/";
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";
     [self setNavWithTitle:@"提交" Font:14 andTextColor:@"#4A4A4A" andIsLeft:NO andTarget:self andAction:@selector(reportAction)];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([self contentOffset]);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.sizeH(50)*self.dataArr.count);
    }];
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(self.sizeH(100));
    }];
}

#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReportCell *cell = [ReportCell cellForTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

#pragma mark - tableViewDelegate
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mainTableView.editing) {
        [self.selectArr addObject:[self.dataArr objectAtIndex:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mainTableView.editing) {
        [self.selectArr removeObject:[self.dataArr objectAtIndex:indexPath.row]];
    }
}

- (NSMutableArray<ReportCellModel*> *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
        NSArray *arr = @[@"政治有害信息",@"反动暴恐",@"淫秽色情",@"诈骗或恶意营销",@"抄袭",@"赌博",@"网络诈骗"];
        for (int i = 0; i < arr.count; ++i) {
            ReportCellModel *m = [[ReportCellModel alloc]init];
            m.title = arr[i];
            m.isSelect = NO;
            [_dataArr addObject:m];
        }
    } return _dataArr;
}

#pragma mark - lazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _mainTableView.bounces = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = White_Color;
        [_mainTableView setEditing:YES];
        _mainTableView.allowsMultipleSelectionDuringEditing = YES;
        [_mainTableView registerClass:[ReportCell class] forCellReuseIdentifier:cellID];
        _mainTableView.rowHeight = self.sizeH(50);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }return _mainTableView;
}

- (NSMutableArray<ReportCellModel *> *)selectArr {
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }return _selectArr;
}

-(UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithImage:Image_Named(@"reportBottom") selectedImage:Image_Named(@"reportBottom")];
        _bottomBtn.showsTouchWhenHighlighted = NO;
        [_bottomBtn addTarget:self action:@selector(goToH5Report) forControlEvents:UIControlEventTouchUpInside];
    }return _bottomBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
