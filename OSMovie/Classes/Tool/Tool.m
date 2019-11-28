//
//  Tool.m
//  AnXin
//
//  Created by wt on 14-2-28.
//  Copyright (c) 2014年 wt. All rights reserved.
//

#import "Tool.h"
#import "CommonCrypto/CommonDigest.h"
// Standard library
#include <stdint.h>
#include <stdio.h>
// Core Foundation
#include <CoreFoundation/CoreFoundation.h>
// Cryptography
#include <CommonCrypto/CommonDigest.h>

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
                                      size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,
                      (const void *)buffer,
                      (CC_LONG)readBytesCount);
    }
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}


@implementation Tool

+(UIColor*)colorConvertFromString:(NSString*)value{
    if([value length]<7)return [UIColor whiteColor];
    
    SEL blackSel = NSSelectorFromString(value);
    if ([UIColor respondsToSelector: blackSel]){
        UIColor* color  = [UIColor performSelector:blackSel];
        if(color!=nil)
            return color;
    }
    
    NSRange range;
    range.location=1;
    range.length=2;
    NSString* r=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
    range.location=3;
    NSString* g=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
    range.location=5;
    NSString* b=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
    
    
    float rColor=0;
    float gColor=0;
    float bColor=0;
    float alpha=1;
    
    [[NSScanner scannerWithString:r] scanHexFloat:&rColor];
    [[NSScanner scannerWithString:g] scanHexFloat:&gColor];
    [[NSScanner scannerWithString:b] scanHexFloat:&bColor];
    
    
    rColor=rColor / 255;
    gColor=gColor / 255;
    bColor=bColor / 255;
    
    
    if([value length]==9){
        range.location=7;
        NSString* a=[NSString stringWithFormat:@"0x%@",[value substringWithRange:range]];
        
        [[NSScanner scannerWithString:a] scanHexFloat:&alpha];
        
        alpha=alpha / 255;
    }
    
    return [UIColor colorWithRed:rColor green:gColor blue:bColor alpha:alpha];
}

+(NSString *)md5:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

+ (NSString *)computeMD5HashOfFileInPath:(NSString *) filePath
{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)filePath, FileHashDefaultChunkSizeForReadingData);
}

+ (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//判空操作的代码
+ (NSString*)strOrEmpty:(NSString*)str{
	return (str==nil?@"":str);
}

// 数据文件路径
+ (NSString *)dataFilePath:(NSString *)str {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:str];
}

//判断电话号码
+ (BOOL)validatePhone:(NSString *)phone {
    NSString *emailRegex = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:phone];
}

//判断email
+ (BOOL)validateEmail:(NSString *)email {
//    NSString *emailRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断是否是汉字
+ (BOOL)isOrChinese:(NSString *)chinese{
    
    NSString * textStr=@"^[\u4e00-\u9fa5]+$";//[\u4e00-\u9fa5]+
    NSPredicate * chineseTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textStr];
    return [chineseTest evaluateWithObject:chinese];
}


//判断email
+ (BOOL)validatePasswd:(NSString *)passwd {
    NSString *passwdRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *passwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwdRegex];
    return [passwdTest evaluateWithObject:passwd];
}


+ (NSDate*)getShortDateFormString:(NSString*)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:str];
}

+ (NSDate*)getDateFormString:(NSString*)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:str];
}

+ (NSDate*)getDateAndTimeFormString:(NSString*)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter dateFromString:str];
}

+ (NSDate*)getTimeFormString:(NSString*)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    return [formatter dateFromString:str];
}

+ (NSString*)getStringFormDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

//评论用到, 不要改动
+ (NSString*)getStringFormDateAndTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

+ (NSString*)getStringMonthAndDayFormDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    return [formatter stringFromDate:date];
}

+ (NSString*)getStringTimeAndWeekFormDate:(NSDate*)date {
    if (!date) {
        return nil;
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps;
    comps = [calendar components:unitFlags fromDate:date];

    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy/MM/dd"];
    
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:[formatter stringFromDate:date]];
    switch (weekday) {
        case 1:
            [string appendString:@"(周日)"];
            break;
        case 2:
            [string appendString:@"(周一)"];
            break;
        case 3:
            [string appendString:@"(周二)"];
            break;
        case 4:
            [string appendString:@"(周三)"];
            break;
        case 5:
            [string appendString:@"(周四)"];
            break;
        case 6:
            [string appendString:@"(周五)"];
            break;
        case 7:
            [string appendString:@"(周六)"];
            break;

        default:
            break;
    }
    return string;
}

