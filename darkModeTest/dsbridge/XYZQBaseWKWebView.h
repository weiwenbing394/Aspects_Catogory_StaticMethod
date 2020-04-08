//
//  XYZQBaseWKWebView.h
//  iIndustrial
//
//  Created by 魏文彬 on 2020/4/3.
//

#import <UIKit/UIKit.h>

#import "DWKWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYZQBaseWKWebView : DWKWebView

/// 初始化
/// @param frame 大小
/// @param scalesPageToFit 网页是否缩放
- (instancetype)initWithFrame:(CGRect)frame scalesPageToFit:(BOOL)scalesPageToFit;

/// 注册供js调用的原生方法类（默认已注册XYZQBaseWKWebViewPlugin类）
/// @param object 原生方法管理类
/// @param name 命名空间
- (void)xyzq_addJavascriptObject:(id)object name:(NSString *)name;

/// 移除供js调用的原生方法类
/// @param name 命名空间
-(void)xyzq_removeJavascriptObject:(NSString *)name;

/// 加载url
/// @param url 网址
- (void)xyzq_loadUrl:(NSString * _Nonnull)url;

/// 加载urlRequest
/// @param urlRequest
- (void)xyzq_loadRequest:(NSURLRequest *)urlRequest;

/// 加载html代码
/// @param string html代码
/// @param baseURL
- (void)xyzq_loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;

/// 执行任意js代码
/// @param javaScriptString js代码
/// @param completionHandler 结果block
- (void)xyzq_loadJavaScriptStr:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;

/// 调用js函数
/// @param methodName 函数名
/// @param args 参数
/// @param completionHandler 结果
- (void)xyzq_loadJavaScriptMethod:(NSString *)methodName arguments:(NSArray *)args completionHandler:(void (^)(id  _Nullable value))completionHandler;

/// 监听当前网页关闭事件
/// @param callback
- (void)xyzq_setJavascriptCloseWindowListener:(void(^_Nullable)(void))callback;

@end

NS_ASSUME_NONNULL_END
