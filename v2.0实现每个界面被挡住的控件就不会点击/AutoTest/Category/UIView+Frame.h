//
//  UIView+Frame.h
//  CJOL
//
//  Created by mac on 2018/3/18.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

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

@end
