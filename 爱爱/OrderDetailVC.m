//
//  OrderDetailVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/6.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//




#import "OrderDetailVC.h"
#import "OrderDetailVC+Methods.h"   //引入分类

#import "LBToAppStore.h"

#import "UIViewController+JTNavigationExtension.h"

@implementation OrderDetailVC

-(void)viewDidLoad
{

    [super viewDidLoad];
    
    [self loadBaseView];    //加载基本视图

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (_hideLeftBtn) {
        
       self.jt_fullScreenPopGestureEnabled = NO;
        
    }
    
    //注册支付宝回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToOrder:) name:@"aliPayResult" object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    if (_hideLeftBtn) {
        
        self.jt_fullScreenPopGestureEnabled = YES;
        
    }
}


-(void)viewDidAppear:(BOOL)animated
{

    [self showCommandView];

}


-(void)showCommandView  //好评引导框
{
    
    //用户好评系统
    LBToAppStore *toAppStore = [[LBToAppStore alloc]init];
    //该app的app ID
    toAppStore.myAppID = MyAppID;
    [toAppStore showGotoAppStore:self];
    
}
























@end
