//
//  hitView.m
//  CJOL
//
//  Created by mac on 2018/2/8.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "hitView.h"

@interface hitView ()

@end

@implementation hitView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < 12; i++) {
            UIColor* sjColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0];
            for (int j = 0; j < 12; j++) {
                UIButton* Button = [[UIButton alloc] initWithFrame:CGRectMake(j * 30, i * 30, 30, 30)];
                sjColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0];
                Button.backgroundColor = sjColor;
                Button.tag = 1 + i * 10 + j;
                [Button addTarget:self action:@selector(tapClick) forControlEvents:1 << 6];
                [self addSubview:Button];
            }
        }
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event{
    //    NSLog(@"%@",NSStringFromCGPoint(point));
    UIView* view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView* subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

- (void)tapClick{
    NSLog(@"%@", @"tapClick");
}

@end

