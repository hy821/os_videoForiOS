//
//  GuessLikeActionSheetView.m
//


#import "GuessLikeActionSheetView.h"
#import "UIButton+Category.h"
#import "UILabel+Category.h"
#import "NewGuessLikeCVCell.h"
#import "NewGuessLikeCell.h"  //为了用里面定义的 cellHeightForShortVideoGuessLike

@interface GuessLikeActionSheetView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<ProgramResultListModel*> *likeDataArray;

@end

@implementation GuessLikeActionSheetView

static NSString *cell_ID = @"NewGuessLikeCVCell";

- (NSMutableArray<ProgramResultListModel *> *)likeDataArray {
    if (!_likeDataArray) {
        _likeDataArray = [NSMutableArray array];
    }return _likeDataArray;
}

-(instancetype)initWithFrame:(CGRect)frame AndData:(NSArray*)arr{
    if(self = [super initWithFrame:frame]) {
        self.likeDataArray = [arr mutableCopy];
        [self createUI];
    }return self;
}

-(void)createUI {
    self.backgroundColor = White_Color;
    UILabel *likeLab = [UILabel labelWithTitle:@"更多精彩" font:16 textColor:KCOLOR(@"#333333") textAlignment:1];
    likeLab.font = Font_Bold(16);
    [self addSubview:likeLab];
    [likeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.height.equalTo(self.sizeH(50));
    }];
    
    UIButton *closeBtn = [UIButton buttonWithImage:Image_Named(@"cacheClose") selectedImage:Image_Named(@"cacheClose")];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(likeLab);
        make.right.equalTo(self).offset(self.sizeW(5));
        make.width.equalTo(self.sizeW(50));
        make.height.equalTo(self.sizeW(50));
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(likeLab.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self.collectionView reloadData];
}

- (void)closeAction {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProgramResultListModel *m = self.likeDataArray[indexPath.item];
    if (self.selectBlock) {
        self.selectBlock(m);
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _likeDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewGuessLikeCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_ID forIndexPath:indexPath];
    if(indexPath.item<_likeDataArray.count) {
        cell.model = _likeDataArray[indexPath.item];
        cell.isHideLine = (indexPath.item == _likeDataArray.count-1);
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ScreenWidth, self.sizeH(cellHeightForShortVideoGuessLike));
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = White_Color;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[NewGuessLikeCVCell class] forCellWithReuseIdentifier:cell_ID];
    }return _collectionView;
}

@end
