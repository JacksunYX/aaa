//
//  FillRoomOrderCell.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/28.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

//配图的宽和高
#define ImgViewWidth  (Width -10*3)/2
#define ImgViewHeight ImgViewWidth*3/4

//平均高度
#define averageHeight ((ImgViewHeight-5*2)/3)


#define HotelNameHeight 20
//图片视图的高度
#define HotelViewBackViewHeight (((Width -10*3)/2)*3/4+30+HotelNameHeight)

#import "FillRoomOrderCell.h"

@implementation FillRoomOrderCell

{

    //房间相关信息展示
    UILabel *hotelName;         //酒店名
    UIImageView *backImgView;   //配图
    UILabel *roomName;          //房间主题名
    UILabel *detail;            //描述文字
    UILabel *price;             //价格
    
    UIView *hotelBackView;

    NSString *dateString;   //代表选择的日期
    NSInteger daysNum;      //代表选择的天数
    UILabel *selectedDate;
    UILabel *totalDays;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;

}


//加载基本视图
-(void)setupView
{
    
    //背景
    hotelBackView =[UIView new];
//    hotelBackView.backgroundColor=[UIColor purpleColor];
    
    [self addHotelView];    //滚动视图上添加信息
    
    //选择入住日期
    _selectDateView =[UIView new];
    _selectDateView.backgroundColor=[UIColor lightGrayColor];
    [self addLabelOnSelectView];    //在选择日期上添加控件
    
    
    //联系人
    UIView *contactView =[UIView new];
    contactView.backgroundColor=[UIColor lightGrayColor];
    _contactName =[UITextField new];
    [self addTextFieldWith:_contactName AndPlaceholder:@"用于确认用户信息" AndNotice:@"联系人" ToView:contactView];
    
    //手机号
    UIView *phoneView =[UIView new];
    phoneView.backgroundColor=[UIColor lightGrayColor];
    _fillPhoneNum =[UITextField new];
    [self addTextFieldWith:_fillPhoneNum AndPlaceholder:@"用于接收预订信息" AndNotice:@"手机号" ToView:phoneView];
    
    
    //一次性添加
    NSArray *viewsArr =@[hotelBackView,_selectDateView,contactView,phoneView];
    
    [self.contentView sd_addSubviews:viewsArr];
    
    
    //开始布局
    UIView *contentView = self.contentView;
    
    
    hotelBackView.sd_layout
    .topSpaceToView(contentView,0)
    .leftSpaceToView(contentView,0)
    .rightSpaceToView(contentView,0)
    .heightIs(HotelViewBackViewHeight)
    ;
    
    _selectDateView.sd_layout
    .topSpaceToView(hotelBackView,5)
    .leftSpaceToView(contentView,0)
    .rightSpaceToView(contentView,0)
    .heightIs(50)
    ;
    
    contactView.sd_layout
    .topSpaceToView(_selectDateView,5)
    .leftSpaceToView(contentView,0)
    .rightSpaceToView(contentView,0)
    .heightIs(50)
    ;
    
    phoneView.sd_layout
    .topSpaceToView(contactView,5)
    .leftSpaceToView(contentView,0)
    .rightSpaceToView(contentView,0)
    .heightIs(50)
    ;
    
    
    [self setupAutoHeightWithBottomView:phoneView bottomMargin:5];
    
    

}


-(void)addHotelView //添加上部分酒店相关信息
{

    //酒店名
    hotelName = [UILabel new];
//    hotelName.backgroundColor=[UIColor redColor];
    hotelName.textColor=[UIColor blackColor];
    hotelName.font=[UIFont boldSystemFontOfSize:16];
    
    
    //配图
    backImgView = [UIImageView new];
//    backImgView.backgroundColor=[UIColor orangeColor];
    
    
    //房间主题名
    roomName = [UILabel new];
//    roomName.backgroundColor=[UIColor yellowColor];
    roomName.textColor=MainThemeColor;
    roomName.font=[UIFont boldSystemFontOfSize:18];
    
    
    //描述文字
    detail =[UILabel new];
//    detail.backgroundColor=[UIColor greenColor];
    detail.textColor=RGBA(100, 100, 100, 1);
    detail.numberOfLines=0;
    detail.font=[UIFont systemFontOfSize:12];
    
    
    //价格
    price=[UILabel new];
//    price.backgroundColor=[UIColor blueColor];
    price.textColor=RGBA(50, 50, 50, 1);
    price.font=[UIFont boldSystemFontOfSize:14];
    
    NSArray *arr =@[hotelName,backImgView,roomName,detail,price];
    
    [hotelBackView sd_addSubviews:arr];
    
    //布局
    CGFloat margin = 10;    //间隔
    
    hotelName.sd_layout
    .topSpaceToView(hotelBackView,margin)
    .leftSpaceToView(hotelBackView,margin)
    .rightSpaceToView(hotelBackView,margin)
    .heightIs(HotelNameHeight)
    ;
    
    backImgView.sd_layout
    .topSpaceToView(hotelName,margin)
    .leftSpaceToView(hotelBackView,margin)
    .widthIs(ImgViewWidth)
    .heightIs(ImgViewHeight)
    ;
    
    roomName.sd_layout
    .topEqualToView(backImgView)
    .leftSpaceToView(backImgView,margin)
    .widthIs(ImgViewWidth)
    .heightIs(averageHeight)
    ;
    
    detail.sd_layout
    .topSpaceToView(roomName,5)
    .leftEqualToView(roomName)
    .widthIs(ImgViewWidth)
    .heightIs(averageHeight)
    ;
    
    price.sd_layout
    .topSpaceToView(detail,5)
    .leftEqualToView(roomName)
    .widthIs(ImgViewWidth)
    .heightIs(averageHeight)
    ;
    
    [self addVirtualData];
}

