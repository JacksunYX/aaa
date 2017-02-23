//
//  HotelClassifyModel.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/23.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///酒店房间分类的模型


#import <Foundation/Foundation.h>

@interface HotelClassifyModel : NSObject

@property (nonatomic,strong) NSString *classify;    //分类

@property (nonatomic,strong) NSString *imageSrc;    //对应图片的地址

@property (nonatomic,strong) NSString *roomsNum;    //主题房间数

@property (nonatomic,strong) NSString *introduction;//主题描述

@property (nonatomic,strong) NSString *themeId;     //主题id


@end
