//
//  OOSBaseWebViewController.m


#import "OOSBaseWebViewController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"

@interface OOSBaseWebViewController ()
<UIWebViewDelegate,
WKNavigationDelegate,
WKUIDelegate,
UIGestureRecognizerDelegate,
WKScriptMessageHandler>
@property (nonatomic,weak) YHWebViewProgressView * progressView;
@property (strong, nonatomic) YHWebViewProgress *progressProxy;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@property (nonatomic,strong) WKWebView * wkWeb;
@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UIButton * closeBtn;
@property (nonatomic,weak) WKWebViewConfiguration * wkConfig;
@property (nonatomic,strong) UIView * showErrorView;
@property (nonatomic,strong) UIImageView * errorIV;
@property (nonatomic,strong) UILabel * errorLab;
@property (nonatomic,assign) BOOL isFirstAppear;

@end

@implementation OOSBaseWebViewController

static NSString *AdvActionOpenApp = @"advActionOpenAppByH5";
 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webType = WKType;
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if(self.bannerUrl == nil) {
        self.bannerUrl = @"";
    }
    if(self.isNavBarHidden) {
        self.closeBtn.hidden = YES;
        [self.view bringSubviewToFront:self.closeBtn];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrame:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    }
    [self createUI];
    [self resolveURL];
    if (self.titleStr) {
        self.title = _titleStr;
    }
    self.navigationItem.leftBarButtonItem = self.backItem;

    if (self.isShowBack) {
        self.closeBtn.hidden = NO;
        [self.view bringSubviewToFront:self.closeBtn];
        
    }else{
        self.fd_prefersNavigationBarHidden = self.isNavBarHidden;
        self.fd_interactivePopDisabled = YES;
    }
}

- (void)willChangeStatusBarFrame:(NSNotification*)notification {
    CGRect newBarFrame = [notification.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    if([self.wkWeb canGoBack]&&self.isNavBarHidden){
        [self.wkWeb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).offset(UIEdgeInsetsMake([self contentOffset], 0, 0, 0));
        }];
    }else{
        if(self.isNavBarHidden){
            [self.wkWeb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(newBarFrame.size.height , 0, 0, 0));
            }];
        }
    }
}

- (void)createUI {
    if(self.webType == NormalType) {
        [self.view addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];
    }else {
        [self.view addSubview:self.wkWeb];
        [self.wkWeb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(self.isNavBarHidden?[UIApplication sharedApplication].statusBarFrame.size.height :[self contentOffset]);
        }];
    }

    [self.view addSubview:self.showErrorView];
    self.showErrorView.hidden = YES;
    [self.showErrorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    // 创建进度条代理，用于处理进度控制
    _progressProxy = [[YHWebViewProgress alloc] init];
    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, self.isNavBarHidden?[UIApplication sharedApplication].statusBarFrame.size.height :[self contentOffset],ScreenWidth, 3.f)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    // 添加到视图
    [self.view addSubview:progressView];
    self.progressView = progressView;
    [self.view bringSubviewToFront:_progressView];
    if(self.isNavBarHidden)
    {
        [self.view bringSubviewToFront:self.closeBtn];
        [self.view bringSubviewToFront:self.backBtn];
    }
}

