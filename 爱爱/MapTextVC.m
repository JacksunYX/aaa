//
//  MapTextVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/15.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "UIImageView+ProgressView.h"

#import "ZGPopUpView.h" //泡泡提示库

#import "UIViewController+JTNavigationExtension.h"


#define DownViewHeight  120                 //下方控件背景的高度
#define HotelLabelWidth ((Width-20)*2/3-10)   //展示酒店相关信息的label宽度


#import "MapTextVC.h"

@interface MapTextVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate,UIGestureRecognizerDelegate>

{
    
    BMKMapView *mapView;    //地图
    
    BMKLocationService *locService; //定位
    
    UIView *DownBackView;   //下方打开百度地图的空间背景
 
    BMKUserLocation *currentUserLocation;   //当前用户方位信息
    
    CLLocationCoordinate2D destinationCoor; //目的地坐标
    
    int loaddownView;   //只在进入的时候加载一次
    
    BMKPinAnnotationView *newAnnotationView;    //标注实例
}

@end

@implementation MapTextVC

-(void)viewDidLoad
{
//    NSLog(@"orderDic:%@",self.orderDic);
    
    //获取酒店的坐标
    destinationCoor.latitude = [[_orderDic objectForKey:@"latitude"]floatValue];
    destinationCoor.longitude = [[_orderDic objectForKey:@"longitude"]floatValue];

    [super viewDidLoad];
    
    loaddownView = 0;   //置0
    
    [self updateNavigation];//修改导航栏显示
    
    [self loadBaiduMap];    //创建百度地图视图
    
    [self locationService]; //定位
    
//    [self creatAnnotationWithHotelModel];   //创建酒店标注
    
}



-(void)viewWillAppear:(BOOL)animated
{
    self.jt_fullScreenPopGestureEnabled = NO;
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    self.jt_fullScreenPopGestureEnabled = YES;
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
    locService.delegate = nil;
}

#pragma mark ----- 视图加载方法
-(void)updateNavigation //修改导航栏显示
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
    
    //右按钮支持回到当前坐标
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"我的位置" style:UIBarButtonItemStylePlain target:self action:@selector(myLocation)];
    
    //修改标题字体大小和颜色
    self.title=@"商家地图";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNormal);
        
    }else{
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNight);
        
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    //关闭侧边栏侧滑
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];

}

-(void)loadBaiduMap     //加载百度地图
{
    
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, Width, Height-NavigationBarHeight-DownViewHeight)];
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
    
    mapView.zoomLevel = 13; //默认加载地图的比例尺级别(数字越大代表显示的越精细)
    
    [self.view addSubview:mapView];
    
}

-(void)creatDownViewWithHotelModel      //根据上个页面传过来的酒店数据创建地图下方控件
{

    DownBackView = [[UIView alloc]initWithFrame:CGRectMake(0, Height-DownViewHeight, Width, DownViewHeight)];
    //创建label用于展示传过来的酒店信息
    UILabel *HotelName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, HotelLabelWidth, 0)];
    HotelName.font = [UIFont fontWithName:PingFangSCC size:16];
    HotelName.numberOfLines=0;
    HotelName.dk_textColorPicker=DKColorWithColors([UIColor blackColor], TitleTextColorNight);
    HotelName.text = [self.orderDic objectForKey:@"hotelName"];
    [HotelName sizeToFit];
    [DownBackView addSubview:HotelName];
    
    //酒店位置信息
    UILabel *HotelLocation = [[UILabel alloc]initWithFrame:CGRectMake(10, HotelName.frame.origin.y+HotelName.frame.size.height+10, HotelLabelWidth, 0)];
    HotelLocation.font = [UIFont fontWithName:PingFangSCX size:14];
    HotelLocation.numberOfLines = 0;
    HotelLocation.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), UnimportantContentTextColorNight);
    HotelLocation.text = [self.orderDic objectForKey:@"hotelAddress"];
    [HotelLocation sizeToFit];
    [DownBackView addSubview:HotelLocation];
    
    //距离酒店的距离
    UILabel *distance = [[UILabel alloc]init];
    distance.font = [UIFont fontWithName:PingFangSCX size:14];
    distance.textAlignment=2;
    distance.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), UnimportantContentTextColorNight);
     //计算两点距离
    distance.text = [self computeDistanceBetweenLocationAndDestination];
    [distance sizeToFit];
    distance.frame=CGRectMake(Width-distance.frame.size.width-10, HotelName.frame.origin.y+HotelName.frame.size.height/2, distance.frame.size.width, distance.frame.size.height);
    [DownBackView addSubview:distance];
    
    
    //分割线
    UILabel *seperatline =[[UILabel alloc]initWithFrame:CGRectMake(0, DownViewHeight*2/3, Width, 0.5)];
    seperatline.backgroundColor=RGBA(230, 230, 230, 1);
    [DownBackView addSubview:seperatline];
    
    
    //查看路线及周边(调用百度地图app)
    UIView *BaiduMapView =[[UIView alloc]initWithFrame:CGRectMake(0, seperatline.frame.origin.y+seperatline.frame.size.height, DownBackView.frame.size.width, DownViewHeight-seperatline.frame.origin.y-seperatline.frame.size.height)];
