//
//  EventHelpTool.h
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventHelpTool : NSObject

/**这个函数是用来筛选window上所有事件控件,结合自己设置的匹配条件,找出最优的可以点击的控件事件集合*/
+ (NSMutableArray *)allSuggestEventView_Click:(NSMutableArray *)events;

/**这个函数是用来筛选window上所有可以滑动的ScrollView(包括子类)控件*/
+ (NSArray *)allCanHappenEventView_Scroll:(NSArray *)events;

/**判断所有事件控件是否有可以滑动的的ScrollView*/
+ (BOOL)canScroll:(NSArray *)events;

/**判断是否有WebView并且WebView的执行页面跳转次数没有达到上限*/
+ (BOOL)hasWebViewEvent:(NSArray *)events;

/**获取里面所有的WebView*/
+ (NSArray *)allWebView:(NSArray *)events;

//如果TabBar和NavagationBar是显示出来的,那么可以确定他们的自按钮一定存在在界面上,并且可以点击的到
+ (id)randomTabBarEvent:(NSArray *)events;
+ (id)randomNavagationBarEvent:(NSArray *)events;

@end
