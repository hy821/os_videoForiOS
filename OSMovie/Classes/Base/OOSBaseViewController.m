//
//  OOSBaseViewController.m

#import "OOSBaseViewController.h"
#import "OOSBaseNavViewController.h"

#import "UIBarButtonItem+Extension.h"
#import "LoginViewController.h"

#define  NAVIBARWIDE                10                         //ios7以后导航栏按钮调整

@interface OOSBaseViewController ()

@end

@implementation OOSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNetError = SSNetLoading_state;
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.contentMode = UIViewContentModeBottom;
}

/*
 在info.plist文件中 View controller-based status bar appearance
 -> YES，控制器对状态栏设置的优先级高于application
 -> NO，以application为准，控制器设置状态栏prefersStatusBarHidden是无效的的根本不会被调用
 */

-(BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2f animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

#pragma mark--设置导航栏名字
-(UILabel*)setTitleName:(NSString *)name andFont:(CGFloat)fontH
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 140, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:fontH];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = name;
    titleLabel.userInteractionEnabled = YES;
    self.navigationItem.titleView=titleLabel;
    return titleLabel;
}

#pragma mark--设置导航栏按钮
-(UIButton*)setNavButtonImageName:(NSString *)imageName andIsLeft:(BOOL)isLeft andTarget:(id)target andAction:(SEL)selector
{
    self.view.contentMode = UIViewContentModeBottom;
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 40, 40);
    btn.showsTouchWhenHighlighted = YES;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:isLeft?UIControlContentHorizontalAlignmentLeft:UIControlContentHorizontalAlignmentRight];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    if(isLeft)
    {
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                           target:nil action:nil];
            negativeSpacer.width = -10;//这个数值可以根据情况自由变化
            self.navigationItem.leftBarButtonItems = @[negativeSpacer, item];
        }else{
            self.navigationItem.leftBarButtonItem = item ;
        }
        
    }else{
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                           target:nil action:nil];
            negativeSpacer.width = -NAVIBARWIDE;//这个数值可以根据情况自由变化
            self.navigationItem.rightBarButtonItems = @[negativeSpacer, item];
        }else{
            self.navigationItem.rightBarButtonItem = item ;
        }
    }
    return btn;
}

-(void)setNoNavBarBackBtn {
    UIButton * backBtn = [[UIButton alloc]init];
    [backBtn setImage:Image_Named(@"back_black") forState:UIControlStateNormal];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(11);
        make.top.equalTo(self.view).offset(34);
        make.width.mas_equalTo(45.f);
        make.height.mas_equalTo(45.f);
    }];
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setPresentVCBackBtn {
    if(iOS11Later) {
        UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame = CGRectMake(0, 0, 40, 44);
        [firstButton setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
        
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }else {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -15;
        //设置导航栏的按钮
        UIBarButtonItem *backButton = [UIBarButtonItem itemWithImageName:@"back_black" highImageName:@"back_black" target:self action:@selector(dissmiss)];
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
    }
}

-(void)dissmiss{
    [self.view endEditing:YES];
    if([g_App.window.rootViewController isKindOfClass:[UITabBarController class]]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        OOSTabBarController * tabBar = [[OOSTabBarController alloc]init];
        //        g_App.tabBarVC = tabBar;
        [g_App restoreRootViewController:tabBar];
    }
}

#pragma mark--处理导航栏按钮间距
-(void)resoleBarItemForSpaceWithItem:(UIBarButtonItem *)item andIsLeft:(BOOL)isLeft {
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                       target:nil action:nil];
        negativeSpacer.width = -NAVIBARWIDE;//这个数值可以根据情况自由变化
        if(isLeft)
        {
            self.navigationItem.leftBarButtonItems = @[negativeSpacer, item];
        }else
        {
            self.navigationItem.rightBarButtonItems = @[negativeSpacer,item];
        }
        
    }else{
        if(isLeft){
            self.navigationItem.leftBarButtonItem = item ;
        }else
        {
            self.navigationItem.rightBarButtonItem = item;
        }
    }
    
}

#pragma mark--跳转操作
-(void)pushController:(OOSBaseViewController *)view{
    OOSBaseNavViewController * base = (OOSBaseNavViewController*)g_App.tabBarVC.selectedViewController;
    view.hidesBottomBarWhenPushed = YES;
    [base pushViewController:view animated:YES];
}

-(void)presentController:(UIViewController *)view
{
    OOSBaseNavViewController * base = (OOSBaseNavViewController*)g_App.tabBarVC.selectedViewController;
    OOSBaseViewController * baseView = (OOSBaseViewController*)base.topViewController;
    [baseView presentViewController:view animated:YES completion:nil];
}

#pragma mark--导航栏按钮纯文字
-(UIButton*)setNavWithTitle:(NSString *)title Font:(CGFloat)font andTextColor:(NSString*)color andIsLeft:(BOOL)isLeft andTarget:(id)target andAction:(SEL)selector
{
    UIButton * finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = [Tool widthOfString:title font:Font_Size(font) height:12]+10;
    finishBtn.frame = CGRectMake(0, 5,width, 55/2.0);
    [finishBtn setContentHorizontalAlignment:isLeft?UIControlContentHorizontalAlignmentLeft:UIControlContentHorizontalAlignmentRight];
    finishBtn.titleLabel.font = Font_Size(font);
    [finishBtn setTitleColor:KCOLOR(color) forState:UIControlStateNormal];
    [finishBtn setTitleColor:KCOLOR(color) forState:UIControlStateSelected];
    [finishBtn setTitle:title forState:UIControlStateNormal];
    [finishBtn setTitle:title forState:UIControlStateSelected];
    if(target&&selector){
        [finishBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithCustomView:finishBtn];
    [self resoleBarItemForSpaceWithItem:barItem andIsLeft:isLeft];
    return finishBtn;
}

-(void)dealloc {
    SSLog(@"%@%s释放",[self getClassName],__func__);
}

- (NSString *)getClassName {
    return NSStringFromClass([self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)endRefreshPulling:(UIScrollView *)scrollView {
    if(scrollView.isDragging) {
        [scrollView.mj_header setState:MJRefreshStateIdle];
    }
}

//支持旋转
- (BOOL)shouldAutorotate {
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
