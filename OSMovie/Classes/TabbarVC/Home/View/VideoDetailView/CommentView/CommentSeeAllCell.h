//
//  CommentSeeAllCell.h
//  KSMovie
//
//  Created by young He on 2019/5/9.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentSeeAllCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic,strong) CommentModel *model;

@end

NS_ASSUME_NONNULL_END
