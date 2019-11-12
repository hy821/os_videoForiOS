//
//  AppDelegate.h
//  OSMovie
//
//  Created by young He on 2019/10/28.
//  Copyright © 2019 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) KSTabBarController * tabBarVC;
- (void)restoreRootViewController:(UIViewController *)rootViewController;

@end

