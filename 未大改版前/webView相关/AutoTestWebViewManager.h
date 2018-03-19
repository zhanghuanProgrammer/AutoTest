//
//  BRSWebViewManager.h
//  MaiXiang
//
//  Created by mac on 2017/10/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoTestWebViewManager : NSObject<UIWebViewDelegate>

+ (AutoTestWebViewManager *)shareInstance;

@end
