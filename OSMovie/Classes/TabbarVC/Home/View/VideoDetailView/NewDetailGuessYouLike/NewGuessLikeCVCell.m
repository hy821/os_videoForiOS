//
//  NewGuessLikeCVCell.m
//



#import "NewGuessLikeCVCell.h"
#import "UILabel+Category.h"

@interface NewGuessLikeCVCell ()

@property (nonatomic,weak) UIImageView *videoIV;
@property (nonatomic,weak) UILabel *titleLab;
@property (nonatomic,weak) UILabel *uperNameLab;
@property (nonatomic,weak) UILabel *playCountLab;
@property (nonatomic,strong) UIView *line;
@end

@implementation NewGuessLikeCVCell

- (void)setIsHideLine:(BOOL)isHideLine {
    _isHideLine = isHideLine;
    self.line.hidden = isHideLine;
}

- (void)setModel:(ProgramResultListModel *)model {
    _model = model;
    [self.videoIV sd_setImageWithURL:URL(model.poster.url) placeholderImage:img_placeHolder options:SDWebImageRetryFailed];
    self.uperNameLab.text = model.authors.firstObject.name;
    self.playCountLab.text = model.playPageCount;
    
    self.titleLab.text = model.name;

    //    self.titleLab.text = [NSString stringWithFormat:@"kw:%@ kwt:%@ 个数:%ld个 %@",model.keyWord,model.keyWordAliasType,(long)model.keyWordCount,model.name];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }return self;
}

- (void)initUI {
    UIImageView *videoIV = [[UIImageView alloc]init];
    videoIV.contentMode = UIViewContentModeScaleAspectFill;
    videoIV.clipsToBounds = YES;
    videoIV.layer.masksToBounds = YES;
    videoIV.layer.cornerRadius = self.sizeH(5);
    [self.contentView addSubview:videoIV];
    self.videoIV = videoIV;
    [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.height.equalTo(self.sizeH(90));
        make.width.equalTo(self.sizeH(90) * 30 / 18);
    }];
    
    UILabel *titleLab = [UILabel labelWithTitle:@"" font:14 textColor:KCOLOR(@"#000000") textAlignment:0];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    self.titleLab.numberOfLines = 3;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoIV).offset(self.sizeH(3));
        make.left.equalTo(self.videoIV.mas_right).offset(self.sizeW(10));
        make.right.equalTo(self.contentView).offset(self.sizeW(-10));
        make.height.lessThanOrEqualTo(self.sizeH(60));
    }];
    
    UILabel *uperNameLab = [UILabel labelWithTitle:@"" font:11 textColor:LightGray_Color textAlignment:0];
    [self.contentView addSubview:uperNameLab];
    self.uperNameLab = uperNameLab;
    [self.uperNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoIV).offset(self.sizeH(-3));
        make.left.equalTo(self.titleLab);
        make.height.equalTo(self.sizeH(20));
    }];
    
    UILabel *playCountLab = [UILabel labelWithTitle:@"" font:11 textColor:LightGray_Color textAlignment:2];
    [self.contentView addSubview:playCountLab];
    self.playCountLab = playCountLab;
    [self.playCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.uperNameLab);
        make.right.equalTo(self.titleLab);
        make.left.greaterThanOrEqualTo(self.uperNameLab.mas_right).offset(self.sizeW(8));
        make.height.equalTo(self.uperNameLab);
    }];
    
    [self.playCountLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.playCountLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line];
    self.line = line;
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(0.9f);
    }];
}

@end
