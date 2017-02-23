//
//  UpdataPasswordViewController.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/2/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "UpdataPasswordViewController.h"
#import "UpdataPasswordViewController+Methods.h"    //引入分类






@implementation UpdataPasswordViewController

-(void)viewDidLoad
{

    [super viewDidLoad];
    
    [self creatBaseView];   //加载基本视图

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event//收起键盘
{
    
    [self.view endEditing:YES];
}


@end
