//
//  VideoDetailMsgController.h
//

#import "OOSBaseViewController.h"
@interface VideoDetailMsgController : UITableViewController
- (void)loadDataWithCommonModel:(VDCommonModel*)model isOff:(BOOL)isOff;
@property (nonatomic,copy) void(^loadDataBlock)(void);
@property (nonatomic,copy) void(^updateDataWhenChangeSourceBlock)(VDCommonModel *model);
@property (nonatomic,copy) void(^changeEpisodeBlock)(VDCommonModel *model);
@property (nonatomic,copy) void(^refreshNewVideoBlock)(ProgramResultListModel *model);
@property (nonatomic,copy) void(^playBlock)(void);
@end