-(void)resolveURL
{
    [self.wkWeb addObserver:self
                 forKeyPath:@"loading"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    [self.wkWeb addObserver:self
                 forKeyPath:@"title"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    [self.wkWeb addObserver:self
                 forKeyPath:@"estimatedProgress"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    //Cookie
    NSURL *url = [NSURL URLWithString:_bannerUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     [self.wkWeb loadRequest:request];
}

#pragma mark--KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"loading"])
    {
    } else if ([keyPath isEqualToString:@"title"])
    {
        self.navigationItem.title = self.wkWeb.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        [self.progressView setProgress:[change[@"new"] doubleValue] animated:YES];
        
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!self.isFirstAppear) {
        return;
    }
    if([self.wkWeb canGoBack]&&self.isNavBarHidden&&(self.navigationController.isNavigationBarHidden)) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([self.wkWeb canGoBack]&&self.isNavBarHidden)
    {
        
        self.wkWeb.mj_y = [self contentOffset];
    }else
    {
        if(self.isNavBarHidden)
        {
            if(!self.isFirstAppear)
            {
                self.isFirstAppear = YES;
                return;
            }
            self.wkWeb.mj_y = [UIApplication sharedApplication].statusBarFrame.size.height;
            self.backBtn.mj_y = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
}
- (void)updateButtonItems
{
    
    if ([self.wkWeb canGoBack]&&self.navigationItem.leftBarButtonItems.count!=2) {
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        //, self.closeItem
        if(self.isNavBarHidden)
        {
            self.progressView.mj_y = [self contentOffset];
            [self.view bringSubviewToFront:self.progressView];
            self.wkWeb.mj_y = [self contentOffset];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.closeBtn.hidden = NO;
            self.fd_interactivePopDisabled = YES;
        }
    } else  if ([self.wkWeb canGoBack]&&self.navigationItem.leftBarButtonItems.count==2)
    {
        if(self.isNavBarHidden)
        {
            self.progressView.mj_y = [self contentOffset];
            [self.view bringSubviewToFront:self.progressView];
            self.wkWeb.mj_y = [self contentOffset];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.closeBtn.hidden = NO;
            self.fd_interactivePopDisabled = YES;
        }
    }
    else
    {
        
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        if(self.isNavBarHidden)
        {
            self.fd_interactivePopDisabled = NO;
            self.closeBtn.hidden = YES;
            self.progressView.mj_y = [UIApplication sharedApplication].statusBarFrame.size.height ;
            [self.view bringSubviewToFront:self.progressView];
            self.wkWeb.mj_y = [UIApplication sharedApplication].statusBarFrame.size.height;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    if(self.isNavBarHidden){
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(UIButton *)backBtn {
    if(!_backBtn) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = button;
    }return _backBtn;
}

-(UIButton *)closeBtn {
    if(!_closeBtn) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(64, 20, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = button;
    }return _closeBtn;
}

- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:KCOLOR(@"#333333") forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }return _backItem;
}


- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:KCOLOR(@"#333333") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        _closeItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }return _closeItem;
}

#pragma mark - Action
- (void)backAction {
    if ([self.wkWeb canGoBack]) {
        [self.wkWeb goBack];
    } else {
        [self closeSelf];
    }
}

-(UIView *)showErrorView {
    if(_showErrorView == nil) {
        _showErrorView = [[UIView alloc]init];
        _showErrorView.backgroundColor = [UIColor whiteColor];
        [_showErrorView addSubview:self.errorIV];
        [_showErrorView addSubview:self.errorLab];
        [self.errorIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.showErrorView.center);
        }];
        [self.errorLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.errorIV.mas_bottom).offset(16);
            make.height.mas_equalTo(20.f);
            make.left.right.equalTo(self.showErrorView);
        }];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadTap)];
        [_showErrorView addGestureRecognizer:tap];
    }
    return _showErrorView;
}

-(void)reloadTap {
    self.showErrorView.hidden = YES;
    [self.view bringSubviewToFront:self.progressView];
    [self.wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_bannerUrl]]];
}

- (UIImageView *)errorIV {
    if(_errorIV == nil) {
        _errorIV = [[UIImageView alloc]initWithImage:Image_Named(@"netError")];
        _errorIV.userInteractionEnabled = YES;
    }return _errorIV;
}

-(UILabel *)errorLab {
    if(_errorLab == nil){
        _errorLab = [[UILabel alloc]init];
        _errorLab.font = Font_Size(16);
        _errorLab.textAlignment = NSTextAlignmentCenter;
        _errorLab.textColor = DarkGray_Color;
        _errorLab.text = @"加载失败, 请点击重试";
    }return _errorLab;
}

