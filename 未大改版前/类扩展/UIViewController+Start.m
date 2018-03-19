//
//  UIViewController+Start.m
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UIViewController+Start.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>
#import "AutoTestProject.h"
#import "AutoTestHeader.h"

@implementation UIViewController (Start)

+ (void)load{
    [super load];
//    if (AutoTest) {
//        [self swizzleInstanceMethod:@selector(viewDidLoad) with:@selector(custom_viewDidLoad)];
//        [self swizzleInstanceMethod:@selector(dismissViewControllerAnimated:completion:) with:@selector(custom_dismissViewControllerAnimated:completion:)];
//        [self swizzleInstanceMethod:@selector(presentViewController:animated:completion:) with:@selector(custom_presentViewController:animated:completion:)];
//    }
}

- (void)custom_viewDidLoad{
    
    if (AutoTest) {
        if (![AutoTestProject shareInstance].isRuning) {
//            [[AutoTestProject shareInstance] autoTest];
        }
    }
    
    [self custom_viewDidLoad];
}

- (void)custom_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self custom_dismissViewControllerAnimated:Push_Pop_Present_Dismiss_Animation completion:completion];
}

- (void)custom_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    [self custom_presentViewController:viewControllerToPresent animated:Push_Pop_Present_Dismiss_Animation completion:completion];
}

/**获取显示在window当前最顶部的viewController*/
+ (UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if(!window)return nil;
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        if ([[window subviews] count]>0) {
            UIView *frontView = [[window subviews] objectAtIndex:0];
            nextResponder = [frontView nextResponder];
        }
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        NSInteger count=((UINavigationController *)tabbar).viewControllers.count;
        if (count>tabbar.selectedIndex) {
            UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
            if(!nav)return nil;
            result=nav.childViewControllers.lastObject;
        }
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}

+ (void)popOrDismissViewController:(UIViewController *)viewController{
    if (!DebugTap) return;
    
    UIViewController *curVC=[self getCurrentVC];
    if (curVC==viewController) {
        //说明curVC里面没有其他加进来的ChildViewControllers
    }else{
        viewController=curVC;
        //说明curVC里面有其他加进来的ChildViewControllers
    }
    
    NSArray *viewcontrollers=viewController.navigationController.viewControllers;
    if (viewcontrollers.count > 1){
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == viewController){
            //push方式
            [viewController.navigationController popViewControllerAnimated:YES];
        }
    }else{
        //present方式
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
