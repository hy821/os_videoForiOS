//
//  AppDelegate.h
//  OSMovie
//
//    Created by Rb on 2019/10/28.

//

#import <UIKit/UIKit.h>
#import "KSTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) KSTabBarController * tabBarVC;
- (void)restoreRootViewController:(UIViewController *)rootViewController;

@end

