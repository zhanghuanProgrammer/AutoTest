//
//  EventHelpTool.m
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "EventHelpTool.h"
#import "ZHEventModel.h"
#import "UIControllerEventRecoder.h"
#import "UIView+LayerIndex.h"
#import "RegionsTool.h"
#import "UIViewController+Start.h"
#import "UIView+AutoTestExt.h"
#import "NSArrayTool.h"

@implementation EventHelpTool

+ (id)randomTabBarEvent:(NSArray *)events{
    NSMutableArray *allTabBarEvent=[NSMutableArray array];
    for (ZHEventModel *event in events) {
        if (event.objSelf.isBelowTabBar) {
            [allTabBarEvent addObject:event];
            event.isRandomAddTabBarOrNavagationBarEvent=YES;
        }
    }
    return [NSArrayTool anyObject:allTabBarEvent];
}

+ (id)randomNavagationBarEvent:(NSArray *)events{
    NSMutableArray *allNavagationBarEvent=[NSMutableArray array];
    for (ZHEventModel *event in events) {
        if (event.objSelf.isBelowNavagationBar) {
            [allNavagationBarEvent addObject:event];
            event.isRandomAddTabBarOrNavagationBarEvent=YES;
        }
    }
    return [NSArrayTool anyObject:allNavagationBarEvent];
}

//对它进行排序,这样可以让最上面的控件先接受点击事件
+ (void)sortEventsByConditionWithLayerIndexDES:(NSMutableArray *)events{
    if ([events isKindOfClass:[NSMutableArray class]]) {
        [events sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            ZHEventModel *event1=(ZHEventModel *)obj1;
            ZHEventModel *event2=(ZHEventModel *)obj2;
            return event1.objSelf.layerIndex>event2.objSelf.layerIndex;
        }];
    }
}

//对它进行排序,这样可以让控件事件按ViewController归类,并且尽量让最window上最顶层的ViewController的事件接受点击事件
+ (void)sortEventsByConditionWithViewControllerDirector:(NSMutableArray *)events{
    if ([events isKindOfClass:[NSMutableArray class]]) {
        [events sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            ZHEventModel *event1=obj1;
            ZHEventModel *event2=obj2;
            if (event1.objSelf.viewControllerDirectorCount==event2.objSelf.viewControllerDirectorCount) {
                return event1.objSelf.windowLoadIndex<event2.objSelf.windowLoadIndex;
            }
            return event1.objSelf.viewControllerDirectorCount<event2.objSelf.viewControllerDirectorCount;
        }];
    }
}

//筛选出所有在window边框内的事件控件,之外的不要
+ (NSMutableArray *)allInScreen:(NSArray *)events{
    NSMutableArray *allInScreenEvents=[NSMutableArray array];
    for (ZHEventModel *event in events) {
        if (event.objSelf.isDisplayedInScreen) {
            [allInScreenEvents addObject:event];
        }
    }
    return allInScreenEvents;
}

+ (void)filterEvents:(NSMutableArray *)events withDirectorCount:(NSInteger)directorCount{
    
    if (directorCount<0) {
        return;
    }
    
    NSMutableArray *sameLevelViewControllerEvents=[NSMutableArray array];
    for (ZHEventModel *event in events) {
        if(event.objSelf.viewControllerDirectorCount==directorCount){
            [sameLevelViewControllerEvents addObject:event];
        }
    }
    
    if (sameLevelViewControllerEvents.count>0) {
        [NSArrayTool reverse:sameLevelViewControllerEvents];
        NSArray *fitArr=[RegionsTool filterEvents:sameLevelViewControllerEvents];
        [events removeObjectsInArray:fitArr];
    }
    
    [self filterEvents:events withDirectorCount:directorCount-1];
}

/**判断所有事件控件是否有可以滑动的的ScrollView*/
+ (BOOL)canScroll:(NSArray *)events{
    for (ZHEventModel *event in events) {
        if (event.isScrollView) {
            return YES;
        }
    }
    return NO;
}

