//
//  RoomClassifyCell.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///用于展示某一类分类房间的自定义cell


@class ThemeRoomModel;
#import <UIKit/UIKit.h>

@interface RoomClassifyCell : UITableViewCell

@property (nonatomic,strong) UIImageView *backImageView;    //图片视图

@property (nonatomic,strong) UILabel *priceLabel;           //单价

@property (nonatomic,strong) UILabel *roomName;             //房间名

@property (nonatomic,strong) UILabel *belongHotel;          //所属酒店

@property (nonatomic,strong) UILabel *distance;             //距离当前位置的距离

-(void)setViewWithRoomMModel:(ThemeRoomModel *)roomModel;   //填充内容


@end
