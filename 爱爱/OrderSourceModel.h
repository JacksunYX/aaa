//
//  OrderSourceModel.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/6.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///订单模型





#import <Foundation/Foundation.h>

@interface OrderSourceModel : NSObject

@property (nonatomic,strong) NSString *imgSrc;  //配图地址

@property (nonatomic,strong) NSString *theme;   //标题

@property (nonatomic,strong) NSString *belongHotel; //所属酒店

@property (nonatomic,strong) NSString *intakeDate;  //入住时间

@property (nonatomic,strong) NSString *totalPrice;  //总价






@end
