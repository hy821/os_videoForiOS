//
//  CollectAndHistoryCell.h
//


#import <UIKit/UIKit.h>

@interface CollectAndHistoryCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic,strong) ProgramResultListModel *model;


@end
