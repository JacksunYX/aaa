//
//  HotelRoomCell.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///用于展示酒店详情中的各种主题房间的自定义cell

@class ThemeRoomModel;

#import <UIKit/UIKit.h>

@interface HotelRoomCell : UITableViewCell

@property (nonatomic,strong) UIImageView *roomBackImg;  //房间背景图片

@property (nonatomic,strong) UILabel *roomClassifyName; //房间的主体名

@property (nonatomic,strong) UILabel *introduction;     //房间描述

@property (nonatomic,strong) UILabel *unitPrice;        //房间单价

//填充主题房间内容
-(void)setViewWithRoomModel:(ThemeRoomModel*)roomModel;    //填充内容

@end
