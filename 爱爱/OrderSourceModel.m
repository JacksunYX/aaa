
//
//  OrderSourceModel.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/6.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "OrderSourceModel.h"

@implementation OrderSourceModel

-(NSString *)description
{

    return [NSString stringWithFormat:@"imgSrc:%@,theme:%@,belongHotel:%@,intakeDate:%@,totalPrice:%@",_imgSrc,_theme,_belongHotel,_intakeDate,_totalPrice];

}

@end
