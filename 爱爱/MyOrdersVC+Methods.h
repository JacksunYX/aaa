//
//  MyOrdersVC+Methods.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/5.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//


#import "OrderSourceModel.h"    //订单模型

#import "MyOrdersVC.h"




@interface MyOrdersVC (Methods)


#pragma mark ----- 统一视图加载方法
-(void)loadBaseView; //加载基本视图

#pragma mark ----- 交互方法

-(IBAction)cancelOrder:(id)sender;  //取消订单的点击事件


@end
