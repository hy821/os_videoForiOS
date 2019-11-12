//
//  LoginTextField.m
//

#import "LoginTextField.h"
#import "UIImage+Extension.h"
#import "SSRequest.h"
#import "UILabel+Category.h"
#import "LoginAlphaBtn.h"

@interface LoginTextField()<UITextFieldDelegate>
@property (nonatomic,assign) TextFieldType type;
@property (nonatomic,copy) NSString * placeholder;
@property (nonatomic,strong) UIImageView *logoIV;
@property (nonatomic,strong) UILabel * headLab; //+86
@property (nonatomic,strong) UIButton * timeBtn;
@property (nonatomic,strong) UIButton * forgetPassWordBtn;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) NSInteger currentIndex;

@end
@implementation LoginTextField

-(instancetype)initWithPlaceholder:(NSString *)placeholder andStyle:(TextFieldType)type {
    if(self = [super init]) {
        self.type = type;
        self.placeholder = placeholder;
        [self createUI];
        [self makeMas];
    }return self;
}
-(void)createUI {
    self.layer.cornerRadius = self.sizeH(8);
    self.clipsToBounds = YES;
    self.layer.borderColor = KCOLOR(@"#ffffff").CGColor;
    self.layer.borderWidth = 1.5f;
    
    UIView *loginAlphaView = [[UIView alloc]init];
    loginAlphaView.backgroundColor = KCOLOR(@"#ffffff");
    loginAlphaView.alpha = 0.2;
    loginAlphaView.layer.masksToBounds = YES;
    loginAlphaView.layer.cornerRadius = self.sizeH(8);
    loginAlphaView.userInteractionEnabled = YES;
    [self addSubview:loginAlphaView];
    [loginAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.textField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
    
    if(self.type == GetCode_type) {
        [self addSubview:self.logoIV];
        self.currentIndex = 0;
        [self addSubview:self.timeBtn];
    }
    
    if (self.type == Normal_Type) {  //输入手机号
        [self addSubview:self.logoIV];
        [self addSubview:self.headLab];
    }
    
    if (self.type == Password_Type) {  //输入密码 带按钮
        [self addSubview:self.forgetPassWordBtn];
    }
    
}
-(void)makeMas {
    
    if(self.type == Email_Type) {
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(self.sizeW(12+5));
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(self.sizeW(-10));
            make.height.mas_equalTo(30.f);
        }];
    }
    
    if (self.type == Normal_Type || self.type == GetCode_type) {  //输入手机号 or 验证码
        [self.logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(self.sizeW(12));
            make.centerY.equalTo(self);
            make.width.equalTo(self.sizeW(0));
        }];
    }
    
    if(self.type == Normal_Type) {

        [self.headLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoIV.mas_right).offset(self.sizeW(8));
            make.centerY.equalTo(self);
            make.width.equalTo(self.sizeW(40));
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headLab.mas_right).offset(5);
            make.right.equalTo(self);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30.f);
        }];
        
    }else if (self.type == GetCode_type) {
        
        [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(self.sizeW(-5));
            make.centerY.equalTo(self);
            make.height.mas_equalTo(self.sizeH(24));
            make.width.mas_equalTo(self.sizeW(75));
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoIV.mas_right).offset(5);
            make.right.equalTo(self.timeBtn.mas_left).offset(-5.f);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30.f);
        }];
    }else if (self.type == Password_Type) {
        
        [self.forgetPassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.centerY.equalTo(self).offset(-3);
            make.height.mas_equalTo(self.sizeH(25));
            make.width.mas_equalTo(self.sizeW(65));
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.forgetPassWordBtn.mas_left).offset(-5.f);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30.f);
        }];
    }else if (self.type == SetPassword_Type) {
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.equalTo(self);
            make.height.mas_equalTo(30.f);
        }];
        
    }
}

