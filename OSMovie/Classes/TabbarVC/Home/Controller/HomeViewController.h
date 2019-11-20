//
//  HomeViewController.h
//  OSMovie
//
//    Created by Rb on 2019/10/30.

//

#import "KSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : KSBaseViewController

@end

@interface HomeNavBar: UIView

@property (nonatomic,copy) void(^loginBlock)(void);

- (void)refreshMsg;

@end


NS_ASSUME_NONNULL_END
