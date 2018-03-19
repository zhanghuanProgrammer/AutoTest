//
//  ZHGestureRecognizerTargetAndAction.h
//  CJOL
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHGestureRecognizerTargetAndAction : NSObject

@property (nonatomic, assign) SEL action;
@property (nonatomic,weak)id target;

- (instancetype)initWithAction:(SEL)action withTarget:(id)target;

@end
