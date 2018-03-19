//
//  UIView+LayerIndex.m
//  CJOL
//
//  Created by zhanghuan on 2017/10/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UIView+LayerIndex.h"
#import "AutoTestHeader.h"
#import <objc/runtime.h>

@implementation UIView (LayerIndex)

static const int UIView_LayerIndex;
static const int UIView_WindowLoadIndex;
static const int UIView_LayerDirector;
static const int UIView_CurViewController;
static const int UIView_ViewControllerDirector;
static const int UIView_ViewControllerDirectorCount;
static const int UIView_IsDisplayedInScreen;
static const int UIView_IsBelowTabBar;
static const int UIView_IsBelowNavagationBar;

- (BOOL)isBelowNavagationBar{
    id num=objc_getAssociatedObject(self, &UIView_IsBelowNavagationBar);
    if (num) {
        return [num boolValue];
    }
    return NO;
}

- (void)setIsBelowNavagationBar:(BOOL)isBelowNavagationBar{
    objc_setAssociatedObject(self, &UIView_IsBelowNavagationBar, [NSNumber numberWithBool:isBelowNavagationBar], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isBelowTabBar{
    id num=objc_getAssociatedObject(self, &UIView_IsBelowTabBar);
    if (num) {
        return [num boolValue];
    }
    return NO;
}
- (void)setIsBelowTabBar:(BOOL)isBelowTabBar{
    objc_setAssociatedObject(self, &UIView_IsBelowTabBar, [NSNumber numberWithBool:isBelowTabBar], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isDisplayedInScreen{
    id num=objc_getAssociatedObject(self, &UIView_IsDisplayedInScreen);
    if (num) {
        return [num boolValue];
    }
    return NO;
}

- (void)setIsDisplayedInScreen:(BOOL)isDisplayedInScreen{
    objc_setAssociatedObject(self, &UIView_IsDisplayedInScreen, [NSNumber numberWithBool:isDisplayedInScreen], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)layerIndex{
    id num=objc_getAssociatedObject(self, &UIView_LayerIndex);
    if (num) {
        return [num integerValue];
    }
    return 0;
}

- (void)setLayerIndex:(NSInteger)layerIndex{
    objc_setAssociatedObject(self, &UIView_LayerIndex, [NSNumber numberWithInteger:layerIndex], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)windowLoadIndex{
    id num=objc_getAssociatedObject(self, &UIView_WindowLoadIndex);
    if (num) {
        return [num integerValue];
    }
    return 0;
}

- (void)setWindowLoadIndex:(NSInteger)windowLoadIndex{
    objc_setAssociatedObject(self, &UIView_WindowLoadIndex, [NSNumber numberWithInteger:windowLoadIndex], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)viewControllerDirectorCount{
    id num=objc_getAssociatedObject(self, &UIView_ViewControllerDirectorCount);
    if (num) {
        return [num integerValue];
    }
    return 0;
}

- (void)setViewControllerDirectorCount:(NSInteger)viewControllerDirectorCount{
    objc_setAssociatedObject(self, &UIView_ViewControllerDirectorCount, [NSNumber numberWithInteger:viewControllerDirectorCount], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)layerDirector{
    return objc_getAssociatedObject(self, &UIView_LayerDirector);
}

- (void)setLayerDirector:(NSString *)layerDirector{
    objc_setAssociatedObject(self, &UIView_LayerDirector, layerDirector, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)curViewController{
    id obj=objc_getAssociatedObject(self, &UIView_CurViewController);
    if (obj==nil) obj= @"";
    return obj;
}

- (void)setCurViewController:(NSString *)curViewController{
    objc_setAssociatedObject(self, &UIView_CurViewController, curViewController, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)viewControllerDirector{
    id obj=objc_getAssociatedObject(self, &UIView_ViewControllerDirector);
    if (obj==nil) obj= @"";
    return obj;
}

- (void)setViewControllerDirector:(NSString *)viewControllerDirector{
    objc_setAssociatedObject(self, &UIView_ViewControllerDirector, viewControllerDirector, OBJC_ASSOCIATION_COPY_NONATOMIC);
}







/**判断是否被自己标志过边框*/
- (BOOL)isCornerRadiusBySelf{
    return self.layer.cornerRadius==AutoTest_CornerRadius&&self.layer.borderWidth==AutoTest_CornerBorderWidth;
}

/**判断是否可以标志过边框,因为一旦控件本身已经被切边框,这个时候,我们不应该私自修改边框大小*/
- (BOOL)canCornerRadiusBySelf{
    return self.layer.cornerRadius==AutoTest_CornerRadius;
}

- (void)cornerRadiusBySelfWithColor:(UIColor *)color{
    self.layer.borderColor=[color CGColor];
    if (![self isCornerRadiusBySelf]) {
        if ([self canCornerRadiusBySelf]) {
            self.layer.cornerRadius=AutoTest_CornerRadius;
        }
        self.layer.borderWidth=AutoTest_CornerBorderWidth;
    }
}

- (NSString *)textDescription{
    NSString *text = nil;
    if ([self isKindOfClass:[UILabel class]] || [self isKindOfClass:[UITextView class]] || [self isKindOfClass:[UITextField class]]) {
        id obj = self;
        text = [obj text];
    }
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        text = button.currentTitle;
    }
    return text ?: @"";
}

- (void)allEventView{
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i=0; i<CurrentScreen_Width; i+=2) {
        for (NSInteger j=0; j<CurrentScreen_Height; j+=2) {
            UIView *responeView = [self collectionEventView:CGPointMake(i, j) toArrM:arrM];
            if (responeView) {
                UIWindow *window=[UIApplication sharedApplication].keyWindow;
                CGRect rect=[responeView convertRect:responeView.bounds toView:window];
//                i+=(NSInteger)(rect.size.width+rect.origin.x-i);
//                j+=(NSInteger)(rect.size.height+rect.origin.y-j);
//                NSLog(@"😄%@",@(CGRectContainsPoint(rect, CGPointMake(i, j))));
//                NSLog(@"😄%@ - %@",NSStringFromCGRect(rect),NSStringFromCGPoint(CGPointMake(i, j)));
            }
        }
    }
    for (UIView *view in arrM) {
        UIImageView *imageView = nil;
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        CGRect rect=[view convertRect:view.bounds toView:window];
        imageView = [[UIImageView alloc]initWithFrame:rect];
        [imageView cornerRadiusWithFloat:0 borderColor:[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0] borderWidth:3];
        [window addSubview:imageView];
    }
}

- (UIView *)collectionEventView:(CGPoint)point toArrM:(NSMutableArray *)arrM{
    UIView *view = self;
    if ([view respondsToSelector:@selector(hitTest:withEvent:)]) {
        UIView *responeView = [view hitTest:point withEvent:nil];
        if (responeView) {
            if (![arrM containsObject:responeView]) {
                
                NSArray *gestureRecognizers=responeView.gestureRecognizers;
                if (gestureRecognizers.count>0) {
                    [arrM addObject:responeView];
                    return responeView;
                }
                
                if ([responeView isKindOfClass:[UIControl class]]) {
                    UIControl *control=(UIControl *)responeView;
                    UIControlEvents allControlEvents=[control allControlEvents];
                    NSSet *allTargets=[control allTargets];
                    for (id target in allTargets) {
                        NSArray *allActions=[control actionsForTarget:target forControlEvent:allControlEvents];
                        if (allActions.count>0) {
                            [arrM addObject:responeView];
                            return responeView;
                        }
                    }
                }
            }
        }
    }
    return nil;
}

@end
