//
//  PhoneResgisterViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "PhoneResgisterViewController.h"
#import "PhoneResgisterViewController+Methods.h"//引入分类

#import "RESideMenu.h"//侧边栏库



@interface PhoneResgisterViewController ()

@end

@implementation PhoneResgisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updataTheNavigationbar];
    
    [self loadRegisterView];//加载注册界面
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event//收起键盘
{
    
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
