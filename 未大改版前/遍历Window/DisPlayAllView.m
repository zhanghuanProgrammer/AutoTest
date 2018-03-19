//
//  DisPlayAllView.m
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DisPlayAllView.h"
#import "UIGestureRecognizer+Ext.h"
#import "ZHGestureRecognizerTargetAndAction.h"
#import "ZHEventModel.h"
#import "UIView+LayerIndex.h"
#import "ZHGetAllEvent.h"
#import "AutoTestHeader.h"
#import "UIViewController+Start.h"
#import "UIView+AutoTestExt.h"
#import "UIGestureRecognizer+YYKitAdd.h"
#import "NSArrayTool.h"

@interface DisPlayAllView ()
@property (nonatomic,assign)NSInteger windowLoadIndex;
@end

@implementation DisPlayAllView

- (void)storeInfoWithView:(UIView *)aView fatherView:(UIView *)fatherView atIndent:(int)indent layerDirector:(NSString *)layerDirector logText:(NSMutableString *)outstring toEvents:(NSMutableArray *)events{
    
    self.windowLoadIndex++;
    aView.windowLoadIndex=self.windowLoadIndex;
    
    //记录所在第几个嵌套层,用于方便排序
    aView.layerIndex=indent;
    aView.isDisplayedInScreen=[aView judgeIsDisplayedInScreen];
    
    //记录层级director 作用是用来标记这个控件的绝对位置 比如 window/view/tableview/tableviewcell/imageview
    layerDirector=[layerDirector stringByAppendingPathComponent:NSStringFromClass([aView class])];
    aView.layerDirector=layerDirector;
    
    //记录当前控件所在的控制器
    UIViewController *vc=[aView getViewController];
    if ([vc isKindOfClass:[UITabBarController class]]) {
        aView.isBelowTabBar=YES;
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        aView.isBelowNavagationBar=YES;
    }
    
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
    if (vc) aView.curViewController=NSStringFromClass(vc.class);
    else aView.curViewController=fatherView.curViewController;
    
    //记录viewController的层级director 比如 UITabBarController/UINavigationViewController/HomeViewController/SubViewController
    if(fatherView!=nil){
        if ([[fatherView.viewControllerDirector lastPathComponent] isEqualToString:aView.curViewController]) {
            aView.viewControllerDirector=fatherView.viewControllerDirector;
            aView.viewControllerDirectorCount=fatherView.viewControllerDirectorCount;
        }else{
            aView.viewControllerDirector=[fatherView.viewControllerDirector stringByAppendingPathComponent:aView.curViewController];
            aView.viewControllerDirectorCount=fatherView.viewControllerDirectorCount+1;
        }
    }else{
        aView.viewControllerDirector=aView.curViewController;
        aView.viewControllerDirectorCount=1;
    }
    
    //如果需要收集事件
    if(events) {
        [ZHGetAllEvent getViewGesInfo:aView toEvents:events];
    }
    if ([self isEvtentView:aView]) {
        //如果需要打印,拼接Log打印
        if(ShouldLogAllView){
            for (int i = 0; i < indent; i++)
                [outstring appendString:@"--"];
            
            [outstring appendFormat:@"[%2d] %@ %@ ==%@ %@\n", indent, [[aView class] description],[aView textDescription],NSStringFromCGRect(aView.frame),NSStringFromClass([aView getViewController].class)];
        }
    }
}

- (BOOL)isEvtentView:(UIView *)view{
    NSArray *gestureRecognizers=view.gestureRecognizers;
    if (gestureRecognizers.count>0) {
        for (UIGestureRecognizer *ges in gestureRecognizers) {
            if ([ges isKindOfClass:[UITapGestureRecognizer class]]) {
                if (ges.view) {
                    NSArray *allTargetAndAction=[ges allGestureRecognizerTargetAndAction];
                    if (allTargetAndAction.count>0) {
                        return YES;
                    }
                }
            }
        }
    }
    
    if ([view isKindOfClass:[UIControl class]]) {
        UIControl *control=(UIControl *)view;
        UIControlEvents allControlEvents=[control allControlEvents];
        NSSet *allTargets=[control allTargets];
        for (id target in allTargets) {
            NSArray *allActions=[control actionsForTarget:target forControlEvent:allControlEvents];
            if (allActions.count>0) {
                return YES;
            }
        }
    }
    
    if ([view isKindOfClass:[UITableViewCell class]] || [view isKindOfClass:[UICollectionViewCell class]] || [view isKindOfClass:[UIScrollView class]] || [view isKindOfClass:[UIWebView class]]) {
        return YES;
    }
    
    if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
        return YES;
    }
    
    return NO;
}

- (void)dumpView:(UIView *)aView fatherView:(UIView *)fatherView atIndent:(int)indent layerDirector:(NSString *)layerDirector logText:(NSMutableString *)outstring toEvents:(NSMutableArray *)events{
    
    //获取记录相关信息
    [self storeInfoWithView:aView fatherView:fatherView atIndent:indent layerDirector:layerDirector logText:outstring toEvents:events];
    
    //需要继续遍历tableView,否则遍历不到所有的tableViewCell
    if ([aView isKindOfClass:[UITableView class]]) {
        UITableView *tableView=((UITableView *)aView);
        
        NSMutableArray *visibleCells=[NSMutableArray arrayWithArray:[tableView visibleCells]];
        [NSArrayTool sortTableView:tableView visibleCells:visibleCells];
        for (UITableViewCell *cell in [visibleCells reverseObjectEnumerator]) {
            [self dumpView:cell fatherView:aView atIndent:indent + 1 layerDirector:layerDirector logText:outstring toEvents:events];
            NSIndexPath *indexPath=[tableView indexPathForCell:cell];
            cell.layerDirector=[cell.layerDirector stringByAppendingPathComponent:[NSString stringWithFormat:@"section-%zd-row-%zd",indexPath.section,indexPath.row]];
        }
        //继续递归遍历
        for (UIView *view in [aView subviews]){
            if ([view isKindOfClass:[UITableViewCell class]]) {
                continue;
            }
            [self dumpView:view fatherView:aView atIndent:indent + 1 layerDirector:layerDirector logText:outstring toEvents:events];
        }
    }
    
    //需要继续遍历collectionView,否则遍历不到所有的collectionViewCell
    else if ([aView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView=((UICollectionView *)aView);
        NSMutableArray *visibleCells=[NSMutableArray arrayWithArray:[collectionView visibleCells]];
        [NSArrayTool sortCollectionView:collectionView visibleCells:visibleCells];
        for (UICollectionViewCell *cell in visibleCells) {
            [self dumpView:cell fatherView:aView atIndent:indent + 1 layerDirector:layerDirector logText:outstring toEvents:events];
            NSIndexPath *indexPath=[collectionView indexPathForCell:cell];
            cell.layerDirector=[cell.layerDirector stringByAppendingPathComponent:[NSString stringWithFormat:@"section-%zd-row-%zd",indexPath.section,indexPath.row]];
        }
        //继续递归遍历
        for (UIView *view in [aView subviews]){
            if ([view isKindOfClass:[UICollectionViewCell class]]) {
                continue;
            }
            [self dumpView:view fatherView:aView atIndent:indent + 1 layerDirector:layerDirector logText:outstring toEvents:events];
        }
    }else{
        //继续递归遍历
        for (UIView *view in [aView subviews]){
            [self dumpView:view fatherView:aView atIndent:indent + 1 layerDirector:layerDirector logText:outstring toEvents:events];
        }
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
