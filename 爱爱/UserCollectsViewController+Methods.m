//
//  UserCollectsViewController+Methods.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/8.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

//自定义颜色宏

#define TextNightColor [UIColor colorWithRed:218.0f/255.0f green:218.0f/255.0f blue:218.0f/255.0f alpha:1.0f]




#import "UserCollectsViewController+Methods.h"

#import "AFNetworking.h"



@implementation UserCollectsViewController (Methods)

#pragma  mrak ---视图创建及请求发送的统一方法

-(void)creatViewAndsendRequest  //视图创建及请求发送的统一方法
{
    
//    if (newsModelArr.count==0)//创建log
//    {
//        logImage =[[UIImageView alloc]initWithFrame:CGRectMake(Width*0.4, Height*0.3, 69, 24)];
//        [logImage setImage:[UIImage imageNamed:@"log_small.png"]];
//        [self.view addSubview:logImage];
//    }
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(touchToManageTheCollects)];
    self.navigationItem.rightBarButtonItem.dk_tintColorPicker=DKColorWithColors([UIColor blueColor], MainThemeColor);
    self.navigationItem.rightBarButtonItem.enabled=NO; //关闭上传功能
    
    [self creatNavigationView];
    
    [self creatTableView];      //创建视图
    
    [self creatToolbarView];    //创建工具栏
}



#pragma mark ---视图加载

-(void)creatNavigationView//添加导航栏按钮相关
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
    self.title=@"我的收藏";
    
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNormal);
        
    }else{
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNight);
        
    }
    
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    [self.navigationItem.rightBarButtonItem setTintColor:MainThemeColor];

}

-(void)creatTableView//创建表视图
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc]init];

    self.tableView.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    self.tableView.separatorInset=UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;  //当编辑模式开启时允许变为选择模式
    self.automaticallyAdjustsScrollViewInsets = NO;
}


-(void)touchToManageTheCollects     //  点击开启/关闭批量删除收藏功能
{
    
//    self.navigationController.toolbar.frame=CGRectMake(0, self.navigationController.toolbar.frame.origin.y+49, Width, self.navigationController.toolbar.frame.size.height);

    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        
        [self.tableView setEditing:YES animated:YES];
        
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        
        [self.navigationController setToolbarHidden:NO animated:YES];
        
    }else{
        
        [self.tableView setEditing:NO animated:YES];
    
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        
        [self.navigationController setToolbarHidden:YES animated:YES];
    
    }
    
//    NSLog(@"ToolBarOriginY2:%f",self.navigationController.toolbar.frame.origin.y);

}

-(void)creatToolbarView     //在工具栏上添加按钮
{
    
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    self.navigationController.toolbar.dk_barTintColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    //创建按钮
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(touchToSelectAllCells)];
    UIBarButtonItem *btn2=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(touchToDeleteCells)];
    btn1.dk_tintColorPicker=DKColorWithColors(MainThemeColor, ContentTextColorNight);
    btn2.dk_tintColorPicker=DKColorWithColors(MainThemeColor, ContentTextColorNight);
    //空格
    UIBarButtonItem *spaceBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *arr1=[[NSArray alloc]initWithObjects:spaceBtn,btn1,spaceBtn,btn2,spaceBtn, nil];
    self.toolbarItems=arr1;
    
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

#pragma mark---请求方法

-(void)sendRequestToGetCollectList  //获取用户收藏列表
{
    
    if (newsModelArr.count<=0) {
        
        [self loadIndicator];
        
    }
    
    newsModelArr = [NSMutableArray new];
    
    deleteArr    = [NSMutableArray new];
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *Urlstr = [[MainUrl stringByAppendingString:CollectUrl]mutableCopy];
    
    [Urlstr appendFormat:@"?userId=%@&&deviceId=%@",CurrentUserId,deviceId];
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:Urlstr] cachePolicy:0 timeoutInterval:10.0];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(data){
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"收藏列表返回dict:%@",dict);
            
            NSArray *newsArr =[dict objectForKey:@"result"];
            
            if (newsArr.count) {
                
                for (int i=0; i<newsArr.count; i++) {   //遍历数组
                    
                    NewsSourceModel *newsModel=[[NewsSourceModel alloc]init];
                    NSDictionary *dic =newsArr[i];
                    NSArray *keyarr =[dic allKeys];
                    
                    for (NSString *key in keyarr) {
                        [newsModel setValue:[dic objectForKey:key] forKey:key];
                    }
                    [newsModelArr addObject:newsModel];
                }
                
                self.navigationItem.rightBarButtonItem.enabled=YES; //开启批量编辑功能
                
                [activityIndicatorView stopAnimating];
                
                [self.tableView reloadData];
                
            }else{
                
                self.navigationItem.rightBarButtonItem.enabled=NO; //关闭批量编辑功能

                [activityIndicatorView stopAnimating];
                
                [self showString:@"暂无收藏,快点去收藏点东西吧~"];
                
            }

            
        }else{
            
//            [hud hide:YES];
            [activityIndicatorView stopAnimating];
            
            [self showString:@"请求超时"];
            
            [self delayTimeToExecute];  //延时1s跳回前一个页面
            
        }
    }];
}

