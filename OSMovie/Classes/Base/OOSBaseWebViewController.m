//
//  OOSBaseWebViewController.m


#import "OOSBaseWebViewController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import "NSData+KKAES.h"
#import "GTMBase64.h"
#import <AdSupport/AdSupport.h>

@interface OOSBaseWebViewController ()
<WKNavigationDelegate,
WKUIDelegate,
UIGestureRecognizerDelegate,
WKScriptMessageHandler>
@property (nonatomic,weak) YHWebViewProgressView * progressView;
@property (strong, nonatomic) YHWebViewProgress *progressProxy;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@property (nonatomic,strong) WKWebView * wkWeb;
@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UIButton * closeBtn;
@property (nonatomic,weak) WKWebViewConfiguration * wkConfig;
@property (nonatomic,strong) UIView * showErrorView;
@property (nonatomic,strong) UIImageView * errorIV;
@property (nonatomic,strong) UILabel * errorLab;

@end

@implementation OOSBaseWebViewController

static NSString *AdvActionOpenApp = @"advActionOpenAppByH5";
static NSString *ParseVideoUrlByApp = @"parseVideoUrlByApp";
static NSString *DownloadAppForCoin = @"downLoadAppForCoinByH5";
static NSString *CheckIDFA  = @"idfaByH5";
static NSString *GetIdfaForRegister  = @"getIdfaByH5"; //获取idfa 注册传参用, 新设备首次注册有金币奖励
static NSString *ContactQQByH5 = @"contactQQByH5";


