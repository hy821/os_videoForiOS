//
//  SelectEpisodeCell.h
//



#import <UIKit/UIKit.h>

@interface SelectEpisodeCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic,copy) void(^showAllEpisodeBlock)(void);

@property (nonatomic,strong) VDCommonModel *model;

//切换剧集  更新的数据源model  以及  选中的剧集indexSel
@property (nonatomic,copy) void(^changeEpisodeBlock)(VDCommonModel *model);

@end
