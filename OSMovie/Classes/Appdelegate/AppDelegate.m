//
//  AppDelegate.m
//  ABOSMovie
//
//    Created by Rb_Developer on 2017/10/28.

//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>
#import "UIImage+Extension.h"
#import "RealReachability.h"
#import "SplashScreenView.h"

@interface AppDelegate ()
@property (nonatomic,strong) AdmetaModel *advModel;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    
    OOSTabBarController *tabBar = [[OOSTabBarController alloc]init];
    self.window.rootViewController = tabBar;
    self.tabBarVC = tabBar;
    
    [GLobalRealReachability startNotifier];
    [USER_MANAGER configAndUpdateHosts];
    [self getSplashAdvMsg];
    [self configNavBar];
    [self updateUserAgent];
    [self.window makeKeyAndVisible];

    return YES;
}

//全局导航栏处理
-(void)configNavBar {
    [[UITabBar appearance] setBarTintColor:KCOLOR(@"#f6f6f6")];
    [[UITabBar appearance] setShadowImage:[UIImage createImageWithColor:UIColorRGB(233, 233, 233)]];
    UINavigationBar *navBar = [UINavigationBar appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [navBar setTitleTextAttributes:attrs];
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = KCOLOR(@"#333333");
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17.0];
    [barItem setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:itemAttrs forState:UIControlStateHighlighted];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setShadowImage:[UIImage createImageWithColor:UIColorRGB(233, 233, 233)]];
    [[UITabBar appearance] setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]]];
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor whiteColor]];
    [WRNavigationBar wr_setDefaultNavBarTintColor:KCOLOR(@"#333333")];
    [WRNavigationBar wr_setDefaultNavBarTitleColor:KCOLOR(@"#333333")];
    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleDefault];
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:NO];
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        WKWebView.appearance.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        WKWebView.appearance.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        WKWebView.appearance.scrollView.scrollIndicatorInsets = WKWebView.appearance.scrollView.contentInset;
        
    } else {
        // Fallback on earlier versions
    }
}

- (void)restoreRootViewController:(UIViewController *)rootViewController {
    [self.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    typedef void (^Animation)(void);
    UIWindow* window = self.window;
    rootViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    [UIView transitionWithView:window duration:0.8f options:UIViewAnimationOptionTransitionFlipFromLeft animations:animation completion:^(BOOL finished) {
        if(finished) {
            g_App.tabBarVC =  (OOSTabBarController*)rootViewController;
        }
    }];
}

- (void)updateUserAgent {
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    [USERDEFAULTS setObject:userAgent forKey:@"webUserAgent"];
    [USERDEFAULTS synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)getSplashAdvMsg {
    WS()
    [[ABSRequest request]getAdvDataWithUrl:[USERDEFAULTS objectForKey:HOST_ad] positionID:@"275488" success:^(ABSRequest *request, id response) {
//        SSLog(@"advData--->%@",response);
        if(response) {
            AdmetaModel *m = [AdmetaModel mj_objectWithKeyValues:response];
            weakSelf.advModel = m;
            [weakSelf showApiSplashAdv];
        }
    } failure:^(ABSRequest *request, NSString *errorMsg) {
        SSLog(@"advError--->%@",errorMsg);
    }];
}

- (void)showApiSplashAdv {
    [USER_MANAGER callBackAdvWithUrls:self.advModel.show_murls];
    SplashScreenView *advertiseView = [[SplashScreenView alloc] initWithFrame:self.window.bounds];
    advertiseView.advModel = self.advModel;
    [advertiseView showSplashScreenWithTime:3 andImgUrl:self.advModel.image_urls.firstObject];
}

@end
