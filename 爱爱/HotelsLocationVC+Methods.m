//
//  HotelsLocationVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define DownViewHeight 100   //下方酒店展示视图的高度
#define HotelImageHeight (DownViewHeight-10*2) //酒店图片宽度(宽高比1:3)



#import "HotelsLocationVC+Methods.h"

#import "UIImageView+ProgressView.h"

#import "UIViewController+JTNavigationExtension.h"  //导航栏库



@implementation HotelsLocationVC (Methods)


#pragma mark ----- 视图创建方法
-(void)creatView   //加载基本视图
{
    
    [self setJt_fullScreenPopGestureEnabled:NO]; //关闭当前控制器的手势侧滑

    [self updataNavigation];    //修改导航栏显示
    
    [self loadBaiduMap];    //创建百度地图视图
    
    [self locationService]; //定位

}


-(void)updataNavigation //修改导航栏显示
{
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(touchtoPop)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //处理左按钮靠右的情况(当前设备的版本>=ios7.0)
    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
        
    {
        
        UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemFixedSpace
                                           
                                                                                          target : nil action : nil ];
        
        negativeSpacer. width = - 20 ;//这个数值可以根据情况自由变化
        
        self.navigationItem.leftBarButtonItems = @[ negativeSpacer, leftItem ] ;
        
    }else{//低于7.0版本不需要考虑
        
        self.navigationItem.leftBarButtonItem= leftItem;
        
    }
    
    //修改标题字体大小和颜色
    self.title=@"周边酒店信息";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:18],
           NSForegroundColorAttributeName:RGBA(50, 50, 50, 1)}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:18],
           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    //关闭侧边栏侧滑
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"我的位置" style:UIBarButtonItemStylePlain target:self action:@selector(myLocation)];
    
}

-(void)creatDownViewWithHotelData:(BMKAnnotationView *)view    //根据点击的酒店创建下方展示信息,可点击然后跳转到酒店详情页
{
    
    if (!hotelDetailView) {
        hotelDetailView = [[UIView alloc]initWithFrame:CGRectMake(0, Height, Width, DownViewHeight)];
        hotelDetailView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
        [self.view addSubview:hotelDetailView];
        
        //酒店图片
        hotelImg =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, HotelImageHeight, HotelImageHeight)];
        hotelImg.layer.cornerRadius=5.0f;
        hotelImg.layer.masksToBounds=YES;   //开启圆角
        [hotelDetailView addSubview:hotelImg];
        
        //标题
        hotelTitle = [[UILabel alloc]init];
        hotelTitle.font=[UIFont systemFontOfSize:16];
        hotelTitle.dk_textColorPicker=DKColorWithColors(RGBA(50, 50, 50, 1), TitleTextColorNight);
        [hotelDetailView addSubview:hotelTitle];
        
        //评分图标
        hotelScroeView =[[UIImageView alloc]init];
        [hotelDetailView addSubview:hotelScroeView];
        
        //评分数
        hotelScroe = [[UILabel alloc]init];
        hotelScroe.font=[UIFont systemFontOfSize:10];
        hotelScroe.dk_textColorPicker=DKColorWithColors(RGBA(150, 150, 150, 1), UnimportantContentTextColorNight);
        [hotelDetailView addSubview:hotelScroe];
        
        //标价
        price = [[UILabel alloc]init];
        price.dk_textColorPicker=DKColorWithColors(MainThemeColor, TitleTextColorNight);
        [price setFont:[UIFont systemFontOfSize:18]];
        [hotelDetailView addSubview:price];
        
        //“起”
        rise =[[UILabel alloc]init];
        rise.dk_textColorPicker=DKColorWithColors(MainThemeColor, ContentTextColorNight);
        [rise setFont:[UIFont systemFontOfSize:12]];
        [rise setText:@"起"];
        [rise sizeToFit];
        [hotelDetailView addSubview:rise];
        
        
        //距离当前位置
        distance = [[UILabel alloc]init];
        distance.dk_textColorPicker = DKColorWithColors(RGBA(100, 100, 100, 1), UnimportantContentTextColorNight);
        [distance setFont:[UIFont systemFontOfSize:12]];
        [hotelDetailView addSubview:distance];
        
    }
    
    //修改酒店图片
    [hotelImg sd_setImageWithURL:[NSURL URLWithString:@"http://www.sucaitianxia.com/sheji/pic/200708/20070811225328187.jpg"] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(20, 20)];
    
    //修改标题内容
    [hotelTitle setText:view.annotation.title];
    [hotelTitle sizeToFit];
    hotelTitle.frame=CGRectMake(hotelImg.frame.origin.x+hotelImg.frame.size.width+10, hotelImg.frame.origin.y, hotelTitle.frame.size.width, hotelTitle.frame.size.height);
    
    //评分
    [hotelScroe setText:@"暂无评分"];
    [hotelScroe sizeToFit];
    hotelScroe.frame=CGRectMake(hotelTitle.frame.origin.x, hotelTitle.frame.origin.y+hotelTitle.frame.size.height+5, hotelScroe.frame.size.width, hotelScroe.frame.size.height);
    
    //标价
    [price setText:[NSString stringWithFormat:@"￥%@",view.annotation.subtitle]];
    [price sizeToFit];
    price.frame=CGRectMake(hotelTitle.frame.origin.x, hotelScroe.frame.origin.y+hotelScroe.frame.size.height+5, price.frame.size.width, price.frame.size.height);
    
    rise.frame=CGRectMake(price.frame.origin.x+price.frame.size.width+2, price.frame.origin.y+price.frame.size.height-rise.frame.size.height-2, rise.frame.size.width, rise.frame.size.height);
    
    //位置
    [distance setText:[NSString stringWithFormat:@"距离目的地%@m",view.annotation.subtitle]];
    [distance sizeToFit];
    distance.frame=CGRectMake(hotelTitle.frame.origin.x, hotelImg.frame.origin.y+hotelImg.frame.size.height-distance.frame.size.height, distance.frame.size.width, distance.frame.size.height);
    
    if (hotelDetailView.frame.origin.y==Height) {   //再屏幕外的话
        
        [UIView animateWithDuration:0.3 animations:^{   //需要做动画处理的操作
            
            hotelDetailView.frame=CGRectMake(0, Height-DownViewHeight, Width, DownViewHeight);
            
        } completion:^(BOOL finished) { //完成后处理方法
            
            NSLog(@"酒店信息出现了");
            
        }];
        
    }
    
}


