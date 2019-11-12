//
//  UIButton+Category.h
//  ZhongRenBang-New
//
//  Created by 看楼听雨 on 16/8/26.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HorizenButton,VerticalButton;

@interface UIButton (Category)
/**
 *  仅有文字
 *
 *  @param title            文字
 *  @param titleColor       文字颜色
 *  @param bgColor          背景颜色
 *  @param highlightedColor 高亮颜色
 *  @param target           目标
 *  @param action           方法
 *
 *  @return self
 */
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor highlightedColor:(UIColor *)highlightedColor;

/**
 *  仅有图片
 *
 *  @param image         默认图片
 *  @param selectedImage 选中图片
 *
 *  @return self
 */
+ (UIButton *)buttonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage;

/**
 *  左边文字 右边图片
 *
 *  @param title      文字
 *  @param image      图片
 *  @param margeWidth 间距
 *
 *  @return self
 */
+ (HorizenButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image marge:(CGFloat)margeWidth;

/**
 *  左边图片 右边文字
 *
 *  @param title      文字
 *  @param titleColor 文字颜色
 *  @param image      图片
 *  @param font       字体大小
 *
 *  @return self
 */
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor image:(UIImage *)image font:(CGFloat)font;
/**
 *  上文字 下图片
 *
 *  @param title  title
 *  @param img    img
 *  @param width  width
 *  @param height height
 *
 *  @return self
 */
+ (VerticalButton *)buttonWithTitle:(NSString *)title img:(UIImage *)img;

+ (UIButton *)buttonWithFrame:(CGRect)frame Title:(NSString *)title Target:(id)target action:(SEL)action image:(NSString *)image backGroudImage:(NSString *)backGroudImage font:(CGFloat)font titleColor:(UIColor *)color;

/**
 *  设置不同状态下Button的背景色
 *
 *  @param backgroundColor Button的背景色
 *  @param state           Button的状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
+ (UIButton *)buttonWithType:(UIButtonType)type
                       title:(NSString *)title
                  titleColor:(UIColor *)titleColor
                   titleFont:(NSInteger)font
                   bordWidth:(float)width
                   bordColor:(UIColor *)color
                cornerRadius:(float)corRadius;

+ (UIButton *)buttonWithTitle:(NSString *)title
                       Target:(id)target
                       action:(SEL)action
                        image:(NSString *)image
               backGroudImage:(NSString *)backGroudImage
                         font:(CGFloat)font
                   titleColor:(UIColor *)color;

@end
