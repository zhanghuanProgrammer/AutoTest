//
//  UIView+LayerIndex.h
//  CJOL
//
//  Created by zhanghuan on 2017/10/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LayerIndex)

@property (nonatomic,assign)NSInteger layerIndex;//当前所在第几层嵌套层数(UIview嵌套子控件)
@property (nonatomic,assign)NSInteger windowLoadIndex;//所在第几层(UIWindow加载的顺序)
@property (nonatomic,copy)NSString *layerDirector;//记录层级director 作用是用来标记这个控件的绝对位置 比如 window/view/tableview/tableviewcell/imageview
@property (nonatomic,copy)NSString *curViewController;//记录当前控件所在的viewController
@property (nonatomic,copy)NSString *viewControllerDirector;//记录viewController的层级director 比如 UITabBarController/UINavigationViewController/HomeViewController/SubViewController
@property (nonatomic,assign)NSInteger viewControllerDirectorCount;//记录viewController的层级director的个数
@property (nonatomic,assign)BOOL isDisplayedInScreen;//是否显示在Window上

@property (nonatomic,assign)BOOL isBelowTabBar;//是否是TabBar的按钮和控件
@property (nonatomic,assign)BOOL isBelowNavagationBar;//是否是NavagationBar的按钮和控件

- (void)cornerRadiusBySelfWithColor:(UIColor *)color;

- (NSString *)textDescription;

- (void)allEventView;

@end
