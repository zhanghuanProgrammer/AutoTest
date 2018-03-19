//
//  UITabBar+Event.m
//  MaiXiang
//
//  Created by mac on 2018/3/19.
//  Copyright © 2018年 GD. All rights reserved.
//

#import "UITabBar+Event.h"
#import "AutoTestHeader.h"

@implementation UITabBar (Event)

- (void)happenEvent{
    [super happenEvent];
    
    if (self.items.count>1) {
        UITabBarController *tabbar = [self getViewController].tabBarController;
        NSInteger original = tabbar.selectedIndex;
        while (original == tabbar.selectedIndex) {
            original = arc4random()%self.items.count;
        }
        tabbar.selectedIndex = original;
    }
}

- (BOOL)isEventView{
    if (self.items.count>0) {
        
        return YES;
    }
    return [super isEventView];
}

@end
