//
//  LoginAlphaBtn.h
//
//    Created by Rb on 2019/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern CGFloat  const LoginAlphaBtnHeight;

@interface LoginAlphaBtn : UIView

-(instancetype)initWithTitle:(NSString*)title andBtnImage:(UIImage*)img andTarget:(id)target andAction:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
