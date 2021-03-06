//
//  AutoTestProject.m
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AutoTestProject.h"
#import "AutoTestHeader.h"

@implementation AutoTestProject

+ (AutoTestProject *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static AutoTestProject *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[AutoTestProject alloc] init];
        _sharedObject.isRuning=NO;
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//保持APP常亮不会自动息屏和进入锁屏状态,这样可以整晚测试了
    });
    return _sharedObject;
}

- (void)autoTest{
    self.isRuning=YES;
    
    NSMutableArray *events=[[DisPlayAllView new] disPlayAllViewForWindow];
    NSLog(@"事件个数:%@",@(events.count));
    [self atLeastRunOne:events];
}

/**随机触发事件,至少要触发一种事件成功*/
- (void)atLeastRunOne:(NSMutableArray *)events{
    [self randomClick:events];
}

/**触发随机点击*/
- (void)randomClick:(NSMutableArray *)events{
    
    UIView *view = [events randomObject];
    [view happenEvent];
    
    //添加一个模拟点击的一个图片,这样看起来更加友好
    [SimulationView addTouchSimulationView:view.centerInWindow afterDismiss:AutoTest_Interval+0.5];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AutoTest_Interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self autoTest];
    });
}

@end
