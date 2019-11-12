//
//  NewGuessLikeCell.m
//


#import "NewGuessLikeCell.h"
#import "UILabel+Category.h"
#import "VideoDetailViewController.h"
#import "NewGuessLikeCVCell.h"
#import "HorizenButton.h"
#import "UIButton+Category.h"

@interface NewGuessLikeCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,weak) UILabel *likeLab;
@property (nonatomic,weak) HorizenButton *moreBtn;

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<ProgramResultListModel*> *likeDataArray;
@end

@implementation NewGuessLikeCell

static NSString *cell_ID = @"NewGuessLikeCVCell";

CGFloat const cellHeightForShortVideoGuessLike = 110;

- (NSMutableArray<ProgramResultListModel *> *)likeDataArray {
    if (!_likeDataArray) {
        _likeDataArray = [NSMutableArray array];
    }return _likeDataArray;
}

- (void)setModel:(VDCommonModel *)model {
    _model = model;
    _likeDataArray = model.likeDataArray.mutableCopy;

    
    NSInteger lineNum = 3;
    if (_likeDataArray.count<3) {
        lineNum = _likeDataArray.count;
    }
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeLab.mas_bottom);
        make.left.equalTo(self.contentView).offset(self.sizeW(10));
        make.right.equalTo(self.contentView).offset(self.sizeW(-10));
        make.height.equalTo((self.sizeH(cellHeightForShortVideoGuessLike))*lineNum);
    }];
   
    if (_likeDataArray.count<3) {
        self.moreBtn.hidden = YES;
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(0);
        }];
    }else {
        self.moreBtn.hidden = NO;
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(self.sizeH(50));
        }];
    }
   
    [self.collectionView reloadData];
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"NewGuessLikeCell";
    NewGuessLikeCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[NewGuessLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }return self;
}

-(void)createUI {
    self.contentView.backgroundColor = White_Color;
    self.clipsToBounds = YES;
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(self.sizeH(7));
    }];
    
    UILabel *likeLab = [UILabel labelWithTitle:@"更多精彩" font:15 textColor:KCOLOR(@"#333333") textAlignment:1];
    self.likeLab = likeLab;
    [self.contentView addSubview:likeLab];
    [self.likeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.height.equalTo(self.sizeH(50));
        make.centerX.equalTo(self.contentView);
    }];
    
    UIImageView *left = [[UIImageView alloc]initWithImage:Image_Named(@"ic_left")];
    [self.contentView addSubview:left];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.likeLab);
        make.right.equalTo(self.likeLab.mas_left).offset(self.sizeW(-5));
    }];
    
    UIImageView *right = [[UIImageView alloc]initWithImage:Image_Named(@"ic_right")];
    [self.contentView addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.likeLab);
        make.left.equalTo(self.likeLab.mas_right).offset(self.sizeW(5));
    }];
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeLab.mas_bottom);
        make.left.equalTo(self.contentView).offset(self.sizeW(10));
        make.right.equalTo(self.contentView).offset(self.sizeW(-10));
        make.height.equalTo(self.sizeH(cellHeightForShortVideoGuessLike));
    }];
    
    HorizenButton *moreBtn = [[HorizenButton alloc]init];
    [moreBtn setTitle:@"点击查看更多视频" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = Font_Size(12);
    [moreBtn setTitleColor:KCOLOR(@"#4A4A4A") forState:UIControlStateNormal];
    [moreBtn setTitleColor:KCOLOR(@"#4A4A4A") forState:UIControlStateSelected];
    moreBtn.isTitleLeft = YES;
    moreBtn.margeWidth = 2.f;
    [moreBtn setImage:Image_Named(@"ic_detail_more") forState:UIControlStateNormal];
    [moreBtn setImage:Image_Named(@"ic_detail_more") forState:UIControlStateSelected];
    [moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:moreBtn];
    self.moreBtn = moreBtn;
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(self.sizeH(50));
        make.bottom.equalTo(self.contentView);
    }];
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProgramResultListModel *m = self.likeDataArray[indexPath.item];    
    if (self.selectBlock) {
        self.selectBlock(m);
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _likeDataArray.count > 3 ? 3 : _likeDataArray.count;
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

- (void)moreAction {
    if(self.showMoreBlock) {
        self.showMoreBlock();
    }
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
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[NewGuessLikeCVCell class] forCellWithReuseIdentifier:cell_ID];
    }return _collectionView;
}

@end
