//
//  KSBaseWebViewController.h


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
typedef NS_ENUM(NSUInteger, WebType) {
    NormalType       = 0,  //webview
    WKType             = 1,  //wkWebView
};

@interface KSBaseWebViewController : KSBaseViewController
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic,assign) WebType webType;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic,assign) BOOL isNavBarHidden;
@property (nonatomic,assign) BOOL isHaveInteration;

@end

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
