//
//  UserSourceModel.m
//  爱爱
//
//  Created by 爱爱网 on 15/12/21.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.
//

#import "UserSourceModel.h"


@implementation UserSourceModel
-(NSString *)description
{
    return [NSString stringWithFormat:@"userId:%@,nickname:%@,gender:%@,birthday:%@,location:%@,phoneNum:%@",self.userId,self.nickname,self.gender,self.birthday,self.location,self.phoneNum];
}


@end
