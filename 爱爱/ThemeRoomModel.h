//
//  ThemeRoomModel.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///酒店主题房间模型


#import <Foundation/Foundation.h>

@interface ThemeRoomModel : NSObject

@property (nonatomic,strong) NSString *roomId;

@property (nonatomic,strong) NSString *imageSrc;        //图片地址

@property (nonatomic,strong) NSString *theme;           //主题名(房间名)

@property (nonatomic,strong) NSString *introduction;    //主题描述

@property (nonatomic,strong) NSString *unitPrice;       //单价

@property (nonatomic,strong) NSString *belongHotelLogSrc;   //所属酒店的log图片地址

@property (nonatomic,strong) NSString *belongHotel;     //所属酒店

@property (nonatomic,strong) NSString *belongHotelID;   //所属酒店的id

@property (nonatomic,strong) NSString *location;        //地理位置

@property (nonatomic,strong) NSString *roomStory;       //房间物语

@property (nonatomic,strong) NSString *stayNotice;      //入住须知

@property (nonatomic,strong) NSArray *roomPictures;     //图片及图片描述的数组

@property (nonatomic,strong) NSArray *roomDevice;       //房间设施数组

@property (nonatomic,strong) NSArray *hotelRomantics;   //浪漫服务数组

@property (nonatomic,strong) NSString *canOrder;        //房间是否能被预定


@end
