//
//  HotelHeaderView.m
//  表视图表头模糊化测试
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 爱爱网. All rights reserved.
//

#import "HotelHeaderView.h"

@implementation HotelHeaderView

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
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width/3)];
    [self addSubview:_backImageView];
//    _backImageView.backgroundColor = [UIColor greenColor];
    
    //酒店log图标
    CGFloat iconbackViewWidth = width/5;  //中间的图标宽度为图片的1/5
    UIView *iconbackView = [[UIView alloc]initWithFrame:CGRectMake(width/2-iconbackViewWidth/2, _backImageView.frame.size.height-iconbackViewWidth/2, iconbackViewWidth, iconbackViewWidth)];
    [self addSubview:iconbackView];
    iconbackView.layer.cornerRadius = iconbackViewWidth/2;
    iconbackView.backgroundColor = [UIColor whiteColor];
    
    CGFloat iconWidth = iconbackView.frame.size.width-3*2;
    _hotelIcon = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, iconWidth, iconWidth)];
    _hotelIcon.center =iconbackView.center;
    [self addSubview:_hotelIcon];
    _hotelIcon.layer.cornerRadius = iconWidth/2;
    _hotelIcon.backgroundColor = [UIColor whiteColor];
    
    //酒店名
    _hotelName = [[UILabel alloc]initWithFrame:CGRectMake(0, iconbackView.frame.origin.y+iconbackView.frame.size.height+5, width, 50)];
    _hotelName.font = [UIFont boldSystemFontOfSize:20];
    _hotelName.textColor = [UIColor blackColor];
    _hotelName.textAlignment=1; //居中
    _hotelName.numberOfLines=0; //自动换行
    [self addSubview:_hotelName];
    
    
    self.frame = CGRectMake(0, 0, width, _hotelName.frame.origin.y+_hotelName.frame.size.height+10);

}



//图片重绘切圆
- (UIImage*)cutImage:(UIImage *)orImage WithRadius:(int)radius
{
    UIGraphicsBeginImageContext(orImage.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+orImage.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+orImage.size.height;
    float x4 = x1;
    float y4 = y3;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, orImage.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, orImage.size.width, orImage.size.height), orImage.CGImage);
    
    
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}


//重绘至期望大小(方法3)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

//设置log图标
-(void)sethotelIconImage:(UIImage *)image
{
    
    UIImage *img =[self scaleToSize:image size:CGSizeMake(150, 150)];
    
    UIImage *im =[self cutImage:img WithRadius:img.size.width/2];
    
    [self.hotelIcon setBackgroundImage:im forState:UIControlStateNormal];

}





















@end
