//
//  UILabel+Category.h
//
//  Created by Hy on 16/8/26.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)
/**
 *  UILabel(简写)
 *
 *  @param title         文字
 *  @param font          字体大小
 *  @param color         颜色(HexString) 或 UIColor 
 *  @param textAlignment 默认 nil : NSTextAlignmentLeft
 *
 *  @return self
 */
+ (UILabel *)labelWithTitle:(NSString *)title font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;
/**
 修改label内容距 `top` `left` `bottom` `right` 边距
 */
//@property (nonatomic, assign) UIEdgeInsets yf_contentInsets;



/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
