//
//  NewLoginViewController.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/26.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "NewLoginViewController.h"
#import "NewLoginViewController+Metheods.h"


@interface NewLoginViewController ()

@end

@implementation NewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatView];   //加载视图
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Login"];
    // 关闭侧滑效果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    self.navigationController.navigationBarHidden=NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event//收起键盘
{
    
    [self.view endEditing:YES];
}


@end
