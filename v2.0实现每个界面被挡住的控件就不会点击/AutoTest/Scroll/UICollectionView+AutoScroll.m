//
//  UICollectionView+AutoScroll.m
//  CJOL
//
//  Created by mac on 2018/3/18.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "UICollectionView+AutoScroll.h"
#import "UIScrollView+AutoScroll.h"
#import "AutoTestHeader.h"

@implementation UICollectionView (AutoScroll)

- (NSInteger)autoScroll{
    NSArray *cells = [self visibleCells];
    if (cells.count>0) {
        if (self.delegate) {
            if([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
                [self.delegate scrollViewWillBeginDragging:self];
            if([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
                [self.delegate scrollViewWillBeginDecelerating:self];
        }
        UICollectionViewCell *cell = [cells randomObject];
        
        UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)self.collectionViewLayout;
        UICollectionViewScrollPosition scrollPosition = 0;
        if ([flow isKindOfClass:[UICollectionViewFlowLayout class]]) {
            if (flow.scrollDirection == UICollectionViewScrollDirectionVertical) {
                scrollPosition = UICollectionViewScrollPositionCenteredVertically;
            }else{
                scrollPosition = UICollectionViewScrollPositionCenteredHorizontally;
            }
        }
        
        [self scrollToItemAtIndexPath:[self indexPathForCell:cell] atScrollPosition:scrollPosition animated:YES];
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
