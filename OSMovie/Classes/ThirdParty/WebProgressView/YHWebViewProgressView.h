//
//  YHWebViewProgressView.h
//

#import <UIKit/UIKit.h>
#import "YHWebViewProgressViewProtocol.h"
@import WebKit;

@interface YHWebViewProgressView : UIView
<YHWebViewProgressViewProtocol>
@property (nonatomic) float progress;

@property (readonly, nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration;// default 0.5
@property (nonatomic) NSTimeInterval fadeAnimationDuration;// default 0.27
/**
 *  进度条的颜色
 */
@property (copy, nonatomic) UIColor *progressBarColor;

/**
 *  使用WKWebKit
 *
 *  @param webView WKWebView对象
 */
- (void)useWkWebView:(WKWebView *)webView;

@end
