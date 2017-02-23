//
//  OrdersCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/5.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

//背景图片的宽和高
#define ImageViewWidth (Width-10*3)/2
#define ImageViewheight ImageViewWidth*9/16

//#import "OrderSourceModel.h"    //订单模型

#import "OrdersCell.h"

#import "UIImageView+ProgressView.h"    //带进度圈的图片加载库

@implementation OrdersCell

{

    UIImageView *backImgv;  //承载图片
    
    UILabel *theme;         //标题
    
    UILabel *belongHotel;   //所属酒店
    
    UILabel *intakeDate;    //入住时间
    
    UILabel *intakeOrNot;   //是否入住
    
    UILabel *totalDays;     //总天数
    
    UILabel *totalPrice;    //总价
    
    

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setup    //加载基本界面
{

    UIView *view = self.contentView;
    
    //背景图
    backImgv = [UIImageView new];
    
    //标题
    theme = [UILabel new];
    theme.textColor=MainThemeColor;
    
    theme.font=[UIFont fontWithName:PingFangSCX size:18];
    
    //所属酒店
    belongHotel = [UILabel new];
    belongHotel.font=[UIFont fontWithName:PingFangSCX size:14];
    belongHotel.textColor=ContentTextColorNormal;
    
    //入住时间
    intakeDate = [UILabel new];
    intakeDate.textColor=TitleTextColorNormal;
    intakeDate.font=[UIFont fontWithName:PingFangSCX size:16];
    
    //是否入住
    intakeOrNot = [UILabel new];
    intakeOrNot.textColor=MainThemeColor;
    intakeOrNot.font=[UIFont fontWithName:PingFangSCX size:14];
    intakeOrNot.textAlignment=2;    //右对齐
    
    //分割线
    UILabel *seperatorLine = [UILabel new];
    seperatorLine.backgroundColor=RGBA(240, 240, 240, 1);
    
    //天数
    totalDays = [UILabel new];
    
    //总价
    totalPrice = [UILabel new];
    
    //取消订单按钮
    _cancelOrder = [UIButton new];
    _cancelOrder.titleLabel.font=[UIFont fontWithName:PingFangSCX size:15];
    [_cancelOrder setTitleColor:ContentTextColorNormal forState:UIControlStateNormal];
    _cancelOrder.layer.borderColor=RGBA(200, 200, 200, 1).CGColor;
    _cancelOrder.layer.borderWidth=1;
    _cancelOrder.layer.cornerRadius=5;
    
    
    NSArray *viewArr = @[backImgv,theme,belongHotel,intakeDate,intakeOrNot,seperatorLine,totalDays,totalPrice,_cancelOrder];
    //按顺序一次性全部添加到主视图上
    [view sd_addSubviews:viewArr];
    
    
    //开始布局
    backImgv.sd_layout
    .widthIs(ImageViewWidth)
    .heightIs(ImageViewheight)
    .leftSpaceToView(view,10)
    .topSpaceToView(view,15)
    ;
    
    CGFloat themeWidth = ImageViewWidth;
    CGFloat themeHeight = (ImageViewheight-5)/2;
    
    theme.sd_layout
    .widthIs(themeWidth)
    .heightIs(themeHeight)
    .topEqualToView(backImgv)
    .leftSpaceToView(backImgv,10)
    ;
    
    belongHotel.sd_layout
    .widthIs(themeWidth)
    .heightIs(themeHeight)
    .topSpaceToView(theme,5)
    .leftEqualToView(theme)
    ;
    
    intakeDate.sd_layout
    .widthIs((Width-30)*2/3)
    .topSpaceToView(backImgv,15)
    .leftEqualToView(backImgv)
    .autoHeightRatio(0)
    ;
    
    intakeOrNot.sd_layout
    .widthIs((Width-30)/3)
    .rightSpaceToView(view,10)
    .centerYEqualToView(intakeDate)
    .autoHeightRatio(0)
    ;
    
    
    seperatorLine.sd_layout
    .heightIs(1)
    .topSpaceToView(intakeDate,10)
    .leftSpaceToView(view,0)
    .rightSpaceToView(view,0)
    ;
    
    
}


-(void)setModel:(NSDictionary *)model  //填充视图
{
    
    _model=model;

    NSString *imageStr = [MainUrl stringByAppendingString:[model objectForKey:@"pictureAddress"]];
    
    [backImgv sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(30, 30)];
    
    [theme setText:[model objectForKey:@"roomType"]];
    
    [belongHotel setText:[model objectForKey:@"hotelName"]];
    
    [intakeDate setText:[NSString stringWithFormat:@"入住时间 : %@",[model objectForKey:@"stayTimes"]]];
    
    
    //以','为分割点，将分割出的对象放入数组
    NSArray *array = [[model objectForKey:@"stayTimes"] componentsSeparatedByString:@","];
    
    [self processTheRichtext:totalDays AndHead:@"共" Andbody:[NSString stringWithFormat:@"%ld",array.count] AndFoot:@"晚"];
    
    [self processTheRichtext:totalPrice AndHead:@"总价 : ¥" Andbody:[model objectForKey:@"totalCost"] AndFoot:@""];
    
    //清空之前的布局并重新布局
    [totalDays sd_clearViewFrameCache];
    [totalPrice sd_clearViewFrameCache];
    [_cancelOrder sd_clearViewFrameCache];
    
    totalDays.sd_layout
    .topSpaceToView(intakeDate,21)
    .leftEqualToView(backImgv)
    .autoHeightRatio(0)
    ;
    [totalDays setSingleLineAutoResizeWithMaxWidth:Width/3];    //单行文本自适应宽度
    
    
    totalPrice.sd_layout
    .topEqualToView(totalDays)
    .leftSpaceToView(totalDays,10)
    .autoHeightRatio(0)
    ;
    [totalPrice setSingleLineAutoResizeWithMaxWidth:Width/3];    //单行文本自适应宽度
    
    _cancelOrder.sd_layout
    .widthIs(80)
    .heightIs(30)
    .rightSpaceToView(self.contentView,10)
    .centerYEqualToView(totalPrice)
    ;
    
    //保存单号,用于取消订单用
    _cancelOrder.tag = [[model objectForKey:@"orderId"]integerValue];
    
    [_cancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
    
    [_cancelOrder setEnabled:NO];
    [_cancelOrder setHidden:YES];
    
    [self setupAutoHeightWithBottomView:totalPrice bottomMargin:10];    //此处必须使用self，其他会计算失败
    
    
    NSString *orderStatus;
    int a = [[model objectForKey:@"orderStatus"]intValue];
    int b = 10;
    if ([model objectForKey:@"payPlan"]) {  //如果有这个字段说明是线上付款
        
        b = [[model objectForKey:@"payPlan"]intValue];
        
    }
    
    switch (a) {
        case 0: //用户取消
            
            orderStatus = @"订单已取消";
            
            break;
        case 1: //用户已下单，酒店还未确认
            
            if (b==0) {
                
               orderStatus = @"待付款";
                
            }else if (b==1){
            
                orderStatus = @"已付款待处理";
            
            }
    
            break;
        case 2: //酒店取消
            
            orderStatus = @"酒店已取消";
            
            break;
        case 3: //酒店确认订单
            
            orderStatus = @"待入住";
            
            break;
        case 4: //已入住
            
            orderStatus = @"已入住";
            
            break;
  
            
        default:
            break;
    }

    [intakeOrNot setText:orderStatus];

}

//将传入的内容进行富文本处理后添加到指定的label上
-(void)processTheRichtext:(UILabel *)label AndHead:(NSString *)head Andbody:(NSString *)days AndFoot:(NSString *)foot
{
    //创建头部
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:head];
    //添加属性
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PingFangSCX size:14],NSForegroundColorAttributeName:TitleTextColorNormal} range:NSMakeRange(0, [attributedString length])];
    
    //创建身体
    NSMutableAttributedString *bodyContent =[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@ ",days]];
    //添加属性
    [bodyContent addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PingFangSCX size:15],NSForegroundColorAttributeName:MainThemeColor} range:NSMakeRange(0, [bodyContent length])];
    
    //创建尾部
    NSMutableAttributedString *footContent =[[NSMutableAttributedString alloc]initWithString:foot];
    //添加属性
    [footContent addAttributes:@{NSFontAttributeName:[UIFont fontWithName:PingFangSCX size:14],NSForegroundColorAttributeName:TitleTextColorNormal} range:NSMakeRange(0, [footContent length])];
    
    //拼接尾部
    [bodyContent appendAttributedString:footContent];
    
    //拼接身体
    [attributedString appendAttributedString:bodyContent];
    
    //设置富文本内容到指定的label上
    [label setAttributedText:attributedString];
    
    // 标注lable的text为attributedString(必须要加上)
    label.isAttributedContent = YES;

}






@end
