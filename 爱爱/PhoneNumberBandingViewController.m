//
//  PhoneNumberBandingViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/20.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "PhoneNumberBandingViewController.h"
#import "PhoneNumberBandingViewController+Methods.h"    //引入分类

@implementation PhoneNumberBandingViewController


-(void)viewDidLoad
{

    [super viewDidLoad];
    
    [self creatBaseView];  //修改导航栏显示

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event//收起键盘
{
    
    [self.view endEditing:YES];
}



@end
