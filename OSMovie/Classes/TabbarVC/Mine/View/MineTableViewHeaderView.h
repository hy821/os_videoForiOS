//
//  MineTableViewHeaderView.h
//


#import <UIKit/UIKit.h>

@interface MineTableViewHeaderView : UIView
@property (nonatomic,copy) void(^modifyMsgBlock)(void);

- (void)refresh;

@property (nonatomic,copy) void(^vipClickBlock)(void);

@end