//    BaiduMapView.backgroundColor = [UIColor redColor];
    [DownBackView addSubview:BaiduMapView];
    //创建点击事件
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchToBaiduMap:)];
    singleTap.numberOfTapsRequired=1;
    singleTap.delegate=self;
    [BaiduMapView addGestureRecognizer:singleTap];
    
    //图标
    UIImageView *imageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"place_icon"]];
    imageV.userInteractionEnabled=YES;
    [imageV sizeToFit];
    
    //文字
    UILabel *Textlabel =[[UILabel alloc]init];
    Textlabel.font=[UIFont fontWithName:PingFangSCC size:16];
    Textlabel.textAlignment=1;
    Textlabel.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), ContentTextColorNight);
    Textlabel.numberOfLines=1;
    Textlabel.text=@"查看路线及周边";
    [Textlabel sizeToFit];
    
    CGFloat totleWidth = imageV.frame.size.width+10+Textlabel.frame.size.width;
    CGFloat originX = (BaiduMapView.frame.size.width-totleWidth)/2; //x坐标
    
    imageV.frame = CGRectMake(originX, BaiduMapView.frame.size.height/2-imageV.frame.size.height/2, imageV.frame.size.width, imageV.frame.size.height);
    [BaiduMapView addSubview:imageV];
    
    Textlabel.frame=CGRectMake(imageV.frame.origin.x+imageV.frame.size.width+10, BaiduMapView.frame.size.height/2-Textlabel.frame.size.height/2, Textlabel.frame.size.width, Textlabel.frame.size.height);
    [BaiduMapView addSubview:Textlabel];
    
    
    
    [self.view addSubview:DownBackView];
    
}

-(UIView *)creatPaopapViewWithHotelData     //根据酒店信息生成一个点击地图上标注可以弹出展示酒店相关的泡泡视图(纯自定义)
{

    UIView *paopaoView = [UIView new];
    paopaoView.backgroundColor = [UIColor whiteColor];
    //酒店配图
    UIImageView *image = [UIImageView new];
    
    //价格
    UILabel *priceLabel = [UILabel new];
    priceLabel.textColor = MainThemeColor;
    priceLabel.font = [UIFont systemFontOfSize:14];
    
    NSArray *viewsArr = @[image,priceLabel];
    
    [paopaoView sd_addSubviews:viewsArr];
    
    //布局
    
    CGFloat height = 30 ;
    CGFloat margin = 5 ;
    
    paopaoView.sd_layout
    .heightIs(height+margin*2)
    
    ;
    
    
    image.sd_layout
    .widthIs(height)
    .heightIs(height)
    .centerYEqualToView(paopaoView)
    .leftSpaceToView(paopaoView,margin)
    ;
    image.sd_cornerRadius = @(5);
    
    priceLabel.sd_layout
    .heightRatioToView(image,1)
    .leftSpaceToView(image,5)
    .centerYEqualToView(paopaoView)
    ;
    
    [priceLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    [paopaoView setupAutoWidthWithRightView:priceLabel rightMargin:5];
    
    
    //赋值
    if ([self.orderDic objectForKey:@"hotelPicture"]) {
        
        NSString *imagestr = [MainUrl stringByAppendingString:[self.orderDic objectForKey:@"hotelPicture"]];
        [image sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(10, 10)];
        
    }
    
    [priceLabel setText:[NSString stringWithFormat:@"总价:¥ %@",[self.orderDic objectForKey:@"totalCost"]]];
    
    return paopaoView;

}

//创建泡泡view的左边视图
-(UIImageView *)creatHotelImage
{

    //酒店配图
    UIImageView *imageView = [UIImageView new];
    imageView.sd_layout
    .widthIs(30)
    .heightIs(30)
    ;
    
    if ([self.orderDic objectForKey:@"hotelPicture"]) {
        NSString *imagestr = [MainUrl stringByAppendingString:[self.orderDic objectForKey:@"hotelPicture"]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(10, 10)];
    }

    return imageView;
}

//创建泡泡view的右边视图
-(UILabel *)creatHotelPrice
{

    //酒店价格
    UILabel *price = [UILabel new];
    price.textColor=MainThemeColor;
    price.font = [UIFont fontWithName:PingFangSCX size:12];
    
    price.sd_layout
    .widthIs(32)
    .heightIs(30)
    ;
    
    [price setText:[NSString stringWithFormat:@"¥%@",[self.orderDic objectForKey:@"totalCost"]]];
    
    return price;

}


//当前位置到目的地的距离
-(NSString *)computeDistanceBetweenLocationAndDestination
{
    //指定起点经纬度
    CLLocationCoordinate2D coor1;
    coor1.latitude = currentUserLocation.location.coordinate.latitude;
    coor1.longitude = currentUserLocation.location.coordinate.longitude;
    
//    NSLog(@"coor1.latitude:%f",coor1.latitude);
//    NSLog(@"coor1.longitude:%f",coor1.longitude);
    
    //单位为米
    BMKMapPoint point1 = BMKMapPointForCoordinate(coor1);
    BMKMapPoint point2 = BMKMapPointForCoordinate(destinationCoor);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    
    NSString *str =[NSString stringWithFormat:@"%.2fkm",(int)distance/1000+((int)distance%1000)/1000.0];
    
//    NSLog(@"两地间距:%@",str);
    
    return str;

}

-(void)TouchToBaiduMap:(UITapGestureRecognizer *)tapgestures    //跳转百度地图点击事件
{

    NSLog(@"跳转到百度地图");
    
    BMKOpenTransitRouteOption *opt = [[BMKOpenTransitRouteOption alloc] init];
    opt.appScheme = @"爱爱";//用于调起成功后，返回原应用
    
    opt.isSupportWeb = YES; //如果调用百度地图客户端失败后会调用web展示
    
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    CLLocationCoordinate2D coor1;
    coor1.latitude = currentUserLocation.location.coordinate.latitude;
    coor1.longitude = currentUserLocation.location.coordinate.longitude;
    
//    NSLog(@"coor1.latitude:%f",coor1.latitude);
//    NSLog(@"coor1.longitude:%f",coor1.longitude);
    
    //指定起点名称
//    start.name = @"创业楼";
    start.pt = coor1;
    //指定起点
    opt.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    
    end.pt = destinationCoor;
    //指定终点名称
//    end.name = @"天安门";
    opt.endPoint = end;
    
    //打开地图公交路线检索
    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapTransitRoute:opt];

    if (code==0) {
        NSLog(@"打开公交检索成功");
    }else{
        NSLog(@"打开公交检索失败");
    }
    
    //单位为米
    BMKMapPoint point1 = BMKMapPointForCoordinate(coor1);
    BMKMapPoint point2 = BMKMapPointForCoordinate(destinationCoor);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);

    NSString *str =[NSString stringWithFormat:@"%.2fkm",(int)distance/1000+((int)distance%1000)/1000.0];
    NSLog(@"两地间距:%@",str);
    
}







