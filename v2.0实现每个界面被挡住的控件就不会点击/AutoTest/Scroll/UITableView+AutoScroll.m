//
//  UITableView+AutoScroll.m
//  CJOL
//
//  Created by mac on 2018/3/18.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "UITableView+AutoScroll.h"
#import "UIScrollView+AutoScroll.h"
#import "AutoTestHeader.h"

@implementation UITableView (AutoScroll)

- (NSInteger)autoScroll{
    NSArray *cells = [self visibleCells];
    if (cells.count>0) {
        if (self.delegate) {
            if([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
                [self.delegate scrollViewWillBeginDragging:self];
            if([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
                [self.delegate scrollViewWillBeginDecelerating:self];
        }
        UITableViewCell *cell = [cells randomObject];
        [self scrollToRowAtIndexPath:[self indexPathForCell:cell] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
        if (self.delegate) {
            if([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)])
                [self.delegate scrollViewDidScroll:self];
            if([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
                [self.delegate scrollViewDidEndDragging:self willDecelerate:YES];
            if([self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
                [self.delegate scrollViewDidEndDecelerating:self];
            if([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
                [self.delegate scrollViewDidEndScrollingAnimation:self];
        }
    }
    return 0;
}

@end
