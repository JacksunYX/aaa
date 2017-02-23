//
//  HotelModel.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///酒店基本信息模型


#import <Foundation/Foundation.h>

@interface HotelModel : NSObject

@property (nonatomic,strong) NSString *hotelId;

@property (nonatomic,strong) NSString *hotelImgSrc; //酒店图片地址

@property (nonatomic,strong) NSString *hotelName;   //酒店名

@property (nonatomic,strong) NSString *unitPrice;   //单价

@property (nonatomic,strong) NSString *hotelAddress;//酒店地址

@property (nonatomic,strong) NSString *hotelLogo;   //酒店logo

@property (nonatomic,strong) NSString *contactPhoneNum; //联系电话



@end