#pragma mark ----- 标注相关
//根据上个页面传入的酒店数据创建标注
-(void)creatAnnotationWithHotelModel
{

    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = destinationCoor;    //坐标
    annotation.title = [self.orderDic objectForKey:@"hotelName"];
    [mapView addAnnotation:annotation];
    
}


///// Override 标注代理方法
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        
        if (!newAnnotationView.paopaoView) {
            
            //自定义弹出的泡泡view
//            BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:[self creatPaopapViewWithHotelData]];
//            
//            newAnnotationView.paopaoView = paopaoView;
            
            //左边视图
            newAnnotationView.leftCalloutAccessoryView = [self creatHotelImage];
            newAnnotationView.rightCalloutAccessoryView= [self creatHotelPrice];
            
        }
        
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

//选中时
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{

    
   // NSLog(@"选中了");
    
    newAnnotationView.pinColor = BMKPinAnnotationColorGreen;

}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
//取消选中时
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{

    //NSLog(@"取消了");

    newAnnotationView.pinColor = BMKPinAnnotationColorRed;
}

//点击弹出的泡泡view时调用
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{

    NSLog(@"点击了paopaoView");

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

#pragma mark ----- 定位代理方法
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
    
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    currentUserLocation=userLocation;
    
    [mapView updateLocationData:currentUserLocation];
    
    if (loaddownView==0) {
        
        [self creatDownViewWithHotelModel];     //创建下方控件
        
        [self creatAnnotationWithHotelModel];   //创建酒店地标
        
    }
    
    loaddownView++;
    
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
    mapView.centerCoordinate = center;
    
    mapView.rotateEnabled = YES;//旋转手势
    
}


- (void)dealloc {
    if (mapView) {
        mapView = nil;
    }
}

//将其他地图的坐标转换为百度地图坐标并返回
-(CLLocationCoordinate2D)changeToBaiduCoorWithCoor:(CLLocationCoordinate2D)currentCoor
{

    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(currentCoor,BMK_COORDTYPE_COMMON);
    //转换GPS坐标至百度坐标(加密后的坐标)
    testdic = BMKConvertBaiduCoorFrom(currentCoor,BMK_COORDTYPE_GPS);
    NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
    //解密加密后的坐标字典
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标

    return baiduCoor;
    
}




@end
