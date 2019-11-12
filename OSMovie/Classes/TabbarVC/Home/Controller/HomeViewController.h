//
//  HomeViewController.h
//  OSMovie
//
//  Created by young He on 2019/10/30.
//  Copyright © 2019 youngHe. All rights reserved.
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
