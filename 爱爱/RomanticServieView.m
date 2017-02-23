//
//  RoomDeviceScrollView.m
//  情趣设施自定义测试
//
//  Created by 薇薇一笑 on 16/3/31.
//  Copyright © 2016年 爱爱网. All rights reserved.
//

#import "RomanticServieView.h"

#import "UIView+SDAutoLayout.h"
#import "UIImageView+ProgressView.h"
#import "UIImageView+CornerRadius.h"

#import "RomanticSingleExample.h"   //引入浪漫服务的单例

@interface RomanticServieView ()



@end


@implementation RomanticServieView


-(instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        _viewsArr = [NSMutableArray new];
        
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
    
    for (UIView *view in self.subviews) {
        
        [view removeFromSuperview]; //先移除所有子视图
        
    }
    
    [_viewsArr removeAllObjects];   //先清空所有数据
    
    //假定每行最多展示的个数,多余的换行,每个间距为自己给的定值
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin = 0;
    NSInteger num = 3;  //每行最多个数
    
    //平均宽度
    CGFloat agvWidth = (width-margin*(num+1))/num;
    
    int i=0;
    
    int remainder;
    
    //取出最后一排的视图个数
    if (modelArr.count>num) {
        
       remainder = (int)(modelArr.count)%num;
        
    }else{
    
        remainder = (int)modelArr.count;
    
    }
    
    
    
    //    创建背景板(一定要注意方位)
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, (modelArr.count-1)/num*(agvWidth+margin)+margin, remainder*agvWidth+(remainder-1)*margin, agvWidth)];
//    backView.backgroundColor=[UIColor greenColor];
    [self addSubview:backView];
    
    while (i<modelArr.count) {  //根据传递过来的参数个数来创建载体
        
        int row =i%num;     //第几个(0代表第一个)
        int line =i/num;    //第几行(0代表第一行)
        
        UIView *view = [UIView new];
        
        
        if (line == (modelArr.count-1)/num) {    //代表此时就是最后一行了,添加到单独的视图上
            
            view.frame=CGRectMake((margin+agvWidth)*row, 0, agvWidth, agvWidth);
            
//            view.backgroundColor=[self radomColor];
            [backView addSubview:view];
            
//            NSLog(@"X:%f",view.frame.origin.x);
            
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
        
        [_viewsArr addObject:view];
        
        i++;    //自增
    }
    
    
    //布局
    backView.sd_layout
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

    UIImageView *imageView = [UIImageView new];
    UILabel *titleLabel = [UILabel new];
    UILabel *priceLabel = [UILabel new];
    
    //修改标签属性
    [titleLabel setTextColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0]];
    [titleLabel setTextAlignment:1];    //居中
    [titleLabel setFont:[UIFont fontWithName:PingFangSCQ size:12]];

    [priceLabel setTextColor:[UIColor colorWithRed:230.f/255.0f green:23.0f/255.0f blue:115.0f/255.0f alpha:1.0]];
    [priceLabel setTextAlignment:1];    //居中
    [priceLabel setFont:[UIFont fontWithName:PingFangSCQ size:12]];
    
    
    imageView.layer.borderColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0].CGColor;
    [imageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];
    imageView.userInteractionEnabled = YES; //开启用户交互
    
    
//    imageView.backgroundColor=[self radomColor];
//    titleLabel.backgroundColor=[self radomColor];
//    priceLabel.backgroundColor=[self radomColor];
    
    
    
    [view sd_addSubviews:@[imageView,titleLabel,priceLabel]];
    
    CGFloat imgvWid = view.frame.size.width*10/16;
    CGFloat imgvHei = imgvWid;
    
    CGFloat textlabelHei = (view.frame.size.height - imgvHei)/2;
    
    
    
    //布局
    imageView.sd_layout
    .topSpaceToView(view,0)
    .widthIs(imgvWid)
    .heightIs(imgvHei)
    .centerXEqualToView(view)
    ;
    
    titleLabel.sd_layout
    .topSpaceToView(imageView,0)
    .heightIs(textlabelHei)
    .widthIs(view.frame.size.width)
    .centerXEqualToView(view)
    ;

    
    priceLabel.sd_layout
    .topSpaceToView(titleLabel,0)
    .heightIs(textlabelHei)
    .widthIs(view.frame.size.width)
    .centerXEqualToView(view)
    ;
    
    //此处开始填充视图
//    NSLog(@"dict:%@",dict);
    NSString *serviceName  = [dict objectForKey:@"romanticName"];
    NSString *servicePrice = [dict objectForKey:@"romanticPrice"];
    
    if ([dict objectForKey:@"romanticPicture"]) {
        
        NSString *imageStr = [MainUrl stringByAppendingString:[dict objectForKey:@"romanticPicture"]];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    }
    
    [titleLabel setText:serviceName];
    [priceLabel setText:[NSString stringWithFormat:@"¥ %@",servicePrice]];
    
    view.tag = [[dict objectForKey:@"serviceId"]integerValue];
    
    //在图片右下角添加一个被选择的标记
    UIImageView *isSelected = [UIImageView new];
    [imageView sd_addSubviews:@[isSelected]];
    
    
    isSelected.sd_layout
    .widthIs(24)
    .heightIs(24)
    .rightSpaceToView(imageView,0)
    .bottomSpaceToView(imageView,0)
    ;
    
    [isSelected setHidden:YES];
    
    [isSelected setImage:[UIImage imageNamed:@"ok_tick_icon"]];
    
    RomanticSingleExample *single = [RomanticSingleExample shareExample];
    for (NSDictionary *dic in single.serviceArr) {
        
        if ((int)[dic objectForKey:@"romanticId"]==(int)[dict objectForKey:@"romanticId"]) {
            
            [isSelected setHidden:NO];
            
            break;
            
        }
        
    }
     
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