- (void)viewDidLoad {
    [super viewDidLoad];
//    if (@available(iOS 11.0, *)) {
//        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }else{
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    self.title = self.titleStr ? self.titleStr : @"";
    self.bannerUrl = self.bannerUrl ? self.bannerUrl : @"";
    
    if(self.isNavBarHidden) {
        self.closeBtn.hidden = YES;
        [self.view bringSubviewToFront:self.closeBtn];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrame:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    }
    
    self.fd_prefersNavigationBarHidden = self.isNavBarHidden;
    self.fd_interactivePopDisabled = YES;
    
    [self createUI];
    [self resolveURL];
    
    //跳AppStore回来时,发通知让WebView回调,刷新观影币任务状态
    [NOTIFICATION addObserver:self selector:@selector(callBackToUpdateCoinTask) name:AppBecomeActiveNoti object:nil];
    
    //fix:WKWebView，隐藏导航栏，视频详情页 全屏播放 退出全屏后，顶部出现20px的空白
    if (@available(iOS 11.0, *)) {
        if(isFullScreenX) {
            self.wkWeb.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
        }else{
            self.wkWeb.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }else{
        // Fallback on earlier versions
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)callBackToUpdateCoinTask {
    NSString *callBackKey = @"isShowEntranceCallBack";
    NSDictionary *dic = @{@"idfa": @"updateTask"};
    
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paraStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *callBackStr = [NSString stringWithFormat:@"%@(%@)",callBackKey,paraStr];
        [self.wkWeb evaluateJavaScript:callBackStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            SSLog(@"CheckIdfaStatus回调H5成功: %@ %@",response,error);
        }];
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
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    [self.view addSubview:self.wkWeb];
    [self.wkWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(self.isNavBarHidden ? statusBarH : [self contentOffset]);
    }];
    
    [self.view addSubview:self.showErrorView];
    self.showErrorView.hidden = YES;
    [self.showErrorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    // 进度条代理，用于处理进度控制
    _progressProxy = [[YHWebViewProgress alloc] init];
    // 进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, self.isNavBarHidden ? statusBarH : [self contentOffset],ScreenWidth, 3.f)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    [self.view bringSubviewToFront:_progressView];
    
    if(self.isNavBarHidden) {
        [self.view bringSubviewToFront:self.closeBtn];
        [self.view bringSubviewToFront:self.backBtn];
    }
    
    self.navigationItem.leftBarButtonItem = self.backItem;
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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.isNavBarHidden animated:YES];
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
    SSLog(@"OOSBaseWebViewController--Dealloc %s",__func__);
    [_wkWeb removeObserver:self forKeyPath:@"loading" context:nil];//移除kvo
    [_wkWeb removeObserver:self forKeyPath:@"title" context:nil];
    [_wkWeb removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    
    if(self.isHaveInteration) {
        [self.wkConfig.userContentController removeScriptMessageHandlerForName:AdvActionOpenApp];
        [self.wkConfig.userContentController removeScriptMessageHandlerForName:ParseVideoUrlByApp];
        [self.wkConfig.userContentController removeScriptMessageHandlerForName:DownloadAppForCoin];
        [self.wkConfig.userContentController removeScriptMessageHandlerForName:CheckIDFA];
        [self.wkConfig.userContentController removeScriptMessageHandlerForName:GetIdfaForRegister];
        [self.wkConfig.userContentController removeScriptMessageHandlerForName:ContactQQByH5];
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

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:AdvActionOpenApp]) {
        //尝试调起三方App
        NSDictionary *dic = (NSDictionary*)message.body;
        NSString *action_type = dic[@"action_type"];
        NSString *action_url = dic[@"action_url"];
        NSString *deeplink_url = dic[@"deeplink_url"];
        NSArray *click_murls = dic[@"click_murls"];
        NSArray *deeplink_murl = dic[@"deeplink_murl"];
        
        NSDictionary *advData = dic[@"advData"];
        SSLog(@"advData:%@",advData);

        //先判断deepLink 唤起App Or 跳落地页
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
            return;
        }
        
        NSInteger type = [action_type integerValue];
        if (type==1 || type==2) {
            if (action_url) {
                OOSBaseWebViewController *vc = [[OOSBaseWebViewController alloc]init];
                vc.bannerUrl = action_url;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if (type==3)
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
    }
    else if ([message.name isEqualToString:ParseVideoUrlByApp]) {
        //解析播放地址
        NSDictionary *dic = (NSDictionary *)message.body;
        NSString *urlStr = dic[@"playUrl"];
        NSString *type = dic[@"type"];
        
        WS()
        if ([type intValue]==11) {  //自上传解密
            [USER_MANAGER decodeH5VideoUrlWithUrl:urlStr success:^(NSString *decodeUrl) {
                
                NSDictionary *dic = @{@"resultCode":@"1",
                                      @"resultData": decodeUrl
                };
                NSString *callBackKey = @"parsedVideoUrl";
                
                if ([NSJSONSerialization isValidJSONObject:dic]) {
                    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *paraStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSString *callBackStr = [NSString stringWithFormat:@"%@(%@)",callBackKey,paraStr];
                    [weakSelf.wkWeb evaluateJavaScript:callBackStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                        SSLog(@"%@ %@",response,error);
                    }];
                }
            }];
        }else {
            [USER_MANAGER parsedUrlForH5WithUrl:urlStr success:^(id response) {
                
                NSDictionary *dic = @{@"resultCode":@"1",
                                      @"resultData": response
                };
                NSString *callBackKey = @"parsedVideoUrl";
                
                if ([NSJSONSerialization isValidJSONObject:dic]) {
                    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *paraStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSString *callBackStr = [NSString stringWithFormat:@"%@(%@)",callBackKey,paraStr];
                    [weakSelf.wkWeb evaluateJavaScript:callBackStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                        SSLog(@"%@ %@",response,error);
                    }];
                }
            } failure:nil];
        }
    }
    else if ([message.name isEqualToString:DownloadAppForCoin]) {
        //下载App获取观影币
       
        NSDictionary *dic = (NSDictionary*)message.body;
        NSString *downLink = dic[@"downLink"] ? dic[@"downLink"] : @"";
        NSString *appId = dic[@"id"] ? dic[@"id"] : @"";
        NSString *packName = dic[@"packName"] ? dic[@"packName"] : @"";
        NSString *deviceId = [USER_MANAGER getUUID];
        
        NSDictionary *advData = dic[@"advData"];
        SSLog(@"advData:%@",advData);
        
        if(downLink.length) {
            WS()
            [[UIApplication sharedApplication] openURL:URL(downLink)  options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    //上报
                    NSDictionary *dic = @{
                        @"appId" : appId,
                        @"deviceId" : deviceId,
                        @"packName" : packName
                    };
                    NSString *callBackKey = @"downLoadAppCallBack";
                    if ([NSJSONSerialization isValidJSONObject:dic]) {
                        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                        NSString *paraStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                        NSString *callBackStr = [NSString stringWithFormat:@"%@(%@)",callBackKey,paraStr];
                        [weakSelf.wkWeb evaluateJavaScript:callBackStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                            SSLog(@"回调H5成功: %@ %@",response,error);
//                            //-------模拟广告商 回调--------//
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970]*1000)];
//                                NSString *signStr = [NSString stringWithFormat:@"%@_%@_%@",deviceId,packName,timeSp];
//                                [weakSelf advReportWithStr:signStr];
//                            });
                        }];
                    }
                }
            }];
            return;
        }
    }else if ([message.name isEqualToString:CheckIDFA]) {
        NSString *callBackKey = @"isShowEntranceCallBack";
        NSDictionary *dic = @{@"idfa": @"y"};
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *paraStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *callBackStr = [NSString stringWithFormat:@"%@(%@)",callBackKey,paraStr];
            [self.wkWeb evaluateJavaScript:callBackStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                SSLog(@"CheckIdfaStatus回调H5成功: %@ %@",response,error);
            }];
        }
    }else if ([message.name isEqualToString:GetIdfaForRegister]) {
        NSString *callBackKey = @"idfaForRegisterCallBack";
        NSDictionary *dic = @{@"idfa": [USER_MANAGER getUUID]};
        
        if ([NSJSONSerialization isValidJSONObject:dic]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *paraStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *callBackStr = [NSString stringWithFormat:@"%@(%@)",callBackKey,paraStr];
            [self.wkWeb evaluateJavaScript:callBackStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                SSLog(@"CheckIdfaStatus回调H5成功: %@ %@",response,error);
            }];
        }
    }else if ([message.name isEqualToString:ContactQQByH5]) {
        //联系QQ客服
        NSString *qqAccount = message.body;
        
        NSString *urlStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqAccount];
        NSURL *url = [NSURL URLWithString:urlStr];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
        }else {
            SSMBToast(@"您未安装手机QQ，请安装后重试。", MainWindow);
        }
    }
}

