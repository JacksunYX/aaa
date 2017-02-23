//
//  HotelReservationVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/17.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

//系统版本号
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

#define tableH self.mytableView.mj_header//刷新头
#define tableF self.mytableView.mj_footer//刷新尾


#import "HotelReservationVC+Methods.h"
#import "HotelListVC.h" //酒店展示页面

#import "HotelClassifyModel.h"  //酒店分类的模型



#import "ImageTextButton.h"     //带图片的按钮库
#import "CCLocationManager.h"   //定位
#import "AreaSelectView.h"  //地域选择库
#import "UIImageView+ProgressView.h"    //带进度圈的图片加载库
#import "MJRefresh.h"       //刷新库
#import "LTPickerView.h"    //单行选择库


@implementation HotelReservationVC (Methods)

-(void)loadBaseView //加载基本视图
{
    
    app =[UIApplication sharedApplication].delegate;    //保存最开始的代理
    
    hotelClassifyArr = [NSMutableArray new];
    
    [self updataTheNavigation];         ///修改导航栏显示
    
    [self creatTableView];  //创建表视图
    
    [self initializeLocationService];   ///定位设置
    
    [self getCity]; //获取当前城市位置
    
}

#pragma mark ----- 视图加载方法
-(void)updataTheNavigation //修改导航栏显示
{

    //修改导航栏颜色
    self.navigationController.navigationBar.dk_barTintColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    //背景色
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    //修改左侧按钮
    self.leftItemBtn =[[ImageTextButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) image:[UIImage imageNamed:@"scale_icon"] title:@"定位中..."];
    self.leftItemBtn.titleLabel.font = [UIFont fontWithName:PingFangSCX size:16];
    [self.leftItemBtn sizeToFit];
    [self.leftItemBtn addTarget:self action:@selector(touchToPushTheLocationPicker) forControlEvents:UIControlEventTouchUpInside];
    self.leftItemBtn.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentRight;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftItemBtn];
    
    //处理左按钮靠右的情况(当前设备的版本>=ios7.0)
    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
        
    {
        
        UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemFixedSpace
                                           
                                                                                          target : nil action : nil ];
        
        negativeSpacer. width = -10 ;//这个数值可以根据情况自由变化
        
        self.navigationItem.leftBarButtonItems = @[ negativeSpacer, leftItem ] ;
        
    }else{//低于7.0版本不需要考虑
        
        self.navigationItem.leftBarButtonItem= leftItem;
        
    }
    
    
    //修改右侧按钮
    self.rightItemBtn =[[ImageTextButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0) image:[UIImage imageNamed:@"hotelList_icon"] title:@"酒店"];
    [self.rightItemBtn sizeToFit];
    [self.rightItemBtn addTarget:self action:@selector(touchToPushToHotelsListVC) forControlEvents:UIControlEventTouchUpInside];
    self.rightItemBtn.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentRight;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightItemBtn];
    //处理右按钮靠左的情况(当前设备的版本>=ios7.0)
    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
        
    {
        
        UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target : nil action : nil ];
        
        negativeSpacer. width = -10 ;//这个数值可以根据情况自由变化
        
        self.navigationItem.rightBarButtonItems = @[ negativeSpacer,rightItem ] ;
        
    }else{      //低于7.0版本不需要考虑
        
        self.navigationItem.rightBarButtonItem= rightItem;
        
    }
    
    [self.rightItemBtn setHidden:YES];  //目前版本先隐藏

}

-(void)setRefreshBtn    //添加一个刷新按钮，防止网络不好时无法获取城市列表及主题列表
{
    
    [refreshBtn setHidden:NO];
    
    if (refreshBtn) {
        
        return;
        
    }else{
    
        refreshBtn = [UIButton new];
        [refreshBtn setTitleColor:MainThemeColor forState:UIControlStateNormal];
        refreshBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [refreshBtn setTitle:@"刷新一下" forState:UIControlStateNormal];
        refreshBtn.layer.borderColor = MainThemeColor.CGColor;
        refreshBtn.layer.borderWidth = 1;
        
        [self.view addSubview:refreshBtn];
        
        //布局
        refreshBtn.sd_layout
        .widthIs(80)
        .heightIs(40)
        .centerXEqualToView(self.view)
        .centerYEqualToView(self.view)
        ;
        
        refreshBtn.sd_cornerRadius = @(5);
        
        //添加点击事件
        [refreshBtn addTarget:self action:@selector(touchToGetCityListOrThemeList) forControlEvents:UIControlEventTouchUpInside];
    
    }
    
}

