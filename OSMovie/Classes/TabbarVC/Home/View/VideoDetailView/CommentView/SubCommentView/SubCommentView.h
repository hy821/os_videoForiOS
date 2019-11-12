//
//  SubCommentView.h
//  KSMovie
//
//  Created by young He on 2019/5/10.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubCommentView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic,strong) CommentModel *model;

@property (nonatomic,copy) void(^closeBlock)(void);

//键盘弹出时, 回调设置
@property (nonatomic,copy) void(^keyBoardShowHideBlock)(CGFloat h);

@property (nonatomic,copy) void(^goLoginBlock)(void);

@end

NS_ASSUME_NONNULL_END
