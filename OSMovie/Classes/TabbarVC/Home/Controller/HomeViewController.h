//
//  HomeViewController.h
//  ABOSMovie
//
//    Created by Rb_Developer on 2017/10/30.

//

#import "OOSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : OOSBaseViewController

@end

@interface HomeNavBar: UIView

@property (nonatomic,copy) void(^loginBlock)(void);

- (void)refreshMsg;

@end


NS_ASSUME_NONNULL_END
