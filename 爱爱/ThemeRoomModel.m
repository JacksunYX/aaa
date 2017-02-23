//
//  ThemeRoomModel.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "ThemeRoomModel.h"

@implementation ThemeRoomModel

-(NSString *)description
{

    return [NSString stringWithFormat:@"imageSrc:%@\ntheme:%@\nunitPrice:%@",self.imageSrc,self.theme,self.unitPrice];

}

@end
