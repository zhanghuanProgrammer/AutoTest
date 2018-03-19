//
//  ZHEventModel.m
//  CJOL
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ZHEventModel.h"
#import "UIControllerEventRecoder.h"
#import "UIViewController+Start.h"
#import "NSArrayTool.h"
#import "UIWebView+Ext.h"
#import "AutoTestHeader.h"

@implementation ZHEventModel

- (CGRect)frameInWindow{
    if (self.objSelf) {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        CGRect rect=[self.objSelf convertRect:self.objSelf.bounds toView:window];
        return rect;
    }
    return CGRectZero;
}
- (CGRect)rect{
    return [self frameInWindow];
}

- (BOOL)isTouchIn:(CGPoint)point{
    return CGRectContainsPoint(self.frameInWindow, point);
}

- (CGPoint)centerInWindow{
    if (self.objSelf) {
        CGRect rect=self.frameInWindow;
        return CGPointMake(rect.origin.x+rect.size.width/2.0, rect.origin.y+rect.size.height/2.0);
    }
    return CGPointZero;
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (BOOL)happenEvent{
    
    UIViewController *curVC_before=[UIViewController getCurrentVC];
//    NSLog(@"😄😄:%@",[self topViewController]);
//    NSLog(@"😄:%@",curVC_before);
    if (!DebugTap) return YES;
    BOOL ishappenEvent=NO;
    if (self.isUIGestureRecognizer&&self.gesTap) {
        if ([self.target respondsToSelector:self.action]) {
            [[UIControllerEventRecoder shareInstance]recorderEventForEventModel:self];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.action withObject:self.gesTap];
#pragma clang diagnostic pop
            ishappenEvent=YES;
        }
    }else if (self.isTableViewCellOrCollectionViewCell) {
        
        if ([self.target respondsToSelector:self.action]) {
            if ([self.objSelf isKindOfClass:[UITableViewCell class]]) {
                if (self.tableView) {
                    [[UIControllerEventRecoder shareInstance]recorderEventForEventModel:self];
                    [self.target tableView:self.tableView didSelectRowAtIndexPath:self.indexPath];
                    ishappenEvent=YES;
                }
            }
            if ([self.objSelf isKindOfClass:[UICollectionViewCell class]]) {
                if (self.collectionView) {
                    [[UIControllerEventRecoder shareInstance]recorderEventForEventModel:self];
                    [self.target collectionView:self.collectionView didSelectItemAtIndexPath:self.indexPath];
                    ishappenEvent=YES;
                }
            }
        }
    }else{
        if ([self.target respondsToSelector:self.action]) {
            [[UIControllerEventRecoder shareInstance]recorderEventForEventModel:self];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.action withObject:self.objSelf];
#pragma clang diagnostic pop
            ishappenEvent=YES;
        }
    }
    if (ishappenEvent) {
        UIViewController *curVC_after=[UIViewController getCurrentVC];
        if (curVC_before!=curVC_after) {
            [[UIControllerEventRecoder shareInstance]addChangeWindowControllerEvent:self];
        }
    }
    return ishappenEvent;
}

/**执行请求网址事件*/
- (void)loadRequest{
    if (self.isWebView) {
        static int timeCount=0;
        UIWebView *webView=(UIWebView *)self.objSelf;
        if (webView.links.count>0&&webView.isDidFinishLoad==YES) {
            if ([webView isKindOfClass:[UIWebView class]]) {
                webView.isDidFinishLoad=NO;
                [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSArrayTool anyObject:webView.links]]]];
                [[UIControllerEventRecoder shareInstance]recorderEventForEventModel:self];
                timeCount=0;
            }
        }else{
            timeCount++;
            if (timeCount>=10) {
                [UIViewController popOrDismissViewController:[UIViewController getCurrentVC]];
            }
        }
    }
}

@end
