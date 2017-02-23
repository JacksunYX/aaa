//
//  MyOrdersVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/5.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//





#import "MyOrdersVC+Methods.h"




@implementation MyOrdersVC (Methods)

#pragma mark ----- 统一视图加载方法
-(void)loadBaseView //加载基本视图
{

    ordersModelArr = [NSMutableArray new];  //初始化
    
    [self updataTheNavigationbar];          //修改导航栏
    
//    [self creatOrdersModelArr];             //创建虚拟订单数据
    
    [self creatTableView];                  //创建表视图
    
    [self getMyOrderListFromService];       //获取订单列表

}


-(void)updataTheNavigationbar   //导航栏设置
{
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(touchToPop)forControlEvents:UIControlEventTouchUpInside];
    
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
    self.title=@"我的订单";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNormal);
        
    }else{
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNight);
        
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    
}

-(void)creatTableView       //创建用于展示"个人中心"列表的表视图
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




#pragma mark ----- 交互方法

//从服务器获取当前用户的订单列表
-(void)getMyOrderListFromService
{

    [self loadIndicator];
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *getorderListStr= [[MainUrl stringByAppendingString:GetMyOrderList]mutableCopy];
    [getorderListStr appendFormat:@"?userId=%@&&deviceId=%@",CurrentUserId,deviceId];
    
//    NSLog(@"getorderListStr:%@",getorderListStr);
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:getorderListStr] cachePolicy:0 timeoutInterval:10.0];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
//            NSLog(@"订单列表dict:%@",dict);
            
            if ([dict objectForKey:@"resultCode"]) {
                
                //对反馈结果做选择
                switch ([[dict objectForKey:@"resultCode"]intValue]) {  //存在resultCode字段
                        
                    case 0:
                    {
                        
                        NSLog(@"失败");
                        
                    }
                        break;
                        
                    case 1:
                    {
                        
                        NSLog(@"成功");
                        
                    }
                        break;
                        
                    case 9:
                    {
                        
                        NSLog(@"用户不存在");
                        
                    }
                        break;
                        
                    case 14:
                    {
                        
                        NSLog(@"请求没有带deviceId");
                        
                    }
                        break;
                        
                    case 15:
                    {
                        
                        NSLog(@"该用户已在其他设备上登录");
                        
                        [self showString:@"当前用户已在其他设备登录了!"];
                        
                        ForceLoginout;  //强制注销
                        
                    }
                        break;
                        
                        
                    default:
                        break;
                }
                
            }else{  //不存在resultCode字段
            
                
            
            }
            
            if ([[dict objectForKey:@"resultCode"]isEqualToString:@"1"]) {  //代表请求成功
                
                if ([dict objectForKey:@"result"]) {    //存在字段result
                    
                    //添加进全局数组
                    ordersModelArr = [NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.mytableView reloadData];   //刷新表视图
                        
                        [activityIndicatorView stopAnimating];
                        
                    });
                    
                }else{
                    
                    [activityIndicatorView stopAnimating];
                
                    [self showString:@"还没有预订过房间哟~"];
                
                }
                
            }
            
        }else{
            
            [activityIndicatorView stopAnimating];
        
            [self showString:@"请求超时"];
        
        }
        
    }];

}

//取消当前订单
-(void)cancelOrderWithOrderId:(NSString *)orderId
{
    
    [self loadIndicator];
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSString *cancelOrderStr = [MainUrl stringByAppendingString:CancelOrder];
    
    NSURL *url = [NSURL URLWithString:cancelOrderStr];
    
    NSString *parm = [NSString stringWithFormat:@"deviceId=%@&&orderId=%@&&cancelReason=%@",deviceId,orderId,@"不想要了"];
    
    NSLog(@"parm:%@",parm);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[parm dataUsingEncoding:NSUTF8StringEncoding]];
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            [activityIndicatorView stopAnimating];
            
            if ([[dict objectForKey:@"resultCode"]isEqualToString:@"1"]) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"订单已取消" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                
                alert.tag = 80; //代表取消完订单的提示框
                
                [alert show];
                
            }else{
                
                [activityIndicatorView stopAnimating];
                
                [self showString:@"请求失败"];
                
            }
            
        }else{
            
            [activityIndicatorView stopAnimating];
            
            [self showString:@"请求超时"];
            
        }
        
    }];
    
}





#pragma mark ----- 辅助方法

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
}


-(void)touchToPop   //返回上一页
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)showString:(NSString *)str   //提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    //    hud.margin = 10.f;
    
    [hud sizeToFit];
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

-(IBAction)cancelOrder:(UIButton *)sender  //取消订单的点击事件
{
    
//    NSLog(@"tag:%ld",sender.tag);
    
    shouldBeCancelOrder = sender.tag;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您真的要取消当前订单吗?" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是的", nil];
    
    alert.tag = 120;    //作为取消提示框的标记
    
    [alert show];
    
}


#pragma mark ----- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 120) { //说明是询问取消订单的提示框
        
        if (buttonIndex == 1) {
            
            //            NSLog(@"取消了");
            [self cancelOrderWithOrderId:[NSString stringWithFormat:@"%ld",shouldBeCancelOrder]];
            
            
        }
        
    }else if (alertView.tag == 80){ //说明是提示已经取消订单的提示框
        
        if (buttonIndex == 0) {
            
            for (NSDictionary *dict in [ordersModelArr mutableCopy]) {
                
                if ([[dict objectForKey:@"orderId"]integerValue]==shouldBeCancelOrder) {
                    
                    [ordersModelArr removeObject:dict]; //移除这个对象，并且还要刷新表视图
                    
                    [self.mytableView reloadData];
                    
                    break;
                }
                
            }
            
        }
        
    }
    
    
}










@end
