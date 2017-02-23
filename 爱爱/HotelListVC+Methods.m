//
//  HotelShowVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define tableH self.mytableView.mj_header//刷新头
#define tableF self.mytableView.mj_footer//刷新尾


#import "UIImageView+ProgressView.h"    //带进度圈的图片加载库
#import "MJRefresh.h"       //刷新库
#import "Reachability.h"    //网络检查库


#import "HotelListVC+Methods.h"

#import "HotelsLocationVC.h"    //酒店所在位置(地图)展示页


@implementation HotelListVC (Methods)



-(void)loadBaseView //加载基本视图
{
 
    hotelArr = [NSMutableArray new];
    
    [self updataTheNavigation]; ///修改导航栏显示
    
    [self creatTableView];      ///创建tableView
    
    [self.mytableView.mj_header beginRefreshing];   ///刷新一次
    
}



#pragma mark ----- 视图加载方法
-(void)updataTheNavigation  //修改导航栏显示
{
    
    //修改导航栏颜色
    self.navigationController.navigationBar.dk_barTintColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    //背景色
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    

    //返回键
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
    
    
    //修改右侧按钮
    UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setBackgroundImage:[[UIImage imageNamed:@"location_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(touchToPushToHotelsLocation) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    //处理右按钮靠左的情况(当前设备的版本>=ios7.0)
    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
        
    {
        
        UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target : nil action : nil ];
        
        negativeSpacer. width = -15 ;//这个数值可以根据情况自由变化
        
        self.navigationItem.rightBarButtonItems = @[ negativeSpacer,rightItem ] ;
        
    }else{      //低于7.0版本不需要考虑
        
        self.navigationItem.rightBarButtonItem= rightItem;
        
    }
    

    self.title=@"酒店列表";
    
}

-(void)creatTableView       //创建用于展示酒店列表的表视图
{

    UITableView *table =[[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, Width, Height-NavigationBarHeight)];
    self.mytableView=table;
    [self.view addSubview:self.mytableView];
    self.mytableView.dataSource=self;
    self.mytableView.delegate=self;
    self.mytableView.tableFooterView=[[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mytableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    //下拉刷新
    tableH = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upData)];

}

-(void)addMjfooter  //添加上拉加载
{
    
    if (tableF) {
        
        return;
        
    }else{
        
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [footer setTitle:TableViewMJFooterUpLoadText forState:MJRefreshStateIdle];
        [footer setTitle:TableViewMJFooterRefreshingText forState:MJRefreshStateRefreshing];
        [footer setTitle:TableViewMJFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
        tableF=footer;
        
    }
    
}

#pragma  mark ----- 交互方法

-(void)upData       //下拉刷新
{

    downPull =YES;  //代表下拉
    
    //判断是否有网络
    Reachability *re =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status =[re currentReachabilityStatus];
    if (status>0) { //有网络才会加载数据
        
        [hotelArr removeAllObjects];
        
        [self creatHotelData];
        
        [self addMjfooter];
        
        [self.mytableView reloadData];
        
        [tableH endRefreshing];
        
    }else{
    
        [self showString:@"请检查网络情况"];
        
        [tableH endRefreshing];
    
    }
    
}

-(void)loadNewData  //上拉加载
{
    
    downPull =NO;   //代表上拉
    
    //判断是否有网络
    Reachability *re =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status =[re currentReachabilityStatus];
    if (status>0) { //有网络才会加载数据
        
        [self creatHotelData];
        
        
        [self.mytableView reloadData];
        
        [tableF endRefreshing];
        
    }else{
        
        [self showString:@"请检查网络情况"];
        
        [tableF endRefreshing];
        
    }
    
}






#pragma  mark ----- 辅助方法
-(void)touchtoPop
{

    [self.navigationController popViewControllerAnimated:YES];

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
    //    hud.margin = 10.f;
    //    hud.cornerRadius=20;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

-(void)touchToPushToHotelsLocation  //跳转到酒店地图展示页面
{

    HotelsLocationVC *hv =[[HotelsLocationVC alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:hv animated:YES];

}


///创建虚拟数据
-(void)creatHotelData
{

    HotelModel *hotelModel1 = [[HotelModel alloc]init];
    [hotelModel1 setValue:@"http://www.sucaitianxia.com/sheji/pic/200708/20070811225328187.jpg" forKey:@"hotelImgSrc"];
    [hotelModel1 setValue:@"豪泰商务酒店(大学院路店)" forKey:@"hotelName"];
    [hotelModel1 setValue:@"118" forKey:@"unitPrice"];
    
    HotelModel *hotelModel2 = [[HotelModel alloc]init];
    [hotelModel2 setValue:@"http://www.sucaitianxia.com/sheji/pic/200708/20070811225328187.jpg" forKey:@"hotelImgSrc"];
    [hotelModel2 setValue:@"世纪皇城时尚酒店" forKey:@"hotelName"];
    [hotelModel2 setValue:@"139" forKey:@"unitPrice"];
    
    HotelModel *hotelModel3 = [[HotelModel alloc]init];
    [hotelModel3 setValue:@"http://www.sucaitianxia.com/sheji/pic/200708/20070811225328187.jpg" forKey:@"hotelImgSrc"];
    [hotelModel3 setValue:@"怡巢连锁酒店" forKey:@"hotelName"];
    [hotelModel3 setValue:@"182" forKey:@"unitPrice"];
    
    HotelModel *hotelModel4 = [[HotelModel alloc]init];
    [hotelModel4 setValue:@"http://www.sucaitianxia.com/sheji/pic/200708/20070811225328187.jpg" forKey:@"hotelImgSrc"];
    [hotelModel4 setValue:@"丰泽园时尚房" forKey:@"hotelName"];
    [hotelModel4 setValue:@"80" forKey:@"unitPrice"];
    
    [hotelArr addObject:hotelModel1];
    [hotelArr addObject:hotelModel2];
    [hotelArr addObject:hotelModel3];
    [hotelArr addObject:hotelModel4];

}





@end