//-------模拟广告商 回调--------//
- (void)advReportWithStr:(NSString*)signStr {
    NSData *signData = [signStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [@"osMta12xg3e0mt5G" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encodeData = [signData AES_ECB_EncryptWith:keyData];

    encodeData = [GTMBase64 encodeData:encodeData];
    NSString *encodeStr = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    SSLog(@"----->encodeStr:%@",encodeStr);
    NSDictionary *dic = @{@"sign":encodeStr};


    NSString *ServerURL = [USERDEFAULTS objectForKey:HOST_api];
    if (![ServerURL containsString:@"http"]) {
        ServerURL = [NSString stringWithFormat:@"http://%@/",ServerURL];
    }
    NSString *requestUrlString = SSStr(ServerURL, @"test/api/callback/download/callback/v1");

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];

    [manager POST:requestUrlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[encodeStr dataUsingEncoding:kCFStringEncodingUTF8]  name:@"sign"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SSLog(@"成功---------->");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SSLog(@"失败---------->");
    }];
}

- (void)closeSelf {
    [self.navigationController popViewControllerAnimated:YES];
}

-(WKWebView *)wkWeb {
    if(_wkWeb == nil) {
        WKWebViewConfiguration* webViewConfig = [[WKWebViewConfiguration alloc]init];
        webViewConfig.processPool = [[WKProcessPool alloc] init];
        webViewConfig.allowsInlineMediaPlayback = YES;  // 使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        self.wkConfig = webViewConfig;
        _wkWeb = [[WKWebView alloc]initWithFrame:CGRectZero configuration:self.wkConfig];
        _wkWeb.UIDelegate = self;
        _wkWeb.navigationDelegate = self;
        [_wkWeb.scrollView setAlwaysBounceVertical:YES];
        [_wkWeb setAllowsBackForwardNavigationGestures:true];
        _wkWeb.backgroundColor = [UIColor whiteColor];
        
        if(self.isHaveInteration){  //交互
            [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:AdvActionOpenApp];
            [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:ParseVideoUrlByApp];
            [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:DownloadAppForCoin];
            [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:CheckIDFA];
            [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:GetIdfaForRegister];
            [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:ContactQQByH5];
            
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
