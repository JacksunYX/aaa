//
//  RoomDeviceScrollView.h
//  情趣设施自定义测试
//
//  Created by 薇薇一笑 on 16/3/31.
//  Copyright © 2016年 爱爱网. All rights reserved.
//
///房间情趣设施自定义View



#import <UIKit/UIKit.h>

@interface RoomDeviceView : UIView

//初始化方法
-(instancetype)initWithWidth:(CGFloat)width;

//根据传入的数据加载视图
-(void)setUpViewWithDeviceArr:(NSArray *)modelArr;

@end
