//
//  ReportViewController.h
//


#import "KSBaseViewController.h"

@interface ReportViewController : KSBaseViewController

@property (nonatomic,strong)  VDCommonModel *model;

@property (nonatomic,assign) BOOL fromShortVideo;
@property (nonatomic,strong) ProgramResultListModel *modelShortVideo; // from ShortVideo

@property (nonatomic,copy) void(^backSVDetailBlock)(void);

@end
