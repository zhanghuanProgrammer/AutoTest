//
//  UICollectionView+Event.m
//  CJOL
//
//  Created by mac on 2018/3/18.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "UICollectionView+Event.h"
#import "UIView+Event.h"
#import "AutoTestHeader.h"

@implementation UICollectionView (Event)

- (void)happenEvent{
    [super happenEvent];
    
    if (self.delegate) {
        SEL action = NSSelectorFromString(@"collectionView:didSelectItemAtIndexPath:");
        if ([self.delegate respondsToSelector:action]) {
            NSArray *cells = [self visibleCells];
            if (cells.count>0) {
                UICollectionViewCell *cell = [cells randomObject];
                [self.delegate collectionView:self didSelectItemAtIndexPath:[self indexPathForCell:cell]];
            }
        }
    }
}

- (BOOL)isEventView{
    if (self.delegate) {
        SEL action = NSSelectorFromString(@"collectionView:didSelectItemAtIndexPath:");
        if ([self.delegate respondsToSelector:action]) {
            for (UICollectionViewCell *cell in [self visibleCells]) {
                [cell cornerRadiusBySelfWithColor:AutoTest_Ges_Tap_Color];
            }
            return YES;
        }
    }
    return [super isEventView];
}

@end
