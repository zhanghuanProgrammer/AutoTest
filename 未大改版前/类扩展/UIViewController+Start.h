//
//  UIViewController+Start.h
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Start)

/**获取显示在window当前最顶部的viewController*/
+ (UIViewController *)getCurrentVC;
/**退出显示在window当前最顶部的viewController*/
+ (void)popOrDismissViewController:(UIViewController *)viewController;

@end
