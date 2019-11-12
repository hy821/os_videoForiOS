//
//  Helper.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

//字符串文字的长度
+(CGFloat)widthOfString:(NSString *)string font:(UIFont*)font height:(CGFloat)height;

//字符串文字的高度
+(CGFloat)heightOfString:(NSString *)string font:(UIFont*)font width:(CGFloat)width;

//字符串文字的label bounds
+(CGRect)boundsOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;

@end


