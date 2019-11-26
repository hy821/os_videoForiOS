//
//  OOSBaseNavViewController.m


#import "OOSBaseNavViewController.h"
#import "UIBarButtonItem+Extension.h"

@interface OOSBaseNavViewController ()

@end

@implementation OOSBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
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
                UIBarButtonItem *backButton = [UIBarButtonItem itemWithImageName:@"back_black" highImageName:@"back_black" target:self action:@selector(back)];
                viewController.navigationItem.leftBarButtonItems =@[negativeSpacer,backButton];
            }
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
