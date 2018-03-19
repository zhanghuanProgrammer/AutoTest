//
//  ZHTestVC.m
//  CJOL
//
//  Created by mac on 2018/2/8.
//  Copyright © 2018年 SuDream. All rights reserved.
//

#import "ZHTestVC.h"
#import "hitView.h"

@interface ZHTestVC ()

@end

@implementation ZHTestVC

- (void)viewDidLoad{
    [super viewDidLoad];

    UIView* view = [[hitView alloc] initWithFrame:CGRectMake((375 - 300) / 2.0, (675 - 300) / 2.0, 300, 300)];
    //    view.clipsToBounds = YES;

    UIView* viewNew = [[UIView alloc] initWithFrame:CGRectMake((375 - 300) / 2.0+10, (675 - 300) / 2.0+10 , 300 , 300 )];
    viewNew.backgroundColor = [UIColor blackColor];
    view.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:view];
    [self.view addSubview:viewNew];
    viewNew.alpha = 0.3;
    
//    for (NSInteger i=0; i<20; i++) {
//        UIView *newView = viewNew;
//        if(i==3)newView.clipsToBounds=YES;
//        viewNew = [[UIView alloc] initWithFrame:CGRectMake(35, 35 , 300 , 300 )];
//        viewNew.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
//        [newView addSubview:viewNew];
//    }
    
    UIScrollView *scv = [[UIScrollView alloc]initWithFrame:CGRectMake(100, 200, 200, 200)];
    scv.alwaysBounceVertical = YES;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 600, 1600)];
    view1.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
    scv.backgroundColor=[UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
    [scv addSubview:view1];
    scv.contentSize = view1.size;
    scv.userInteractionEnabled = YES;
    scv.scrollEnabled = YES;
    scv.bounces=YES;
    [self.view addSubview:scv];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"%@",@"😄开始");
//        [[UIApplication sharedApplication].keyWindow allEventView];
//        NSLog(@"%@",@"😄结束");
//    });
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end

