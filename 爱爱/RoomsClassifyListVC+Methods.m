//
//  RoomsClassifyListVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define SelectListViewHeight 50    //多端选项视图的高度




#import "RoomsClassifyListVC+Methods.h"

@implementation RoomsClassifyListVC (Methods)

-(void)loadBaseView //加载基本视图
{
 
    roomsArr = [NSMutableArray new];
    
    [self updataTheNavigationbar];         ///修改导航栏显示
    
//    [self creatRoomsData];   //创建虚拟数据
    
    [self creatTableView];      ///创建tableView
    
    [self getCurrentClassifyRoomList];   //获取当前主题的房间列表(暂无数据)
    
}

#pragma  mark ----- 视图创建

-(void)updataTheNavigationbar   //导航栏设置
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
    self.title=[self.model objectForKey:@"classify"];
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNormal);
        
    }else{
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNight);
        
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    //打开手势侧滑功能
    //    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
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
    self.mytableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.mytableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
}





#pragma mark ----- 交互方法

-(void)getCurrentClassifyRoomList   //获取当前主题的房间列表
{
    [self loadIndicator];   //加载进度圈
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *roomListUrl= [[MainUrl stringByAppendingString:GetRoomList]mutableCopy];
    [roomListUrl appendFormat:@"?zoneCode=%@&&roomThemeId=%@&&deviceId=%@",[self.model objectForKey:@"zoneCode"],[self.model objectForKey:@"roomThemeId"],deviceId];
    
//    NSLog(@"roomLisUrl:%@",roomListUrl);
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:roomListUrl] cachePolicy:0 timeoutInterval:10.0];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"房间列表:%@",dict);
            
            NSArray *arr = [dict objectForKey:@"result"];
            
            if (arr.count>0) {     //数量大于零，可以开始刷新页面了
                
                for (int i =0; i<arr.count; i++) {
                    
                    NSDictionary *roomDic = arr[i];
                    
                    ThemeRoomModel *roomModel = [ThemeRoomModel new];
                    
                    //赋值
                    [roomModel setValue:[roomDic objectForKey:@"roomId"]        forKey:@"roomId"];
                    [roomModel setValue:[roomDic objectForKey:@"hotelName"]     forKey:@"belongHotel"];
                    [roomModel setValue:[roomDic objectForKey:@"roomPicture"]   forKey:@"imageSrc"];
                    [roomModel setValue:[roomDic objectForKey:@"roomPrice"]     forKey:@"unitPrice"];
                    [roomModel setValue:[roomDic objectForKey:@"roomType"]      forKey:@"theme"];
                    [roomModel setValue:[roomDic objectForKey:@"roomStory"]     forKey:@"introduction"];
                    
                    [roomsArr addObject:roomModel]; //添加进全局数组
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [activityIndicatorView stopAnimating];   //隐藏进度圈
                
                [self.mytableView reloadData];          //刷新表视图
                
            });
            
            
            
        }else{
            
            [activityIndicatorView stopAnimating];   //隐藏进度圈
            
            [self showString:@"请求超时"];
            
        }
        
    }];

}






#pragma  mark ----- 辅助方法

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
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

-(void)touchtoPop
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)creatRoomsData   //创建虚拟数据
{

    ThemeRoomModel *roomModel1 =[[ThemeRoomModel  alloc]init];
    [roomModel1 setValue:@"http://www.tianelian.com/uploads/housetype/post-thumbnail/5594c5eb36025.jpg" forKey:@"imageSrc"];
    [roomModel1 setValue:@"教师别恋" forKey:@"theme"];
    [roomModel1 setValue:@"天鹅恋情侣酒店(华科店)" forKey:@"belongHotel"];
    [roomModel1 setValue:@"368" forKey:@"unitPrice"];
    
    ThemeRoomModel *roomModel2 =[[ThemeRoomModel  alloc]init];
    [roomModel2 setValue:@"http://pic31.nipic.com/20130726/8952533_152834945000_2.jpg" forKey:@"imageSrc"];
    [roomModel2 setValue:@"罗马落日" forKey:@"theme"];
    [roomModel2 setValue:@"天鹅恋情侣酒店(关山店)" forKey:@"belongHotel"];
    [roomModel2 setValue:@"298" forKey:@"unitPrice"];
    
    ThemeRoomModel *roomModel3 =[[ThemeRoomModel  alloc]init];
    [roomModel3 setValue:@"http://image95.360doc.com/DownloadImg/2016/03/2405/68325341_2.jpg" forKey:@"imageSrc"];
    [roomModel3 setValue:@"沙滩之子" forKey:@"theme"];
    [roomModel3 setValue:@"天鹅恋情侣酒店(华科店)" forKey:@"belongHotel"];
    [roomModel3 setValue:@"233" forKey:@"unitPrice"];
    
    ThemeRoomModel *roomModel4 =[[ThemeRoomModel  alloc]init];
    [roomModel4 setValue:@"http://tupian.enterdesk.com/2013/lxy/12/3/1/6.jpg" forKey:@"imageSrc"];
    [roomModel4 setValue:@"仙剑忆情" forKey:@"theme"];
    [roomModel4 setValue:@"天鹅恋情侣酒店(华科店)" forKey:@"belongHotel"];
    [roomModel4 setValue:@"998" forKey:@"unitPrice"];
    
    [roomsArr addObject:roomModel1];
    [roomsArr addObject:roomModel2];
    [roomsArr addObject:roomModel3];
    [roomsArr addObject:roomModel4];
    
}









@end
