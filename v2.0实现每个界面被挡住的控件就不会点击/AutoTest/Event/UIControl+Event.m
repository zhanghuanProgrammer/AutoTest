//
//  UIControl+Event.m
//  CJOL
//
//  Created by mac on 2018/3/18.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "UIControl+Event.h"
#import "AutoTestHeader.h"

@implementation UIControl (Event)

- (void)happenEvent{
    [super happenEvent];
    
    UIControlEvents allControlEvents=[self allControlEvents];
    NSSet *allTargets=[self allTargets];
    for (id target in allTargets) {
        NSArray *allActions=[self actionsForTarget:target forControlEvent:allControlEvents];
        for (NSString *actionStr in allActions) {
            if (self.userInteractionEnabled&&self.alpha>0.1&&(![self isHidden])) {
                
                if ([target respondsToSelector:NSSelectorFromString(actionStr)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [target performSelector:NSSelectorFromString(actionStr) withObject:self];
#pragma clang diagnostic pop
                }
            }
        }
    }
}

- (BOOL)isEventView{
    UIControlEvents allControlEvents=[self allControlEvents];
    NSSet *allTargets=[self allTargets];
    for (id target in allTargets) {
        NSArray *allActions=[self actionsForTarget:target forControlEvent:allControlEvents];
        if (allActions.count>0) {
            if (self.enabled && self.userInteractionEnabled&&self.alpha>0.1&&(![self isHidden])) {
                [self cornerRadiusBySelfWithColor:AutoTest_UIControl_Action_Color];
                return YES;
            }
        }
    }
    return [super isEventView];
}

@end