-(void)setNoticeLabel   //添加一个提示，声明当前城市没有合作方
{

    [noticeLabel setHidden:NO];
    
    if (noticeLabel) {
        
        return;
        
    }else{
        
        noticeLabel = [UILabel new];
        noticeLabel.textColor = ContentTextColorNormal;
        noticeLabel.textAlignment=1;
        noticeLabel.font = [UIFont systemFontOfSize:14];
        
        [self.view addSubview:noticeLabel];
        
        //布局
        noticeLabel.sd_layout
        .topSpaceToView(self.view,70)
        .leftSpaceToView(self.view,10)
        .autoHeightRatio(0)
        ;
        
//        noticeLabel.layer.borderWidth = 1;
//        noticeLabel.layer.borderColor = MainThemeColor.CGColor;
//        noticeLabel.sd_cornerRadius = @(5);
        [noticeLabel setSingleLineAutoResizeWithMaxWidth:70];
        
        [noticeLabel setText:@"⬆️可以查看其它城市主题酒店"];
    }

}

- (void)initializeLocationService   //开始定位
{
    // 初始化定位管理器
    self.locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    self.locationManager.delegate = self;
    // 设置定位精确度到米
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为10m
    self.locationManager.distanceFilter = 10.0f;
    // 开始定位
    [self.locationManager requestAlwaysAuthorization];//这句话ios8以上版本使用
    [self.locationManager startUpdatingLocation];
    
    [self loadIndicator];   //加载指示器
    
    firstRefresh = YES; //标记，说明已经加载进度指示器了
    
}

-(void)creatTableView       //创建用于展示酒店列表的表视图
{
    
    UITableView *table =[[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, Width, Height-NavigationBarHeight-self.tabBarController.tabBar.frame.size.height)];
    self.mytableView=table;
    [self.view addSubview:self.mytableView];
    self.mytableView.dataSource=self;
    self.mytableView.delegate=self;
    self.mytableView.tableFooterView=[[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mytableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.mytableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
}



#pragma mark ----- 交互方法

-(void)touchToGetCityListOrThemeList    //重新刷新城市列表或者主题列表
{

    [refreshBtn setHidden:YES];
    
    [self loadIndicator];
    
    if (cityArr.count<=0) { //说明没有城市列表，此时刷新动作为获取城市列表
        
        [self getCitiesList];
        
    }else{  //反之则是没有成功加载主题列表
    
        [self processTheCurrentCity];
    
    }

}

-(void)getCitiesList    //获取城市列表
{
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识

    NSMutableString *citiesUrl= [[MainUrl stringByAppendingString:GetCitiesList]mutableCopy];
    
    [citiesUrl appendFormat:@"?deviceId=%@",deviceId];
    
//    NSLog(@"citiesUrl:%@",citiesUrl);
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:citiesUrl]];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"城市列表:%@",dict);
            
            if ([[dict objectForKey:@"resultCode"] isEqualToString:@"1"]) { //说明请求成功
                
                //此处可对数据做进一步处理
                cityArr = [dict objectForKey:@"result"];
                
            }
            
            [self processTheCurrentCity];   //处理当前定位的城市是否在城市列表中
            
        }else{
            
            [activityIndicatorView stopAnimating];
        
            [self showString:@"请求超时,请检查您的网络状况"];
            
            [self setRefreshBtn];
        
        }
        
    }];

}

-(void)getRoomThemeLisWithCity:(NSInteger)zoneCode //根据传入的城市名获取对应的主题列表
{
    
    if (!firstRefresh) {
        
        [self loadIndicator];   //加载指示器
        
    }
    
    if (hotelClassifyArr.count>0) {
        
        [hotelClassifyArr removeAllObjects];    //先移除所有对象
        
    }
    
    if (!refreshBtn.hidden) {
        
        [refreshBtn setHidden:YES];
        
    }
    
    if (!noticeLabel.hidden) {
        
        [noticeLabel setHidden:YES];
        
    }
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *themeLisUrl= [[MainUrl stringByAppendingString:GetRoomThemeList]mutableCopy];
    [themeLisUrl appendFormat:@"?zoneCode=%ld&&deviceId=%@",zoneCode,deviceId];
//    NSLog(@"themeLisUrl:%@",themeLisUrl);
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:themeLisUrl]];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"主题列表:%@",dict);
            
            
                
            if ([[dict objectForKey:@"resultCode"]isEqualToString:@"1"]) {  //代表获取成功
                
                NSArray *arr = [dict objectForKey:@"result"];
                
                if (arr.count>0) {
                    
                    for (int i = 0; i<arr.count; i++) {
                        
                        HotelClassifyModel *model =[HotelClassifyModel new];
                        NSDictionary *dict = arr[i];
                        //赋值
                        [model setValue:[dict objectForKey:@"themeName"]        forKey:@"classify"];
                        [model setValue:[dict objectForKey:@"themePicture"]     forKey:@"imageSrc"];
                        [model setValue:[dict objectForKey:@"roomNum"]          forKey:@"roomsNum"];
                        [model setValue:[dict objectForKey:@"themeDescription"] forKey:@"introduction"];
                        [model setValue:[dict objectForKey:@"themeId"]        forKey:@"themeId"];
                        
                        
                        [hotelClassifyArr addObject:model]; //加入全局数组
                        
                    }
                    
                }else{
                    
                    [self showString:@"还没有合作方哟~"];
                    
                }
                
            }
            
            
            
            
