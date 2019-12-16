//
//  OOSBaseWebViewController.h


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface OOSBaseWebViewController : OOSBaseViewController
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic,assign) BOOL isNavBarHidden;
@property (nonatomic,assign) BOOL isHaveInteration;//交互

@end

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
