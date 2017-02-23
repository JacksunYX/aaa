//
//  VideoNewVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/10.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "VideoNewVC+Methods.h"

#import "NewLoginViewController.h"  //新的登录界面
#import "CommendSourceModel.h"  //评论组

#import "Reachability.h"
#import "MJRefresh.h"
#import "WZLBadgeImport.h"      //按钮小红点库
#import "IQKeyboardManager.h"   //键盘库

//以下是腾讯QQ和QQ空间
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <QZoneConnection/QZoneConnection.h>
//微信
#import "WXApi.h"
//微博
#import "WeiboSDK.h"

#import "KrVideoPlayerController.h" //视频库

@implementation VideoNewVC (Methods)

#pragma mark --- 创建视图及发送请求统一方法
-(void)creatViewandSendRequest//创建视图及发送请求统一方法
{

    
    [self changeNavigationBarState];//调整导航栏显示
    
    [self loadLogImage];            //加载log
    
    [self sendRequestToGetData];    //发送请求获取视频资源
    
    [self addVideoPlayer];   //开启视频
    
}




#pragma mark ---视图创建方法

-(void)loadLogImage     //加载log图片
{
    if (!logImage) {
        logImage =[[UIImageView alloc]initWithFrame:CGRectMake(Width*0.4, Height*0.3, 69, 24)];
        [logImage setImage:[UIImage imageNamed:@"log_small.png"]];
        logImage.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
        [self.view addSubview:logImage];
    }
}

-(void)changeNavigationBarState //修改导航栏
{
    
    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    //导航栏颜色
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    //修改左侧按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
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
    
    self.navigationController.toolbarHidden=YES;
    
    //打开手势侧滑功能
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    //关闭侧边栏侧滑
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
}



- (void)addVideoPlayer
{
    
    NSURL *url = [NSURL URLWithString:@"http://119.29.80.151/py/qwe.mp4"];
    
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, width, width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            [weakSelf toolbarHidden:NO];
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            [weakSelf toolbarHidden:YES];
        }];
        [self.view addSubview:self.videoController.view];
    }
    self.videoController.contentURL = url;
    
}
//隐藏navigation tabbar 电池栏
- (void)toolbarHidden:(BOOL)Bool
{
    self.navigationController.navigationBar.hidden = Bool;
    self.tabBarController.tabBar.hidden = Bool;
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}


-(void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];
    
    [self.videoController dismiss];

}

-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    [self.videoController pause];

}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    [self.videoController play];
    
}


#pragma mark ----- 交互方法

-(void)sendRequestToGetData //发送上拉加载的请求并获取数据
{
    //判断是否有网络
    Reachability *re =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status =[re currentReachabilityStatus];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"])     //离线阅读的模式下(取本地数据)
    {
        
        
    }else if(status==0){                //无网络
        
        [self showAlertView:@"请检查网络环境~"];
        
    }else//有网络
    {
        
        if (ToUpdataComend) {
            NSLog(@"刷新评论");
            [self UrlComment];//发送评论请求
            
        }else{
            
            [self UrlNews];//发送新闻请求
            
        }
    }
}



-(void)UrlNews      //发送请求详细新闻数据的请求
{
        
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSMutableString *Urlstr = [[MainUrl stringByAppendingString:newsDetail]mutableCopy];
    
    if (CurrentUserId) {    //是否登录
        
        [Urlstr appendFormat:@"?newsId=%@&userId=%@",self.newsModel.newsId,CurrentUserId];
        
    }else{
        
        [Urlstr appendFormat:@"?newsId=%@&userId=",self.newsModel.newsId];
        
    }
    //拼接完整url
    
    //    NSLog(@"Urlstr:%@",Urlstr);
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:Urlstr] cachePolicy:0 timeoutInterval:10.0];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(data){
            
//            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"视频dic:%@",dic);
            
        }else{
            
            [self showString:@"请求超时"];
            
        }
        
    }];

}

-(void)UrlComment   //加载评论
{
    NSLog(@"开始加载评论");
    

}









#pragma mark ----- 辅助方法

-(NSMutableString *)getTheCurrentDate   //取得当前时间字符串数据
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *date=[nsdf2 stringFromDate:[NSDate date]];//取得当前时间的字符串
    
    NSMutableString *str =[date mutableCopy];//copy为可变的
    
    //对时间字符串进行加工
    [str deleteCharactersInRange:NSMakeRange(16, 1)];
    [str deleteCharactersInRange:NSMakeRange(13, 1)];
    [str deleteCharactersInRange:NSMakeRange(10, 1)];
    [str deleteCharactersInRange:NSMakeRange(7, 1)];
    [str deleteCharactersInRange:NSMakeRange(4, 1)];
    //    NSLog(@"%@  %lu",str,str.length);
    return str;
}

-(void)showString:(NSString *)str       //提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    //    hud.margin = 10.f;
    hud.cornerRadius=20;
    hud.removeFromSuperViewOnHide = YES;
    [hud sizeToFit];
    [hud hide:YES afterDelay:1];
}

-(void)showAlertView:(NSString *)string //警告框
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}

-(void)touchToPop   //返回上一页
{
    [self.navigationController popViewControllerAnimated:YES];
}












@end
