//
//  VerticalButton.m
//  SmallStuff
//
//  Created by Hy on 2017/3/30.
//  Copyright © 2017年 yuhuimin. All rights reserved.
//

#import "VerticalButton.h"

@implementation VerticalButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = self.bounds.size.width * 0.5 - self.imageView.image.size.width * 0.5;
    self.imageView.y = (self.bounds.size.height - 20) * 0.5 - self.imageView.image.size.height * 0.5;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.bounds.size.height - self.titleLabel.bounds.size.height - _verticalMarge;
    self.titleLabel.width = self.bounds.size.width;
    self.titleLabel.height = self.titleLabel.bounds.size.height;
    
    self.titleLabel.backgroundColor = self.backgroundColor;
    self.imageView.backgroundColor = self.backgroundColor;
    
    CGSize titleSize = self.titleLabel.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    CGFloat interval = 1.0;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width + interval))];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width + interval), 0, 0)];
}

@end
