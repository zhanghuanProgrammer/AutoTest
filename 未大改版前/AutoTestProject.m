//
//  AutoTestProject.m
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AutoTestProject.h"
#import "DisPlayAllView.h"
#import "UIGestureRecognizer+Ext.h"
#import "ZHGestureRecognizerTargetAndAction.h"
#import "ZHEventModel.h"
#import "UIView+LayerIndex.h"
#import "AutoTestHeader.h"
#import "UIScrollView+AutoScroll.h"
#import "EventHelpTool.h"
#import "UIView+AutoTestExt.h"
#import "UIViewController+Start.h"
#import "UIControllerEventRecoder.h"
#import "NSArrayTool.h"
#import "CurVC.h"
//#import "TreeModel.h"

@implementation AutoTestProject

+ (AutoTestProject *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static AutoTestProject *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[AutoTestProject alloc] init];
        _sharedObject.isRuning=NO;
        brs_hook_ui();
#if AutoTest_CrashAutoReStart
        NSSetUncaughtExceptionHandler (&UnCaughtExceptionHandler);
#endif
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//保持APP常亮不会自动息屏和进入锁屏状态,这样可以整晚测试了
    });
    return _sharedObject;
}

/**如果APP崩溃,调用这个方法打开其他的APP,再由其他的APP自动打开此APP,实现崩溃后自动启动,这样可以整夜测试了,前提是安装testapp2并且两个APP可以实现互相跳转*/
void UnCaughtExceptionHandler(NSException *exception){
//    [AutoTestProject capture]; 如果有必要,可以实现崩溃前截屏并保存至收集,供查看所有可能崩溃的地方
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"testapp2://"]]){
//        NSString *text=[[TreeModel sharedObj]printTree];
//        [text writeToFile:@"/Users/mac/Desktop/代码助手.m" atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"testapp2://2"]];
    }
}

/**如果有需要可以调用这个方法打开其他的APP,再由其他的APP自动打开此APP,实现进入后台再进入前台的自动测试*/
- (void)enterBackground_enterForeground_Event{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"testapp2://"]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"testapp2://2"]];
    }
}

/**window截屏*/
+ (UIImage *)capture {
    
    UIView *view = [UIApplication sharedApplication].keyWindow;
    if(view){
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
    
    return [UIImage new];
}

- (void)autoTest{
    self.isRuning=YES;
    
    NSMutableArray *events=[[DisPlayAllView new] disPlayAllViewForWindow];
    [self atLeastRunOne:events];
//    [[ZHDraw new]saveDrawRect];
}

/**随机触发事件,至少要触发一种事件成功*/
- (void)atLeastRunOne:(NSMutableArray *)events{
    
    NSInteger random_Event=arc4random()%10;
    if (random_Event<3) {//滚动事件
        if([EventHelpTool canScroll:events]){
            [self scrollEvent:events];
        }else{
            [self atLeastRunOne:events];
        }
    }else{
        if ([EventHelpTool hasWebViewEvent:events]) {
            [self loadRequest:events];
        }else{
            //点击事件
            [self randomClick:events];
        }
    }
}

/**触发webView自动请求网址*/
- (void)loadRequest:(NSArray *)events{
    NSArray *allWebViews=[EventHelpTool allWebView:events];
    for (ZHEventModel *model in allWebViews) {
        [model loadRequest];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AutoTest_Interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self autoTest];
    });
}

/**触发随机滚动*/
- (void)scrollEvent:(NSArray *)events{
    NSInteger sj_x=arc4random() % (NSInteger)([UIScreen mainScreen].bounds.size.width);
    NSInteger sj_y=arc4random() % (NSInteger)([UIScreen mainScreen].bounds.size.height);
    
    NSInteger direction=0;
    
    NSArray *centerPointArrM=[EventHelpTool allCanHappenEventView_Scroll:events];
    if (centerPointArrM.count>0) {
        NSInteger sj=arc4random()%centerPointArrM.count;
        ZHEventModel *model=centerPointArrM[sj];
        CGPoint point=model.centerInWindow;
        sj_x=point.x;sj_y=point.y;
        
        BOOL isHappenScroll=NO;
        for (ZHEventModel *event in events) {
            if (event.isScrollView) {
                if ([event isTouchIn:CGPointMake(sj_x, sj_y)]) {
                    if (event==model||(CGRectContainsRect(event.frameInWindow, model.frameInWindow))) {
                        UIScrollView *scrollView=(UIScrollView *)event.objSelf;
                        direction=[scrollView autoScroll];
                        isHappenScroll=YES;
                        break;
                    }
                }
            }
        }
        if (!isHappenScroll) {
            UIScrollView *scrollView=(UIScrollView *)model.objSelf;
            direction=[scrollView autoScroll];
        }
    }
    
    //添加一个模拟滑动的一个图片,这样看起来更加友好
    [self addSwipeSimulationView:CGPointMake(sj_x, sj_y) direction:direction];
}