-(void)addLabelOnSelectView //在选择日期上添加控件
{

    //左边的提示文字
    UILabel *notice =[UILabel new];
    notice.textColor=[UIColor blackColor];
    notice.font=[UIFont systemFontOfSize:14];
    [notice setText:[NSString stringWithFormat:@"选择入住日期"]];
    [notice sizeToFit];
    [_selectDateView addSubview:notice];
    
    //中间的label用于显示选择的日期
    if (!selectedDate) {
        selectedDate =[UILabel new];
        [_selectDateView addSubview:selectedDate];
        selectedDate.textColor=[UIColor whiteColor];
        selectedDate.backgroundColor=[UIColor grayColor];
        selectedDate.font=[UIFont boldSystemFontOfSize:12];
    }
    
    if (!dateString) {  //如果为空
        dateString=@"";
    }
    [selectedDate setText:[NSString stringWithFormat:@"您选择了:%@",dateString]];
    
    
    //右边的label用于显示总的预订天数
    if (!totalDays) {
        
        totalDays =[UILabel new];
        [_selectDateView addSubview:totalDays];
        totalDays.textColor=[UIColor redColor];
        totalDays.backgroundColor=[UIColor yellowColor];
        totalDays.font=[UIFont boldSystemFontOfSize:14];
        totalDays.textAlignment=1;
        
    }
    
    [totalDays setText:[NSString stringWithFormat:@"共%ld晚",daysNum]];
    
    
    //开始布局
    notice.sd_layout
    .leftSpaceToView(_selectDateView,10)
    .centerYEqualToView(_selectDateView)
    .widthIs(notice.frame.size.width)
    ;
    
    CGFloat centetTextfieldWidth =(Width-10*4-notice.frame.size.width)*2/3;
    CGFloat rightTextfieldWidth =(Width-10*4-notice.frame.size.width)/3;
    
    selectedDate.sd_layout
    .leftSpaceToView(notice,10)
    .centerYEqualToView(_selectDateView)
    .widthIs(centetTextfieldWidth)
    .heightIs(30)
    ;
    
    totalDays.sd_layout
    .leftSpaceToView(selectedDate,10)
    .centerYEqualToView(_selectDateView)
    .widthIs(rightTextfieldWidth)
    .heightIs(30)
    ;
    

}

//根据传入的数据创建输入框
-(void)addTextFieldWith:(UITextField *)textFild  AndPlaceholder:(NSString *)placeholder AndNotice:(NSString *)noticeString ToView:(UIView *)view
{
    
    //输入框左边的提示文字
    UILabel *notice =[UILabel new];
    notice.textColor=[UIColor blackColor];
    notice.font=[UIFont systemFontOfSize:14];
    [notice setText:[NSString stringWithFormat:@"%@:",noticeString]];
    [notice sizeToFit];
    [view addSubview:notice];
    
    
    //输入框
    textFild.placeholder=placeholder;
    [view addSubview:textFild];
    
    
    //开始布局
    notice.sd_layout
    .leftSpaceToView(view,10)
    .centerYEqualToView(view)
    .widthIs(notice.frame.size.width)
    .heightIs(notice.frame.size.height)
    ;
    
    textFild.sd_layout
    .leftSpaceToView(notice,10)
    .rightSpaceToView(view,10)
    .centerYEqualToView(view)
    .heightIs(30)
    ;
    
}


//添加虚拟数据(测试用)
-(void)addVirtualData
{

    [hotelName setText:@"天鹅恋情侣酒店"];
    [backImgView setImage:[UIImage imageNamed:@"hotelBakImage.png"]];
    [roomName setText:@"迷情盛宴"];
    [detail setText:@"人生两大境界:洞房花烛夜,金榜题名时。今夜,烛光摇曳中..."];
    [price setText:@"¥298"];

}


//重置选择日期的视图
-(void)setDateWithDateString:(NSString *)string Anddays:(NSInteger)days
{

    if (!string) {  //如果为空
        string=@"";
    }
    [selectedDate setText:[NSString stringWithFormat:@"您选择了:%@",string]];

    [totalDays setText:[NSString stringWithFormat:@"共%ld晚",days]];

}

//填充输入框
-(void)setTextFieldWith:(NSString *)string AndtextField:(UITextField *)textfield
{

    [textfield setText:string];

}







@end
