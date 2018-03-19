//
//  ZHGestureRecognizerTargetAndAction.m
//  CJOL
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ZHGestureRecognizerTargetAndAction.h"

@implementation ZHGestureRecognizerTargetAndAction

- (instancetype)initWithAction:(SEL)action withTarget:(id)target{
    self = [super init];
    if (self) {
        _action = action;
        _target = target;
    }
    return self;
}

@end
