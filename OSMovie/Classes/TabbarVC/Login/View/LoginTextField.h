//
//  LoginTextField.h
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, TextFieldType) {
    Normal_Type,//纯文本   输入手机号
    GetCode_type,// 输入验证码 带验证码按钮
    Password_Type,  //输入密码 带忘记密码按钮
    SetPassword_Type, //设置密码 纯文字
    Email_Type  //Email
};
typedef void(^TextLengthBlock)(NSString * text);
typedef void(^TextChangeBlock)(NSString * text);

@interface LoginTextField : UIView

@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) UIFont * textFont;
@property (nonatomic,copy) TextLengthBlock checkBlock;
@property (nonatomic,copy) TextChangeBlock textChangeBlock;
@property (nonatomic,copy) NSString * mobileText;
@property (nonatomic,copy) void (^receieveBlock)(BOOL isAllow);
@property (nonatomic,assign) BOOL isAllowTap;

@property (nonatomic,copy) void (^forgetPasswordBlock)(NSString *phoneNum);

-(instancetype)initWithPlaceholder:(NSString *)placeholder andStyle:(TextFieldType)type;
-(void)startTimer;
-(void)pauseTimer;
-(NSString*)text;
-(void)netErrorToDo;

//点击完成 收起键盘
@property (nonatomic,copy) void(^foldKeyBoardBlock)(void);

@end
