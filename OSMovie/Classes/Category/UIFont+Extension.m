//
//  UIFont+Extension.m
//

#import "UIFont+Extension.h"
#define BXScreenW [UIScreen mainScreen].bounds.size.width
@implementation UIFont (Extension)
+ (UIFont *)fontWithDevice:(CGFloat)fontSize {
    if (BXScreenW > 375) {
        fontSize = fontSize + 3;
    }else if (BXScreenW == 375){
        fontSize = fontSize + 1.5;
    }else if (BXScreenW == 320){
        fontSize = fontSize;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

/**
 *  专门为客户性别，年龄电话写的
 */
+ (UIFont *)fontWithCustomer:(CGFloat)fontSize {
    if (BXScreenW > 375) {
        fontSize = fontSize + 2;
    }else if (BXScreenW == 375){
        fontSize = fontSize + 1.5;
    }else if (BXScreenW == 320){
        fontSize = fontSize;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

+ (UIFont *)navItemFontWithDevice:(CGFloat)fontSize {
    if (BXScreenW > 375) {
        fontSize = fontSize + 2;
    }else if (BXScreenW == 375){
        fontSize = fontSize + 1;
    }else if (BXScreenW == 320){
        fontSize = fontSize;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

+ (UIFont *)fontWithTwoLine:(CGFloat)fontSize {
    if (BXScreenW > 375) {
        fontSize = fontSize + 2;
    }else if (BXScreenW == 375){
        fontSize = fontSize + 1;
    }else if (BXScreenW == 320){
        fontSize = fontSize;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

+ (UIFont *)insuranceCellFont:(CGFloat)fontSize {
    if (BXScreenW > 375) {
        fontSize = fontSize + 3.5;
    }else if (BXScreenW == 375){
        fontSize = fontSize + 2;
    }else if (BXScreenW == 320){
        fontSize = fontSize;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return font;
}

@end
