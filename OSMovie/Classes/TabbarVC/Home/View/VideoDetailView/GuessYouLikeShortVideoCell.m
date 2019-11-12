//
//  GuessYouLikeShortVideoCell.m
//


#import "GuessYouLikeShortVideoCell.h"
#import "UILabel+Category.h"

@interface GuessYouLikeShortVideoCell ()

@property (nonatomic,weak) UIImageView *videoIV;
@property (nonatomic,weak) UILabel *titleLab;

@end

@implementation GuessYouLikeShortVideoCell

- (void)setModel:(ProgramResultListModel *)model {
    _model = model;
    [self.videoIV sd_setImageWithURL:URL(model.poster.url) placeholderImage:img_placeHolder options:SDWebImageRetryFailed];
    
    self.titleLab.text = model.name;
    
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
    [self.contentView addSubview:videoIV];
    self.videoIV = videoIV;
    
    CGFloat VideoCommonItemH = ((ScreenWidth-self.sizeW(3)*2-2*self.sizeW(10))/3)*80/123;

    [self.videoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(VideoCommonItemH);
    }];
    
    UILabel *titleLab = [UILabel labelWithTitle:@"" font:12 textColor:KCOLOR(@"#000000") textAlignment:1];
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    self.titleLab.numberOfLines = 2;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoIV.mas_bottom).offset(self.sizeH(3));
        make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView).offset(-2);
    }];
    
}

@end