/**判断所有事件控件是否有WebView*/
+ (BOOL)hasWebViewEvent:(NSArray *)events{
    for (ZHEventModel *event in events) {
        if (event.isWebView) {
            if (![[UIControllerEventRecoder shareInstance] canRecorderEventForEventModel:event]) {
                continue;
            }
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)allWebView:(NSArray *)events{
    NSMutableArray *allWebViews=[NSMutableArray array];
    for (ZHEventModel *event in events) {
        if (event.isWebView) {
            if (![[UIControllerEventRecoder shareInstance] canRecorderEventForEventModel:event]) {
                continue;
            }
            [allWebViews addObject:event];
        }
    }
    return allWebViews;
}

/**这个函数是用来筛选window上所有事件控件,结合自己设置的匹配条件,找出最优的可以点击的控件事件集合*/
+ (NSMutableArray *)allSuggestEventView_Click:(NSMutableArray *)events{
    
    NSMutableArray *oraginalArrM=[NSMutableArray arrayWithArray:events];
    
//    [events setArray:[self allInScreen:events]];
    
    NSInteger random=arc4random()%10;
    if (random<2) {// 1/5的概率筛选不被其它事件区域遮挡的控件
        [events setArray:[RegionsTool filterEvents:events]];
    }
    
    [self sortEventsByConditionWithViewControllerDirector:events];
    
//    ZHEventModel *lastModel=[events lastObject];
//    [self filterEvents:events withDirectorCount:lastModel.objSelf.viewControllerDirectorCount];

    NSString *mostMatchController=[self mostMatchController:events forFatherMostEnableUpViewController:nil];
    
    return [self searchCanHappenEventView_Click:events allInScreens:oraginalArrM mostMatchController:mostMatchController];
}

/**这个函数是用来筛选window上所有可以滑动的ScrollView(包括子类)控件*/
+ (NSArray *)allCanHappenEventView_Scroll:(NSArray *)events{
    NSMutableArray *centerPointArrM=[NSMutableArray array];
    
    for (ZHEventModel *event in events) {
        if (event.isScrollView) {
            [centerPointArrM addObject:event];
        }
    }
    
    return centerPointArrM;
}

#pragma mark -下面是筛选过程的细节
+ (NSMutableArray *)searchCanHappenEventView_Click:(NSArray *)events allInScreens:(NSArray *)allInScreens mostMatchController:(NSString *)mostMatchController{
    
    NSMutableArray *centerPointEventArrM=[NSMutableArray array];
    
    if (mostMatchController) {
        for (ZHEventModel *event in events) {
            if (![[UIControllerEventRecoder shareInstance] canRecorderEventForEventModel:event]) {
                continue;
            }
            if (![event.objSelf.curViewController isEqualToString:mostMatchController]) {
                continue;
            }
            if (!event.isScrollView) {//因为这类事件被记录用来滑动
                if (event.isUIGestureRecognizer&&event.gesTap) {
                    [centerPointEventArrM addObject:event];
                }else if (event.isTableViewCellOrCollectionViewCell) {
                    if ([event.target respondsToSelector:event.action]) {
                        if ([event.objSelf isKindOfClass:[UITableViewCell class]]) {
                            if (event.tableView) {
                                [centerPointEventArrM addObject:event];
                            }
                        }
                        if ([event.objSelf isKindOfClass:[UICollectionViewCell class]]) {
                            if (event.collectionView) {
                                [centerPointEventArrM addObject:event];
                            }
                        }
                    }
                }else{
                    if ([event.target respondsToSelector:event.action]) {
                        [centerPointEventArrM addObject:event];
                    }
                }
            }
        }
    }
    
    if (centerPointEventArrM.count<=0) {
        //里面的控件都已经点击了很对次,不需要再点击了,退出这个界面
        UIViewController *curVC_Before=[UIViewController getCurrentVC];
        [UIViewController popOrDismissViewController:[UIViewController getCurrentVC]];
        UIViewController *curVC_After=[UIViewController getCurrentVC];
        if (curVC_Before==curVC_After) {//说明已经到栈顶了
            
            mostMatchController=[self mostMatchController:events forFatherMostEnableUpViewController:mostMatchController];
            if (mostMatchController.length>0) {
                return [self searchCanHappenEventView_Click:allInScreens allInScreens:allInScreens mostMatchController:mostMatchController];
            }else{
                return centerPointEventArrM;
            }
        }
    }
    
    //随机添加一个TabBar和NavagationBar事件
    if (arc4random()%2==0) {
        NSMutableArray *tempArr=[NSMutableArray array];
        ZHEventModel *lastEvent=[centerPointEventArrM lastObject];
        UIViewController *vc=[lastEvent.objSelf getViewController];
        if (!vc.navigationController.navigationBarHidden) {
            ZHEventModel *randomEvent=[EventHelpTool randomNavagationBarEvent:events];
            if (randomEvent) {
                [tempArr addObject:randomEvent];
            }
        }
        if (!vc.tabBarController.tabBar.hidden) {
            ZHEventModel *randomEvent=[EventHelpTool randomTabBarEvent:events];
            if (randomEvent) {
                [tempArr addObject:randomEvent];
            }
        }
        if (tempArr.count>0) {
            [centerPointEventArrM addObject:[NSArrayTool anyObject:tempArr]];
        }
    }
    
    return centerPointEventArrM;
}

/**分析这些事件,找出最适合的events的viewcontroller*/
+ (NSString *)mostMatchController:(NSArray *)events forFatherMostEnableUpViewController:(NSString *)forFatherMostEnableUpViewController{
    NSString *mostMatchController=[self mostEnableUpViewController:events forFatherMostEnableUpViewController:forFatherMostEnableUpViewController];
    while (mostMatchController!=nil) {
        if ([self haveAllMostHappenForViewController:mostMatchController events:events]) {
            return mostMatchController;//找到了
        }
        mostMatchController=[self mostEnableUpViewController:events forFatherMostEnableUpViewController:mostMatchController];
    }
    return @"";
}

/**去找指定某个ViewController下面的还能有可点击控件的ViewController相关的event 如果指定的ViewController为nil,说明是找最顶端的*/
+ (NSString *)mostEnableUpViewController:(NSArray *)events forFatherMostEnableUpViewController:(NSString *)forFatherMostEnableUpViewController{
    if(forFatherMostEnableUpViewController==nil){
        //因为这个event已经基本上排好序了,所以可以从最顶端的控件开始分析
        if(events.count>0){
            ZHEventModel *model=[events firstObject];
            return model.objSelf.curViewController;
        }
    }else{
        BOOL isFind=NO;
        for (ZHEventModel *model in events) {
            if ([model.objSelf.curViewController isEqualToString:forFatherMostEnableUpViewController]) {
                isFind=YES;
            }else{
                if (isFind) {
                    return model.objSelf.curViewController;
                }
            }
        }
    }
    return nil;
}

/**在events里面去找,如果控件是在viewController里面的,并且还能再次点击(没有到达点击上限),就说明可以返回这个viewControllerString相关的event,否则只能说明这个viewControllerString已经没有必要再进去点击里面的控件了*/
+ (BOOL)haveAllMostHappenForViewController:(NSString *)viewControllerString events:(NSArray *)events{
    for (ZHEventModel *event in events) {
        if ([event.objSelf.curViewController isEqualToString:viewControllerString]) {
            if ([[UIControllerEventRecoder shareInstance] canRecorderEventForEventModel:event]) {
                if (!event.isScrollView){
                    return YES;
                }
            }
        }
    }
    return NO;
}

+ (void)LogAllEventsViewController:(NSArray *)events{
    NSMutableArray *eventsViewControllerArrM=[NSMutableArray array];
    for (ZHEventModel *event in events) {
        if ([[eventsViewControllerArrM lastObject] isEqualToString:event.objSelf.curViewController]==NO) {
            [eventsViewControllerArrM addObject:event.objSelf.curViewController];
        }
    }
    NSLog(@"%@",eventsViewControllerArrM);
}

@end
