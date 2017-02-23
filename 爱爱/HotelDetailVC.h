//
//  HotelDetailVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///酒店详情页

@class ParallaxHeaderView;

#import "HorizontalMenu.h"  //分段选择库

#import <UIKit/UIKit.h>

@interface HotelDetailVC : UIViewController<UITableViewDataSource,UITableViewDelegate,HorizontalMenuDelegate>
{

    NSMutableArray  *hotelRoomsArr;  //酒店房间数组

    UIScrollView    *myScrollView;  //全局的滚动视图
    
    HorizontalMenu  *segment;       //分段选择控件
}

@property (nonatomic,strong) UITableView *mytableView;  //表视图

@property (nonatomic,strong) ParallaxHeaderView *headerView;


@end
