//
//  HorizenButton.m
//  Osss
//
//  Created by Lff_OsDeveloper on 2017/3/30.
//  Copyright © 2019年    asdfghjkl. All rights reserved.
//

#import "HorizenButton.h"

@implementation HorizenButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(self.isTitleLeft)
    {
        if (self.imageView.x < self.titleLabel.x) {
            self.titleLabel.x = self.imageView.x;
            
            self.imageView.x = self.titleLabel.x + self.titleLabel.width + _margeWidth;
            
        }
    }else{
        if (self.imageView.x < self.titleLabel.x) {
            
            //        self.titleLabel.x = self.imageView.x;
            
            self.titleLabel.x = self.imageView.x + self.imageView.width + _margeWidth;
        }
    }
}
    

- (void)setMargeWidth:(CGFloat)margeWidth
{
    _margeWidth = margeWidth;
}

@end
