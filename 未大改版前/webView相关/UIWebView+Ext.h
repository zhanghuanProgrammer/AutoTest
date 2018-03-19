//
//  UIWebView+Ext.h
//  MaiXiang
//
//  Created by mac on 2017/10/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Ext)

@property (nonatomic,strong)NSMutableArray *links;
@property (nonatomic,assign)BOOL isDidFinishLoad;

- (void)custom_webViewDidFinishLoad;
- (void)custom_DidFailLoadWithError;

@end
