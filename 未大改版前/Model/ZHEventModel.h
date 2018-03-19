//
//  ZHEventModel.h
//  CJOL
//
//  Created by mac on 2017/10/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ZHGestureRecognizerTargetAndAction.h"

@interface ZHEventModel : ZHGestureRecognizerTargetAndAction

@property (nonatomic,weak)UIView* objSelf;//事件发生源
@property (nonatomic,assign)CGRect frameInWindow;
@property (nonatomic,assign)CGRect rect;
@property (nonatomic,assign)CGPoint centerInWindow;

@property (nonatomic,assign)BOOL isScrollView;//是否是ScrollView
@property (nonatomic,assign)BOOL isTableViewCellOrCollectionViewCell;//是否是TableViewCell或者CollectionViewCell
@property (nonatomic,assign)BOOL isWebView;


@property (nonatomic,strong)NSIndexPath *indexPath;//记录这个cell的IndexPath
@property (nonatomic,weak)UITableView *tableView;//记录这个cell的tableView
@property (nonatomic,weak)UICollectionView *collectionView;//记录这个cell的collectionView

@property (nonatomic,assign)BOOL isUIGestureRecognizer;//判断是否是手势事件
@property (nonatomic,weak)UITapGestureRecognizer *gesTap;//记录这个手势

@property (nonatomic,assign)BOOL isRandomAddTabBarOrNavagationBarEvent;//判断是否是随机添加的一个TabBar和NavagationBar事件,这个是为了让TabBar和NavagationBar事件有更多的点击机会,这样更加便于遍历全部页面

@property (nonatomic,assign)BOOL isMostHappenEvent;//如果这个控件点击过很多次(全局config中可以配置次数),或者这个cell(IndexPath)点击过,就没必要再次点击了

/**判断在window上面点击某一个点,是否在这个view(事件发生源-objSelf)上面*/
- (BOOL)isTouchIn:(CGPoint)point;

/**执行事件*/
- (BOOL)happenEvent;

/**执行请求网址事件*/
- (void)loadRequest;

@end
