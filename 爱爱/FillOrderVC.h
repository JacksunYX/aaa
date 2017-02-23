//
//  OrderDetailVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/26.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///填写订单页面


@class ThemeRoomModel;
@class HotelModel;

@class CalendarHomeViewController;
#import "WKTextFieldFormatter.h"    //文本输入框字符过滤库

#import <UIKit/UIKit.h>

@interface FillOrderVC : UIViewController<WKTextFieldFormatterDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

{

    CalendarHomeViewController *chvc;   //日期选择实例对象
    NSString *dateString;
    NSInteger daysNum;
    
    
    UITextField *phoneNum;      //手机号输入框
    UITextField *contactName;   //联系人输入框
    
    
    
    UIScrollView *myscrollView; //滚动视图
    
    //房间相关信息展示
    UILabel *hotelName;         //酒店名
    UIImageView *backImgView;   //配图
    UILabel *roomName;          //房间主题名
    UILabel *detail;            //描述文字
    UILabel *price;             //价格
    
    UILabel *selectedDate;      //展示当前已经选择的日期
    UILabel *totalDays;         //展示当前选择的天数

    UIButton *totalPriceBtn;    //总价按钮
    
    DGActivityIndicatorView *activityIndicatorView; //加载指示器
    
    NSMutableArray *datePriceArr;   //保存时间、房间库存和价格的数组
    
    NSString *totalDateString;  //拼接好的完整的时间字符串
    NSString *totalPriceString; //拼接好的完整的价格字符串
    
    BOOL havealiPay;    //用来判断是否用支付宝已经付款了
    
}

@property (nonatomic,strong) UITableView *mytableView;  //表视图

@property (strong, nonatomic) WKTextFieldFormatter *formatter;  //输入限制实例对象

@property (nonatomic,strong) ThemeRoomModel *roomModel; //房间模型

@property (nonatomic,strong) HotelModel *hotelModel;    //酒店模型

@property (nonatomic,strong) NSDictionary *orderDict;   //保存当前同步后保存的订单数据


@end
