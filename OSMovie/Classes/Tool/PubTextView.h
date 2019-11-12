//
//  PubTextView.h
//  SmallStuff
//
//  Created by 闵玉辉 on 17/4/1.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PubTextView : UITextView
@property (nonatomic,copy) NSString * placeText;
@property (nonatomic,strong) UIColor * placeTextColor;
@property (nonatomic,strong) UIFont * placeTextFont;

//点击键盘上的完成按钮, 结束编辑时
@property (nonatomic,copy) void(^finishEditBlock)(NSString *content);
@end
