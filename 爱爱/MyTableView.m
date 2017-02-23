//
//  MyTableView.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/20.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "MyTableView.h"

@implementation MyTableView


//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.separatorInset=UIEdgeInsetsMake(0, 10, 0, 10);//分割线缩进
        self.separatorStyle=UITableViewCellSeparatorStyleNone;//不显示分割线
    }
    return self;
}


@end
