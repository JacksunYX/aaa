//
//  HotelReservationVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/17.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///酒店预订首页




@class ImageTextButton; //带图片的按钮库
@class LTPickerView;    //一级选择库(暂用于城市选择)


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HotelReservationVC : UIViewController<CLLocationManagerDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{

    NSString *currentCity;  //当前所选城市
    
    NSString *currentCityCode;  //当前城市的code
    
    NSMutableArray *hotelClassifyArr;   //保存当前需要展示的酒店房间类型分类的数组
    
    NSMutableArray *cityArr;      //用来保存从后台获取的所有城市的数组
    
    LTPickerView *cityPicker;  //城市选择器
    
    DGActivityIndicatorView *activityIndicatorView; //加载指示器
    
    BOOL firstRefresh;  //是否是第一次刷新列表
    
    UIButton *refreshBtn;   //用于刷新城市列表及主题列表
    
    UILabel *noticeLabel;   //提示当前所在城市没有合作酒店
    
    AppDelegate *app;

}

@property (nonatomic,strong) ImageTextButton *leftItemBtn;  //导航栏左边按钮

@property (nonatomic,strong) ImageTextButton *rightItemBtn; //导航栏右边按钮

@property(strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic,strong) UIScrollView *scrollView;  //用来展示的滚动视图

@property (nonatomic,strong) UITableView *mytableView;  //用来展示分类列表的表视图




@end
