//
//  RomanticSingleExample.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/5/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "RomanticSingleExample.h"

@implementation RomanticSingleExample
static RomanticSingleExample *example;

+(RomanticSingleExample *)shareExample  //获取单例
{

    @synchronized (self) {  //互斥锁
        
        if (!example) {
            
            example = [[RomanticSingleExample alloc]init];
            
        }
        
    }
    
    return example;

}

-(id)init
{

    self = [super init];
    
    if (self) {
        
        //此处可以处理一些基本属性
        _serviceArr = [NSMutableArray new];
        
    }

    return self;
    
}

@end
