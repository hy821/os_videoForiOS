//
//  UIColor+Tools.h
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到小
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};
@interface UIColor (Tools)
/**
 *  RGB Color
 *
 *  @param red   redColor
 *  @param green greenColor
 *  @param blue  blueColor
 *  @param alpha alpha
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithRGBAColorRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
/**
 *  十六进制color
 *
 *  @param hexString 十六进制
 *  @param alpha     alpha
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
/**
 *  十六进制color
 *
 *  @param hexString 十六进制
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;
/**
 *  通用蓝(1B88EE)
 *
 *  @return 0x1B88EE
 */
+ (UIColor *)normalBlue;
/**
 *  通用黑色(333333)
 *
 *  @return 0x333333
 */
+ (UIColor *)normalBlack;
/**
 *  通用淡黑色(999999)
 *
 *  @return 0x999999
 */
+ (UIColor *)normalGrayBlack;
/**
 *  通用灰色(666666)
 *
 *  @return 0x666666
 */
+ (UIColor *)normalGray;
/**
 *  通用Cell分割线(F5F5F5)
 *
 *  @return 0xFF5F5
 */
+ (UIColor *)normalDividerColor;
/**
 *  通用分割线(E1E1E1)
 *
 *  @return 0xE1E1E1
 */
+ (UIColor *)normalLineColor;
/**
 *  通用橙色(FF7139)
 *
 *  @return 0xFF7139
 */
+ (UIColor *)normalOrangeColor;
/**
 *  按钮通用橙色(FF6750)
 *
 *  @return 0xFF6750
 */
+ (UIColor *)normalBtnOrangeColor;

//获取图片主色调
+ (UIColor*)mostColor:(UIImage*)image;
@end
