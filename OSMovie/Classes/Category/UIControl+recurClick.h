//
//  UIControl+recurClick.h
//
//  Created by Lff on 16/9/12.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (recurClick)
@property (nonatomic, assign) NSTimeInterval uxy_acceptEventInterval;
@property (nonatomic, assign)BOOL uxy_ignoreEvent;
@end
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval_Key";
static const void *BandNameKey = &BandNameKey;
