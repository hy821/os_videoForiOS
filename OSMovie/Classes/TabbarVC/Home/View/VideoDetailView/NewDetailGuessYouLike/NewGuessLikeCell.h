//
//  NewGuessLikeCell.h
//


#import <UIKit/UIKit.h>

@interface NewGuessLikeCell : UITableViewCell

extern CGFloat  const cellHeightForShortVideoGuessLike;

+(instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic,strong) VDCommonModel *model;

@property (nonatomic,copy) void(^selectBlock)(ProgramResultListModel*model);

@property (nonatomic,copy) void(^showMoreBlock)(void);

@end
