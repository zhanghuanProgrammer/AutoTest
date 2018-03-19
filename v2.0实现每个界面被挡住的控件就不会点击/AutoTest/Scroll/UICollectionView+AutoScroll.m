//
//  UICollectionView+AutoScroll.m
//  CJOL
//
//  Created by mac on 2018/3/18.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "UICollectionView+AutoScroll.h"
#import "UIScrollView+AutoScroll.h"

@implementation UICollectionView (AutoScroll)

- (NSInteger)autoScroll{
    NSArray *cells = [self visibleCells];
    if (cells.count>0) {
        UICollectionViewCell *cell = [cells randomObject];
        [self scrollToItemAtIndexPath:[self indexPathForCell:cell] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
    return 0;
}

@end
