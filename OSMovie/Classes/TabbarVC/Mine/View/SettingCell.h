//
//  SettingCell.h
//



#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic,strong) SettingCellModel *model;

@end
