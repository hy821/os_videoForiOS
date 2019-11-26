//
//  ReportViewController.h
//


#import "OOSBaseViewController.h"

@interface ReportViewController : OOSBaseViewController

@property (nonatomic,strong)  VDCommonModel *model;

@property (nonatomic,assign) BOOL fromShortVideo;
@property (nonatomic,strong) ProgramResultListModel *modelShortVideo; // from ShortVideo

@property (nonatomic,copy) void(^backSVDetailBlock)(void);

@end
