//
//  MyOrdersVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/5.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///我的订单页面



#import <UIKit/UIKit.h>

@interface MyOrdersVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

{

    NSMutableArray *ordersModelArr;   //用于存放订单模型的数组
    
    DGActivityIndicatorView *activityIndicatorView; //加载指示器
    
    NSInteger shouldBeCancelOrder;  //需要被取消的订单编号号

}

@property (nonatomic,strong) UITableView *mytableView;  //用来展示订单列表的表视图

@end
