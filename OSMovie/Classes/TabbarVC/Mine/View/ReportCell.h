//
//  ReportCell.h
//

#import <UIKit/UIKit.h>

@interface ReportCell : UITableViewCell
+(instancetype)cellForTableView:(UITableView*)tableView;
@property (nonatomic,strong) ReportCellModel *model;
@end
