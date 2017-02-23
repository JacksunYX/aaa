//
//  RoomHeaderView.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///用于展示房间详情最上面的图片相关

@class ThemeRoomModel;
#import <UIKit/UIKit.h>

@interface RoomHeaderView : UIView

@property (nonatomic,strong) UIImageView *backImageView;    //酒店图片背景

@property (nonatomic,strong) UILabel *priceLabel;           //价格

@property (nonatomic,strong) UILabel *roomName;             //房间名(主题)

//自定义初始化方法
-(instancetype)initWithWidth:(CGFloat)width;    //根据宽度自动计算出高度

-(void)setViewWithRoomModel:(ThemeRoomModel *)roomModel;    //填充视图

@end
