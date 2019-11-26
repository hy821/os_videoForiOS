//
//  SplashScreenView.h
//  启动屏加启动广告页
//

#import <UIKit/UIKit.h>

static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adImageUrl";
static NSString *const adDeadline = @"adDeadline";
@interface SplashScreenView : UIView

/** 显示广告页面方法*/
- (void)showSplashScreenWithTime:(NSInteger )ADShowTime andImgUrl:(NSString *)url;

/** 广告图的显示时间*/
@property (nonatomic, assign) NSInteger ADShowTime;

/** 广告落地页, webViewUrl */
@property (nonatomic, copy) NSString *imgLinkUrl;

@property (nonatomic,strong) AdmetaModel *advModel;

@end