-(void)touchToDeleteCells           //点击删除多个cell
{
    
    if (self.tableView.editing) {
        
        if (deleteArr.count) {
            
            NSString *deviceId = [self getDeviceId]; //获取设备标识
            
            NSString *deleteUrl = [[MainUrl copy] stringByAppendingString:DeleteCollects];
            
            NSString *collects =@"";
            
            //删除服务器端的收藏数据
            for (NewsSourceModel *newsModel in deleteArr) {
                
                if (newsModel == [deleteArr lastObject]) {
                    
                    collects = [collects stringByAppendingString:[NSString stringWithFormat:@"%@",newsModel.newsId]];
                    
                }else{
                    
                    collects = [collects stringByAppendingString:[NSString stringWithFormat:@"%@,",newsModel.newsId]];
                    
                }
            }
            
//            NSLog(@"collects:%@",collects);
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain",@"text/html", nil];
            manager.securityPolicy.allowInvalidCertificates = YES;
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            //构造请求体的字典
            NSDictionary *parameters = @{
                                         
                                         @"userId":CurrentUserId,
                                         @"contentIds":collects,
                                         @"deviceId":deviceId,
                                         
                                         };
            
            [manager POST:deleteUrl parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                NSLog(@"批量删除收藏返回responseObject:%@",responseObject);
                
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                
                NSLog(@"操作失败");
                
            }];
            
            //删除本地表格的收藏数据
            [newsModelArr removeObjectsInArray:deleteArr];
            
            [self.tableView reloadData];
            
            [self.tableView setEditing:NO animated:YES];
            
            [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
            
            [self.navigationController setToolbarHidden:YES animated:YES];
            
            if (!newsModelArr.count) {
                
                self.navigationItem.rightBarButtonItem.enabled=NO;
                
            }
            
            [deleteArr removeAllObjects];
            
            
            
        }else{
            
            [self showString:@"请选择了以后再进行删除操作~"];
            
        }
        
    }
    
    else return;
    
    
    
}

-(void)deleteSingleCollectWithNewId:(NSNumber *)newsId  //滑动删除单个新闻
{

    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *Urlstr = [[MainUrl stringByAppendingString:commandUrl]mutableCopy];
    //拼接完整url
    [Urlstr appendFormat:@"?objectId=%@&userId=%@&command=%d&contentType=%d&&deviceId=%@",newsId,CurrentUserId,0,1,deviceId];
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:Urlstr]cachePolicy:0 timeoutInterval:5.f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
//            NSLog(@"result:%@",[dict objectForKey:@"resultCode"]);
            
            if ([[dict objectForKey:@"resultCode"] isEqualToString:@"1"]) {
                
                NSLog(@"已取消收藏");
                
            }else{
                
                NSLog(@"操作失败");
                
            }
            
        }else{
            
            NSLog(@"操作失败,可能是网络原因");
            
        }
        
    }];

}


#pragma mark ---辅助方法

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
}

-(void)touchToPop       //返回上一页
{
    
    [self.navigationController popViewControllerAnimated:YES];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //获取侧边栏的视图
    YRSideViewController *sideViewController=[delegate sideViewController];
    
    [sideViewController  showLeftViewController:YES];
}


-(void)showString:(NSString *)str//提示框
{
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    hud2.mode = MBProgressHUDModeText;
    hud2.labelText = str;
    hud2.margin = 10.f;
//    hud.cornerRadius=20;
    hud2.removeFromSuperViewOnHide = YES;
    
    [hud2 hide:YES afterDelay:2];
}


-(void)touchToSelectAllCells    //  点击 全选/取消全选 当前所有单元格
{
    static int i=0;
    
    if (!i) {
        
        for (int i = 0; i<newsModelArr.count; i++) {  //row
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            
        }
        
        [deleteArr removeAllObjects];
        [deleteArr addObjectsFromArray:newsModelArr];
        
        i=1;
        
    }else{
    
        for (int i = 0; i<newsModelArr.count; i++) {  //row
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
        
        [deleteArr removeAllObjects];
        
        i=0;
    
    }
    
    

}


-(void)delayTimeToExecute   //延时执行
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self touchToPop];
        
    });
    
}










@end
