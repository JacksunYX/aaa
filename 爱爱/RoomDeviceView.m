//
//  RoomDeviceScrollView.m
//  情趣设施自定义测试
//
//  Created by 薇薇一笑 on 16/3/31.
//  Copyright © 2016年 爱爱网. All rights reserved.
//

#import "RoomDeviceView.h"

#import "UIView+SDAutoLayout.h"

#import "UIImageView+ProgressView.h"
#import "UIImageView+CornerRadius.h"

@interface RoomDeviceView ()



@end


@implementation RoomDeviceView


-(instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        
    }
    
    return self;

}

-(instancetype)initWithWidth:(CGFloat)width
{

    self =[super init];
    
    if (self) {
        
        self.frame=CGRectMake(0, 0, width, 0);
        
    }
    
    return self;

}


//根据传入的数据加载视图
-(void)setUpViewWithDeviceArr:(NSArray *)modelArr
{
    
    if (modelArr.count<=0) {
        
        self.sd_layout
        .heightIs(0)
        ;
        
        return;
        
    }
    
    //假定每行最多放6个展示,多余的换行,每个间距为10
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin =10;
    NSInteger num =6;
    
    //平均宽度
    CGFloat agvWidth = (width-margin*(num+1))/num;
    
    int i=0;
    
    int remainder ;
    
    //取出最后一排的视图个数
    if (modelArr.count>num) {   //多排
        
        remainder = (int)(modelArr.count)%num;
        
    }else{  //一排
        
        remainder = (int)modelArr.count;
        
    }
    
    //    创建背景板(一定要注意方位)
    UIView *backView = [[UIView alloc]init];
//    backView.backgroundColor=[UIColor redColor];
    [self addSubview:backView];
    
    while (i<modelArr.count) {  //根据传递过来的参数个数来创建载体
        
        int row =i%num;     //第几个(0代表第一个)
        int line =i/num;    //第几行(0代表第一行)
        
        UIView *view = [UIView new];
        
        
        if (line==modelArr.count/num) {    //代表此时就是最后一行了,添加到单独的视图上
            
            view.frame=CGRectMake((margin+agvWidth)*row, 0, agvWidth, agvWidth);
//            view.backgroundColor=[self radomColor];
            [backView addSubview:view];
            
        }else{  //反之则不是最后一行,直接添加到父视图上
        
            CGFloat originX = row*agvWidth+margin*(row+1);
            CGFloat originY = line*agvWidth+margin*(line+1);
            
            view.frame =CGRectMake(originX, originY, agvWidth, agvWidth);
//            view.backgroundColor=[self radomColor];
            
            [self addSubview:view];
        
        }
        
//        [self changeTheBordcolorWithView:view]; //修改边框色
        
        //处理完方位问题，可以在载体上添加需要展示的信息视图了
        //首先处理图片
        [self addImageViewAndTitleLabelOnView:view AndDictionary:(NSDictionary *)modelArr[i]];
        
        i++;    //自增
    }
    
    

    //布局
    backView.sd_layout
    .widthIs(remainder*agvWidth+(remainder-1)*margin)
    .heightIs(agvWidth)
    .topSpaceToView(self,(modelArr.count-1)/num*(agvWidth+margin)+margin)
    .centerXEqualToView(self)
    ;

    [self setupAutoHeightWithBottomView:backView bottomMargin:margin];

}

-(UIColor *)radomColor  //产生随机色
{
    
    CGFloat red =arc4random()%255;
    CGFloat green =arc4random()%255;
    CGFloat blue =arc4random()%255;
    
    UIColor *color =[UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0];
    
    return color;
    
}


-(void)changeTheBordcolorWithView:(UIView *)view    //修改视图边框
{

    view.layer.borderColor=[self radomColor].CGColor;
    view.layer.borderWidth=1;

}

//添加图片视图和标签
-(void)addImageViewAndTitleLabelOnView:(UIView *)view AndDictionary:(NSDictionary *)dict
{

    UIImageView *imageView =[UIImageView new];
    UILabel *titleLabel =[UILabel new];
    
    //修改标签属性
    [titleLabel setTextColor:UnimportantContentTextColorNormal];
    [titleLabel setTextAlignment:1];    //居中
    [titleLabel setFont:[UIFont fontWithName:PingFangSCQ size:12]];
    
//    imageView.backgroundColor=[self radomColor];
//    titleLabel.backgroundColor=[self radomColor];
    
    [view sd_addSubviews:@[imageView,titleLabel]];
    
    CGFloat imgvWid = view.frame.size.width*10/16;
    CGFloat imgvHei = imgvWid;
    
    //布局
    imageView.sd_layout
    .topSpaceToView(view,0)
    .widthIs(imgvWid)
    .heightIs(imgvHei)
    .centerXEqualToView(view)
    ;
    
    titleLabel.sd_layout
    .topSpaceToView(imageView,0)
//    .leftSpaceToView(view,0)
//    .rightSpaceToView(view,0)
    .bottomSpaceToView(view,0)
    .centerXEqualToView(imageView)
    ;
    [titleLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    //此处开始填充视图
//    NSLog(@"dict:%@",dict);
    NSString *deviceName =[dict objectForKey:@"deviceName"];
    if ([dict objectForKey:@"devicePicture"]) {
        
        NSString *imageStr = [MainUrl stringByAppendingString:[dict objectForKey:@"devicePicture"]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    }
    
    [titleLabel setText:deviceName];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
