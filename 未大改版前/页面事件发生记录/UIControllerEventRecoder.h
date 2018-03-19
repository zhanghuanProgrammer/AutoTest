//
//  UIControllerEventRecoder.h
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHEventModel.h"

@interface UIControllerEventRecoder : NSObject

@property (nonatomic,strong)NSMutableDictionary *controllerEventRecoder;//这个用来记住那些控件已经点过几次了
@property (nonatomic,strong)NSMutableDictionary *changeWindowControllerEventRecoder;//这个是用来记住一些特殊的控件,因为他们触发事件后,会导致界面跳转或者更多的界面变化,这写控件需要提供更多的点击次数

@property (nonatomic,assign)NSInteger randomClickCount;//随机乱点的次数

+ (UIControllerEventRecoder *)shareInstance;

- (void)recorderEventForEventModel:(ZHEventModel *)eventModel;
- (BOOL)canRecorderEventForEventModel:(ZHEventModel *)eventModel;
- (void)addChangeWindowControllerEvent:(ZHEventModel *)eventModel;

@end
