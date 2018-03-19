//
//  UIViewController+Start.m
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UIViewController+Start.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import "AutoTestProject.h"
#import "AutoTestHeader.h"

@implementation UIViewController (Start)

+ (void)load{
    [super load];
    if (AutoTest) {
        [self swizzleInstanceMethod:@selector(viewDidLoad) with:@selector(custom_viewDidLoad)];
    }
}

- (void)custom_viewDidLoad{
    
    if (AutoTest) {
        if (![AutoTestProject shareInstance].isRuning) {
            [[AutoTestProject shareInstance] autoTest];
        }
    }
    
    [self custom_viewDidLoad];
}

@end
