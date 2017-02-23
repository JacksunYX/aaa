//
//  RomanticSingleExample.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/5/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///用于保存用户当前所选浪漫服务的单例


#import <Foundation/Foundation.h>

@interface RomanticSingleExample : NSObject

@property (nonatomic,strong) NSMutableArray *serviceArr;    //保存所选择的浪漫服务


+(RomanticSingleExample *)shareExample; //获取单例

@end
