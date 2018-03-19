//
//  ZHGetAllEvent.m
//  CJOL
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ZHGetAllEvent.h"
#import "UIGestureRecognizer+Ext.h"
#import "ZHGestureRecognizerTargetAndAction.h"
#import "ZHEventModel.h"
#import "UIView+LayerIndex.h"
#import "AutoTestHeader.h"
#import "UIGestureRecognizer+YYKitAdd.h"
#import "UIView+AutoTestExt.h"

@implementation ZHGetAllEvent

+ (void)getViewGesInfo:(UIView *)view toEvents:(NSMutableArray *)events{
    //获取view的手势
    NSArray *gestureRecognizers=view.gestureRecognizers;
    if (gestureRecognizers.count>0) {
        for (UIGestureRecognizer *ges in gestureRecognizers) {
            if ([ges isKindOfClass:[UITapGestureRecognizer class]]) {
                if (ges.view) {
                    
                    NSArray *allTargetAndAction=[ges allGestureRecognizerTargetAndAction];
                    for (ZHGestureRecognizerTargetAndAction *targetAndAction in allTargetAndAction) {
                        
                        ZHEventModel *eventModel=[ZHEventModel new];
                        eventModel.target=targetAndAction.target;
                        eventModel.action=targetAndAction.action;
                        eventModel.objSelf=ges.view;
                        eventModel.gesTap=(UITapGestureRecognizer *)ges;
                        eventModel.isUIGestureRecognizer=YES;
                        [ges.view cornerRadiusBySelfWithColor:AutoTest_Ges_Tap_Color];
                        [events addObject:eventModel];
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
            for (NSString *actionStr in allActions) {
                if (view.userInteractionEnabled&&view.alpha>0.1&&(![view isHidden])) {
                    ZHEventModel *eventModel=[ZHEventModel new];
                    eventModel.target=target;
                    eventModel.action=NSSelectorFromString(actionStr);
                    eventModel.objSelf=view;
                    [view cornerRadiusBySelfWithColor:AutoTest_UIControl_Action_Color];
                    [events addObject:eventModel];
                }
            }
        }
    }
    
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableView=((UITableView *)view);
        
        for (UITableViewCell *cell in [tableView visibleCells]) {
            if (tableView.delegate) {
                ZHEventModel *eventModel=[ZHEventModel new];
                eventModel.isTableViewCellOrCollectionViewCell=YES;
                eventModel.target=tableView.delegate;
                eventModel.action=NSSelectorFromString(@"tableView:didSelectRowAtIndexPath:");
                eventModel.objSelf=cell;
                NSIndexPath *indexPath=[tableView indexPathForCell:cell];
                eventModel.indexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                eventModel.tableView=tableView;
                [cell cornerRadiusBySelfWithColor:AutoTest_Ges_Tap_Color];
                [events addObject:eventModel];
            }
        }
    }
    
    if ([view isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView=((UICollectionView *)view);
        for (UICollectionViewCell *cell in [collectionView visibleCells]) {
            if (collectionView.delegate) {
                ZHEventModel *eventModel=[ZHEventModel new];
                eventModel.isTableViewCellOrCollectionViewCell=YES;
                eventModel.target=collectionView.delegate;
                eventModel.action=NSSelectorFromString(@"collectionView:didSelectItemAtIndexPath:");
                eventModel.objSelf=cell;
                NSIndexPath *indexPath=[collectionView indexPathForCell:cell];
                eventModel.indexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                eventModel.collectionView=collectionView;
                [cell cornerRadiusBySelfWithColor:AutoTest_Ges_Tap_Color];
                [events addObject:eventModel];
                
            }
        }
    }
    
//    if ([view isKindOfClass:[UIScrollView class]]) {
//        UIScrollView *scrollView=((UIScrollView *)view);
//        //可以滚动的,不可以滚动的不收集事件
//        if (scrollView.scrollEnabled) {
//            ZHEventModel *eventModel=[ZHEventModel new];
//            eventModel.isScrollView=YES;
//            eventModel.objSelf=scrollView;
//            [scrollView cornerRadiusWithFloat:0 borderColor:AutoTest_ScollSwipe_Color borderWidth:1];
//            [events addObject:eventModel];
//        }
//    }
    
    //UITabBarButton  //这里很蛋疼的是有几个系统自带的UITabBarButton,这个按钮是系统自带的点击事件,获取不到,不过可以拿取它的tabbar,再根据UITabBarButton的位置调用TabbarViewController的selectedIndex属性,就可以了
    if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
        if(view.alpha-0.245f!=0.0f){//为了重用自己这个函数,先设置一个自定义值
            if (view.userInteractionEnabled&&view.alpha>0.1&&(![view isHidden])){
                UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
                    if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                        id button=view;
                        if([button respondsToSelector:@selector(tabBar)]){
                            UITabBar *tabbar=[button tabBar];
                            if (tabbar) {
                                NSMutableArray *buttonSuperviews=[NSMutableArray array];
                                for (UIView *tempView in [button superview].subviews)
                                    if ([tempView isKindOfClass:NSClassFromString(@"UITabBarButton")])[buttonSuperviews addObject:tempView];
                                
                                NSInteger index=[buttonSuperviews indexOfObject:button];
                                UIViewController *vc=[tabbar getViewController];
                                if ([vc isKindOfClass:[UITabBarController class]]) {
                                    UITabBarController *tabBarVc=(UITabBarController *)vc;
                                    tabBarVc.selectedIndex=index;
                                }
                            }
                        }
                    }
                }];
                view.userInteractionEnabled=YES;
                
                tap.isYYKit=YES;//确保是临时添加的,不能重复添加
                BOOL isAdd=NO;
                for (UIGestureRecognizer *ges in view.gestureRecognizers) {
                    if (ges.isYYKit) isAdd=YES;
                }
                if (isAdd==NO) {
                    [view addGestureRecognizer:tap];
                    view.alpha=0.245;//为了重用自己这个函数,先设置一个自定义值
                    [self getViewGesInfo:view toEvents:events];
                    view.alpha=1;//用完了就恢复
                }
            }
        }
    }
    
    if ([view isKindOfClass:[UIWebView class]]) {
        UIWebView *webView=((UIWebView *)view);
        ZHEventModel *eventModel=[ZHEventModel new];
        eventModel.isWebView=YES;
        eventModel.objSelf=webView;
        [webView cornerRadiusWithFloat:0 borderColor:AutoTest_ScollSwipe_Color borderWidth:1];
        [events addObject:eventModel];
    }
}

@end
