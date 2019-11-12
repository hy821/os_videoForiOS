//
//  AllEpisodeRectCell.h
//



#import <UIKit/UIKit.h>

@interface AllEpisodeRectCell : UITableViewCell

@property (nonatomic,strong) MediaTipResultModel *model;

+(instancetype)cellForTableView:(UITableView*)tableView;

@end
