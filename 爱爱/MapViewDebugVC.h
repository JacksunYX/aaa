//
//  MapViewDebugVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/11.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

///定位当前位置,以及选择起点和终点后,根据选择的地图app进行第三方展示

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@interface MapViewDebugVC : UIViewController<CLLocationManagerDelegate>

@property(strong, nonatomic) CLLocationManager *locationManager;

@end
