//
//  UILabel+Category.m
//
//  Created by Hy on 16/8/26.
//  Copyright © 2016年 XJ. All rights reserved.
//

#import "UILabel+Category.h"
#import "UIColor+Tools.h"
#import <objc/runtime.h>
/// 获取UIEdgeInsets在水平方向上的值
//CG_INLINE CGFloat
//UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
//    return insets.left + insets.right;
//}
//
///// 获取UIEdgeInsets在垂直方向上的值
//CG_INLINE CGFloat
//UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
//    return insets.top + insets.bottom;
//}
//
//CG_INLINE void
//ReplaceMethod(Class _class, SEL _originSelector, SEL _newSelector) {
//    Method oriMethod = class_getInstanceMethod(_class, _originSelector);
//    Method newMethod = class_getInstanceMethod(_class, _newSelector);
//    BOOL isAddedMethod = class_addMethod(_class, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
//    if (isAddedMethod) {
//        class_replaceMethod(_class, _newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
//    } else {
//        method_exchangeImplementations(oriMethod, newMethod);
//    }
//}

@implementation UILabel (Category)

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        ReplaceMethod([self class], @selector(drawTextInRect:), @selector(yf_drawTextInRect:));
//        ReplaceMethod([self class], @selector(sizeThatFits:), @selector(yf_sizeThatFits:));
//    });
//}
//
//- (void)yf_drawTextInRect:(CGRect)rect {
//    UIEdgeInsets insets = self.yf_contentInsets;
//    [self yf_drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
//}
//
//- (CGSize)yf_sizeThatFits:(CGSize)size {
//    if (CGSizeEqualToSize(size, CGSizeZero)) {
//        NSAssert(NO, @"label size can not be CGSizeZero");
//    }
//    UIEdgeInsets insets = self.yf_contentInsets;
//    size = [self yf_sizeThatFits:CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(insets), size.height-UIEdgeInsetsGetVerticalValue(insets))];
//    size.width += UIEdgeInsetsGetHorizontalValue(insets);
//    size.height += UIEdgeInsetsGetVerticalValue(insets);
//    return size;
//}
//
//const void *kAssociatedYf_contentInsets;
//- (void)setYf_contentInsets:(UIEdgeInsets)yf_contentInsets {
//    objc_setAssociatedObject(self, &kAssociatedYf_contentInsets, [NSValue valueWithUIEdgeInsets:yf_contentInsets] , OBJC_ASSOCIATION_RETAIN);
//}
//
//- (UIEdgeInsets)yf_contentInsets {
//    return [objc_getAssociatedObject(self, &kAssociatedYf_contentInsets) UIEdgeInsetsValue];
//}

+ (UILabel *)labelWithTitle:(NSString *)title font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;
{
    UILabel *label = [self new];
    label.text = title ? title : @"";
    label.font = Font_Size(font);
    label.textAlignment = textAlignment ? textAlignment : NSTextAlignmentLeft;
    if ([color isKindOfClass:[UIColor class]]) {
        label.textColor = color;
    }else if ([color isKindOfClass:[NSString class]])
    {
        label.textColor = color;
    }
    return label;
}


+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    if (labelText) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:space];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        label.attributedText = attributedString;
        [label sizeToFit];
    }
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    if (labelText) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        label.attributedText = attributedString;
        [label sizeToFit];
    }
}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}


@end
