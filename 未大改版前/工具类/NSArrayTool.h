//
//  NSArrayTool.h
//  MaiXiang
//
//  Created by mac on 2017/10/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSArrayTool : UIWebView

+ (void)sortTableView:(UITableView *)tableView visibleCells:(NSMutableArray *)visibleCells;

+ (void)sortCollectionView:(UICollectionView *)collectionView visibleCells:(NSMutableArray *)visibleCells;

+ (void)reverse:(NSMutableArray *)arr;

+ (id)anyObject:(NSArray *)arr;

@end
