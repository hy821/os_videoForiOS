//
//  UIImage+ZipSizeAndLength.h
//  CatEntertainment
//
//  Created by 闵玉辉 on 2018/5/22.
//  Copyright © 2018年 闵玉辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZipSizeAndLength)
- (UIImage *)compressToByte:(NSUInteger)maxLength;
//直接调用这个方法进行压缩体积,减小大小
- (UIImage *)zip;
@end
