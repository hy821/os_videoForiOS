//
//  AllEpisodeView.h
//



#import <UIKit/UIKit.h>

@interface AllEpisodeView : UIView

@property (nonatomic,copy) void(^closeBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame AndData:(VDCommonModel*)model AndIntroArr:(NSArray<MediaTipResultModel *>*)introArr;

@property (nonatomic,copy) void(^selectBlock)(VDCommonModel*model);

@end
