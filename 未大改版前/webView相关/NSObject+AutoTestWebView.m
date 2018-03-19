//
//  NSObject+AutoTestWebView.m
//  MaiXiang
//
//  Created by mac on 2017/10/31.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NSObject+AutoTestWebView.h"
#import "UIWebView+Ext.h"
#import <objc/runtime.h>

@implementation NSObject (AutoTestWebView)

static char *kAutoTestWebViewKey = "kAutoTestWebViewKey";

- (void)setBrsProxyWebView:(AutoTestProxyWebView *)proxyWebView {
    objc_setAssociatedObject(self, kAutoTestWebViewKey, proxyWebView, OBJC_ASSOCIATION_RETAIN);
}

- (AutoTestProxyWebView *) brsProxyWebView{
    AutoTestProxyWebView *proxyWebView = objc_getAssociatedObject(self, kAutoTestWebViewKey);
    return proxyWebView;
}

- (BOOL)brs_respondsToSelector:(SEL)aSelector {
    if (self.brsProxyWebView.thisWebView != nil) {
        NSString *selStr = NSStringFromSelector(aSelector);
        if ([selStr isEqualToString:@"webViewDidFinishLoad:"]){
            [self.brsProxyWebView.thisWebView custom_webViewDidFinishLoad];
        }
        if ([selStr isEqualToString:@"webView:didFailLoadWithError:"]){
            [self.brsProxyWebView.thisWebView custom_DidFailLoadWithError];
        }
    }
    return  [self brs_respondsToSelector:aSelector];
}

@end
