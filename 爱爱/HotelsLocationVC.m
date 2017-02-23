//
//  HotelsLocationVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//









#import "HotelsLocationVC.h"
#import "HotelsLocationVC+Methods.h"    //引入分类



@interface HotelsLocationVC ()


@end



@implementation HotelsLocationVC



-(void)viewDidLoad
{

    [super viewDidLoad];
    
    [self creatView];   //加载基本视图
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [mapView viewWillAppear];
    i=0;
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    locService.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
    locService.delegate = nil;
    
}

-(void)viewDidAppear:(BOOL)animated
{
//
//    //关闭手势侧滑功能
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//
//    [self closeTheGesture];
    
}
//
-(void)viewDidDisappear:(BOOL)animated
{
//
//    //关闭手势侧滑功能
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//
//    [self openTheGesture];
    
}
























- (void)dealloc {
    if (mapView) {
        mapView = nil;
    }
}



@end
