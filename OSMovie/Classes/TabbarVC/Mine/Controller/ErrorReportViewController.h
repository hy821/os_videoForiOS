//
//  ErrorReportViewController.h
//


#import "KSBaseViewController.h"

@interface ErrorReportViewController : KSBaseViewController

@property (nonatomic,copy) void(^backSVDetailBlock)(void);  //从短视频详情页进来时, 且短视频页player是带进去的, 需要block告知updatePlayer

@end

@interface ErrorReportBottomView : UIView

@property (nonatomic,copy) void(^sendBlock)(NSString *textSend);

@end

