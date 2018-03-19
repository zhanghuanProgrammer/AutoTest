//
//  UIWebView+Ext.m
//  MaiXiang
//
//  Created by mac on 2017/10/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UIWebView+Ext.h"
#import "NSObject+AutoTestWebView.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "AutoTestWebViewManager.h"
#import "AutoTestHeader.h"

static const int UIWebView_Links;
static const int UIWebView_IsDidFinishLoad;

@implementation UIWebView (Ext)

+ (void)load{
    [super load];
    
    if (AutoTest) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self swizzleMethod:@selector(respondsToSelector:) with:@selector(brs_respondsToSelector:) withClass:[NSObject class] isInstanceMethod:YES];
            [self swizzleInstanceMethod:@selector(loadRequest:) with:@selector(custom_loadRequest:)];
        });
    }
}


- (void)custom_loadRequest:(NSURLRequest *)request{
    self.delegate = [AutoTestWebViewManager shareInstance];
    NSObject *delegate = (NSObject *)self.delegate;
    if (delegate.brsProxyWebView == nil) {
        delegate.brsProxyWebView = [[AutoTestProxyWebView alloc] init];
    }
    delegate.brsProxyWebView.thisWebView = self;
    [self custom_loadRequest:request];
}

- (void)custom_webViewDidFinishLoad{
    [self js_allLinks];
    self.isDidFinishLoad=YES;
}

- (void)custom_DidFailLoadWithError{
    [self.links removeAllObjects];
    self.isDidFinishLoad=YES;
}

- (void)js_allLinks{
    [self.links removeAllObjects];
    
    JSContext *context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    NSString *js = @"function allLink() {\
    var linkArray=new Array();\
    var links = document.links;\
    for(var i = 0; i < links.length; i++) {\
    linkArray.push(links[i].href);\
    }\
    return linkArray;\
    }";
    
    [context evaluateScript:js];
    
    JSValue *value = [context[@"allLink"] callWithArguments:nil];
    
    NSArray *links=[value toArray];
    
    NSMutableArray *urls=[NSMutableArray array];
    for (NSString *link in links) {
        if ([link hasPrefix:@"http://"]||[link hasPrefix:@"https://"]||([link rangeOfString:@"http://"].location!=NSNotFound)||([link rangeOfString:@"https://"].location!=NSNotFound)) {
            [urls addObject:link];
        }
    }
    
    
    [self.links addObjectsFromArray:urls];
}

- (NSMutableArray *)links{
    NSMutableArray *links = objc_getAssociatedObject(self, &UIWebView_Links);
    if (!links) {
        links = [NSMutableArray array];
        objc_setAssociatedObject(self, &UIWebView_Links, links, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return links;
}

- (void)setLinks:(NSMutableArray *)links{
    if (!links) {
        links = [NSMutableArray array];
    }
    objc_setAssociatedObject(self, &UIWebView_Links, links, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isDidFinishLoad{
    id num=objc_getAssociatedObject(self, &UIWebView_IsDidFinishLoad);
    if (num) {
        return [num boolValue];
    }
    return NO;
}

- (void)setIsDidFinishLoad:(BOOL)isDidFinishLoad{
    objc_setAssociatedObject(self, &UIWebView_IsDidFinishLoad, [NSNumber numberWithBool:isDidFinishLoad], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