-(void)dealloc {
    SSLog(@"%s",__func__);
    [_wkWeb removeObserver:self forKeyPath:@"loading" context:nil];//移除kvo
    [_wkWeb removeObserver:self forKeyPath:@"title" context:nil];
    [_wkWeb removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
 
    if(self.isHaveInteration) {
        [self.wkConfig.userContentController removeScriptMessageHandlerForName:AdvActionOpenApp];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

#pragma mark-- wkWebViewDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if(!self.showErrorView.isHidden) {
        self.showErrorView.hidden = YES;
    }
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if(self.showErrorView.isHidden) {
        self.showErrorView.hidden = NO;
        [self.view bringSubviewToFront:self.showErrorView];
        [self.view bringSubviewToFront:self.progressView];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if(!self.showErrorView.isHidden) {
        self.showErrorView.hidden = YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(!self.showErrorView.isHidden) {
        self.showErrorView.hidden = YES;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if(self.showErrorView.isHidden) {
        self.showErrorView.hidden = NO;
        [self.view bringSubviewToFront:self.showErrorView];
        [self.view bringSubviewToFront:self.progressView];
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:AdvActionOpenApp])
    {
        //尝试调起三方App
        NSDictionary *dic = (NSDictionary*)message.body;
        NSString *action_type = dic[@"action_type"];
        NSString *action_url = dic[@"action_url"];
        NSString *deeplink_url = dic[@"deeplink_url"];
        NSArray *click_murls = dic[@"click_murls"];
        NSArray *deeplink_murl = dic[@"deeplink_murl"];
        
        NSInteger type = [action_type integerValue];
        if (type==3)
        { //下载,调整AppStore
            if(action_url.length) {
                [[UIApplication sharedApplication] openURL:URL(action_url) options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        if (click_murls && click_murls.count>0) {
                            [USER_MANAGER callBackAdvWithUrls:click_murls];
                        }
                    }
                }];
            }
            
        }
        else if (type==5)
        { //deepLink 唤起App Or 跳落地页
            if(deeplink_url.length) {
                [[UIApplication sharedApplication] openURL:URL(deeplink_url)  options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        if (click_murls && click_murls.count>0) {
                            [USER_MANAGER callBackAdvWithUrls:click_murls];
                        }
                        if (deeplink_murl && deeplink_murl.count>0) {
                            [USER_MANAGER callBackAdvWithUrls:deeplink_murl];
                        }
                        
                    }else {  //调起失败,跳落地页
                        if(action_url.length) {
                            [[UIApplication sharedApplication] openURL:URL(action_url) options:@{} completionHandler:^(BOOL success) {
                                if (success) {
                                    if (click_murls && click_murls.count>0) {
                                        [USER_MANAGER callBackAdvWithUrls:click_murls];
                                    }
                                }
                            }];
                        }
                    }
                }];
            }
    }
    }
}

- (void)closeSelf {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.scalesPageToFit = YES;
        _webView.autoresizesSubviews = NO;
        _webView.backgroundColor = White_Color;
    }return _webView;
}

-(WKWebView *)wkWeb {
    if(_wkWeb == nil) {
        WKWebViewConfiguration* webViewConfig = [[WKWebViewConfiguration alloc]init];
        webViewConfig.processPool = [[WKProcessPool alloc] init];
        webViewConfig.allowsInlineMediaPlayback = YES;
        self.wkConfig = webViewConfig;
        _wkWeb = [[WKWebView alloc]initWithFrame:CGRectZero configuration:self.wkConfig];
        _wkWeb.UIDelegate = self;
        _wkWeb.navigationDelegate = self;
        [_wkWeb.scrollView setAlwaysBounceVertical:YES];
        [_wkWeb setAllowsBackForwardNavigationGestures:true];
        _wkWeb.backgroundColor = [UIColor whiteColor];
        
        if(self.isHaveInteration){  //交互
            [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:AdvActionOpenApp];
        }
    }return _wkWeb;
}
@end


@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {_scriptDelegate = scriptDelegate;}
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}
@end
