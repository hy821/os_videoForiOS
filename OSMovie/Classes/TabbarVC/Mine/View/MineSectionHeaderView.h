//
//  MineSectionHeaderView.h
//


#import <UIKit/UIKit.h>

@interface MineSectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong) MineTVCellModel *model;
@property (nonatomic,copy) void(^tapBlock)(NSInteger section);
@property (nonatomic,assign) NSInteger section;
@end
