//
//  HotelsLocationVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///周边酒店展示页


#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import <UIKit/UIKit.h>

@interface HotelsLocationVC : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,UIGestureRecognizerDelegate>
{

    BMKMapView *mapView;    //地图
    
    BMKLocationService *locService; //定位
    
    BMKUserLocation *currentUserLocation;   //当前用户方位信息
    
    UIView *hotelDetailView;
    
    UIImageView *hotelImg;      //酒店图标
    UILabel *hotelTitle;        //酒店标题
    UIImageView *hotelScroeView;//评分图标
    UILabel *hotelScroe;        //评分数
    UILabel *price;             //标价
    UILabel *rise;              //"起"
    UILabel *distance;          //距离
    int i;
    
}
@end
