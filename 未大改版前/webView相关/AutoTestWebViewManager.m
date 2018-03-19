//
//  BRSWebViewManager.m
//  MaiXiang
//
//  Created by mac on 2017/10/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AutoTestWebViewManager.h"

@implementation AutoTestWebViewManager

+ (AutoTestWebViewManager *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static AutoTestWebViewManager *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[AutoTestWebViewManager alloc] init];
    });
    return _sharedObject;
}

@end