#pragma mark ----- 交互方法

-(void)loadBaiduMap //加载百度地图
{
    
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, Width, Height-NavigationBarHeight)];
    //    mapView.mapType = BMKMapTypeNone;//设置地图为空白类型
    //切换为卫星图
//    [mapView setMapType:BMKMapTypeSatellite];
    //切换为普通地图
    [mapView setMapType:BMKMapTypeStandard];
    
    //打开实时路况图层
    //    [mapView setTrafficEnabled:YES];
    
    //打开百度城市热力图图层（百度自有数据）
    //    [mapView setBaiduHeatMapEnabled:YES];
    
    // 表示距离屏幕上、左、下、右边距离，单位为屏幕坐标下的像素密度
    mapView.mapPadding = UIEdgeInsetsMake(0, 5, 5, 0);
    //是否显示比例尺
    //    mapView.showMapScaleBar=YES;
    //    self.view = mapView;
    
    //设置隐藏地图标注
    //    [mapView setShowMapPoi:NO];
    
    mapView.zoomLevel = 16; //默认加载地图的比例尺级别(数字越大代表显示的越精细)
    
    [self.view addSubview:mapView];
    
    //设置地图显示范围
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.924257, 116.403263);
//    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.038325, 0.028045);
//    mapView.limitMapRegion = BMKCoordinateRegionMake(center, span);////限制地图显示范围
//    mapView.rotateEnabled = NO;//禁用旋转手势
    
}

-(void)locationService //定位
{
    
    //初始化BMKLocationService
    locService = [[BMKLocationService alloc]init];
    locService.delegate=self;
    
    locService.distanceFilter=10.0f;
    //启动LocationService
    [locService startUserLocationService];
    
    mapView.showsUserLocation = NO;//先关闭显示的定位图层
    mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    mapView.showsUserLocation = YES;//显示定位图层
    
}



#pragma mark ----- 辅助方法

-(void)touchtoPop   //返回上一页
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)myLocation   //回到当前位置
{
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(currentUserLocation.location.coordinate.latitude, currentUserLocation.location.coordinate.longitude);
//    BMKCoordinateSpan span = BMKCoordinateSpanMake(1.0, 1.0);
//    mapView.limitMapRegion = BMKCoordinateRegionMake(center, span);////限制地图显示范围
    mapView.rotateEnabled = YES;//旋转手势
    mapView.centerCoordinate = center ;
    
}

