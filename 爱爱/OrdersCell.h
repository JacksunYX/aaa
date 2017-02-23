//
//  OrdersCell.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/5.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///用于展示我的订单列表的自定义cell


#import <UIKit/UIKit.h>

@interface OrdersCell : UITableViewCell


@property (nonatomic,strong) UIButton *cancelOrder;  //取消订单按钮


@property (nonatomic,strong) NSDictionary *model;


@end
