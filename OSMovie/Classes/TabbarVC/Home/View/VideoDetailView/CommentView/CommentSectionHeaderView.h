//
//  CommentSectionHeaderView.h
//  KSMovie
//
//  Created by young He on 2019/5/9.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) CommentModel *model;

@property (nonatomic,copy) void(^replyBlock)(void);
@property (nonatomic,copy) void(^likeBtnToLoginBlock)(void);  //点赞发现未登录, 去登录
@end
