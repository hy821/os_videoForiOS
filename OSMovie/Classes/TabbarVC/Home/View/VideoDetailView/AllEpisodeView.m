//
//  AllEpisodeView.m
//



#import "AllEpisodeView.h"
#import "UIButton+Category.h"
#import "AllEpisodeRectCell.h"
#import "SelectEpisodeCircleCell.h"
#import "AllEpisodeIntroCell.h"

@interface AllEpisodeView()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UIButton *closeBtn;
@property (nonatomic,weak) UIButton *episodeBtn;
@property (nonatomic,weak) UIButton *introBtn;

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic,assign) BOOL isIntro;  //是否是简介 or 选择剧集 RectCell

@property (nonatomic,assign) BOOL isRect;  //是否是Rect:  YES:TableView   NO: CollectionView+TableView

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) VDCommonModel *model;

@property (nonatomic,strong) NSArray<MediaTipResultModel *> *dataArr;

@property (nonatomic,strong) NSArray<EpisodeIntroModel *> *introArr;

@end

@implementation AllEpisodeView

static NSString * const cellID_Rect = @"AllEpisodeRectCell";
static NSString * const cellID_Circle = @"SelectEpisodeCircleCell";
static NSString * const cellID_Intro = @"AllEpisodeIntroCell";

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isIntro ? self.introArr.count : self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isIntro) {
        AllEpisodeIntroCell *cell = [AllEpisodeIntroCell cellForTableView:tableView];
        cell.model = self.introArr[indexPath.row];
        return cell;
    }else {
        AllEpisodeRectCell *cell = [AllEpisodeRectCell cellForTableView:tableView];
        cell.model = self.dataArr[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isIntro) {
        [self.model.episodeDataArray enumerateObjectsUsingBlock:^(MediaTipResultModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSelect = (indexPath.item == idx);
        }];
        self.model.indexSelectForEpisode = indexPath.row;
        self.dataArr = self.model.episodeDataArray;
        [self.collectionView reloadData];

        if (self.selectBlock) {
            self.selectBlock(self.model);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isIntro ? self.introArr[indexPath.row].cellHeight : self.sizeH(100);
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = White_Color;
        [_mainTableView registerClass:[AllEpisodeRectCell class] forCellReuseIdentifier:cellID_Rect];
        [_mainTableView registerClass:[AllEpisodeIntroCell class] forCellReuseIdentifier:cellID_Intro];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }return _mainTableView;
}

//--------CollectionView----------//
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectEpisodeCircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID_Circle forIndexPath:indexPath];
    MediaTipResultModel *m = self.dataArr[indexPath.item];
    m.isCacheView = NO;
    cell.model = m;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.model.episodeDataArray enumerateObjectsUsingBlock:^(MediaTipResultModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelect = (indexPath.item == idx);
    }];
    self.model.indexSelectForEpisode = indexPath.item;
    self.dataArr = self.model.episodeDataArray;
    [self.collectionView reloadData];
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = self.sizeW(15);
        layout.minimumInteritemSpacing = self.sizeW(15);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(self.sizeH(35), self.sizeH(35));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = White_Color;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SelectEpisodeCircleCell class] forCellWithReuseIdentifier:cellID_Circle];
    }return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }return self;
}

- (instancetype)initWithFrame:(CGRect)frame AndData:(VDCommonModel*)model AndIntroArr:(NSArray<EpisodeIntroModel *> *)introArr{
    if (self = [super initWithFrame:frame]) {
        self.model = model;
        self.dataArr = model.episodeDataArray;
        self.introArr = introArr;
        self.isRect = (model.videoType == VideoType_Variety);
        [self initUI];
    }return self;
}

- (void)closeAction {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)selectAction {
    self.episodeBtn.selected = YES;
    self.introBtn.selected = NO;
    self.isIntro = NO;
    
    if (!self.isRect) { //--->circle  cv
        _mainTableView.hidden = YES;
        _collectionView.hidden = NO;
    }else {
        _mainTableView.hidden = NO;
        _collectionView.hidden = YES;
        [_mainTableView reloadData];
    }
    
}

- (void)introAction {
    self.episodeBtn.selected = NO;
    self.introBtn.selected = YES;
    self.isIntro = YES;
    
    _mainTableView.hidden = NO;
    if (!self.isRect) { //--->circle  cv
        _collectionView.hidden = YES;
    }else {
        [_mainTableView reloadData];
    }
    
}

- (void)initUI {
    if (!self.isRect) {  //cv
        self.isIntro = YES;
    }else {
        self.isIntro = NO;
    }

    self.backgroundColor = White_Color;
   
    UIButton *closeBtn = [UIButton buttonWithImage:Image_Named(@"cacheClose") selectedImage:Image_Named(@"cacheClose")];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    self.closeBtn = closeBtn;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.equalTo(self.sizeW(50));
        make.height.equalTo(self.sizeW(50));
    }];
    
    UIButton *episodeBtn = [UIButton buttonWithTitle:@"选择剧集" titleColor:Black_Color bgColor:White_Color highlightedColor:nil];
    episodeBtn.selected = YES;
    [episodeBtn.titleLabel setFont:Font_Size(15)];
    [episodeBtn setTitleColor:KCOLOR(@"#FF5C3E") forState:(UIControlStateSelected)];
    [episodeBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:episodeBtn];
    self.episodeBtn = episodeBtn;
    [self.episodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.closeBtn);
        make.left.equalTo(self).offset(self.sizeW(12));
    }];
    
    UIButton *introBtn = [UIButton buttonWithTitle:@"剧集简介" titleColor:Black_Color bgColor:White_Color highlightedColor:nil];
    [introBtn.titleLabel setFont:Font_Size(15)];
    [introBtn setTitleColor:KCOLOR(@"#FF5C3E") forState:(UIControlStateSelected)];
    [introBtn addTarget:self action:@selector(introAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:introBtn];
    self.introBtn = introBtn;
    [self.introBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.closeBtn);
        make.left.equalTo(self.episodeBtn.mas_right).offset(self.sizeW(20));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(0.9f);
        make.top.equalTo(self.closeBtn.mas_bottom);
    }];
    
    //----------TV
    [self addSubview:self.mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeBtn.mas_bottom).offset(1);
        make.left.right.bottom.equalTo(self);
    }];
    [_mainTableView reloadData];
    
    //-----------CV
    if (!self.isRect) {
        [self addSubview:self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(self.sizeH(10+50), self.sizeH(10), self.sizeH(10), self.sizeH(10)));
        }];
        [_collectionView reloadData];
        _mainTableView.hidden = YES;
    }
}

@end
