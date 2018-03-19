//
//  UIView+AutoTestExt.m
//  MaiXiang
//
//  Created by mac on 2017/10/25.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UIView+AutoTestExt.h"
#import "UIView+LayerIndex.h"

@implementation UIView (AutoTestExt)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIViewController *)getViewController{
    for (UIView *view = self.superview; view; view = view.superview) {
        UIResponder *responder = [view nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

// 判断View是否显示在屏幕上
- (BOOL)judgeIsDisplayedInScreen{
    if (self == nil) return NO;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.bounds toView:window];
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    
    //如果这个控件不在父控件的显示范围内,并且 - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event 也点击不到
    UIView *superView = self.superview;
    if (![self isDisplayedInView:superView]){
        if ([superView respondsToSelector:@selector(hitTest:withEvent:)]) {
            UIView *responeView = [superView hitTest:CGPointMake(self.width/2.0+self.x, self.height/2.0+self.y) withEvent:nil];
            if (!responeView) {
                return NO;
            }else if(responeView != self){
                return NO;
            }
        }
    }
    
//    如果在scrollView里面,但是不在scrollView的显示范围内
//    UIView *superView = self.superview;
//    if (superView&&[superView isKindOfClass:[UIScrollView class]]) {
//        UIScrollView *scrollView=(UIScrollView *)superView;
//        CGRect scrollViewShowRect = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, scrollView.width, scrollView.height);
//        CGRect intersectionRect = CGRectIntersection(self.frame, scrollViewShowRect);
//        if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect) || CGRectEqualToRect(intersectionRect, CGRectZero)) {
//            return NO;
//        }
//    }
    return YES;
}

- (BOOL)isDisplayedInView:(UIView *)otherView{
    if (self == nil || otherView == nil) return NO;
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.bounds toView:otherView];
    CGRect bound = otherView.bounds;
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, bound);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    return TRUE;
}


- (void)cornerRadiusWithFloat:(CGFloat)vaule borderColor:(UIColor *)color borderWidth:(CGFloat)width{
    self.layer.cornerRadius=vaule;
    if (color!=nil)self.layer.borderColor=[color CGColor];
    if(width!=0)self.layer.borderWidth=width;
    self.layer.masksToBounds=YES;
}

@end
