//
//  MapViewDebugVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/11.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

//系统版本号
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)



#import "MapViewDebugVC.h"

#import "MapNavigationManager.h"  //地图库

#import "CCLocationManager.h"


@interface MapViewDebugVC ()

@property(nonatomic,strong)UILabel *textLabel;

@end

@implementation MapViewDebugVC

-(void)viewDidLoad
{

    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor=[UIColor redColor];
    self.title=@"地图测试";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initializeLocationService];
    
    [self createButton];
    
}

-(void)createButton //创建按钮
{
    
    if (IS_IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [_locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        _locationManager.delegate = self;
    }
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(Width/2-160, NavigationBarHeight+20, 320, 60)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.textColor = [UIColor redColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.numberOfLines = 0;
    _textLabel.text = @"测试位置";
    [self.view addSubview:_textLabel];
    
    UIButton *latBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    latBtn.frame = CGRectMake(Width/2-150/2,_textLabel.frame.origin.y+_textLabel.frame.size.height+50 , 150, 30);
    [latBtn setTitle:@"点击获取坐标" forState:UIControlStateNormal];
    [latBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [latBtn addTarget:self action:@selector(getLat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:latBtn];
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cityBtn.frame = CGRectMake(Width/2-150/2,latBtn.frame.origin.y+latBtn.frame.size.height+20, 150, 30);
    [cityBtn setTitle:@"点击获取城市" forState:UIControlStateNormal];
    [cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(getCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cityBtn];
    
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    allBtn.frame = CGRectMake(Width/2-150/2,cityBtn.frame.origin.y+cityBtn.frame.size.height+20, 150, 30);
    [allBtn setTitle:@"点击获取所有信息" forState:UIControlStateNormal];
    [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(getAllInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBtn];
    
    [self showBorder:latBtn];
    [self showBorder:cityBtn];
    [self showBorder:allBtn];
}

-(void)showBorder:(UIButton *)sender
{
    sender.layer.borderColor=[UIColor redColor].CGColor;
    sender.layer.borderWidth=0.5;
    sender.layer.cornerRadius = 8;
    
}

-(void)getLat
{
    __block __weak MapViewDebugVC *wself = self;
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            
            NSLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
            [wself setLabelText:[NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude]];
            
        }];
    }
    
}

-(void)getCity
{
    __block __weak MapViewDebugVC *wself = self;
    
    if (IS_IOS8) {
        
        //获取城市
        [[CCLocationManager shareLocation]getCity:^(NSString *cityString) {
            NSLog(@"cityString:%@",cityString);
            [wself setLabelText:cityString];
            
        }];
        
        //获取地址
//        [[CCLocationManager shareLocation]getAddress:^(NSString *addressString) {
//           
//            NSLog(@"addressString:%@",addressString);
//            
//        }];
        
    }
    
}


-(void)getAllInfo
{
    __block NSString *string;
    __block __weak MapViewDebugVC *wself = self;
    
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation]getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            string = [NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude];
        } withAddress:^(NSString *addressString) {
            NSLog(@"%@",addressString);
            string = [NSString stringWithFormat:@"%@\n%@",string,addressString];
            [wself setLabelText:string];
            
        }];
    }
    
}

-(void)setLabelText:(NSString *)text
{
    NSLog(@"text %@",text);
    _textLabel.text = text;
}

-(void)creatLocationBtn //创建定位按钮
{

    UIButton *currentDirection =[[UIButton alloc]init];
    [currentDirection setTitle:@"开始定位" forState:UIControlStateNormal];
    [currentDirection setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [currentDirection sizeToFit];
    currentDirection.frame=CGRectMake(Width/2-currentDirection.frame.size.width/2, (Height-NavigationBarHeight)/2-currentDirection.frame.size.height/2, currentDirection.frame.size.width, currentDirection.frame.size.height);
    [self.view addSubview:currentDirection];
    
    [currentDirection addTarget:self action:@selector(StartDirection:) forControlEvents:UIControlEventTouchUpInside];

}


-(IBAction)StartDirection:(UIButton *)sender
{

    [MapNavigationManager showSheetWithCity:@"武汉市" start:@"化徐村" end:@"中南民族大学"];

}


- (void)initializeLocationService
{
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = 10.0f;
    // 开始定位
    [_locationManager requestAlwaysAuthorization];//这句话ios8以上版本使用
    [_locationManager startUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{

    CLLocation *location = [locations lastObject];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);

}



@end