#pragma mark--noti
-(void)textFieldChange:(NSNotification*)noti {
    UITextField * textField = noti.object;
    
    switch (self.type) {
        case Email_Type:
        {
            
        }
            break;
        case Normal_Type:
        {
            if(textField.text.length>11) {
                textField.text = [textField.text substringWithRange:NSMakeRange(0, 11)];
            }
        }
            break;
        case GetCode_type:
        {
            if(textField.text.length>6) {
                textField.text = [textField.text substringWithRange:NSMakeRange(0, 6)];
            }
        }
            break;
        case Password_Type:
        case SetPassword_Type:
        {
            if(textField.text.length == 12) {
                if(self.checkBlock){
                    self.checkBlock(textField.text);
                }
            }
            
            if(textField.text.length>12) {
                textField.text = [textField.text substringWithRange:NSMakeRange(0, 12)];
            }
        }
            break;
        default:
            break;
    }

    
    
    if(self.textChangeBlock){
        self.textChangeBlock(textField.text);
    }
}

- (void)setMobileText:(NSString *)mobileText {
    _mobileText = mobileText;
}

- (void)forgetPasswordAction {
    if (self.forgetPasswordBlock) {
        self.forgetPasswordBlock((self.textField.text.length>0) ? self.textField.text : @"");
    }
}

#pragma mark - lazyLoad
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.delegate = self;
        _textField.textColor = White_Color;
        _textField.font = Font_Size(17);

        NSString*holderText = self.placeholder;
        NSMutableAttributedString*placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                           value:White_Color
                           range:NSMakeRange(0,holderText.length)];
        _textField.attributedPlaceholder = placeholder;
        
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [topView setBarStyle:0];
        topView.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(2, 5, 50, 25);
        [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:DarkGray_Color forState:UIControlStateNormal];
        [btn setTitle:@"完成"forState:UIControlStateNormal];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
        [topView setItems:buttonsArray];
        [_textField setInputAccessoryView:topView];
        
        switch (self.type) {
            case Email_Type:
            {
                _textField.keyboardType = UIKeyboardTypeDefault;
            }
                break;
            case Normal_Type:
            {
                _textField.keyboardType = UIKeyboardTypeNumberPad;
            }
                break;
            case GetCode_type:
            {
                _textField.keyboardType = UIKeyboardTypeNumberPad;
//                _textField.keyboardType = UIKeyboardTypeDefault;
            }
                break;
            case Password_Type:
            {
                _textField.keyboardType = UIKeyboardTypeDefault;
                _textField.secureTextEntry = YES;
            }
            case SetPassword_Type:
            {
                _textField.keyboardType = UIKeyboardTypeDefault;
            }
                break;
            default:
                break;
        }
    }return _textField;
}

- (void)dismissKeyBoard {
    if(self.foldKeyBoardBlock) {
        self.foldKeyBoardBlock();
    }
}

-(UILabel *)headLab {
    if (!_headLab) {
        _headLab = [UILabel labelWithTitle:@"+86" font:17 textColor:KCOLOR(@"#ffffff") textAlignment:0];
    }return _headLab;
}

-(UIImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = [[UIImageView alloc] init];
        _logoIV.contentMode = UIViewContentModeScaleAspectFit;
        if(self.type == Normal_Type) {
            _logoIV.image = Image_Named(@"loginInputLogoPhone");
        }else if (self.type == GetCode_type) {
            _logoIV.image = Image_Named(@"loginInputLogoCode");
        }else {
            _logoIV.image = Image_Named(@"");
        }
    }return _logoIV;
}

