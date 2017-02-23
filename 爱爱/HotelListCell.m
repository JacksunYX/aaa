//
//  HotelShowCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define CellHeight 100   //下方酒店展示视图的高度
#define HotelImageHeight (CellHeight-10*2) //酒店图片宽度(宽高比4:3)


#import "HotelListCell.h"

#import "HotelModel.h"  //酒店模型

#import "UIImageView+ProgressView.h"    //带进度圈的图片加载库

@implementation HotelListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        
        [self loadBaseViews];   //加载基本视图
        
    }
    
    return self;
    
}

-(void)loadBaseViews    //加载基本视图
{

    //酒店图片
    _hotelImg =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, HotelImageHeight, HotelImageHeight)];
    _hotelImg.layer.cornerRadius=5.0f;
    _hotelImg.layer.masksToBounds=YES;   //开启圆角
    [self.contentView addSubview:_hotelImg];
    
    //标题
    _hotelTitle = [[UILabel alloc]init];
    _hotelTitle.font=[UIFont systemFontOfSize:16];
    _hotelTitle.dk_textColorPicker=DKColorWithColors(RGBA(50, 50, 50, 1), TitleTextColorNight);
    [self.contentView addSubview:_hotelTitle];
    
    //评分图标
    _hotelScoreView =[[UIImageView alloc]init];
    [self.contentView addSubview:_hotelScoreView];
    
    //评分数
    _hotelScroe = [[UILabel alloc]init];
    _hotelScroe.font=[UIFont systemFontOfSize:10];
    _hotelScroe.dk_textColorPicker=DKColorWithColors(RGBA(150, 150, 150, 1), UnimportantContentTextColorNight);
    [self.contentView addSubview:_hotelScroe];
    
    //标价
    _price = [[UILabel alloc]init];
    _price.dk_textColorPicker=DKColorWithColors(MainThemeColor, TitleTextColorNight);
    [_price setFont:[UIFont systemFontOfSize:18]];
    [self.contentView addSubview:_price];
    
    //“起”
    _rise =[[UILabel alloc]init];
    _rise.dk_textColorPicker=DKColorWithColors(MainThemeColor, ContentTextColorNight);
    [_rise setFont:[UIFont systemFontOfSize:12]];
    [_rise setText:@"起"];
    [_rise sizeToFit];
    [self.contentView addSubview:_rise];
    
    
    //距离当前位置
    _distance = [[UILabel alloc]init];
    _distance.dk_textColorPicker = DKColorWithColors(RGBA(100, 100, 100, 1), UnimportantContentTextColorNight);
    [_distance setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_distance];
    
}

-(void)UpdataViewWithHotelModel:(HotelModel *)hotelModel
{
    
    //修改酒店图片
    [_hotelImg sd_setImageWithURL:[NSURL URLWithString:hotelModel.hotelImgSrc] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(20, 20)];
    
    //修改标题内容
    [_hotelTitle setText:hotelModel.hotelName];
    [_hotelTitle sizeToFit];
    _hotelTitle.frame=CGRectMake(_hotelImg.frame.origin.x+_hotelImg.frame.size.width+10, _hotelImg.frame.origin.y, _hotelTitle.frame.size.width, _hotelTitle.frame.size.height);
    
    //评分
    [_hotelScroe setText:@"暂无评分"];
    [_hotelScroe sizeToFit];
    _hotelScroe.frame=CGRectMake(_hotelTitle.frame.origin.x, _hotelTitle.frame.origin.y+_hotelTitle.frame.size.height+5, _hotelScroe.frame.size.width, _hotelScroe.frame.size.height);
    
    //标价
    [_price setText:[NSString stringWithFormat:@"￥%@",hotelModel.unitPrice]];
    [_price sizeToFit];
    _price.frame=CGRectMake(_hotelTitle.frame.origin.x, _hotelScroe.frame.origin.y+_hotelScroe.frame.size.height+5, _price.frame.size.width, _price.frame.size.height);
    
    _rise.frame=CGRectMake(_price.frame.origin.x+_price.frame.size.width+2, _price.frame.origin.y+_price.frame.size.height-_rise.frame.size.height-2, _rise.frame.size.width, _rise.frame.size.height);
    
    //位置
    [_distance setText:[NSString stringWithFormat:@"距离目的地%@m",hotelModel.unitPrice]];
    [_distance sizeToFit];
    _distance.frame=CGRectMake(_hotelTitle.frame.origin.x, _hotelImg.frame.origin.y+_hotelImg.frame.size.height-_distance.frame.size.height, _distance.frame.size.width, _distance.frame.size.height);

}



@end
