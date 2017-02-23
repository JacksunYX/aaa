//
//  RoomClassifyCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "RoomClassifyCell.h"
#import "ThemeRoomModel.h"

#import "UIImageView+ProgressView.h"    //带进度圈的图片加载库
#import "UIImageView+Animation.h"

@implementation RoomClassifyCell

//重写初始化方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self creatBaseView];   //创建基本视图
        
    }
    
    return self;

}

-(void)creatBaseView
{
    //图片
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, Width*9/16)]; //(宽高比16:9)
    [self.contentView addSubview:_backImageView];
//    _backImageView.backgroundColor=[UIColor redColor];
    
    CGFloat labelWidth = (Width-10*3)/2;
    
    //房间名
    _roomName = [[UILabel alloc]initWithFrame:CGRectMake(10, _backImageView.frame.origin.y+_backImageView.frame.size.height, labelWidth, 30)];
    [self.contentView addSubview:_roomName];
    [_roomName setTextColor:TitleTextColorNormal];
    [_roomName setFont:[UIFont systemFontOfSize:16]];
//    _roomName.backgroundColor=[UIColor greenColor];
    
    //酒店名
    _belongHotel =[[UILabel alloc]initWithFrame:CGRectMake(10, _roomName.frame.origin.y+_roomName.frame.size.height,  labelWidth, 30)];
    [self.contentView addSubview:_belongHotel];
    _belongHotel.numberOfLines=0;
    [_belongHotel setTextColor:ContentTextColorNormal];
    [_belongHotel setFont:[UIFont systemFontOfSize:14]];
//    _belongHotel.backgroundColor=[UIColor orangeColor];
    
    
    //距离
    _distance = [[UILabel alloc]initWithFrame:CGRectMake(Width-10-labelWidth, _roomName.frame.origin.y+10, labelWidth, 30)];
    [self.contentView addSubview:_distance];
    _distance.textAlignment=2;
    [_distance setTextColor:[UIColor grayColor]];
    [_distance setFont:[UIFont systemFontOfSize:10]];
//    _distance.backgroundColor=[UIColor purpleColor];
    
    
    //价格
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _backImageView.frame.origin.y+_backImageView.frame.size.height-30-20, Width/5, 30)];
    _priceLabel.backgroundColor=RGBA(50, 50, 50, 0.7);
    _priceLabel.textColor=[UIColor whiteColor];
    _priceLabel.font=[UIFont systemFontOfSize:16];
    _priceLabel.textAlignment=1;
    [self processAssignedAngleWith:_priceLabel AndCornerRadius:_priceLabel.frame.size.width];
    [self.contentView addSubview:_priceLabel];

}


-(void)setViewWithRoomMModel:(ThemeRoomModel *)roomModel   //填充内容
{

    if (roomModel.imageSrc) {
        
        NSString *imageUrlStr = [MainUrl stringByAppendingString:roomModel.imageSrc];
        
        //    NSLog(@"imageUrlStr:%@",imageUrlStr);
        
        //设置背景图
//        [_backImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(30, 30)];
        
        [_backImageView animateImageWithURL:[NSURL URLWithString:imageUrlStr]];
        
    }
    
    //价格
    if (roomModel.unitPrice) {
        
        [_priceLabel setText:[NSString stringWithFormat:@"¥%@",roomModel.unitPrice]];
        [_priceLabel setHidden:NO];
        
    }else{
    
        [_priceLabel setHidden:YES];
    
    }
    
    
    //房间主题名
    [_roomName setText:roomModel.theme];
    
    //所属酒店
    [_belongHotel setText:roomModel.belongHotel];
    

}


//指定切角方位(目前是切右边的上下2个角)
-(void)processAssignedAngleWith:(UIView *)view AndCornerRadius:(CGFloat)cornerRadius
{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;

}









@end
