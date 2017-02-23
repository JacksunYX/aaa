//
//  RoomDetailVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///房间详情页面

@class ThemeRoomModel;
@class RoomHeaderView;
@class HotelModel;

#import <UIKit/UIKit.h>

@interface RoomDetailVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>

{

    UIButton *backBtn; //返回按钮
    
    DGActivityIndicatorView *activityIndicatorView; //加载指示器
    
    BOOL loadRecommandViewOrNot;    //是否已经给推荐栏添加了点击事件
    
    BOOL loadRomanticViewOrNot;     //是否已经给浪漫服务视图添加了点击事件
    
    NSArray *devicesArr;        //存放设施数据的数组
    
    UIButton *refreshBtn;       //用于网络不好时的刷新按钮
}

@property (nonatomic,strong) UITableView *mytableView;  //表视图

@property (nonatomic,strong) ThemeRoomModel *roomModel; //房间模型

@property (nonatomic,strong) RoomHeaderView *HeaderView;    //表头模糊视图

@property (nonatomic,strong) HotelModel *hotelModel;        //酒店模型

@property (nonatomic,strong) NSMutableDictionary *hotelDic;  //酒店相关信息的字典


@end