//            firstRefresh = NO;
            
        }else{
            
//            [activityIndicatorView stopAnimating];
            
            
            
            [self showString:@"请求超时"];
            
            if (hotelClassifyArr.count<=0) {
                
                [self setRefreshBtn];
                
            }
            
        }
        
        firstRefresh = NO;
        
        GCDWithMain(^{
            
            [activityIndicatorView stopAnimating];
            
            [self.mytableView reloadData];  //主界面刷新
            
        });
        
    }];

}

-(void)processTheCurrentCity    //处理当前定位的城市是否在城市列表中
{
    
    int i =0;

    for (NSDictionary *dict in cityArr) {
        
        if ([[dict objectForKey:@"zoneName"]isEqualToString:currentCity]) { //说明当前城市在列表中
            
            i = [[dict objectForKey:@"zoneCode"] intValue];
            
            currentCityCode = [dict objectForKey:@"zoneCode"];
            
            break;  //跳出循环
        }
        
    }
    
    if (i) {   //可以获取当前城市的主题列表了
        
        [self getRoomThemeLisWithCity:i];
        
    }else{
        
        [activityIndicatorView stopAnimating];
    
        [self showString:@"当前城市还没有合作方哟~"];
        
        [self setNoticeLabel];  //提示
    
    }
    

}


#pragma mark ----- 辅助方法

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
}

-(void)showAlertView:(NSString *)string     //警告框
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}

-(void)showString:(NSString *)str           //提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    //    hud.cornerRadius=20;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

-(void)touchToPushTheLocationPicker //弹出区域选择视图
{
    /*
    //如果正在定位,则不可点
    if ([self.leftItemBtn.titleLabel.text isEqualToString:@"定位中..."]) {
        
        return;
        
    }else{
    
        AreaSelectView *selectView = [[AreaSelectView alloc] initWithFrame:CGRectMake(0, Height,Width ,Height)];
        [self.view addSubview:selectView];
        
        //设置定位城市
        AreaModel *model = [DBUtil getCityWithName:currentCity];
        if(model)
        {
            [selectView.cities setObject:[NSArray arrayWithObject:model] forKey:@"定"];
        }
        [selectView.keys insertObject:@"定" atIndex:0];
        
        //弹出选择界面
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.tabBarController.tabBar setHidden:YES];   //隐藏下方控件
            
            [self.navigationController setNavigationBarHidden:YES animated:NO];
            
            selectView.frame=CGRectMake(0, 0, Width, selectView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            
            
        }];
        
        __weak AreaSelectView *_selectView = selectView;
        [selectView setSelectedCityBlock:^(AreaModel * info) {
            [self.leftItemBtn setTitleWithString:info.areaName];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                _selectView.frame=CGRectMake(0, Height, Width, _selectView.frame.size.height);
                
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                
            } completion:^(BOOL finished) {
                
                [self.tabBarController.tabBar setHidden:NO];   //显示下方控件
                
                [_selectView removeFromSuperview];
                
            }];
            
        }];
    
    }
     */
    
    
    //一级城市选择
    
    if (!cityPicker&&cityArr.count>0) {
        cityPicker = [LTPickerView new];
        
        cityPicker.title = @"选择城市";
        
        NSMutableArray *cityNameArr =[NSMutableArray new];
        
        for (NSDictionary *dict in cityArr) {
            
            [cityNameArr addObject:[dict objectForKey:@"zoneName"]];
            
        }
        
        cityPicker.dataSource = cityNameArr;//设置要显示的数据
        
        __block __weak HotelReservationVC *wself = self;
        
        //回调
        cityPicker.block = ^(LTPickerView *obj,NSString* cityName,NSInteger num){
            
            currentCity = cityName; //更新当前城市
            
            [wself.leftItemBtn setTitleWithString:cityName];
            
            [wself processTheCurrentCity];
            
        };
        
    }
    
    if (currentCity) {
        
        cityPicker.defaultStr = currentCity;
        
    }
    
    [cityPicker show];//显示
    
}


