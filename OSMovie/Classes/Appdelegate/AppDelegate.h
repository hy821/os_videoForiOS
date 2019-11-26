//
//  AppDelegate.h
//  OSMovie
//
//    Created by Rb_Developer on 2019/10/28.

//

#import <UIKit/UIKit.h>
#import "OOSTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) OOSTabBarController * tabBarVC;
- (void)restoreRootViewController:(UIViewController *)rootViewController;

@end

