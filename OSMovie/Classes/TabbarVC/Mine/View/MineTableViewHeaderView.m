//
//  MineTableViewHeaderView.m
//



#import "MineTableViewHeaderView.h"
#import "UILabel+Category.h"
#import "UIButton+Category.h"
#import "HorizenButton.h"
#import "SettingViewController.h"

@interface MineTableViewHeaderView ()

@property (nonatomic,weak) UIImageView *bgIV;
@property (nonatomic,weak) UIImageView *iconIV;
@property (nonatomic,weak) UILabel *nameLab;
@property (nonatomic,weak) UIButton *setBtn;
@property (nonatomic,weak) UIImageView *shadowRectIV;
@property (nonatomic,strong) HorizenButton *vipBtn;
@end

@implementation MineTableViewHeaderView

- (void)refresh {
    if ([USER_MANAGER getUserIcon].length>0) {
        self.iconIV.image = Image_Named([USER_MANAGER getUserIcon]);
    }else {
        self.iconIV.image = img_placeHolderIcon;
    }
    
    if ([USER_MANAGER getUserNickName].length>0) {
        self.nameLab.text = [USER_MANAGER getUserNickName];
    }else {
        self.nameLab.text = @"点击登录";
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        [self createUI];
    }return self;
}

- (void)createUI {
    self.backgroundColor = White_Color;
    
    UIImageView *iv = [[UIImageView alloc]init];
    iv.image = Image_Named(@"img_user_bg");
    iv.userInteractionEnabled = YES;
    [self addSubview:iv];
    self.bgIV = iv;
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-self.sizeH(30));
    }];
    
    UIImageView *iconIV = [[UIImageView alloc]init];
    iconIV.layer.masksToBounds = YES;
    iconIV.contentMode = UIViewContentModeScaleAspectFill;
    if ([USER_MANAGER getUserIcon].length>0) {
        iconIV.image = Image_Named([USER_MANAGER getUserIcon]);
    }else {
        iconIV.image = img_placeHolderIcon;
    }
    
    iconIV.userInteractionEnabled = YES;
    [self.bgIV addSubview:iconIV];
    self.iconIV = iconIV;
    self.iconIV.layer.cornerRadius = self.sizeH(35);
    self.iconIV.layer.borderColor = White_Color.CGColor;
    self.iconIV.layer.borderWidth = self.sizeH(4);
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgIV);
        make.width.height.equalTo(self.sizeH(70));
    }];
    
    UILabel *lab = [UILabel labelWithTitle:@"" font:15 textColor:KCOLOR(@"#181818") textAlignment:1];
    lab.userInteractionEnabled = YES;
    [lab setFont:Font_Bold(15)];
    if ([USER_MANAGER getUserNickName].length>0) {
        lab.text = [USER_MANAGER getUserNickName];
    }else {
        lab.text = @"点击登录";
    }
    [self.bgIV addSubview:lab];
    self.nameLab = lab;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_bottom).offset(7);
        make.centerX.equalTo(self.iconIV);
    }];
    
    UIButton *btn = [UIButton buttonWithImage:Image_Named(@"ic_setting") selectedImage:Image_Named(@"ic_setting")];
    [btn addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgIV addSubview:btn];
    self.setBtn = btn;
    [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgIV).offset([self contentOffset]-30);
        make.right.equalTo(self.bgIV).offset(self.sizeH(-20));
    }];
    
    UIImageView *shadowRectIV = [[UIImageView alloc]init];
    shadowRectIV.image = Image_Named(@"img_user_shadow");
    shadowRectIV.userInteractionEnabled = YES;
    [self addSubview:shadowRectIV];
    self.shadowRectIV = shadowRectIV;
    [self.shadowRectIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgIV);
        make.height.equalTo(self.sizeH(70));
        make.width.equalTo(self.sizeW(345));
        make.bottom.equalTo(self);
    }];
    
//    HorizenButton *vipBtn = [[HorizenButton alloc]init];
//    [vipBtn setTitle:@"进入我的会员专区" forState:UIControlStateNormal];
//    [vipBtn setTitle:@"进入我的会员专区" forState:UIControlStateSelected];
//    vipBtn.titleLabel.font = Font_Size(16);
//    [vipBtn setTitleColor:KCOLOR(@"#A99898") forState:UIControlStateNormal];
//    [vipBtn setTitleColor:KCOLOR(@"#A99898") forState:UIControlStateSelected];
//    vipBtn.isTitleLeft = NO;
//    vipBtn.margeWidth = 4.f;
//    [vipBtn setImage:Image_Named(@"ic_vipsmall_logo") forState:UIControlStateNormal];
//    [vipBtn setImage:Image_Named(@"ic_vipsmall_logo") forState:UIControlStateSelected];
//    [vipBtn addTarget:self action:@selector(goToVipAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.shadowRectIV addSubview:vipBtn];
//    self.vipBtn = vipBtn;
//    [self.vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.shadowRectIV);
//    }];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.nameLab addGestureRecognizer:gesture1];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.iconIV addGestureRecognizer:gesture2];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    if (self.modifyMsgBlock) {
        self.modifyMsgBlock();
    }
}

//- (void)goToVipAction {
//    if (self.vipClickBlock) {
//        self.vipClickBlock();
//    }
//}

- (void)setAction {
    SettingViewController *vc = [[SettingViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [SelectVC pushViewController:vc animated:YES];
}

@end
