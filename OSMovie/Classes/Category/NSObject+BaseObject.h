//
//  NSObject+BaseObject.h
//  SmallStuff
//
//  Created by Hy on 2017/3/29.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BaseObject)
/**
 *  适配宽度(iPhone 6)
 */
- (CGFloat(^)(CGFloat))sizeW;
/**
 *  适配高度(iPhone 6)
 */
- (CGFloat(^)(CGFloat))sizeH;
/**
 *居上 尺寸
 **/
-(CGFloat)contentOffset;
/**
 *tabbar 尺寸
 **/
-(CGFloat)tabbarHeight;
/**
 *status高度
 **/
-(CGFloat)statusBarHeight;

@end
