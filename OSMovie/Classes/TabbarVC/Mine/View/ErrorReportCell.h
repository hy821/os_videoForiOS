//
//  ErrorReportCell.h
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ErrorReportCell : UITableViewCell
+(instancetype)cellForTableView:(UITableView*)tableView;
@property (nonatomic,strong) ReportCellModel *model;
@property (nonatomic,copy) void(^selectBlock)(BOOL isSel);
@end

NS_ASSUME_NONNULL_END
