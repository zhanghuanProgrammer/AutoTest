//
//  UITableView+Event.m
//  CJOL
//
//  Created by mac on 2018/3/18.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "UITableView+Event.h"
#import "AutoTestHeader.h"
#import "UIView+Event.h"

@implementation UITableView (Event)

- (void)happenEvent{
    [super happenEvent];
    
    if (self.delegate) {
        SEL action = NSSelectorFromString(@"tableView:didSelectRowAtIndexPath:");
        if ([self.delegate respondsToSelector:action]) {
            NSArray *cells = [self visibleCells];
            if (cells.count>0) {
                UITableViewCell *cell = [cells randomObject];
                [self.delegate tableView:self didSelectRowAtIndexPath:[self indexPathForCell:cell]];
            }
        }
    }
}

- (BOOL)isEventView{
    if (self.delegate) {
        SEL action = NSSelectorFromString(@"tableView:didSelectRowAtIndexPath:");
        if ([self.delegate respondsToSelector:action]) {
            for (UITableViewCell *cell in [self visibleCells]) {
                [cell cornerRadiusBySelfWithColor:AutoTest_Ges_Tap_Color];
            }
            return YES;
        }
    }
    return [super isEventView];
}

@end
