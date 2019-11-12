//
//  ShortVideoMsgCell.h
//


#import <UIKit/UIKit.h>

@interface ShortVideoMsgCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic,strong) VDCommonModel *model;

@end
