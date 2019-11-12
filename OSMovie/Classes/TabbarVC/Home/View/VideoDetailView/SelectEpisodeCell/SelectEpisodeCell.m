//
//  SelectEpisodeCell.m
//


#import "SelectEpisodeCell.h"
#import "UILabel+Category.h"
#import "UIButton+Category.h"

#import "SelectEpisodeCircleCell.h"
#import "SelectEpisodeRectCell.h"

@interface SelectEpisodeCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,weak) UILabel *synopsisLab;  //选集
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<MediaTipResultModel*> *episodeDataArray;
@property (nonatomic,assign) BOOL isCircle;

@end

@implementation SelectEpisodeCell

static NSString *cellID_circle = @"SelectEpisodeCircleCell";
static NSString *cellID_rect = @"SelectEpisodeRectCell";

- (NSMutableArray<MediaTipResultModel *> *)episodeDataArray {
    if (!_episodeDataArray) {
        _episodeDataArray = [NSMutableArray array];
    }return _episodeDataArray;
}

- (void)setModel:(VDCommonModel *)model {
    _model = model;
    self.episodeDataArray = model.episodeDataArray.mutableCopy;
    _isCircle = !(model.videoType == VideoType_Variety);
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _episodeDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MediaTipResultModel *m = _episodeDataArray[indexPath.item];
    m.isCacheView = NO;
    if (self.isCircle) {
        SelectEpisodeCircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID_circle forIndexPath:indexPath];
        cell.model = m;
        return cell;
    }else {
        SelectEpisodeRectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID_rect forIndexPath:indexPath];
        cell.model = m;
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.model.episodeDataArray enumerateObjectsUsingBlock:^(MediaTipResultModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelect = (indexPath.item == idx);
    }];
    self.model.indexSelectForEpisode = indexPath.item;
    //更新当前cell的UI
    _episodeDataArray = self.model.episodeDataArray.mutableCopy;
    [self.collectionView reloadData];
    //通知更新外面的数据
    if (self.changeEpisodeBlock) {
        self.changeEpisodeBlock(self.model);
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = White_Color;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[SelectEpisodeCircleCell class] forCellWithReuseIdentifier:cellID_circle];
        [_collectionView registerClass:[SelectEpisodeRectCell class] forCellWithReuseIdentifier:cellID_rect];
    }return _collectionView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.isCircle ? CGSizeMake(self.sizeH(35), self.sizeH(35)) : CGSizeMake(self.sizeW(112), self.sizeH(120));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.isCircle ? self.sizeW(10) : self.sizeW(20);
}

+(instancetype)cellForTableView:(UITableView *)tableView {
    static NSString * ID = @"SelectEpisodeCell";
    SelectEpisodeCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil) {
        cell = [[SelectEpisodeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _isCircle = YES;
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

    UILabel *synopsisLab = [UILabel labelWithTitle:@"选集" font:15 textColor:KCOLOR(@"#333333") textAlignment:0];
    [self.contentView addSubview:synopsisLab];
    self.synopsisLab = synopsisLab;
    [self.synopsisLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(self.sizeH(10));
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.height.equalTo(self.sizeH(25));
    }];
    
    UIButton *allBtn = [UIButton buttonWithTitle:@"全部剧集" titleColor:KCOLOR(@"#FF5C3E") bgColor:White_Color highlightedColor:KCOLOR(@"#FF5C3E")];
    [allBtn.titleLabel setFont:Font_Size(11)];
    [allBtn addTarget:self action:@selector(allAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
        make.centerY.height.equalTo(self.synopsisLab);
    }];
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.synopsisLab.mas_bottom).offset(self.sizeH(5));
        make.left.equalTo(self.synopsisLab);
        make.right.equalTo(allBtn);
        make.bottom.equalTo(self.contentView).offset(-self.sizeH(7));
    }];

}

- (void)allAction {
    if (self.showAllEpisodeBlock) {
        self.showAllEpisodeBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
