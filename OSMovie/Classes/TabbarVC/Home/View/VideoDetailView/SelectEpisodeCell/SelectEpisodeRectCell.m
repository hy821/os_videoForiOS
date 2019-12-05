//
//  SelectEpisodeRectCell.m
//



#import "SelectEpisodeRectCell.h"
#import "UILabel+Category.h"

@interface SelectEpisodeRectCell()
@property (nonatomic,weak) UILabel *titleLab;
@property (nonatomic,weak) UILabel *picLab;
@property (nonatomic,weak) UIImageView *coverIV;
@property (nonatomic,weak) UIImageView *videoIV;
@end

@implementation SelectEpisodeRectCell

- (void)setModel:(MediaTipResultModel *)model {
    [self.videoIV sd_setImageWithURL:URL(model.coverInfo.url) placeholderImage:img_placeHolder options:SDWebImageRetryFailed];
    self.titleLab.text = model.title;
    self.picLab.text = model.mediaIndex;

    if (model.isSelect) {
        self.titleLab.textColor = ThemeColor;
        self.videoIV.layer.borderColor = ThemeColor.CGColor;
    }else {
        self.titleLab.textColor = KCOLOR(@"#4A4A4A");
        self.videoIV.layer.borderColor = White_Color.CGColor;
    }
    
}

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self createUI];
    }return self;
}

- (void)createUI {
    self.backgroundColor = White_Color;
    UIImageView *iv = [[UIImageView alloc]init];
    iv.image = img_placeHolder;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    iv.layer.borderWidth = 1;
    iv.layer.borderColor = White_Color.CGColor;
    iv.layer.masksToBounds = YES;
    iv.layer.cornerRadius = 2;
    self.videoIV = iv;
    [self.contentView addSubview:iv];
    [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(self.sizeH(80));
    }];

//    UIImageView *coverIV = [[UIImageView alloc]initWithImage:Image_Named(@"")];
//    [self.contentView addSubview:coverIV];
//    self.coverIV = coverIV;
//    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.videoIV);
//    }];

    UILabel *picLab = [UILabel labelWithTitle:@"" font:9 textColor:White_Color textAlignment:2];
    picLab.numberOfLines = 0;
    self.picLab = picLab;
    [self.videoIV addSubview:self.picLab];
    [self.picLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.videoIV).offset(self.sizeH(-8));
        make.bottom.equalTo(self.videoIV.mas_bottom).offset(self.sizeH(-8));
        make.height.lessThanOrEqualTo(self.sizeH(50));
        make.width.equalTo(self.sizeW(100));
    }];
    
    UILabel *titleLab = [UILabel labelWithTitle:@"" font:10 textColor:KCOLOR(@"#4A4A4A") textAlignment:0];
    titleLab.numberOfLines = 0;
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoIV.mas_bottom).offset(self.sizeH(5));
        make.left.right.equalTo(self.videoIV);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-self.sizeH(5));
    }];
    
}

@end
