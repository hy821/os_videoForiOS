//
//  LoginAlphaBtn.h
//  MagicVideo
//
//  Created by young He on 2019/9/19.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern CGFloat  const LoginAlphaBtnHeight;

@interface LoginAlphaBtn : UIView

-(instancetype)initWithTitle:(NSString*)title andBtnImage:(UIImage*)img andTarget:(id)target andAction:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
