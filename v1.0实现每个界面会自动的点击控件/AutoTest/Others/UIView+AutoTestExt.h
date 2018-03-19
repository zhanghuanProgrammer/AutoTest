//
//  UIView+AutoTestExt.h
//  MaiXiang
//
//  Created by mac on 2017/10/25.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoTestExt)

@property (nonatomic) CGFloat left;      
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;     
@property (nonatomic) CGFloat bottom;    
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;

- (UIWindow *)getWindow;
- (CGRect)frameInWindow;
- (CGPoint)centerInWindow;
- (CGRect)rectIntersectionInWindow;
- (CGRect)frameInSuperView;
- (CGRect)rectIntersectionInSuperView;
/**在桌面上的显示区域-递归*/
- (CGRect)canShowFrameRecursive;
/**在桌面上的显示区域*/
- (CGRect)canShowFrame;
/**在桌面上的显示区域-递归*/
- (BOOL)canShow;
- (CGRect)canTouchFrame;
- (BOOL)isHitTest;


/**获取其直接接收事件响应的最顶端控制器*/
- (UIViewController *)getViewController;

/**切圆角边框*/
- (void)cornerRadiusWithFloat:(CGFloat)vaule borderColor:(UIColor *)color borderWidth:(CGFloat)width;

- (void)cornerRadiusBySelfWithColor:(UIColor *)color;

- (NSString *)textDescription;

@end
