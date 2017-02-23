//
//  MyMessageViewController+Methods.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/18.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "MyMessageViewController.h"

@interface MyMessageViewController (Methods)

#pragma  mrak ---视图创建及请求发送的统一方法

-(void)creatViewAndsendRequest; //视图创建及请求发送的统一方法

#pragma mark ---视图加载

-(void)creatNavigationView;     //添加导航栏按钮相关



-(void)showString:(NSString *)str; //提示框



@end
