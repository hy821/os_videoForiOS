//
//  UIButton+Category.m
//  ZhongRenBang-New
//
//  Created by 看楼听雨 on 16/8/26.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "UIButton+Category.h"
#import "HorizenButton.h"
#import "UIColor+Tools.h"
#import "VerticalButton.h"

@implementation UIButton (Category)

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor highlightedColor:(UIColor *)highlightedColor;
{
    UIButton *button = [self buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:title forState:(UIControlStateNormal)];
    [button setTitle:title forState:(UIControlStateSelected)];

    if (bgColor) {
        [button setBackgroundColor:bgColor];
    }
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:(UIControlStateNormal)];
        [button setTitleColor:titleColor forState:(UIControlStateSelected)];
    }
    
    if (highlightedColor) {
        [button setTitleColor:highlightedColor forState:(UIControlStateHighlighted)];
    }
    return button;
}

+ (UIButton *)buttonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage

{
    UIButton *button = [self buttonWithType:(UIButtonTypeCustom)];
    [button setImage:image forState:(UIControlStateNormal)];
    
    if (selectedImage) {
        [button setImage:selectedImage forState:(UIControlStateSelected)];
    }
    return button;
}

+ (HorizenButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image marge:(CGFloat)margeWidth
{
    HorizenButton *button = [HorizenButton buttonWithType:UIButtonTypeCustom];
    button.margeWidth = margeWidth;
    [button setTitle:title forState:(UIControlStateNormal)];
    button.titleLabel.font = Font_Size(15);
    [button setTitleColor:KCOLOR(@"#333333") forState:(UIControlStateNormal)];
    [button setImage:image forState:(UIControlStateNormal)];
    [button sizeToFit];
    
    return button;
}
+ (UIButton *)buttonWithType:(UIButtonType)type
                       title:(NSString *)title
                  titleColor:(UIColor *)titleColor
                   titleFont:(NSInteger)font
                   bordWidth:(float)width
                   bordColor:(UIColor *)color
                cornerRadius:(float)corRadius{
    
    UIButton *btn = [UIButton buttonWithType:type?type:UIButtonTypeCustom];
    [btn setTitle:title?title:@"" forState:UIControlStateNormal];
    [btn setTitleColor:titleColor?titleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font?font:12];
    
    btn.layer.borderWidth = width?width:1;
    btn.layer.cornerRadius = corRadius?corRadius:4;
    btn.layer.borderColor = color?color.CGColor:[UIColor lightGrayColor].CGColor;
    btn.layer.masksToBounds = YES;
    
    return btn;
}

+ (VerticalButton *)buttonWithTitle:(NSString *)title img:(UIImage *)img
{
    VerticalButton *button = [VerticalButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitle:title forState:(UIControlStateNormal)];

    if (img) {
        [button setImage:img forState:(UIControlStateNormal)];
    }
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor image:(UIImage *)image font:(CGFloat)font
{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    
    // 设置高亮时的背景
    button.adjustsImageWhenHighlighted = NO;

    // 设置间距
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame Title:(NSString *)title Target:(id)target action:(SEL)action image:(NSString *)image backGroudImage:(NSString *)backGroudImage font:(CGFloat)font titleColor:(UIColor *)color{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = frame;
    
    //设置文字
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    //添加点击事件
    if (target) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    //设置图片
    if (image) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    //设置背景图片
    if (backGroudImage) {
        [button setBackgroundImage:[UIImage imageNamed:backGroudImage] forState:UIControlStateNormal];
    }
    //设置字体
    if (font) {
        button.titleLabel.font = [UIFont systemFontOfSize:font];
    }
    
    //设置字体颜色
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    return button;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[self imageWithColor:backgroundColor] forState:state];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIButton *)buttonWithTitle:(NSString *)title Target:(id)target action:(SEL)action image:(NSString *)image backGroudImage:(NSString *)backGroudImage font:(CGFloat)font titleColor:(UIColor *)color {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    //设置文字
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    //添加点击事件
    if (target) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    //设置图片
    if (image) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    //设置背景图片
    if (backGroudImage) {
        [button setBackgroundImage:[UIImage imageNamed:backGroudImage] forState:UIControlStateNormal];
    }
    //设置字体
    if (font) {
        button.titleLabel.font = [UIFont systemFontOfSize:font];
    }
    
    //设置字体颜色
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    return button;
}


@end
