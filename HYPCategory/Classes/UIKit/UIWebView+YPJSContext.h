//
//  UIWebView+YPJSContext.h
//  YPDemo
//
//  Created by Peng on 2018/10/29.
//  Copyright © 2018年 heyupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const kUIWebViewJSContext;

UIKIT_EXTERN API_DEPRECATED("No longer supported; please adopt WKWebView.", ios(2.0, 12.0)) API_UNAVAILABLE(tvos, macos)
@interface UIWebView (yp_JSContext)

//获取JS的运行环境
- (JSContext *)yp_JSContext;

- (void)yp_addJSInterface:(NSString *)name target:(id)target;

- (void)yp_addJSInterface:(NSString *)name handler:(void(^)(NSArray * params))handler;

@end

NS_ASSUME_NONNULL_END
