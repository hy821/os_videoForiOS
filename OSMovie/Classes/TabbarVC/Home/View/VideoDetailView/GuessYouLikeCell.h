//
//  GuessYouLikeCell.h
//


#import <UIKit/UIKit.h>

@interface GuessYouLikeCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic,strong) VDCommonModel *model;

@property (nonatomic,copy) void(^selectBlock)(ProgramResultListModel*model);

@end
