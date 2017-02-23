//
//  TableViewCell7.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/19.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//


#import "TableViewCell7.h"
#import "DetailNewsViewController.h"

#import "UIImageView+CornerRadius.h"    //图片处理圆角库



//#import "UIImageView+WebCache.h"//图片处理库

#import "UIImageView+ProgressView.h"    //带进度圈的图片加载




@implementation TableViewCell7



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//重写初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        [self creatLeftBtn];
        [self creatRightBtn];
        
        self.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
        
    }
    return self;
    
}

-(void)creatLeftBtn//创建左边视图
{
    
    CGRect frame =CGRectMake(0, 0, Width, 0);
    
    CGFloat imgwidth = (Width-30)/2;
    
    
    //左边
    //背景框
    _backViewL=[[UIView alloc]initWithFrame:CGRectMake(10, 0, imgwidth, 0)];

    
    //图片
    _imvL=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgwidth, imgwidth/3*2)];//宽高比例3:2
    _imvL.userInteractionEnabled=YES;//开启用户交互
    [_backViewL addSubview:_imvL];
    [_imvL zy_cornerRadiusAdvance:3.0f rectCornerType:UIRectCornerAllCorners];  //处理圆角
    
    //左上角背景
    UIView *backL=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    backL.backgroundColor=[UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:0.2];
    [self processAssignedAngleWith:backL AndCornerRadius:3.0f];
    backL.userInteractionEnabled=NO;
    //离线模式下隐藏
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
        
        [backL setHidden:YES];
        
    }
    [_imvL addSubview:backL];
    
    //眼睛
    _eyeL=[[UIImageView alloc]initWithFrame:CGRectMake(2, backL.frame.size.height/2-5, 15, 10)];
    [_eyeL setImage:[UIImage imageNamed:@"eye_icon"]];
    [backL addSubview:_eyeL];
    
    //点击量
    _clickL=[[UILabel alloc]initWithFrame:CGRectMake(_eyeL.frame.origin.x+_eyeL.frame.size.width+2, 0, backL.frame.size.width-(_eyeL.frame.origin.x+_eyeL.frame.size.width+2), 20)];
    _clickL.textAlignment=1;
    _clickL.font=[UIFont systemFontOfSize:10];
    _clickL.textColor=[UIColor whiteColor];
    [backL addSubview:_clickL];
    
    //标题
    _titleL=[[UILabel alloc]initWithFrame:CGRectMake(0, _imvL.frame.size.height, imgwidth, 50)];
    _titleL.textAlignment=1;//居中
    _titleL.font=[UIFont systemFontOfSize:14];//字体大小
    _titleL.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), TitleTextColorNight);
    _titleL.numberOfLines=0;//自动换行
    [_backViewL addSubview:_titleL];

    frame.size.height=_titleL.frame.origin.y+_titleL.frame.size.height;
    
    _backViewL.frame=CGRectMake(10, 0, imgwidth, frame.size.height);
    
//    frame.size.height=frame.size.height+10;
//    
//    self.frame=frame;
    
//    _backViewL.layer.masksToBounds=YES;
    
    //调整显示

//    _backViewL.layer.cornerRadius=3;
    
//    _backViewL.layer.borderColor=[[UIColor grayColor]CGColor];
//    _backViewL.layer.borderWidth=0.1;
//    _backViewL.clipsToBounds = NO;
    
//    _backViewL.layer.shadowColor = [UIColor grayColor].CGColor;
//    _backViewL.layer.shadowOpacity = 0.5;
//    _backViewL.layer.shadowRadius = 5.0;
//    _backViewL.layer.shadowOffset = CGSizeMake(0, 1);
    _backViewL.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    [self.contentView addSubview:_backViewL];

    
}


