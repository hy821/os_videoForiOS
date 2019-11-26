//
//  LoginViewController.m
//
//    Created by Rb_Developer on 2019/9/18.
//

#import "LoginViewController.h"
#import "UILabel+Category.h"
#import "UIButton+Category.h"
#import "LoginTextField.h"
#import "M80AttributedLabel.h"

@interface LoginViewController()

@property (nonatomic,weak) LoginTextField *emailTF;
@property (nonatomic,weak) LoginTextField *codeTF;
@property (nonatomic,weak) UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self initUI];
}

- (void)initUI {
    self.view.backgroundColor = ThemeColor;
    
    UILabel *titleLab = [UILabel labelWithTitle:@"邮箱登录" font:15 textColor:KCOLOR(@"#DC4E0F") textAlignment:1];
    [self.view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset([self statusBarHeight] + self.sizeH(10));
    }];
    
    UIButton *backBtn = [UIButton buttonWithImage:Image_Named(@"back_black") selectedImage:Image_Named(@"back_black")];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLab);
        make.left.equalTo(self.view).offset(self.sizeW(15));
    }];
    
    UIImageView *mainIV = [[UIImageView alloc]initWithImage:Image_Named(@"logo")];
    mainIV.layer.masksToBounds = YES;
    mainIV.layer.cornerRadius = self.sizeW(15);
    [self.view addSubview:mainIV];
    
    [mainIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(titleLab.mas_bottom).offset(self.sizeH(48));
        make.width.height.equalTo(self.sizeW(100));
    }];
    
    LoginTextField *emailTF = [[LoginTextField alloc]initWithPlaceholder:@"请输入邮箱" andStyle:Email_Type];
    WS()
    emailTF.textChangeBlock = ^(NSString *text) {
        weakSelf.codeTF.mobileText = text;
    };
    emailTF.foldKeyBoardBlock = ^{
        [weakSelf.view endEditing:YES];
    };
    [self.view addSubview:emailTF];
    self.emailTF = emailTF;
    [self.emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainIV.mas_bottom).offset(self.sizeH(30));
        make.left.equalTo(self.view).offset(self.sizeW(55));
        make.right.equalTo(self.view).offset(self.sizeW(-55));
        make.height.mas_equalTo(self.sizeH(46));
    }];
    
    LoginTextField *codeTF = [[LoginTextField alloc]initWithPlaceholder:@"请输入验证码" andStyle:GetCode_type];
    [self.view addSubview:codeTF];
    self.codeTF = codeTF;
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailTF.mas_bottom).offset(self.sizeH(25));
        make.left.right.height.equalTo(self.emailTF);
    }];
    codeTF.foldKeyBoardBlock = ^{
        [weakSelf.view endEditing:YES];
    };
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = Font_Size(16);
    [loginBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [loginBtn setTitleColor:White_Color forState:UIControlStateSelected];
    [loginBtn setBackgroundColor:Orange_ThemeColor forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:Orange_ThemeColor forState:UIControlStateHighlighted];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = self.sizeH(23);
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTF.mas_bottom).offset(self.sizeH(56));
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.sizeH(168));
        make.height.equalTo(self.sizeH(46));
    }];
}

- (void)loginBtnAction {
    if(self.emailTF.text.length==0) {
        SSMBToast(@"请输入正确的邮箱", MainWindow);
        return;
    }
    if(self.codeTF.text.length==0) {
        SSMBToast(@"请输入验证码", MainWindow);
        return;
    }
    
    SSGifShow(MainWindow, @"Loading");
    WS()
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SSDissMissMBHud(MainWindow, YES);
        [weakSelf loginCheck];
    });
}

- (void)loginCheck {
    if ([self.codeTF.text isEqualToString:@"123456"]) {  
        SSMBToast(@"登录成功", MainWindow);
        [USER_MANAGER loginSuccess];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        SSMBToast(@"密码错误, 请重试~", MainWindow);
    }
    
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
