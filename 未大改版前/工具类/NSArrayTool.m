//
//  NSArrayTool.m
//  MaiXiang
//
//  Created by mac on 2017/10/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NSArrayTool.h"

@implementation NSArrayTool

+ (void)sortTableView:(UITableView *)tableView visibleCells:(NSMutableArray *)visibleCells{
    [visibleCells sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UITableViewCell *cell1=obj1,*cell2=obj2;
        NSIndexPath *indexPath1=[tableView indexPathForCell:cell1];
        NSIndexPath *indexPath2=[tableView indexPathForCell:cell2];
        if (indexPath1.section==indexPath2.section) {
            return indexPath1.row>indexPath2.row;
        }
        return indexPath1.section>indexPath2.section;
    }];
}

+ (void)sortCollectionView:(UICollectionView *)collectionView visibleCells:(NSMutableArray *)visibleCells{
    [visibleCells sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UICollectionViewCell *cell1=obj1,*cell2=obj2;
        NSIndexPath *indexPath1=[collectionView indexPathForCell:cell1];
        NSIndexPath *indexPath2=[collectionView indexPathForCell:cell2];
        if (indexPath1.section==indexPath2.section) {
            return indexPath1.row>indexPath2.row;
        }
        return indexPath1.section>indexPath2.section;
    }];
}

/**反转数组里的内容*/
+ (void)reverse:(NSMutableArray *)arr{
    NSUInteger count = arr.count;
    int mid = floor(count / 2.0);
    for ( NSUInteger i = 0; i < mid; i++ ) {
        [arr exchangeObjectAtIndex:i withObjectAtIndex:(count - (i + 1))];
    }
}

/**任意的一个元素*/
+ (id)anyObject:(NSArray *)arr{
    if (arr.count) {
        return arr[arc4random_uniform((u_int32_t)arr.count)];
    }
    return nil;
}

@end
