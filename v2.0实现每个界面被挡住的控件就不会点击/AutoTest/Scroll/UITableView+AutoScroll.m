//
//  UITableView+AutoScroll.m
//  CJOL
//
//  Created by mac on 2018/3/18.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "UITableView+AutoScroll.h"
#import "UIScrollView+AutoScroll.h"

@implementation UITableView (AutoScroll)

- (NSInteger)autoScroll{
    NSArray *cells = [self visibleCells];
    if (cells.count>0) {
        UITableViewCell *cell = [cells randomObject];
        [self scrollToRowAtIndexPath:[self indexPathForCell:cell] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    }
    return 0;
}

@end
