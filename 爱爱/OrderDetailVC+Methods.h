//
//  OrderDetailVC+Methods.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/6.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//


#import "OrderDetailVC.h"



@interface OrderDetailVC (Methods)

#pragma mark ----- 统一视图加载方法
-(void)loadBaseView; //加载基本视图

//通知的回调,根据返回的结果进行跳转
-(void)jumpToOrder:(NSNotification *)dict;




@end