-(void)touchToPushToHotelsListVC    //跳转到酒店列表页
{

    HotelListVC *hvc =[[HotelListVC alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:hvc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    
}

-(void)getCity  //获取当前定位的城市
{
    if (noticeLabel) {
        
        [noticeLabel setHidden:YES];
        
    }
    
    __block __weak HotelReservationVC *wself = self;
    
//    if (IS_IOS8) {
    
        [[CCLocationManager shareLocation] getCity:^(NSString *addressString) {
            
            currentCity = addressString;    //保存当前定位的城市
            
            [wself.leftItemBtn setTitleWithString:currentCity];
            
            [wself getCitiesList];   //获取城市列表
            
            if ([addressString isEqualToString:@"定位失败"]) {
                
                UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,到设置->隐私,打开定位服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                [alvertView show];
                
            }
            
        } error:^(NSError *error) {
            
            NSLog(@"定位失败%@",error);
            
//            showHudString(@"定位失败");
            //当定位失败时，使用默认位置(暂定为武汉市)
            currentCity = @"武汉市";
            
            [wself.leftItemBtn setTitleWithString:currentCity];
            
            [wself getCitiesList];   //获取城市列表
            
        }];
    
//    }
    
}

-(void)loadIndicator    //加载指示器
{
    
    if (!activityIndicatorView) {
        
        activityIndicatorView = [[DGActivityIndicatorView alloc]initWithType:7 tintColor:MainThemeColor size:Width/8];
        
    }
    
    [self.view addSubview:activityIndicatorView];
    
    //布局下
    activityIndicatorView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    ;
    
    [activityIndicatorView startAnimating]; //加载等待视图
    
}


///创建虚拟数据
-(void)creatHotelClassifyArr
{

    HotelClassifyModel *model1 = [[HotelClassifyModel alloc]init];
    [model1 setValue:@"角色扮演" forKey:@"classify"];
    [model1 setValue:@"http://www.tianelian.com/uploads/housetype/post-thumbnail/5594c5eb36025.jpg" forKey:@"imageSrc"];
    [model1 setValue:@"12" forKey:@"roomsNum"];
    [model1 setValue:@"与你的Ta来场cosplay" forKey:@"introduction"];
    
    HotelClassifyModel *model2 = [[HotelClassifyModel alloc]init];
    [model2 setValue:@"SM风格" forKey:@"classify"];
    [model2 setValue:@"http://www.tianelian.com/uploads/housetype/post-thumbnail/5594c5f8c7467.jpg" forKey:@"imageSrc"];
    [model2 setValue:@"30" forKey:@"roomsNum"];
    [model2 setValue:@"玩一场激情游戏" forKey:@"introduction"];
    
    HotelClassifyModel *model3 = [[HotelClassifyModel alloc]init];
    [model3 setValue:@"华丽浪漫" forKey:@"classify"];
    [model3 setValue:@"http://www.tianelian.com/uploads/housetype/post-thumbnail/53ec7e52b4fed.jpg" forKey:@"imageSrc"];
    [model3 setValue:@"74" forKey:@"roomsNum"];
    [model3 setValue:@"做一次公主" forKey:@"introduction"];
    
    HotelClassifyModel *model4 = [[HotelClassifyModel alloc]init];
    [model4 setValue:@"清新纯真" forKey:@"classify"];
    [model4 setValue:@"http://www.tianelian.com/uploads/housetype/post-thumbnail/5594c589d23bb.jpg" forKey:@"imageSrc"];
    [model4 setValue:@"23" forKey:@"roomsNum"];
    [model4 setValue:@"寻回最初的纯情" forKey:@"introduction"];
    
    [hotelClassifyArr addObject:model1];
    [hotelClassifyArr addObject:model2];
    [hotelClassifyArr addObject:model3];
    [hotelClassifyArr addObject:model4];

}

//定位状态修改的通知回调
-(void)tongzhi:(NSNotification *)text
{
    
    NSLog(@"定位状态修改的通知回调");

    [self initializeLocationService];   ///定位设置
    
    [self getCity]; //获取当前城市位置

}

#pragma mark ----- UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1) {   //跳转到设置界面
        
        app.after = app.after + 1 ;   //自增一下标记
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }
    
}









@end
