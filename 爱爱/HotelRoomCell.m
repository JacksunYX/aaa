//
//  HotelRoomCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "HotelRoomCell.h"

#import "ThemeRoomModel.h"  //引入模型

#import "UIImageView+ProgressView.h"    //带进度圈的图片加载库

@implementation HotelRoomCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupView];   //加载基本视图
        
    }
    
    return self;

}

-(void)setupView    //加载基本视图
{
    //宽高比例4:3
    CGFloat ImgViewWidth = (Width -10*3)/2;
    CGFloat ImgViewHeight=ImgViewWidth*3/4;
    
    //房间图片
    _roomBackImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, ImgViewWidth, ImgViewHeight)];
    [self.contentView addSubview:_roomBackImg];
    
    CGFloat  averageHeight = (ImgViewHeight-5*2)/3;
    //主题标签
    _roomClassifyName =[[UILabel alloc]initWithFrame:CGRectMake(_roomBackImg.frame.origin.x+_roomBackImg.frame.size.width+10, _roomBackImg.frame.origin.y, ImgViewWidth, averageHeight)];
    [_roomClassifyName setFont:[UIFont boldSystemFontOfSize:20]];
    [_roomClassifyName setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:_roomClassifyName];
    
    //主题描述
    _introduction = [[UILabel alloc]initWithFrame:CGRectMake(_roomClassifyName.frame.origin.x, _roomClassifyName.frame.origin.y+_roomClassifyName.frame.size.height+5, ImgViewWidth, averageHeight)];
    [_introduction setFont:[UIFont boldSystemFontOfSize:14]];
    _introduction.numberOfLines=0;
    [_introduction setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:_introduction];
    
    //标价
    _unitPrice = [[UILabel alloc]initWithFrame:CGRectMake(_roomClassifyName.frame.origin.x, _roomBackImg.frame.origin.y+_roomBackImg.frame.size.height-averageHeight, ImgViewWidth, averageHeight)];
    [_unitPrice setFont:[UIFont boldSystemFontOfSize:16]];
    [_unitPrice setTextColor:MainThemeColor];
    [self.contentView addSubview:_unitPrice];
    
}


-(void)setViewWithRoomModel:(ThemeRoomModel*)roomModel    //填充内容
{
    //设置图片
    [_roomBackImg sd_setImageWithURL:[NSURL URLWithString:roomModel.imageSrc] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(20, 20)];
    
    //设置主题
    [_roomClassifyName setText:roomModel.theme];
    
    //设置描述文字
    [_introduction setText:roomModel.introduction];
    
    //设置单价
    [_unitPrice setText:[NSString stringWithFormat:@"¥%@",roomModel.unitPrice]];
    
}















@end