+ (NSString*)getShortStringTimeAndWeekFormDate:(NSDate*)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps;
    comps = [calendar components:unitFlags fromDate:date];
    
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:[formatter stringFromDate:date]];
    switch (weekday) {
        case 1:
            [string appendString:@"(周日)"];
            break;
        case 2:
            [string appendString:@"(周一)"];
            break;
        case 3:
            [string appendString:@"(周二)"];
            break;
        case 4:
            [string appendString:@"(周三)"];
            break;
        case 5:
            [string appendString:@"(周四)"];
            break;
        case 6:
            [string appendString:@"(周五)"];
            break;
        case 7:
            [string appendString:@"(周六)"];
            break;
            
        default:
            break;
    }
    return string;
}



+ (NSString*)arrayChangeToString:(NSArray*)array withSplit:(NSString*)split {
    NSMutableString *string = [NSMutableString string];
    for (int i = 0 ; i < array.count; i++) {
        [string appendString:[array objectAtIndex:i]];
        if (i != array.count - 1) {
            [string appendString:split];
        }
    }
    return string;
}

+ (NSArray*)changeStringToArray:(NSString*)string {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@","];
    return [string componentsSeparatedByCharactersInSet:characterSet];
}

//显示缓存大小
+ (NSString *)displayCache{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
    float roomMax=0;
    roomMax=[self  folderSizeAtPath:documentDirectory];
    if (roomMax>1024.0&&roomMax<1024.0*1024.0) {
        return [NSString stringWithFormat:@"%.fKB",roomMax/1024.0];
    }else if (roomMax>1024.0*1024.0){
        return [NSString stringWithFormat:@"%.2fMB",roomMax/(1024.0*1024.0)];
    }else{
        return @"0KB";
    }
}

+ (float )folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+ (BOOL)showGuideView {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id flag = [userDefaults objectForKey:@"userGuide"];
    if (flag) {
        return NO;
    } else {
        [userDefaults setBool:YES forKey:@"userGuide"];
        [userDefaults synchronize];
        return YES;
    }
}


//获取当前时间秒数 数字
+ (long long)getCurrentTimeSecsNum {
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    return theTime;
}

//获取当前时间秒数 字符串
+ (NSString *)getCurrentTimeSecsString {
//    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;  //毫秒*1000
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    return curTime;
}

+ (NSString *)dateStringForAdvClickCacheKey {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd";
    NSDate *datenow = [NSDate date];
    return [formater stringFromDate:datenow];
}

+ (void)gradientColorWithRed:(CGFloat)red
                          green:(CGFloat)green
                           blue:(CGFloat)blue
                     startAlpha:(CGFloat)startAlpha
                       endAlpha:(CGFloat)endAlpha
                      direction:(DirectionStyle)direction
                          frame:(CGRect)frame
                           view:(UIImageView *)objIV
{
    //底部上下渐变效果背景
    // The following methods will only return a 8-bit per channel context in the DeviceRGB color space. 通过图片上下文设置颜色空间间
    UIGraphicsBeginImageContext(frame.size);
    //获得当前的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建颜色空间 /* Create a DeviceRGB color space. */
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    //通过矩阵调整空间变换
    CGContextScaleCTM(context, frame.size.width, frame.size.height);
    
    //通过颜色组件获得渐变上下文
    CGGradientRef backGradient;
    //253.0/255.0, 163.0/255.0, 87.0/255.0, 1.0,
    if (direction == DirectionStyleToUnder) {
        //向下
        //设置颜色 矩阵
        CGFloat colors[] = {
            red, green, blue, startAlpha,
            red, green, blue, endAlpha,
        };
        backGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    } else {
        //向上
        CGFloat colors[] = {
            red, green, blue, endAlpha,
            red, green, blue, startAlpha,
        };
        backGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    }
    
    //释放颜色渐变
    CGColorSpaceRelease(rgb);
    //通过上下文绘画线色渐变
    CGContextDrawLinearGradient(context, backGradient, CGPointMake(0.5, 0), CGPointMake(0.5, 1.1), kCGGradientDrawsBeforeStartLocation);
    //通过图片上下文获得照片
    objIV.image = UIGraphicsGetImageFromCurrentImageContext();
}

//获取当前时间毫秒数 数字
+ (long long)getCurrentTimeMillsNum {
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    return theTime;
}

+ (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData {
    if (![jsonData isKindOfClass:[NSData class]] || jsonData.length < 1) {
        return nil;
    }
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    if (![jsonObj isKindOfClass:[NSDictionary class]]) {return nil;}
    return [NSDictionary dictionaryWithDictionary:(NSDictionary *)jsonObj];
}



+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height
{
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds=[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    CGRect newBounds;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>8.0){
        newBounds=bounds;
    }else{
        newBounds=bounds;
        newBounds.size.height=bounds.size.height+10;
    }
    return newBounds.size.height;
}

+(CGRect)boundsOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds=[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    CGRect newBounds;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>8.0){
        newBounds=bounds;
    }else{
        newBounds=bounds;
        newBounds.size.height=bounds.size.height+10;
    }
    return newBounds;
}

@end
