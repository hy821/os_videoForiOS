//
//  SelectEpisodeCircleCell.m
//


#import "SelectEpisodeCircleCell.h"
#import "UILabel+Category.h"

@interface SelectEpisodeCircleCell ()
@property (nonatomic,weak) UIImageView *coverIV;
@property (nonatomic,weak) UILabel *numLab;

@property (nonatomic,weak) UIImageView *cacheIV;

@end

@implementation SelectEpisodeCircleCell

- (void)setModel:(MediaTipResultModel *)model {
    self.numLab.text = model.index;
    self.cacheIV.hidden = YES;
    
    if (model.isCacheView) {
        if (model.isCache) {
            self.cacheIV.hidden = NO;
            self.backgroundColor = ThemeColor;
            self.numLab.textColor = White_Color;
        }else {
            self.backgroundColor = KCOLOR(@"#F7F7F7");
            self.numLab.textColor = KCOLOR(@"#919191");
        }
    }else {
        if (model.isSelect) {
            self.backgroundColor = ThemeColor;
            self.numLab.textColor = White_Color;
        }else {
            self.backgroundColor = KCOLOR(@"#F7F7F7");
            self.numLab.textColor = KCOLOR(@"#919191");
        }
    }
}

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self createUI];
    }return self;
}

- (void)createUI {
    self.backgroundColor = KCOLOR(@"#F7F7F7");
    UILabel *numLab = [UILabel labelWithTitle:@"" font:17 textColor:KCOLOR(@"#919191") textAlignment:1];
    [numLab setFont:Font_Bold(17)];
    self.numLab = numLab;
    [self.contentView addSubview:self.numLab];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UIImageView *coverIV = [[UIImageView alloc]initWithImage:Image_Named(@"circleWhite")];
    [self.contentView addSubview:coverIV];
    self.coverIV = coverIV;
    [self.coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
 
    UIImageView *cacheIV = [[UIImageView alloc]initWithImage:Image_Named(@"ic_download")];
    [self.contentView addSubview:cacheIV];
    cacheIV.hidden = YES;
    self.cacheIV = cacheIV;
    [self.cacheIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.width.height.equalTo(self.sizeH(10));
    }];
}

@end
