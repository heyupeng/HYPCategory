//
//  UIWebView+YPJSContext.m
//  YPDemo
//
//  Created by Peng on 2018/10/29.
//  Copyright © 2018年 heyupeng. All rights reserved.
//

#import "UIWebView+YPJSContext.h"

NSString * const kUIWebViewJavaScriptContext = @"documentView.webView.mainFrame.javaScriptContext";

@implementation UIWebView (YPJSContext)

- (JSContext *)yp_jsContext {
    JSContext * jscontext = [self valueForKeyPath:kUIWebViewJavaScriptContext];
    return jscontext;
}

@end