//根据上个页面传入的酒店数据创建标注数组,并进行标注
-(void)creatAnnotationWithHotelModel
{
    NSMutableArray *annotatsArr =[NSMutableArray new];
    //产生随机的方位(相距不会太远)
    
    for (int j=0; j<5; j++) {
        
        CLLocationCoordinate2D destinationCoor;
        
        //获取整数部分
        NSInteger first = (NSInteger)currentUserLocation.location.coordinate.latitude;
        NSInteger next  = (NSInteger)currentUserLocation.location.coordinate.longitude;
        
        //获取小数部分
        double point1 = currentUserLocation.location.coordinate.latitude-first;
        double point2 = currentUserLocation.location.coordinate.longitude-next;
        
        //        NSLog(@"first:%ld\nnext:%ld",first,next);
        //        NSLog(@"point1:%lf\npoint2:%lf",point1,point2);
        
        //获取浮点前两位
        double firstTwo1 = (double)((NSInteger)(point1*100))/100;
        double firstTwo2 = (double)((NSInteger)(point2*100))/100;
        
        //分解(获取后几位浮点数便于后面加法计算)
        double lastFour1 = (double)(arc4random()%10000)/1000000;
        double lastFour2 = (double)(arc4random()%10000)/1000000;
        
        destinationCoor.latitude = first+firstTwo1+lastFour1;
        destinationCoor.longitude = next+firstTwo2+lastFour2;
        
        //        NSLog(@"latitude:%.4f-----longitude:%.4f",destinationCoor.latitude,destinationCoor.longitude);
        
        //创建标记
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = destinationCoor;
        annotation.title = [NSString stringWithFormat:@"店名test%d",i];
        annotation.subtitle=[NSString stringWithFormat:@"%d",arc4random()%600];
        
        [annotatsArr addObject:annotation]; //添加进数组
        
    }
    
    [mapView addAnnotations:annotatsArr];
    
}


#pragma mark ----- 开启/关闭手势侧滑
-(void)closeTheGesture  //关闭
{

    AppDelegate *app =[UIApplication sharedApplication].delegate;
    JTNavigationController *jnc = [app hotelViewController];
    
//    jnc.fullScreenPopGestureEnabled=NO;
    UIViewController *vc =jnc.jt_viewControllers[0];
    vc.jt_fullScreenPopGestureEnabled=NO;

}

-(void)openTheGesture   //开启
{

    AppDelegate *app =[UIApplication sharedApplication].delegate;
    JTNavigationController *jnc = [app hotelViewController];
    
    jnc.fullScreenPopGestureEnabled=YES;

}


///代理方法区

#pragma mark ----- BMKMapViewDelegate (标注的代理方法)
//填充视图
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"]; //重用
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
    
}

//地图位置发生改变时就会被调用一次
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
    if (hotelDetailView.frame.origin.y<Height&&hotelDetailView) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            hotelDetailView.frame=CGRectMake(0, Height, Width, DownViewHeight);
            
        } completion:^(BOOL finished) {
            
            NSLog(@"酒店信息隐藏了");
            
        }];
        
    }
    
}

//取消选择标签时调用
-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    
    //    NSLog(@"取消选择了标签");
    
}

//选择标签时调用
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
    if ([view.annotation.title isEqualToString:@"我的位置"]) {  //当前坐标点不需要弹出酒店信息
        
        return ;
        
    }
    
    [self creatDownViewWithHotelData:view];
    
}

//点击标签弹出的泡泡框时调用
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    
    //    NSLog(@"点击了泡泡框:%@",[view.annotation title]);
    
}



#pragma mark ----- 定位的代理方法
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"heading is %@",userLocation.heading);
    
    [mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    currentUserLocation=userLocation;
    
    //    NSLog(@"currentUserLocation.location.coordinate.latitude:%f\ncurrentUserLocation.location.coordinate.longitude:%f",currentUserLocation.location.coordinate.latitude,currentUserLocation.location.coordinate.longitude);
    
    //设置地图显示的中心点
//    [self myLocation];
    
    if (i!=1) {
        
        [self creatAnnotationWithHotelModel];   //创建酒店地标
        
        i=1;
        
    }
    
    [mapView updateLocationData:currentUserLocation];
    
}








@end
