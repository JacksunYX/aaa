//
//  PureImageViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/13.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "PureImageViewController.h"
#import "PureImageViewController+Methods.h" //引入分类

@interface PureImageViewController ()

@end

@implementation PureImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatCurrentView];    //加载视图
    
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}


-(void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];
    
    //修改状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}


@end
