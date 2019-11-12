//
//  SNLoading.h
//  ZhongRenBang
//
//  Created by 童臣001 on 16/7/26.
//  Copyright © 2016年 ZengWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNLoading : NSObject

+ (void)showWithTitle:(NSString *)title;
+ (void)hideWithTitle:(NSString *)title;

+ (void)updateWithTitle:(NSString *)title detailsText:(NSString *)detailsText;

@end

