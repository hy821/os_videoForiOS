//
//  SplashScreenView.m
//

#import "SplashScreenView.h"
#import "OOSBaseWebViewController.h"

@interface  SplashScreenView()

@property (nonatomic, strong) UIImageView *adImageView;

@property (nonatomic, strong) UIButton *countButton;

@property (nonatomic, strong) NSTimer *countTimer;

@property (nonatomic, assign) NSInteger count;
@end

@implementation SplashScreenView

- (void)setAdvModel:(AdmetaModel *)advModel {
    _advModel = advModel;
}

- (NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 1.广告图片
        _adImageView = [[UIImageView alloc] initWithFrame:frame];
        _adImageView.userInteractionEnabled = YES;
        _adImageView.contentMode = UIViewContentModeScaleAspectFill;
        _adImageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAdVC)];
        [_adImageView addGestureRecognizer:tap];
        
        // 2.跳过按钮
        _countButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _countButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 84, 30, 60, 30);
        [_countButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        _countButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countButton.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countButton.layer.cornerRadius = 4;
        
        [self addSubview:_adImageView];
        [self addSubview:_countButton];
      
    }
    return self;
}

- (void)pushToAdVC {
    //点击广告图时，广告图消失，同时像首页发送通知，并把广告页对应的地址传给首页
    [self dismiss];

    [USER_MANAGER callBackAdvWithUrls:self.advModel.click_murls];

    //deepLink jump OtherApp
    if (self.advModel.deeplink_url && self.advModel.deeplink_url.length>0) {
        [[UIApplication sharedApplication] openURL:URL(self.advModel.deeplink_url) options:@{} completionHandler:^(BOOL success) {
            if(success) {
                [USER_MANAGER callBackAdvWithUrls:self.advModel.deeplink_murl];
            }else {
                if (self.advModel.action_url && self.advModel.action_url.length>0) {
                    OOSBaseWebViewController *vc = [[OOSBaseWebViewController alloc]init];
                    vc.bannerUrl = self.advModel.action_url;
                    vc.hidesBottomBarWhenPushed = YES;
                    [SelectVC pushViewController:vc animated:YES];
                }
            }
        }];
        return;
    }  
    
    switch (self.advModel.action_type) {
        case 1:
        case 2:
        {
            OOSBaseWebViewController *vc = [[OOSBaseWebViewController alloc]init];
            vc.bannerUrl = self.advModel.action_url;
            vc.hidesBottomBarWhenPushed = YES;
            [SelectVC pushViewController:vc animated:YES];
        }
            break;
        case 3:  //第三方下载地址 AppStore
        {
            [[UIApplication sharedApplication] openURL:URL(self.advModel.action_url) options:@{} completionHandler:nil];
        }
            break;
        default:
            break;
    }
    
}

- (void)countDown {
    _count --;
    [_countButton setTitle:[NSString stringWithFormat:@"跳过%ld",(long)_count] forState:UIControlStateNormal];
    if (_count == 0) {
        [self dismiss];
    }
}

- (void)showSplashScreenWithTime:(NSInteger)ADShowTime andImgUrl:(NSString *)url
{
    //Add---
    [_adImageView sd_setImageWithURL:URL(url)];
    
    _ADShowTime = ADShowTime;
    [_countButton setTitle:[NSString stringWithFormat:@"跳过%ld",(long)ADShowTime] forState:UIControlStateNormal];
 
    [self startTimer];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    window.hidden = NO;
    [window addSubview:self];
}

// 定时器倒计时
- (void)startTimer {
    _count = _ADShowTime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

// 移除广告页面
- (void)dismiss {
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
