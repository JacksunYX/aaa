//
//  RoomHeaderView.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "RoomHeaderView.h"

#import "UIImageView+ProgressView.h"    //带进度圈的图片加载库

#import "ThemeRoomModel.h"

@implementation RoomHeaderView

//自定义初始化方法
-(instancetype)initWithWidth:(CGFloat)width
{
    
    self = [super initWithFrame:CGRectMake(0, 0, width, 0)];
    
    if (self) {
        
        [self creatBaseView];
        
    }
    
    return self;
    
}

-(void)creatBaseView    //加载基本视图
{

    CGFloat width = self.frame.size.width;
    
    //酒店背景图片
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width*9/16)];
    [self addSubview:_backImageView];
//    _backImageView.backgroundColor = [UIColor greenColor];

    
    //酒店名
    _roomName = [[UILabel alloc]initWithFrame:CGRectMake(0, _backImageView.frame.origin.y+_backImageView.frame.size.height+10, width, 50)];
    _roomName.font = [UIFont systemFontOfSize:20];
    _roomName.textColor = MainThemeColor;
    _roomName.textAlignment=1; //居中
    _roomName.numberOfLines=0; //自动换行
    [self addSubview:_roomName];
    
    self.frame = CGRectMake(0, 0, width, _roomName.frame.origin.y+_roomName.frame.size.height+10);

}

-(void)setViewWithRoomModel:(ThemeRoomModel *)roomModel    //填充视图
{
    //优先选择第一张图片
    NSDictionary *dict = [roomModel.roomPictures firstObject];
    
    if ([dict objectForKey:@"pictureAddress"]) {
        
        NSString *imageUrlStr = [MainUrl stringByAppendingString:[dict objectForKey:@"pictureAddress"]];
        
        //设置背景图
        [_backImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(30, 30)];
        
    }
    
    //设置房间名
    [_roomName setText:roomModel.theme];

}






@end
