//
//  DisPlayAllView.m
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DisPlayAllView.h"
#import "UIGestureRecognizer+Ext.h"
#import "AutoTestHeader.h"
#import "UIViewController+Start.h"
#import "UIView+AutoTestExt.h"
#import "UIGestureRecognizer+YYKitAdd.h"

@interface DisPlayAllView ()
@property (nonatomic,assign)NSInteger windowLoadIndex;
@end

@implementation DisPlayAllView

- (void)storeInfoWithView:(UIView *)aView fatherView:(UIView *)fatherView atIndent:(int)indent layerDirector:(NSString *)layerDirector logText:(NSMutableString *)outstring toEvents:(NSMutableArray *)events{
    
    self.windowLoadIndex++;
    
    //记录当前控件所在的控制器
    UIViewController *vc=[aView getViewController];
   
    if ([vc isKindOfClass:[UIAlertController class]]) {//去除掉系统的弹出框,因为我暂时没有抓到系统的弹出框的点击Cell
        UIAlertController *alertVc=(UIAlertController *)vc;
        [alertVc dismissViewControllerAnimated:Push_Pop_Present_Dismiss_Animation completion:nil];
        return;
    }
    if ([aView isKindOfClass:[UIAlertView class]]) {//去除掉系统的弹出框,因为我暂时没有抓到系统的弹出框的点击代理对象
        UIAlertView *alertVIew=(UIAlertView *)aView;
        [alertVIew dismissWithClickedButtonIndex:0 animated:Push_Pop_Present_Dismiss_Animation];
        [alertVIew setHidden:YES];
        [alertVIew removeFromSuperview];
        return;
    }
    
    //如果需要收集事件
    if(events) {
        if ([aView isEventView]) {
            [events addObject:aView];
        }
    }
    //如果需要打印,拼接Log打印
    if(ShouldLogAllView){
        for (int i = 0; i < indent; i++)
            [outstring appendString:@"--"];
        
        [outstring appendFormat:@"[%2d] %@ %@ ==%@ %@\n", indent, [[aView class] description],[aView textDescription],NSStringFromCGRect(aView.frame),NSStringFromClass([aView getViewController].class)];
    }
}

- (void)dumpView:(UIView *)aView fatherView:(UIView *)fatherView atIndent:(int)indent layerDirector:(NSString *)layerDirector logText:(NSMutableString *)outstring toEvents:(NSMutableArray *)events{
    
    //获取记录相关信息
    [self storeInfoWithView:aView fatherView:fatherView atIndent:indent layerDirector:layerDirector logText:outstring toEvents:events];
    
    //继续递归遍历
    for (UIView *view in [aView subviews]){
        [self dumpView:view fatherView:aView atIndent:indent + 1 layerDirector:layerDirector logText:outstring toEvents:events];
    }
}

- (NSString *)displayViews:(UIView *)aView fatherView:(UIView *)fatherView toEvents:(NSMutableArray *)events logText:(NSMutableString *)outstring{
    self.windowLoadIndex=0;
    [self dumpView:aView fatherView:fatherView atIndent:0 layerDirector:@"" logText:outstring toEvents:events];
    return outstring;
}

- (NSMutableArray *)disPlayAllView:(UIView *)aView fatherView:(UIView *)fatherView{
    NSMutableArray *events=[NSMutableArray array];
    NSMutableString *outstring=[NSMutableString string];
    [self displayViews:aView fatherView:fatherView toEvents:events logText:outstring];
    
    if (ShouldLogAllView) {
        NSLog(@"Log Window Director:\n%@",outstring);
    }
    return events;
}

- (NSMutableArray *)disPlayAllViewForWindow{
    return [self disPlayAllView:[UIApplication sharedApplication].keyWindow fatherView:nil];
}

- (void)logWindow:(UIWindow *)window{
    NSMutableString *outstring=[NSMutableString string];
    NSMutableArray *events=[NSMutableArray array];
    [self displayViews:window fatherView:nil toEvents:events logText:outstring];
    NSLog(@"打印所有view:\n%@",outstring);
}

- (void)logKeyWindow{
    [self logWindow:[UIApplication sharedApplication].keyWindow];
}

@end
