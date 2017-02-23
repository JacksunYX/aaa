//
//  NewSettingViewController+Methods.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/2/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "NewSettingViewController.h"

#import "XGPush.h"

#import "AppDelegate.h"


@interface NewSettingViewController (Methods)

#pragma  mrak ---视图创建及请求发送的统一方法
-(void)creatView;                               //视图创建


#pragma mark ---视图加载

-(void)creatNavigationView;                     //添加导航栏按钮相关

-(void)creatTableView;                          //创建表视图


#pragma mark ----- 辅助方法

-(IBAction)touchToGetMessage:(UISwitch *)sender;    //修改是否获取消息推送的状态


- (BOOL)isAllowedNotification;  //用户是否同意后台推送

-(void)touchToSetNotification;  //设置推送通知状态

- (void)tongzhi:(NSNotification *)text;  //通知回调



@end
