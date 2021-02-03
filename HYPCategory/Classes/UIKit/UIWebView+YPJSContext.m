//
//  UIWebView+YPJSContext.m
//  YPDemo
//
//  Created by Peng on 2018/10/29.
//  Copyright © 2018年 heyupeng. All rights reserved.
//

#import "UIWebView+YPJSContext.h"

NSString * const kUIWebViewJSContext = @"documentView.webView.mainFrame.javaScriptContext";

@implementation UIWebView (YPJSContext)

- (JSContext *)yp_JSContext {
    JSContext * jscontext = [self valueForKeyPath:kUIWebViewJSContext];
    return jscontext;
}

- (void)yp_addJSInterface:(NSString *)name target:(id)target {
    JSContext * jsContext = [self yp_JSContext];
    jsContext[name] = target;
    
    if (!jsContext.exceptionHandler) return;;
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
//        context.exception = exceptionValue;
        NSLog(@"JS Handler 异常信息：%@", exceptionValue);
    };
}

- (void)yp_addJSInterface:(NSString *)name callblock:(void(^)(NSArray * params))handler {
    JSContext * context = [self yp_JSContext];
    //JS上下文增加可调用OC方法的映射
    if (!handler) {
        context[name] = nil;
        return;
    }
    context[name] = ^() {
        //用数组接收传过来的多个参数
        NSArray *params = [JSContext currentArguments];
        //然后取出相对应的值
        if (handler) {
            handler(params);
        }
    };
}

@end
