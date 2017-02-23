//
//  HotelShowCell.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///用于展示酒店列表的自定义cell

@class HotelModel;
#import <UIKit/UIKit.h>

@interface HotelListCell : UITableViewCell

@property (nonatomic,strong) UIImageView *hotelImg; //图片视图

@property (nonatomic,strong) UILabel *hotelTitle;   //标题(店名)

@property (nonatomic,strong) UIImageView *hotelScoreView;   //评分图标

@property (nonatomic,strong) UILabel *hotelScroe;   //评分描述

@property (nonatomic,strong) UILabel *price;        //标价

@property (nonatomic,strong) UILabel *rise;         //"起"

@property (nonatomic,strong) UILabel *distance;     //距离

-(void)UpdataViewWithHotelModel:(HotelModel *)hotelModel;   //传递酒店模型信息修改显示内容

@end
