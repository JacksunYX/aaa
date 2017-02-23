//
//  HotelRoomClassifyCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//


#import "UIImageView+ProgressView.h"    //带进度圈的图片加载库
#import "UIImageView+Animation.h"

#import "HotelClassifyModel.h"  //酒店分类模型

#import "HotelRoomClassifyCell.h"

@implementation HotelRoomClassifyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setupView];   //加载基本视图
        
    }
    
    return self;

}

-(void)setupView    //加载视图
{
    
    self.frame=CGRectMake(0, 0, Width, 0);
    
    //承载图片的视图
    CGFloat imageViewWidth = self.frame.size.width-20;
    CGFloat imageViewHeight =imageViewWidth/2;
    
    self.backImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, imageViewWidth, imageViewHeight)];
    self.backImage.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.backImage];
    
    
    //分类文字
    CGFloat classifyLabelWidth = imageViewWidth/3;
    CGFloat classifyLabelHeight = classifyLabelWidth/3;
    
    self.classifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.backImage.frame.size.width/2-classifyLabelWidth/2,self.backImage.frame.size.height/2-classifyLabelHeight/2, classifyLabelWidth, classifyLabelHeight)];
    self.classifyLabel.layer.borderColor=[UIColor whiteColor].CGColor;
    self.classifyLabel.layer.borderWidth=2.0;
    self.classifyLabel.backgroundColor= [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:0.3];
    self.classifyLabel.textColor=[UIColor whiteColor];
    self.classifyLabel.textAlignment=1;
    self.classifyLabel.font=[UIFont fontWithName:PingFangSCX size:20];
    [self.backImage addSubview:self.classifyLabel];
    self.classifyLabel.hidden = YES;
    
    
    //该类房间的数量
    UIView *roomsBackView =[[UIView alloc]initWithFrame:CGRectMake(self.backImage.frame.origin.x+imageViewWidth/2-25, self.backImage.frame.origin.y+imageViewHeight-25, 50, 50)];
    roomsBackView.backgroundColor =[UIColor whiteColor];
    roomsBackView.layer.cornerRadius=roomsBackView.frame.size.width/2;
    [self addSubview:roomsBackView];
    
    self.rooms = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    self.rooms.backgroundColor=MainThemeColor;
    self.rooms.layer.cornerRadius=self.rooms.frame.size.width/2;
    self.rooms.titleLabel.font=[UIFont systemFontOfSize:12];
    [self.rooms setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.rooms];
    self.rooms.center=roomsBackView.center;
    
    
    
    //下方分类描述
    CGFloat introductionOriginY = roomsBackView.frame.origin.y+roomsBackView.frame.size.height+10;
    self.introduction = [[UILabel alloc]initWithFrame:CGRectMake(self.backImage.frame.origin.x, introductionOriginY, self.backImage.frame.size.width, 50)];
    self.introduction.textAlignment=1;  //居中
    self.introduction.numberOfLines=0;  //自动换行
    self.introduction.font=[UIFont fontWithName:PingFangSCQ size:18];
    self.introduction.textColor=ContentTextColorNormal;
    [self addSubview:self.introduction];
    
    self.frame = CGRectMake(0, 0, Width, introductionOriginY+self.introduction.frame.size.height+10);
    
}

-(void)setViewWithHotelClassifyModel:(HotelClassifyModel *)hotelClassifyModel
{
    
    NSString *imageUrl = [MainUrl stringByAppendingString:hotelClassifyModel.imageSrc];
    
//    NSLog(@"imageUrl:%@",imageUrl);
    
    //设置图片
    [self.backImage animateImageWithURL:[NSURL URLWithString:imageUrl]];
    
    //分类文字
    [self.classifyLabel setText:hotelClassifyModel.classify];
    [UIView animateWithDuration:0.5f animations:^{
        
       self.classifyLabel.hidden = NO;
        
    }];
    
    //房间间数
    [self.rooms setTitle:[NSString stringWithFormat:@"%@间",hotelClassifyModel.roomsNum] forState:UIControlStateNormal];
    
    //分类描述
    [self.introduction setText:hotelClassifyModel.introduction];
//    [self.introduction sizeToFit];  //自适应
//    
//    self.introduction.frame=CGRectMake(self.frame.size.width/2-self.introduction.frame.size.width/2, self.introduction.frame.origin.y, self.introduction.frame.size.width, self.introduction.frame.size.height);
    
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.introduction.frame.origin.y+self.introduction.frame.size.height+10);

}


@end