-(void)creatRightBtn//创建右边视图
{

    CGRect frame =CGRectMake(0, 0, Width, 0);
    
    CGFloat imgwidth = (Width-30)/2;
    
    //右边
    //背景框
    _backViewR=[[UIView alloc]initWithFrame:CGRectMake(_backViewL.frame.origin.x+_backViewL.frame.size.width+10, 0, imgwidth, 0)];
    
    //图片
    _imvR=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgwidth, imgwidth/3*2)];//宽高比例3:2
    _imvR.userInteractionEnabled=YES;//开启用户交互
    [_backViewR addSubview:_imvR];
    [_imvR zy_cornerRadiusAdvance:3.0f rectCornerType:UIRectCornerAllCorners];
    
    //左上角背景
    UIView *backR=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    backR.backgroundColor=[UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:0.2];
    [self processAssignedAngleWith:backR AndCornerRadius:3.0f];
    
    backR.userInteractionEnabled=NO;
    
    //离线模式下隐藏
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
        
        [backR setHidden:YES];
        
    }
    
    [_backViewR addSubview:backR];
    
    //眼睛
    _eyeR=[[UIImageView alloc]initWithFrame:CGRectMake(2, backR.frame.size.height/2-5, 15, 10)];
    [_eyeR setImage:[UIImage imageNamed:@"eye_icon"]];
    [backR addSubview:_eyeR];
    
    //点击量
    _clickR=[[UILabel alloc]initWithFrame:CGRectMake(_eyeR.frame.origin.x+_eyeR.frame.size.width+2, 0, backR.frame.size.width-(_eyeR.frame.origin.x+_eyeR.frame.size.width+2), 20)];
    _clickR.textAlignment=1;
    _clickR.font=[UIFont systemFontOfSize:10];
    _clickR.textColor=[UIColor whiteColor];
    [backR addSubview:_clickR];
    
    //标题
    _titleR=[[UILabel alloc]initWithFrame:CGRectMake(0,imgwidth*2/3, imgwidth, 50)];
    _titleR.textAlignment=1;//居中
    _titleR.font=[UIFont systemFontOfSize:14];//字体大小
    _titleR.numberOfLines=0;//自动换行
    _titleR.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), TitleTextColorNight);
    [_backViewR addSubview:_titleR];
    
    frame.size.height=_titleR.frame.origin.y+_titleR.frame.size.height;
    
    _backViewR.frame=CGRectMake(_backViewR.frame.origin.x, _backViewR.frame.origin.y, imgwidth, frame.size.height);

    [self.contentView addSubview:_backViewR];
    
//    _backViewR.layer.masksToBounds=YES;

    
    //调整显示
//    _backViewR.layer.cornerRadius=3;
    
//    _backViewR.layer.borderColor=[[UIColor grayColor]CGColor];
//    _backViewR.layer.borderWidth=0.1;
//    _backViewR.clipsToBounds = NO;
    
//    _backViewR.layer.shadowColor = [UIColor grayColor].CGColor;
//    _backViewR.layer.shadowOpacity = 0.5;
//    _backViewR.layer.shadowRadius = 5.0;
//    _backViewR.layer.shadowOffset = CGSizeMake(0, 1);
    _backViewR.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
}

//处理传过来的数组
-(void)setViewWithNewsArr:(NSArray *)newsArr
{

    _newsModelL =newsArr[0];
    _newsModelR =newsArr[1];
    
    NSString *imgurL;
    NSString *imgurR;
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
        
        //离线模式下
        [self.imvL setImage:_newsModelL.titleImg];
        [self.imvR setImage:_newsModelR.titleImg];
        
    }else{  //有网状态
    
        if (_newsModelL.imageSrc) {
            imgurL =[MainUrl stringByAppendingString:_newsModelL.imageSrc];
        }
        if (_newsModelR.imageSrc) {
            imgurR =[MainUrl stringByAppendingString:_newsModelR.imageSrc];
        }
        
        //左边
        [self.imvL sd_setImageWithURL:[NSURL URLWithString:imgurL] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(40, 40)];
        
        if ([_newsModelL.views intValue]/10000>0) {
            
            self.clickL.text=[NSString stringWithFormat:@"%.1f万",[_newsModelL.views intValue]/10000.0];
            
        }else{
            
            self.clickL.text=[NSString stringWithFormat:@"%d",[_newsModelL.views intValue]];
            
        }
        
        //右边
        [self.imvR sd_setImageWithURL:[NSURL URLWithString:imgurR] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(40, 40)];
        
        if ([_newsModelR.views intValue]/10000>0) {
            
            self.clickR.text=[NSString stringWithFormat:@"%.1f万",[_newsModelR.views intValue]/10000.0];
            
        }else{
            
            self.clickR.text=[NSString stringWithFormat:@"%d",[_newsModelR.views intValue]];
            
        }
    
    }
    
    
    self.titleL.text=_newsModelL.title;
    
    self.titleR.text=_newsModelR.title;


    _backViewL.tag=[_newsModelL.newsId integerValue];
    _backViewR.tag=[_newsModelR.newsId integerValue];

}

//处理view的指定方位切圆角
-(void)processAssignedAngleWith:(UIView *)view AndCornerRadius:(CGFloat)cornerRadius
{
    //当前切的左上和右下
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];

    CAShapeLayer *maskLayer = [CAShapeLayer new];
    
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}






@end
