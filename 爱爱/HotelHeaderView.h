//
//  HotelHeaderView.h
//  表视图表头模糊化测试
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 爱爱网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelHeaderView : UIView

@property (nonatomic,strong) UIImageView *backImageView;    //酒店图片背景

@property (nonatomic,strong) UIButton *hotelIcon;           //酒店log图标

@property (nonatomic,strong) UILabel *hotelName;            //酒店名

//自定义初始化方法
-(instancetype)initWithWidth:(CGFloat)width;    //根据宽度自动计算出高度

//设置log图标
-(void)sethotelIconImage:(UIImage *)image;

@end
