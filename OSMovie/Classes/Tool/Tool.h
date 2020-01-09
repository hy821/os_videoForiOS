//
//  Tool.h
//  AnXin
//
//  Created by wt on 14-2-28.
//  Copyright (c) 2014年 wt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <CoreFoundation/CoreFoundation.h>
// In bytes
#define FileHashDefaultChunkSizeForReadingData 4096

// Extern
#if defined(__cplusplus)
#define FILEMD5HASH_EXTERN extern "C"
#else
#define FILEMD5HASH_EXTERN extern
#endif

FILEMD5HASH_EXTERN CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
                                                         size_t chunkSizeForReadingData);

@interface Tool : NSObject

//颜色值转换UIColor(16进制) ，如#ffffff转  whiteColor
+(UIColor*)colorConvertFromString:(NSString*)value;
/**  MD5加密 */
+ (NSString *)md5:(NSString *)srcString;
/**MD5文件加密 */
+(NSString *)computeMD5HashOfFileInPath:(NSString *) filePath;
/** 文件大小 */
+ (long long)fileSizeAtPath:(NSString*) filePath;
/**判断字符串是否为空 */
+ (NSString*)strOrEmpty:(NSString*)str;
/**数据文件路径 */
+ (NSString *)dataFilePath:(NSString *)_str;
/**判断电话号码 */
+ (BOOL)validatePhone:(NSString *)phone;
/**判断email */
+ (BOOL)validateEmail:(NSString *)email;
/**  判断是否是汉字 */
+ (BOOL)isOrChinese:(NSString *)chinese;
/**时间格式 */
+ (NSDate*)getShortDateFormString:(NSString*)str;
+ (NSDate*)getDateFormString:(NSString*)str;
+ (NSDate*)getDateAndTimeFormString:(NSString*)str;
+ (NSDate*)getTimeFormString:(NSString*)str;
+ (NSString*)getStringFormDate:(NSDate*)date;
//评论用到, 不要改动
+ (NSString*)getStringFormDateAndTime:(NSDate*)date;
+ (NSString*)getStringTimeAndWeekFormDate:(NSDate*)date;
+ (NSString*)getStringMonthAndDayFormDate:(NSDate*)date;
+ (NSString*)getShortStringTimeAndWeekFormDate:(NSDate*)date;
//获取当前时间秒数 数字
+ (long long)getCurrentTimeSecsNum;
//获取当前时间 秒数 字符串
+ (NSString *)getCurrentTimeSecsString;
+ (NSString *)dateStringForAdvClickCacheKey;
// 数组格式化成字符串
+ (NSString*)arrayChangeToString:(NSArray*)array withSplit:(NSString*)split;
+ (NSArray*)changeStringToArray:(NSString*)string;
+ (NSString *)displayCache;
+ (BOOL)showGuideView;
//code适配
+ (void)codeAutoWithLeft:(CGFloat)left andRight:(CGFloat)right andTop:(CGFloat)top andBottom:(CGFloat)bottom andWidth:(CGFloat)width andHeight:(CGFloat)height;
//渐变色
typedef NS_ENUM(NSInteger, DirectionStyle){
    DirectionStyleToUnder = 0,  //向下
    DirectionStyleToUn = 1      //向上
};
/**
 *  渐变色
 *  @param red              红色
 *  @param green            绿色
 *  @param blue             蓝色
 *  @param startAlpha       开始的透明度
 *  @param endAlpha         结束的透明度
 *  @param direction        方向
 *  @param frame            大小
 */
+ (void)gradientColorWithRed:(CGFloat)red
                          green:(CGFloat)green
                           blue:(CGFloat)blue
                     startAlpha:(CGFloat)startAlpha
                       endAlpha:(CGFloat)endAlpha
                      direction:(DirectionStyle)direction
                          frame:(CGRect)frame
                           view:(UIImageView*)objIV;


//获取当前时间毫秒数 数字
+ (long long)getCurrentTimeMillsNum;

//data转Dic
+ (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData;



//字符串文字的长度
+(CGFloat)widthOfString:(NSString *)string font:(UIFont*)font height:(CGFloat)height;

//字符串文字的高度
+(CGFloat)heightOfString:(NSString *)string font:(UIFont*)font width:(CGFloat)width;

//字符串文字的label bounds
+(CGRect)boundsOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;



//MARK: 将saveBase64编码中的"-"，"_"字符串转换成"+"，"/"，字符串长度余4倍的位补"="
+ (NSData*)safeUrlBase64Decode:(NSString*)safeUrlbase64Str;

#pragma - 因为Base64编码中包含有+,/,=这些不安全的URL字符串,所以要进行换字符
+(NSString*)safeUrlBase64Encode:(NSData*)data;

@end
