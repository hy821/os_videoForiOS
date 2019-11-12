//
//  KSBaseNavViewController.m


#import "KSBaseNavViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface KSBaseNavViewController ()

@end

@implementation KSBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {// 如果现在push的不是栈底控制器(最先push进来的那个控制器)

//        viewController.hidesBottomBarWhenPushed = [viewController isKindOfClass:[CEPlayerViewController class]]?NO:YES;

//        if([viewController isKindOfClass:[SearchViewController  class]]
//           |[viewController isKindOfClass:[ModifiedDataViewController  class]]
//           |[viewController isKindOfClass:[GoodsViewController  class]]
//           |[viewController isKindOfClass:[PaySuccessViewController  class]]
//           |[viewController isKindOfClass:[MapViewController  class]]
//           |[viewController isKindOfClass:[FlockRedPacketsViewController  class]]
//           |[viewController isKindOfClass:[CEBaseWebViewController  class]]
//           |[viewController isKindOfClass:[ShopDetailViewController  class]]
//           |[viewController isKindOfClass:[YLMRedPacketDetailViewController class]]
//           |[viewController isKindOfClass:[CEPlayerViewController class]])
//        {
//
//
//        }else{
            if(@available(iOS 11.0, *))
            {
                UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
                firstButton.frame = CGRectMake(0, 0, 50, 50);
                [firstButton setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
                [firstButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
                firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
                
                UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
                
                viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
            }else{
                UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
                negativeSpacer.width = -15;
                //设置导航栏的按钮
                UIBarButtonItem *backButton = [UIBarButtonItem itemWithImageName:@"back_black" highImageName:@"back_black" target:self action:@selector(back)];
                viewController.navigationItem.leftBarButtonItems =@[negativeSpacer,backButton];
            }
//        }
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
        
    }
    [super pushViewController:viewController animated:animated];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0,*)) {
        return UIStatusBarStyleDarkContent;
    }else {
        return UIStatusBarStyleDefault;
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
