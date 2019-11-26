//
//  OOSTabBarController.m
//


#import "OOSTabBarController.h"
#import "OOSBaseViewController.h"
#import "OOSBaseNavViewController.h"
#import "OOSTabBar.h"
#import "KSLayerAnimation.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

@interface OOSTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic,assign) NSInteger indexFlag;

@end

@implementation OOSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configVC];
    self.delegate = self;
}

-(void)configVC {
    NSArray *classNames = @[@"HomeViewController",@"MineViewController"];
    NSArray *titles = @[@"首页",@"我的"];
    NSArray *normalImg = @[@"tab_HomeUn",@"tab_MineUn"];
    NSArray *selectImg = @[@"tab_Home",@"tab_Mine"];
    
    for(int i=0;i<classNames.count;i++) {
        Class class=NSClassFromString(classNames[i]);
        OOSBaseViewController * root=[[class alloc]init];
        [self addChildController:root title:titles[i] imageName:normalImg[i] selectedImageName:selectImg[i] navVc:[OOSBaseNavViewController class]];
    }
}
- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc {
    
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置一下选中tabbar文字颜色
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : KCOLOR(@"#D96139") }forState:UIControlStateSelected];
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : KCOLOR(@"#403632") }forState:UIControlStateNormal];
    UINavigationController * nav = [[navVc alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate { //旋转
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0,*)) {
        return UIStatusBarStyleDarkContent;
    }else {
        return UIStatusBarStyleDefault;
    }
}

-(UIViewController*)childViewControllerForStatusBarStyle {
    UINavigationController * nav = self.selectedViewController;
    return nav.topViewController;
}

#pragma mark- UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//    NSInteger  index = [self.viewControllers indexOfObject:viewController];
//    BOOL isLogin = IS_LOGIN;
//    BOOL isNotOne = index==0?YES:NO;
//    if((!isLogin)&&(!isNotOne)){
//        self.indexFlag = 0;
//        [self gotoLogin];
//        return NO;
//
//    }else {
//        return YES;
//    }

    return YES;

}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (self.indexFlag != index) {
        [self animationWithIndex:index];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:TabBarRefresh object:@(index)];
    }
}

- (void)animationWithIndex:(NSInteger) index {
    [KSLayerAnimation animationWithTabbarIndex:index type:BounceAnimation];
    self.indexFlag = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
