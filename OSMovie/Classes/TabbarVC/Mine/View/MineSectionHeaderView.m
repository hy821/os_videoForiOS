//
//  MineSectionHeaderView.m
//


#import "MineSectionHeaderView.h"
#import "UILabel+Category.h"

@interface MineSectionHeaderView()
@property (nonatomic,weak) UIImageView *arrowIV;
@property (nonatomic,weak) UIImageView *iconIV;
@property (nonatomic,weak) UILabel *nameLab;
@property (nonatomic,weak) UIView *line;
@property (nonatomic,weak) UIControl *coverControl;
@end

@implementation MineSectionHeaderView

- (void)setModel:(MineTVCellModel *)model {
    _model = model;
    self.iconIV.image = Image_Named(model.imgName);
    self.nameLab.text = model.title;
//    self.line.hidden = [model.title containsString:@"意见反馈"];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = White_Color;
        [self createUI];
    }return self;
}

-(void)createUI {
    self.clipsToBounds = YES;
    UIImageView *iconIV = [[UIImageView alloc]init];
    iconIV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconIV];
    self.iconIV = iconIV;
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(self.sizeW(12));
        make.width.height.equalTo(self.sizeH(20));
    }];
    
    UILabel *lab = [UILabel labelWithTitle:@"" font:15 textColor:KCOLOR(@"#4A4A4A") textAlignment:1];
    [self.contentView addSubview:lab];
    self.nameLab = lab;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconIV);
        make.left.equalTo(self.iconIV.mas_right).offset(5);
    }];
    
    UIImageView *iv = [[UIImageView alloc]init];
    iv.image = Image_Named(@"ic_user_next");
    [self addSubview:iv];
    self.arrowIV = iv;
    [self.arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-self.sizeH(14));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#EEEDED");
    [self.contentView addSubview:line];
    self.line = line;
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV);
        make.right.equalTo(self.arrowIV);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(0.7f);
    }];
    
    UIControl *coverControl = [[UIControl alloc]init];
    [coverControl addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:coverControl];
    [coverControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)tapAction {
    if (self.tapBlock) {
        self.tapBlock(self.section);
    }
}

@end
