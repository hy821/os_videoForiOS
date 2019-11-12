//
//  SynopsisCell.h
//


#import <UIKit/UIKit.h>

@interface SynopsisCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic,strong) VDCommonModel *model;

@property (nonatomic,copy) void(^foldOpenBlock)(BOOL isOpen);

@end
