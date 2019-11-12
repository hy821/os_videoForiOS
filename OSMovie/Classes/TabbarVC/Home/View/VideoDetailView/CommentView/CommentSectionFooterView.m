//
//  CommentSectionFooterView.m
//  KSMovie
//
//  Created by young He on 2019/5/9.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "CommentSectionFooterView.h"

@implementation CommentSectionFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }return self;
}

- (void)createUI {
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = KCOLOR(@"#F8F8F8");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.sizeW(14));
        make.right.equalTo(self.contentView).offset(self.sizeW(-12));
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(0.9f);
    }];
}

@end
