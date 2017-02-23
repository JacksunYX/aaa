//
//  NormalRegisterViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/21.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "NormalRegisterViewController.h"
#import "NormalRegisterViewController+Methods.h"//引入分类

#import "RESideMenu.h"//侧边栏库






@interface NormalRegisterViewController ()

@end



@implementation NormalRegisterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Register"];
    
    [self updataTheNavigationbar];

    [self loadRegisterView];//加载注册界面
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 关闭侧滑效果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    self.navigationController.navigationBarHidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