/**触发随机点击*/
- (void)randomClick:(NSMutableArray *)events{
    
    NSInteger sj_x=arc4random() % (NSInteger)([UIScreen mainScreen].bounds.size.width);
    NSInteger sj_y=arc4random() % (NSInteger)([UIScreen mainScreen].bounds.size.height);

    if (AutoTest_Random_Touch==0) {//如果不是完全随机
        
        NSMutableArray *centerPointArrM=[EventHelpTool allSuggestEventView_Click:events];
        
        if (centerPointArrM.count>0) {
            
            NSInteger sj=arc4random()%centerPointArrM.count;
            ZHEventModel *model=centerPointArrM[sj];
            CGPoint point=model.centerInWindow;
            sj_x=point.x;sj_y=point.y;
            
            BOOL isHappenEvent=NO;
            for (ZHEventModel *event in events) {
                if (!event.isMostHappenEvent) {
                    if ([event isTouchIn:CGPointMake(sj_x, sj_y)]) {
                        if (event==model||(CGRectContainsRect(event.frameInWindow, model.frameInWindow))) {
                            if ([[UIControllerEventRecoder shareInstance] canRecorderEventForEventModel:event]) {
                                if ([event happenEvent]) {
                                    isHappenEvent=YES;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            if (!isHappenEvent) {
                [model happenEvent];
            }
        }else{
            //没有找到可以点击的事件了
            ZHEventModel *event=[NSArrayTool anyObject:events];
            sj_x=event.centerInWindow.x;
            sj_y=event.centerInWindow.y;
            [event happenEvent];
            [UIControllerEventRecoder shareInstance].randomClickCount+=1;
        }
    }else{
        for (ZHEventModel *event in events) {
            if ([event isTouchIn:CGPointMake(sj_x, sj_y)]) {
                [event happenEvent];
                break;
            }
        }
    }
    
    //添加一个模拟点击的一个图片,这样看起来更加友好
    [self addTouchSimulationView:CGPointMake(sj_x, sj_y)];
}

/**添加一个模拟点击的一个图片,这样看起来更加友好*/
- (void)addTouchSimulationView:(CGPoint)point{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(point.x, point.y, 30, 30)];
    imageView.center=CGPointMake(point.x, point.y);
    imageView.image=[UIImage imageNamed:@"AutoTest_Tap"];
    UIView *keyWindow=[UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:imageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AutoTest_Interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageView removeFromSuperview];
        [self autoTest];
    });
}

//direction 1左 2上 3右 4下
/**添加一个模拟滑动的一个图片,这样看起来更加友好*/
- (void)addSwipeSimulationView:(CGPoint)point direction:(NSInteger)direction{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(point.x, point.y, 20, 20)];
    if (direction==1||direction==3) {
        imageView.frame=CGRectMake(point.x, point.y, 52, 28);
    }else{
        imageView.frame=CGRectMake(point.x, point.y, 28, 52);
    }
    switch (direction) {
        case 1:imageView.image=[UIImage imageNamed:@"AutoTest_Right"]; break;//注意图像刚好要反过来,就像上拉加载和下拉刷新一样的道理
        case 2:imageView.image=[UIImage imageNamed:@"AutoTest_Down"];break;//注意图像刚好要反过来,就像上拉加载和下拉刷新一样的道理
        case 3:imageView.image=[UIImage imageNamed:@"AutoTest_Left"];break;//注意图像刚好要反过来,就像上拉加载和下拉刷新一样的道理
        case 4:imageView.image=[UIImage imageNamed:@"AutoTest_Up"];break;//注意图像刚好要反过来,就像上拉加载和下拉刷新一样的道理
        default:imageView.image=nil;break;
    }
    
    imageView.center=CGPointMake(point.x, point.y);
    UIView *keyWindow=[UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:imageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AutoTest_Interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageView removeFromSuperview];
        [self autoTest];
    });
}

@end
