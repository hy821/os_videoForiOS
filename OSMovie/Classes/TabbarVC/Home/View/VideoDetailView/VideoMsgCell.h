//
//  VideoMsgCell.h
//


#import <UIKit/UIKit.h>

@interface VideoMsgCell : UITableViewCell

+(instancetype)cellForTableView:(UITableView*)tableView;

@property (nonatomic,strong) VDCommonModel *model;

//切换视频源后, 通知请求Episode, 然后刷新EpisodeCell
@property (nonatomic,copy) void(^changeSourceBlock)(NSInteger indexSelect);

//btnType : 1播放
@property (nonatomic,copy) void(^clickBlock)(NSInteger btnType);

@end
