//
//  VideoCommonCVCell.m
//

#import "VideoCommonCVCell.h"
#import "UILabel+Category.h"

@interface VideoCommonCVCell()

@property (nonatomic,weak) UIImageView *videoIV;
@property (nonatomic,weak) UIImageView *sortIV;  //排序 1 2 3
@property (nonatomic,weak) UILabel *sortLab;
@property (nonatomic,weak) UILabel *scoreLab;
@property (nonatomic,weak) UILabel *updatingLab; //更新中
@property (nonatomic,weak) UILabel *titleLab;
@property (nonatomic,weak) UILabel *subTitleLab;

@end

@implementation VideoCommonCVCell

- (void)setEmpty {
    self.sortIV.hidden = YES;
    self.sortLab.hidden = YES;
    self.scoreLab.text = @"";
    self.videoIV.hidden = YES;
    self.titleLab.text = @"";
    self.subTitleLab.text = @"";
    self.updatingLab.hidden = YES;
}

- (void)setModel:(ProgramResultListModel *)model {
    _model = model;
    self.sortIV.hidden = YES;
    self.sortLab.hidden = YES;
    
    self.videoIV.hidden = NO;
    [self.videoIV sd_setImageWithURL:URL(model.poster.url) placeholderImage:img_placeHolder options:SDWebImageRetryFailed];
    if (model.points && [model.points integerValue]>0) {
        self.scoreLab.text = [NSString stringWithFormat:@"%@分",model.points];
    }else {
        self.scoreLab.text = @"";
    }
    
    self.titleLab.text = model.name;
    self.subTitleLab.text = model.descriptionForModel;
    
    ///更新
    self.updatingLab.hidden = YES;
    if ([model.type integerValue]==1 || [model.type integerValue]==3 || [model.type integerValue]==4) {  //剧情
        if (![model.finished integerValue]) {
            self.updatingLab.hidden = NO;
            self.updatingLab.text = @"更新中";
        }else {
            self.updatingLab.hidden = NO;
            self.updatingLab.text = [NSString stringWithFormat:@"%@集全",model.episodes];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }return self;
}

- (void)createUI {
    UILabel *subLab = [UILabel labelWithTitle:@"" font:10 textColor:KCOLOR(@"#B4B4B4") textAlignment:1];
    [self.contentView addSubview:subLab];
    self.subTitleLab = subLab;
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(self.sizeH(-5));
        make.left.equalTo(self.contentView).offset(self.sizeW(3));
        make.right.equalTo(self.contentView).offset(self.sizeW(-3));
        make.height.equalTo(self.sizeH(14));
    }];
    
    UILabel *titleLab = [UILabel labelWithTitle:@"" font:12 textColor:KCOLOR(@"#000000") textAlignment:1];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.subTitleLab.mas_top);
        make.left.right.equalTo(self.subTitleLab);
        make.height.equalTo(self.sizeH(14));
    }];
    
    UIImageView *videoIV = [[UIImageView alloc]init];
    videoIV.contentMode = UIViewContentModeScaleAspectFill;
    videoIV.clipsToBounds = YES;
    [self.contentView addSubview:videoIV];
    self.videoIV = videoIV;
    [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.titleLab.mas_top).offset(self.sizeH(-5));
    }];
    
    UIImageView *gradientIV = [[UIImageView alloc]init];
    [self.videoIV addSubview:gradientIV];
    [gradientIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.videoIV);
        make.height.equalTo(self.sizeH(20));
    }];
    
    WS()
    [Tool gradientColorWithRed:0 green:0 blue:0 startAlpha:1 endAlpha:0 direction:(DirectionStyleToUn) frame:CGRectMake(0, 0, 100, weakSelf.sizeH(22)) view:gradientIV];
    
    UIImageView *sortIV = [[UIImageView alloc]init];
    sortIV.contentMode = UIViewContentModeScaleAspectFit;
    sortIV.clipsToBounds = YES;
    [self.videoIV addSubview:sortIV];
    self.sortIV = sortIV;
    
    [self.sortIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoIV).offset(self.sizeH(3));
        make.left.equalTo(self.videoIV).offset(self.sizeH(3));
    }];
    
    UILabel *sortLab = [UILabel labelWithTitle:@"" font:11 textColor:White_Color textAlignment:1];
    sortLab.font = Font_Bold(11);
    [self.sortIV addSubview:sortLab];
    self.sortLab = sortLab;
    [self.sortLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.sortIV);
        make.centerY.equalTo(self.sortIV).offset(2);
    }];
    
    UILabel *scoreLab = [UILabel labelWithTitle:@"" font:11 textColor:ThemeColor textAlignment:0];
    [self.videoIV addSubview:scoreLab];
    self.scoreLab = scoreLab;
    [self.scoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoIV.mas_bottom).offset(self.sizeH(-2));
        make.left.equalTo(self.videoIV).offset(self.sizeW(4));
    }];
  
    UILabel *updatingLab = [UILabel labelWithTitle:@"" font:11 textColor:White_Color textAlignment:2];
    [self.videoIV addSubview:updatingLab];
    self.updatingLab = updatingLab;
    [self.updatingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.videoIV.mas_bottom).offset(self.sizeH(-2));
        make.right.equalTo(self.videoIV).offset(self.sizeW(-4));
    }];
    
}

@end
