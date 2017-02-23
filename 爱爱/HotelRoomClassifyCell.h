//
//  HotelRoomClassifyCell.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///用于展示酒店房间分类的自定义cell

@class HotelClassifyModel;

#import <UIKit/UIKit.h>

@interface HotelRoomClassifyCell : UITableViewCell

@property (nonatomic,strong) UIImageView *backImage;    //用于承载分类图片

@property (nonatomic,strong) UILabel * classifyLabel;   //用于展示何种分类

@property (nonatomic,strong) UIButton *rooms;           //用于展示该类房间的数量

@property (nonatomic,strong) UILabel *introduction;     //用于展示该分类的描述

//填充酒店分类展示内容
-(void)setViewWithHotelClassifyModel:(HotelClassifyModel *)hotelClassifyModel;

@end
