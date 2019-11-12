//
//  GuessYouLikeCell.m
//


#import "GuessYouLikeCell.h"
#import "UILabel+Category.h"
#import "VideoCommonCVCell.h"
#import "VideoDetailViewController.h"
#import "GuessYouLikeShortVideoCell.h"

@interface GuessYouLikeCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,weak) UILabel *likeLab;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<ProgramResultListModel*> *likeDataArray;
@property (nonatomic,assign) BOOL isShortVideo;
@end

@implementation GuessYouLikeCell
static NSString *cell_ID = @"VideoCommonCVCell";
static NSString *cell_shortID = @"GuessYouLikeShortVideoCell";

- (NSMutableArray<ProgramResultListModel *> *)likeDataArray {
    if (!_likeDataArray) {
        _likeDataArray = [NSMutableArray array];
    }return _likeDataArray;
}

- (void)setModel:(VDCommonModel *)model {
    _model = model;
    _likeDataArray = model.likeDataArray.mutableCopy;
    _isShortVideo = model.videoType == VideoType_Short;
    [self.collectionView reloadData];
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"GuessYouLikeCell";
    GuessYouLikeCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[GuessYouLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        make.height.equalTo(self.sizeH(60));
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
    
    CGFloat VideoCommonItemH = ((ScreenWidth-2*self.sizeW(3)-2*self.sizeW(10))/3)*155/110 + self.sizeH(50);
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.likeLab.mas_bottom);
        make.left.equalTo(self.contentView).offset(self.sizeW(10));
        make.right.equalTo(self.contentView).offset(self.sizeW(-10));
        make.height.equalTo(VideoCommonItemH*2);
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
    return _likeDataArray.count > 6 ? 6 : _likeDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isShortVideo) {
        GuessYouLikeShortVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_shortID forIndexPath:indexPath];
        cell.model = _likeDataArray[indexPath.item];
        return cell;
    }else {
        VideoCommonCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_ID forIndexPath:indexPath];
        cell.model = _likeDataArray[indexPath.item];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat VideoCommonItemW = (ScreenWidth-2*self.sizeW(3)-2*self.sizeW(10))/3;
    CGFloat VideoCommonItemH = ((ScreenWidth-2*self.sizeW(3)-2*self.sizeW(10))/3)*155/110 + self.sizeH(50);
    CGSize itemSize = CGSizeMake(VideoCommonItemW, VideoCommonItemH);

    CGFloat ShortVideoCommonItemW = ((ScreenWidth-self.sizeW(3)*2-2*self.sizeW(10))/3);
    CGFloat ShortVideoCommonItemH = ((ScreenWidth-self.sizeW(3)*2-2*self.sizeW(10))/3)*80/123 + self.sizeH(45);
    CGSize shortItemSize = CGSizeMake(ShortVideoCommonItemW, ShortVideoCommonItemH);
    
    return _isShortVideo ? shortItemSize : itemSize;
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
        [_collectionView registerClass:[VideoCommonCVCell class] forCellWithReuseIdentifier:cell_ID];
        [_collectionView registerClass:[GuessYouLikeShortVideoCell class] forCellWithReuseIdentifier:cell_shortID];
    }return _collectionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
