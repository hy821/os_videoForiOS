//
//  HomeListViewController.m
//  ABOSMovie
//
//    Created by Rb_Developer on 2017/10/31.

//

#import "HomeListViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "VideoCommonCVCell.h"
#import "OSVDController.h"
#import "RefreshGifHeader.h"
#import "OOSBaseWebViewController.h"

@interface HomeListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<ProgramResultListModel *> *listArr;
@property (nonatomic,copy) NSString *cursor;


@end

static NSString *cell_ID = @"VideoCommonCVCell";

@implementation HomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KCOLOR(@"F8F8F8");
    self.cursor = @"0";
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(3);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self loadDataWithAnimation:YES];
}

- (void)loadDataWithAnimation:(BOOL)isAnimation {
    if (isAnimation) {SSGifShow(MainWindow, @"加载中");}
    NSDictionary *dic = @{@"si" : self.model.categoryID,
                          @"cursor" : self.cursor,
                          @"size" : @"15" //@(PageCount_VideoLib)
                          };
    
    [[ABSRequest request]GET:HomePageListUrl parameters:dic success:^(ABSRequest *request, id response) {
        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
        self.isNetError = SSNetNormal_state;
        [self.collectionView.mj_header endRefreshing];
        
        if([self.cursor isEqualToString:@"0"] && (self.listArr.count>0)) {
            [self.listArr removeAllObjects];
        }
        NSArray *arr = [ProgramResultListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [self.listArr addObjectsFromArray:arr];
        [self.collectionView reloadData];
        
        if (arr.count < PageCount_VideoLib) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.collectionView.mj_footer endRefreshing];
        }
        
    } failure:^(ABSRequest *request, NSString *errorMsg) {
        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
        SSMBToast(errorMsg, MainWindow);
        self.isNetError = SSNetError_state;
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = self.sizeW(3);
        layout.minimumInteritemSpacing = 0;
        CGFloat VideoCommonItemW = (ScreenWidth-2*self.sizeW(3))/3;
        CGFloat VideoCommonItemH = ((ScreenWidth-2*self.sizeW(3))/3)*155/110 + self.sizeH(50);
        layout.itemSize = CGSizeMake(VideoCommonItemW, VideoCommonItemH);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[VideoCommonCVCell class] forCellWithReuseIdentifier:cell_ID];
        WS()
        _collectionView.mj_header = [RefreshGifHeader headerWithRefreshingBlock:^{
            weakSelf.cursor = @"0";
            [weakSelf loadDataWithAnimation:NO];
        }];
        _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.cursor = self.listArr.lastObject.cursor ? self.listArr.lastObject.cursor : @"0";
            [weakSelf loadDataWithAnimation:NO];
        }];
    }
    return _collectionView;
}

- (NSMutableArray<ProgramResultListModel *> *)listArr {
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }return _listArr;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProgramResultListModel *m = [self.listArr objectAtIndex:indexPath.item];
    VideoCommonCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_ID forIndexPath:indexPath];
    cell.model = m;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ck = [USER_MANAGER isCK];
    if (ck.length>0) {
        OOSBaseWebViewController *vc = [[OOSBaseWebViewController alloc]init];
        vc.webType = WKType;
        vc.isNavBarHidden = YES;
        vc.bannerUrl = ck;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        ProgramResultListModel *m = self.listArr[indexPath.item];
        OSVDController *vc = [[OSVDController alloc]init];
        vc.model = m;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark--DZ
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.isNetError==SSNetLoading_state)return nil;
    return self.isNetError == SSNetNormal_state ? Image_Named(@"netError") : Image_Named(@"netError");
}
-(NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if(self.isNetError==SSNetLoading_state)return nil;
    NSString *text = self.isNetError==SSNetError_state?@"网络请求失败":@"暂无更多内容~";
    NSDictionary *attribute = self.isNetError?@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: KCOLOR(@"#333333")}:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: KCOLOR(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

// 返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.isNetError!=SSNetError_state)return nil;
    NSString *text = @"加载失败,点击重试";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: KCOLOR(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

-(UIImage*)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if(self.isNetError!=SSNetError_state)return nil;
    return Image_Named(@"reload");
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if (self.isNetError!=SSNetError_state) {
        return;
    }
    self.isNetError = SSNetLoading_state;
    [self.collectionView reloadEmptyDataSet];
    
    self.cursor = @"0";
    [self loadDataWithAnimation:NO];
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return (self.listArr.count==0);
}

@end
