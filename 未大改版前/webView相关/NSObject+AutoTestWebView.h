//
//  NSObject+AutoTestWebView.h
//  MaiXiang
//
//  Created by mac on 2017/10/31.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AutoTestProxyWebView.h"

@interface NSObject (AutoTestWebView)

#pragma mark -webView相关
- (void)setBrsProxyWebView:(AutoTestProxyWebView *)proxyWebView;
- (AutoTestProxyWebView *) brsProxyWebView;
- (BOOL)brs_respondsToSelector:(SEL)aSelector;

@end
