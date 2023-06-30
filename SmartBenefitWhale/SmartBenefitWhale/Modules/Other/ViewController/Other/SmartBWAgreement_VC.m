//
//  SmartBWAgreement_VC.m
//  SmartBenefitWhale
//
//  Created by ZiZY-iMac on 2023/6/30.
//

#import "SmartBWAgreement_VC.h"
#import <WebKit/WebKit.h>

@interface SmartBWAgreement_VC ()
<
    WKUIDelegate,
    WKNavigationDelegate
>

@property (nonatomic,strong) UIView                                             *navigationViews;

@property (nonatomic,strong) WKWebView                                          *mainWebView;
@property (nonatomic,strong) UIView                                             *errorView;
@property (nonatomic,strong) NSURL                                              *baseURL;
@property (nonatomic,strong) NSString                                           *baseURLString;

@end

@implementation SmartBWAgreement_VC
#pragma mark ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Life Cycle Method ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    [self.view addSubview:self.navigationViews];
    [self.view addSubview:self.mainWebView];
}

#pragma mark <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< WKNavigationDelegate Method  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/*
 WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等
 */
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [AppMainWindow showHudWithText:@""];
    [self.errorView removeFromSuperview];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [AppMainWindow dismissHud];
    [self.view addSubview:self.errorView];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [AppMainWindow dismissHud];
}

//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    MyCustomLog(@"error:%@",error);
}

// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    [AppMainWindow dismissHud];
}

// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [AppMainWindow dismissHud];
//    NSString *substr = navigationAction.request.URL.absoluteString;
//    if ([CAFNOCacheTool filtrateDesignatedInfo:substr]) {
//        [kApplicationManager openURL:[NSURL URLWithString:substr] options:@{} completionHandler:^(BOOL success) {
//            ;
//        }];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }
//    else {
        decisionHandler(WKNavigationActionPolicyAllow);
//    }
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    [AppMainWindow dismissHud];
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//需要响应身份验证时调用 同样在block中需要传入用户身份凭证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    //用户身份信息
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        ///  如果没有错误的情况下 创建一个凭证，并使用证书
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }else {
            ///  验证失败，取消本次验证
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
    else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

//进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    MyCustomLog(@"进程被意外终止");
    [self reLoadWebViews];
}

#pragma mark -- WKUIDelegate
/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark ----------------------------------------------------- Every WebView Method -----------------------------------------------------
/// 重载网页
- (void)reLoadWebViews {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.baseURL];
    [request addValue:[self readCurrentCookieWithDomain:self.baseURLString] forHTTPHeaderField:@"Cookie"];
    [self.mainWebView loadRequest:request];
}

//解决第一次进入的cookie丢失问题
- (NSString *)readCurrentCookieWithDomain:(NSString *)domainStr {
    NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableString * cookieString = [[NSMutableString alloc]init];
    for (NSHTTPCookie*cookie in [cookieJar cookies]) {
        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    
    //删除最后一个“;”
    if ([cookieString hasSuffix:@";"]) {
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
    }
    
    return cookieString;
}

//解决 页面内跳转（a标签等）还是取不到cookie的问题
- (void)getCookie {
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //js函数
    NSString *JSFuncString =
    @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
    }\
    function getCookie(name)\
    {\
    var arr = document.cookie.match(new RegExp('(^| )'+name+'=([^;]*)(;|$)'));\
    if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
    var exp = new Date();\
    exp.setTime(exp.getTime() - 1);\
    var cval=getCookie(name);\
    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";
    
    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", cookie.name, cookie.value];
        [JSCookieString appendString:excuteJSString];
    }
    //执行js
    [_mainWebView evaluateJavaScript:JSCookieString completionHandler:nil];
}

#pragma mark **************************************************** Subgroup Views Lazy Load Method ****************************************************
#pragma mark **************************************************** Web About Views Lazy Load Method ****************************************************
- (NSURL *)baseURL {
    if (!_baseURL) {
        _baseURL = [NSURL URLWithString:self.baseURLString];
    }
    return _baseURL;
}

- (NSString *)baseURLString {
    if (!_baseURLString) {
        _baseURLString = self.agreementstring;
    }
    return _baseURLString;
}

- (WKWebView *)mainWebView {
    if (!_mainWebView) {
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        
        config.userContentController = wkUController;
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 14.5;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        
        _mainWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kWindowWidth, kWindowHeight - kNavigationBarHeight) configuration:config];
        // UI代理
        _mainWebView.UIDelegate = self;
        // 导航代理
        _mainWebView.navigationDelegate = self;
        _mainWebView.scrollView.bounces = NO;
        _mainWebView.scrollView.bouncesZoom = NO;
        _mainWebView.scrollView.scrollsToTop = NO;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _mainWebView.allowsBackForwardNavigationGestures = NO;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.baseURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:600.f];
        [request addValue:[self readCurrentCookieWithDomain:self.baseURLString] forHTTPHeaderField:@"Cookie"];
        [_mainWebView loadRequest:request];
    }
    return _mainWebView;
}

- (UIView *)errorViews {
    if (!_errorView) {
        _errorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kWindowHeight*0.5, kWindowWidth, kWindowHeight*0.5)];
        [_errorView setBackgroundColor:kWhiteColor];
        UILabel *hintLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kWindowWidth, kScreen_Y(0.5) - 100.0)];
        hintLab.textColor = kGrayColor;
        hintLab.textAlignment = NSTextAlignmentCenter;
        hintLab.font = SystemFont(16);
        hintLab.text = @"加载失败，请检查网络是否\n正常或者尝试重新加载.";
        hintLab.numberOfLines = 0;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_X(0.5) - 100.0, kScreen_Y(0.5) - 32.0, 200.0, 36.0)];
        btn.layer.borderColor = kGray2Color.CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.cornerRadius = 8.0;
        [btn setTitleColor:kBlackColor forState:UIControlStateNormal];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        btn.titleLabel.font = SystemFont(17);
        [btn addTarget:self action:@selector(reLoadWebViews) forControlEvents:UIControlEventTouchUpInside];
        [_errorView addSubview:hintLab];
        [_errorView addSubview:btn];
    }
    return _errorView;
}

- (UIView *)navigationViews {
    if (!_navigationViews) {
        _navigationViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, kWindowWidth, kNavigationBarHeight)];
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(8.0, kStatusBarHeight, 40.0, kNavigationBarContentHeight)];
        [backButton setImage:ImageByName(@"back_black_mark") forState:UIControlStateNormal];
        [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50.0, kStatusBarHeight, kWindowWidth - 100.0, kNavigationBarContentHeight)];
        titleLab.textColor = kBlackColor;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = SystemFont(18);
        titleLab.text = self.titlestring;
        
        [_navigationViews addSubview:backButton];
        [_navigationViews addSubview:titleLab];
    }
    return _navigationViews;
}

@end
