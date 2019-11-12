//
//  SubCommentCell.h
//  KSMovie
//
//  Created by young He on 2019/5/11.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubCommentCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic,strong) CommentModel *model;

- (void)hideBottomLine;

@property (nonatomic,copy) void(^likeBtnToLoginBlock)(void);  //点赞发现未登录, 去登录

@end

NS_ASSUME_NONNULL_END
