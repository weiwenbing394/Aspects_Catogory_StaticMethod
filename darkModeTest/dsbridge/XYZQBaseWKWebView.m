//
//  XYZQBaseWKWebView.m
//  iIndustrial
//
//  Created by 魏文彬 on 2020/4/3.
//

#import "XYZQBaseWKWebView.h"

#import "SwizzeMethod.h"

//#import "XYZQBaseWKWebViewPlugin.h"

@implementation XYZQBaseWKWebView

#pragma mark life cycle
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame scalesPageToFit:YES];
}

- (instancetype)initWithFrame:(CGRect)frame scalesPageToFit:(BOOL)scalesPageToFit
{
    if (self = [super initWithFrame:frame configuration:[self getWKConfig:scalesPageToFit]])
    {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.autoresizingMask = UIViewAutoresizingNone;
        if (@available(iOS 11.0, *))
        {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#if DEBUG
        [self setDebugMode:true];
#endif
        //注册供js调用的原生方法管理类
//        [self addJavascriptObject:[[XYZQBaseWKWebViewPlugin alloc]init] namespace:NSStringFromClass([XYZQBaseWKWebViewPlugin class])];
    }
    return self;
};

+(void)load
{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hookWKWebView];
    });
}

#pragma privete method
- (WKWebViewConfiguration*)getWKConfig:(BOOL)scalesPageToFit
{
    NSString *jScript = @"";
    if (scalesPageToFit) {
        jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    }
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    wkWebConfig.mediaPlaybackRequiresUserAction = NO;
    
    return wkWebConfig;
}

+ (void)hookWKWebView
{
    SwizzlingMethod([self class], @selector(webView:decidePolicyForNavigationAction:decisionHandler:), @selector(wk_webView:decidePolicyForNavigationAction:decisionHandler:));
}

#pragma mark public method
- (void)xyzq_addJavascriptObject:(id)object name:(NSString *)name
{
    [self addJavascriptObject:object namespace:name];
};

-(void)xyzq_removeJavascriptObject:(NSString *)name
{
    [self removeJavascriptObject:name];
};

- (void)xyzq_loadUrl:(NSString * _Nonnull)url
{
    [self loadUrl:url];
};

- (void)xyzq_loadRequest:(NSURLRequest *)urlRequest
{
    [self loadRequest:urlRequest];
};

- (void)xyzq_loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;
{
    [self loadHTMLString:string baseURL:baseURL];
};

- (void)xyzq_loadJavaScriptStr:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler
{
    [self evaluateJavaScript:(javaScriptString) completionHandler:completionHandler];
};

- (void)xyzq_loadJavaScriptMethod:(NSString *)methodName arguments:(NSArray *)args completionHandler:(void (^)(id  _Nullable value))completionHandler
{
    [self callHandler:methodName arguments:args completionHandler:completionHandler];
}

- (void)xyzq_setJavascriptCloseWindowListener:(void(^_Nullable)(void))callback
{
    [self setJavascriptCloseWindowListener:callback];
};

#pragma mark - Delegates WKNavigationDelegate
- (void)wk_webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *requestURL = navigationAction.request.URL;
    NSString *requestString = [requestURL absoluteString];
    
    if ([requestString isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([requestURL.scheme isEqualToString:@"tel"])
    {
        if ([app canOpenURL:requestURL])
        {
            [app openURL:requestURL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    if ([requestURL.scheme isEqualToString:@"mailto"])
    {
        if ([app canOpenURL:requestURL])
        {
            [app openURL:requestURL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    if ([requestURL.absoluteString containsString:@"ituns.apple.com"])
    {
        if ([app canOpenURL:requestURL])
        {
            [app openURL:requestURL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    [self wk_webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
}


@end
