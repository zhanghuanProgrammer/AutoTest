/*
 *
 * Copyright (c) 2015-2020  Bonree Company
 * 北京博睿宏远科技发展有限公司  版权所有 2015-2020
 *
 * PROPRIETARY RIGHTS of Bonree Company are involved in the
 * subject matter of this material.  All manufacturing, reproduction, use,
 * and sales rights pertaining to this subject matter are governed by the
 * license agreement.  The recipient of this software implicitly accepts
 * the terms of the license.
 * 本软件文档资料是博睿公司的资产,任何人士阅读和使用本资料必须获得
 * 相应的书面授权,承担保密责任和接受相应的法律约束.
 *
 */

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (*loadView_func)(id SELF, SEL _cmd);
typedef void (*viewDidLoad_func)(id SELF, SEL _cmd);
typedef void (*viewWillAppear_func)(id SELF, SEL _cmd, BOOL animated);
typedef void (*viewDidAppear_func)(id SELF, SEL _cmd, BOOL animated);
typedef void (*viewWillDisappear_fun)(id SELF, SEL _cmd, BOOL animated);
typedef void (*viewDidDisappear_func)(id SELF, SEL _cmd, BOOL animated);
typedef void (*viewDidDealloc)(id SELF, SEL _cmd);

static loadView_func orig_loadView;
static viewDidLoad_func orig_viewDidLoad;
static viewWillAppear_func orig_viewWillAppear;
static viewDidAppear_func orig_viewDidAppear;
static viewWillDisappear_fun orig_viewWillDisappear;
static viewDidDisappear_func orig_viewDidDisappear;
static NSMutableArray *vcStack;
static NSArray *systemVC;


void brs_swizze(Class class, SEL orig_sel, IMP brs_func) {
    class_replaceMethod(class, orig_sel, (IMP)brs_func, NULL);
}

static void brs_loadView(id SELF, SEL _cmd) {
    orig_loadView(SELF, _cmd);
    NSString *name = NSStringFromClass([SELF class]);
    NSLog(@"当前视图loadView:%@",name);
}

static void brs_viewDidLoad(id SELF, SEL _cmd) {
    orig_viewDidLoad(SELF, _cmd);
    NSString *name = NSStringFromClass([SELF class]);
    NSLog(@"当前视图viewDidLoad:%@",name);
}

static void brs_viewWillAppear(id SELF, SEL _cmd, BOOL animated) {
    orig_viewWillAppear(SELF, _cmd, animated);
    NSString *name = NSStringFromClass([SELF class]);
    NSLog(@"当前视图WillAppear:%@",name);
}

static void brs_viewDidAppear(id SELF, SEL _cmd, BOOL animated) {
    orig_viewDidAppear(SELF, _cmd, animated);
    NSString *name = NSStringFromClass([SELF class]);
    NSLog(@"当前视图DidAppear:%@",name);
    
    if (![systemVC containsObject:name]) {
        [vcStack addObject:[NSString stringWithFormat:@"%@",SELF]];
    }
    NSLog(@"%@",vcStack);
}

static void brs_viewWillDisappear(id SELF, SEL _cmd, BOOL animated) {
    orig_viewWillDisappear(SELF, _cmd, animated);
    
}

static void brs_viewDidDisappear(id SELF, SEL _cmd, BOOL animated) {
    orig_viewDidDisappear(SELF, _cmd, animated);
    [vcStack removeObject:[NSString stringWithFormat:@"%@",SELF]];
}

void brs_hook_ui() {
    
    Class class = [UIViewController class];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL orig_sel;
        
        orig_sel = @selector(loadView);
        orig_loadView = (loadView_func)[class instanceMethodForSelector:orig_sel];
        brs_swizze(class, orig_sel, (IMP)brs_loadView);
        
        orig_sel = @selector(viewDidLoad);
        orig_viewDidLoad = (viewDidLoad_func)[class instanceMethodForSelector:orig_sel];
        brs_swizze(class, orig_sel, (IMP)brs_viewDidLoad);
        
        orig_sel = @selector(viewWillAppear:);
        orig_viewWillAppear = (viewWillAppear_func)[class instanceMethodForSelector:orig_sel];
        brs_swizze(class, orig_sel, (IMP)brs_viewWillAppear);
        
        orig_sel = @selector(viewDidAppear:);
        orig_viewDidAppear = (viewDidAppear_func)[class instanceMethodForSelector:orig_sel];
        brs_swizze(class, orig_sel, (IMP)brs_viewDidAppear);
        
        orig_sel = @selector(viewWillDisappear:);
        orig_viewWillDisappear = (viewWillDisappear_fun)[class instanceMethodForSelector:orig_sel];
        brs_swizze(class, orig_sel, (IMP)brs_viewWillDisappear);
        
        orig_sel = @selector(viewDidDisappear:);
        orig_viewDidDisappear = (viewDidDisappear_func)[class instanceMethodForSelector:orig_sel];
        brs_swizze(class, orig_sel, (IMP)brs_viewDidDisappear);
        
        vcStack = [NSMutableArray array];
        
        systemVC = @[@"UIApplicationExtensionViewControllerHost",@"UISystemInputViewController",@"UIInputWindowController",@"UIKBAlertController",@"UIKBStackViewController",@"UIActivityViewController",@"UIKBSystemLayoutViewController",@"UIDebuggingInformationTopLevelViewController",@"UIPrinterSetupConfigureViewController",@"UIWebRotatingAlertController",@"UIPrinterSetupPINViewController",@"UIKeyboardCandidateGridCollectionViewController",@"UIPrintPanelTableViewController",@"UICompatibilityInputViewController",@"UIDocumentMenuViewController",@"UIDebuggingInformationViewController",@"UIInputViewController",@"UISearchContainerViewController",@"UIPrintPreviewViewController",@"UIAlertController",@"UICollectionViewController",@"UIPrinterUtilityTableViewController",@"UIPrinterBrowserViewController",@"UIStatusBarViewController",@"UIPageViewController",@"UIZoomViewController",@"UIDocumentPickerViewController",@"UISplitViewController",@"UIPrintPanelNavigationController",@"UIDebuggingInformationRootTableViewController",@"UIPrintRangeViewController",@"UIPrintActivityWrapperNavigationController",@"UIKeyCommandDiscoverabilityHUDViewController",@"UIWebSelectTableViewController",@"UIDocumentPickerExtensionViewController",@"UIWebDateTimePopoverViewController",@"UIPrinterPickerViewController",@"UIKeyboardCandidateRowViewController",@"UIPrintPaperViewController",@"UIBookViewController",@"UIPrintMoreOptionsTableViewController",@"UITableViewController",@"UISearchController",@"UIMoreListController",@"UIMoreNavigationController",@"UIWebFileUploadPanel",@"UIPrintingProgressViewController",@"UIPageController",@"UITabBarController",@"UIApplicationRotationFollowingControllerNoTouches",@"UIPrinterSetupDisplayPINViewController",@"UINavigationController",@"UIApplicationRotationFollowingController",@"UIVideoEditorController",@"UISnapshotModalViewController",@"UIImagePickerController",@"UIReferenceLibraryViewController",@"UIActivityGroupViewController"];
    });
}

