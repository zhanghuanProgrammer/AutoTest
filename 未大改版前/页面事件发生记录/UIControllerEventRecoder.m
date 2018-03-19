//
//  UIControllerEventRecoder.m
//  MaiXiang
//
//  Created by mac on 2017/10/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "UIControllerEventRecoder.h"
#import "UIView+LayerIndex.h"
#import "AutoTestHeader.h"

@interface UIControllerEventRecoder ()

@end

@implementation UIControllerEventRecoder

+ (UIControllerEventRecoder *)shareInstance{
    static dispatch_once_t pred = 0;
    __strong static UIControllerEventRecoder *_sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[UIControllerEventRecoder alloc] init];
        _sharedObject.controllerEventRecoder=[NSMutableDictionary dictionary];
        _sharedObject.changeWindowControllerEventRecoder=[NSMutableDictionary dictionary];
    });
    
    return _sharedObject;
}

- (void)setRandomClickCount:(NSInteger)randomClickCount{
    _randomClickCount=randomClickCount;
    if (_randomClickCount>AutoTest_RandomClickCount) {
        _randomClickCount=0;
        //清空记录
        _controllerEventRecoder=[NSMutableDictionary dictionary];
        _changeWindowControllerEventRecoder=[NSMutableDictionary dictionary];
    }
}

- (void)addChangeWindowControllerEvent:(ZHEventModel *)eventModel{
    NSString *layerDirector=[eventModel.objSelf.curViewController stringByAppendingPathComponent:eventModel.objSelf.layerDirector];
    [self.changeWindowControllerEventRecoder setValue:@"" forKey:layerDirector];
}

- (void)recorderEventForEventModel:(ZHEventModel *)eventModel{
    
    if (eventModel.isRandomAddTabBarOrNavagationBarEvent) {
        return;
    }
    
    if ([self canRecorderEventForEventModel:eventModel]==NO) {
        return;//不可以再点击了
    }
    
    NSString *layerDirector=[eventModel.objSelf.curViewController stringByAppendingPathComponent:eventModel.objSelf.layerDirector];
    NSNumber *happenCount=self.controllerEventRecoder[layerDirector];
    NSInteger happenCount_int=[happenCount integerValue];
    if (eventModel.isTableViewCellOrCollectionViewCell) {
        happenCount_int++;
        [self.controllerEventRecoder setValue:[NSNumber numberWithInteger:happenCount_int] forKey:layerDirector];
    }else{
        if (!eventModel.isScrollView) {
            happenCount_int++;
            [self.controllerEventRecoder setValue:[NSNumber numberWithInteger:happenCount_int] forKey:layerDirector];
        }
    }
}

- (BOOL)canRecorderEventForEventModel:(ZHEventModel *)eventModel{
    if (eventModel.isMostHappenEvent) {
        return NO;//不可以再点击了
    }
    
    NSString *layerDirector=[eventModel.objSelf.curViewController stringByAppendingPathComponent:eventModel.objSelf.layerDirector];
    if (self.controllerEventRecoder[layerDirector]==nil) {
        NSNumber *happenCount=[NSNumber numberWithInteger:0];
        if (layerDirector==nil) layerDirector=@"";
        [self.controllerEventRecoder setValue:happenCount forKey:layerDirector];
        return YES;
    }else{
        NSNumber *happenCount=self.controllerEventRecoder[layerDirector];
        NSInteger happenCount_int=[happenCount integerValue];
        if (eventModel.isTableViewCellOrCollectionViewCell) {
            if (happenCount_int>AutoTest_Happen_Click_Cell) {
                eventModel.isMostHappenEvent=YES;
                return NO;
            }else{
                return YES;
            }
        }else if(eventModel.isWebView){
            if (happenCount_int>AutoTest_WebView_AutoLink) {
                eventModel.isMostHappenEvent=YES;
                return NO;
            }else{
                return YES;
            }
        }else{
            if (!eventModel.isScrollView) {
                if (happenCount_int>AutoTest_Happen_Click_UIControl) {
                    if (self.changeWindowControllerEventRecoder[eventModel.objSelf.layerDirector]) {
                        if (happenCount_int<AutoTest_Happen_Click_ChangeTopViewController) {
                            return YES;
                        }
                    }
                    eventModel.isMostHappenEvent=YES;
                    return NO;
                }else{
                    return YES;
                }
            }
        }
    }
    return YES;
}

@end