-(UIButton *)timeBtn {
    if(_timeBtn == nil) {
        _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_timeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timeBtn setTitle:@"获取验证码" forState:UIControlStateSelected];
        [_timeBtn setTitleColor:KCOLOR(@"#ffffff") forState:UIControlStateNormal];
        [_timeBtn setTitleColor:KCOLOR(@"#ffffff") forState:UIControlStateSelected];
        _timeBtn.backgroundColor = Clear_Color;
        _timeBtn.titleLabel.font = Font_Size(12);
        _timeBtn.layer.cornerRadius = self.sizeH(12.f);
        _timeBtn.clipsToBounds = YES;
        _timeBtn.layer.borderColor = KCOLOR(@"#ffffff").CGColor;
        _timeBtn.layer.borderWidth = 1;
        [_timeBtn addTarget:self action:@selector(startAnimation:) forControlEvents:UIControlEventTouchUpInside];
    }return _timeBtn;
}

-(UIButton *)forgetPassWordBtn {
    if(_forgetPassWordBtn == nil) {
        _forgetPassWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPassWordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPassWordBtn setTitle:@"忘记密码" forState:UIControlStateSelected];
        [_forgetPassWordBtn setTitleColor:KCOLOR(@"#E95727") forState:UIControlStateNormal];
        [_forgetPassWordBtn setTitleColor:KCOLOR(@"#E95727") forState:UIControlStateSelected];
        _forgetPassWordBtn.backgroundColor = White_Color;
        _forgetPassWordBtn.titleLabel.font = Font_Size(12);
        _forgetPassWordBtn.layer.cornerRadius = self.sizeH(12.f);
        _forgetPassWordBtn.clipsToBounds = YES;
        _forgetPassWordBtn.layer.borderColor = KCOLOR(@"#E95727").CGColor;
        _forgetPassWordBtn.layer.borderWidth = 0.8f;
        [_forgetPassWordBtn addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    }return _forgetPassWordBtn;
}

-(void)startAnimation:(UIButton*)sender {
    if([self.timeBtn.currentTitle isEqualToString:@"获取验证码"]){
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", RegexestEmail];
        if(![regextestmobile evaluateWithObject:self.mobileText]){
            SSMBToast(@"请填写正确的邮箱", MainWindow);
            return;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self timeStart];
            [self.textField becomeFirstResponder];
        });
        

//        NSDictionary *dic = @{@"phone" : self.mobileText,
//                              @"ts": @([Tool getCurrentTimeSecsNum])
//        };
//
//        NSString *signStr = [NSString stringWithFormat:@"%@%@%@",self.mobileText,[Tool getCurrentTimeSecsString],KEY_SKEY];
//        SSGifShow(MainWindow, @"加载中");
//        [[SSRequest request] POSTAboutLogin:GetPhoneCodeUrl parameters:dic.mutableCopy signString:signStr success:^(SSRequest *request, NSDictionary *response) {
//
//            SSDissMissAllGifHud(MainWindow, YES);
//            [self timeStart];
//            [self.textField becomeFirstResponder];
//
//        } failure:^(SSRequest *request, NSString *errorMsg) {
//            SSDissMissAllGifHud(MainWindow, YES);
//            SSMBToast(errorMsg, MainWindow);
//        }];
    }
}

-(void)timeStart {
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.currentIndex = 60;
    [self.timeBtn setTitle:[NSString stringWithFormat:@"剩余%zd秒",self.currentIndex] forState:UIControlStateNormal];
    self.timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)timeRun {
    if(self.currentIndex == 1) {
        self.timeBtn.userInteractionEnabled = YES;
        [self.timeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        if(self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        return;
    }
    self.currentIndex--;
    [self.timeBtn setTitle:[NSString stringWithFormat:@"剩余%zd秒",self.currentIndex] forState:UIControlStateNormal];
}

-(void)startTimer {
    if(self.currentIndex != 0){
        if(self.timer)
        {
            [self.timer invalidate];
            self.timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)sinleRegist
{
    
    
}

-(void)lastDoForCode
{
    
}
-(void)netErrorToDo
{
    if([self.timeBtn.currentTitle isEqualToString:@"获取验证码"]){
        
    }
}

-(NSString *)text
{
    return self.textField.text;
}
-(void)pauseTimer{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
 
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
