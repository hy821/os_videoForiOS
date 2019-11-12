//
//  LoginAlphaBtn.m
//  MagicVideo
//
//  Created by young He on 2019/9/19.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "LoginAlphaBtn.h"
#import "UIButton+Category.h"

CGFloat  const LoginAlphaBtnHeight = 44;

@implementation LoginAlphaBtn

-(instancetype)initWithTitle:(NSString*)title andBtnImage:(UIImage*)img andTarget:(id)target andAction:(SEL)selector {
    if (self = [super init]) {
        [self creatWithTitle:title andBtnImage:img andTarget:target andAction:selector];
    }return self;
}

- (void)creatWithTitle:(NSString*)title andBtnImage:(UIImage*)img andTarget:(id)target andAction:(SEL)selector {
    
    UIView *loginAlphaView = [[UIView alloc]init];
    loginAlphaView.backgroundColor = KCOLOR(@"#ffffff");
    loginAlphaView.alpha = 0.2;
    loginAlphaView.layer.masksToBounds = YES;
    loginAlphaView.layer.cornerRadius = self.sizeH(LoginAlphaBtnHeight/2);
    [self addSubview:loginAlphaView];
    [loginAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
   
    UIButton * wxLoginBtn = [UIButton buttonWithTitle:title titleColor:KCOLOR(@"#ffffff") image:img font:18];
    [wxLoginBtn setBackgroundColor:Clear_Color forState:UIControlStateNormal];
    [wxLoginBtn setBackgroundColor:Clear_Color forState:UIControlStateHighlighted];
    wxLoginBtn.layer.masksToBounds = YES;
    wxLoginBtn.layer.cornerRadius = self.sizeH(LoginAlphaBtnHeight/2);
    wxLoginBtn.layer.borderColor = KCOLOR(@"#ffffff").CGColor;
    wxLoginBtn.layer.borderWidth = 1.5;
    [wxLoginBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:wxLoginBtn];
    [wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

@end
