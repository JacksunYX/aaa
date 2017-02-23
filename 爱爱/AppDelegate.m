//
//  AppDelegate.m
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/7.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.
//

#import "AppDelegate.h"

//#import "NewsViewController.h"//主页

//信鸽推送
#import "XGPush.h"
#import "XGSetting.h"

#import "AlipayHeader.h"    //支付宝集成库


#import "FirstViewController.h" //资讯页
#import "NewsVC.h"  //新的资讯页
#import "HotelReservationVC.h"  //酒店页
#import "MineDataVC.h"          //我的信息页

#import "RESideMenu.h"//侧边栏库

#import "NewSliderViewController.h" //新的侧边栏
#import "XXYNavigationController.h"//导航栏库
#import "IQKeyboardManager.h"  //键盘库
#import "PICoachmark/PICoachmark.h" //引导提示库
//#import "MJRefresh.h"

//第三方平台的SDK头文件，根据需要的平台导入。
#import <ShareSDK/ShareSDK.h>
//以下是腾讯QQ和QQ空间
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <QZoneConnection/QZoneConnection.h>
//微信
#import "WXApi.h"
//微博
#import "WeiboSDK.h"

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "UIViewController+JTNavigationExtension.h"  //导航栏库

#define FirstEnterNum   @"click01"


#import "ZWIntroductionViewController.h"//引导界面库
#import "EAIntroView.h" //新的引导页库

#import "FPSLabel.h"    //用来显示当前页面的fps


@interface AppDelegate ()<RESideMenuDelegate,UITabBarControllerDelegate,EAIntroDelegate>
{
    RESideMenu *sideMenuViewController;
    
    BMKMapManager* _mapManager;
    
    UITabBarController *tabBarVC;
    
}
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;   //引导页
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"程序启动了aaa");
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [IQKeyboardManager sharedManager];  //一键修改所有键盘高度自适应
    
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor =[UIColor whiteColor];

    [self initShareSDK];        //加载分享资源
    
    [self loadNewMainView];     //加载页面
    
    [self startTheBaiduMap];    //启动百度地图相关
    
    [self CreateSqlite];        //创建本地数据库
    
//    [self loadWelcomeView];     //加载引导页
    
    [self showBasicIntroWithBg];    //加载新的引导页
    
    [NSThread sleepForTimeInterval:1.0]; //让启动画面显示久一点
    
//    [self printFontsFamily];    //打印字体库
    
#pragma mark ----- 信鸽推送相关
    
    {
    
        //[XGPush handleReceiveNotification:nil];
        
        //初始化app
        //[XGPush startWithAppkey:@"IN421FX97FUT"];
        
        //[XGPush startAppForMSDK:354 appKey:@"xg354key"];
        
        
        [XGPush startApp:2200191370 appKey:@"IXUGN933D42P"];
        
        //注销之后需要再次注册前的准备
        void (^successCallback)(void) = ^(void){
            //如果变成需要注册状态
            if(![XGPush isUnRegisterStatus])
            {
                //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
                
                float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
                if(sysVer < 8){
                    [self registerPush];
                }
                else{
                    [self registerPushForIOS8];
                }
#else
                //iOS8之前注册push方法
                //注册Push服务，注册后才能收到推送
                [self registerPush];
#endif
            }
        };
        [XGPush initForReregister:successCallback];
        
        //[XGPush registerPush];  //注册Push服务，注册后才能收到推送
        
        
        //推送反馈(app不在前台运行时，点击推送激活时)
        [XGPush handleLaunching:launchOptions];
        
        //推送反馈回调版本示例
        void (^successBlock)(void) = ^(void){
            //成功之后的处理
            NSLog(@"[XGPush]handleLaunching's successBlock");
            
        };
        
        void (^errorBlock)(void) = ^(void){
            //失败之后的处理
            NSLog(@"[XGPush]handleLaunching's errorBlock");
        };
        
        //角标清0
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        //清除所有通知(包含本地通知)
//        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
        
        //本地推送示例
        
//         NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:10];
//         
//         NSMutableDictionary *dicUserInfo = [[NSMutableDictionary alloc] init];
//         [dicUserInfo setValue:@"myid" forKey:@"clockID"];
//         NSDictionary *userInfo = dicUserInfo;
//         
//         [XGPush localNotification:fireDate alertBody:@"测试本地推送" badge:2 alertAction:@"确定" userInfo:userInfo];
        
    
    }
    
//    [FPSLabel showInWindow:self.window];    //显示fps
    
    return YES;
}

-(void)printFontsFamily //打印当前项目中的字体库
{

    NSArray *fontFamilies = [UIFont familyNames];
    NSLog(@"字体数量%ld",fontFamilies.count);
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }

}



-(void)loadWelcomeView  //加载引导页面
{

    if (![[[NSUserDefaults standardUserDefaults] objectForKey:FirstEnterNum]isEqualToString:@"YES"]) {
        
        //引导页创建
        NSArray *coverImageNames = @[@"yd11.png", @"yd22.png", @"yd33.png"];//文字
        NSArray *backgroundImageNames = @[@"yd1.png", @"yd2.png", @"yd3.png"];//图片
        
        self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
        [self.window addSubview:self.introductionView.view];
        
        __weak AppDelegate *weakSelf = self;
        self.introductionView.didSelectedEnter = ^() {
            
            [UIView animateWithDuration:0.5 animations:^{   //先用动画隐藏引导页
                
                weakSelf.introductionView.view.alpha=0;
                
            } completion:^(BOOL finished) { //完成动画后清除
                
                [weakSelf.introductionView.view removeFromSuperview];
                weakSelf.introductionView = nil;
                
//                [weakSelf creatPopView];
                
            }];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:FirstEnterNum];
            
        };
    }

}

- (void)showBasicIntroWithBg    //新的引导页
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:FirstEnterNum]isEqualToString:@"YES"]) {
     
        return;
        
    }
    
    EAIntroPage *page1 = [EAIntroPage page];
//    page1.title = @"Hello world";
//    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.bgImage = [UIImage imageNamed:@"1.png"];
//    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
//    page2.title = @"This is page 2";
//    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    page2.bgImage = [UIImage imageNamed:@"2.png"];
//    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
//    page3.title = @"This is page 3";
//    page3.desc = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
    page3.bgImage = [UIImage imageNamed:@"3.png"];
//    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:[UIScreen mainScreen].bounds andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    [intro showInView:tabBarVC.view animateDuration:0.0];
}

#pragma mark ----- 引导页完成的代理方法
-(void)introDidFinish
{

    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:FirstEnterNum];

}


-(void)startTheBaiduMap //启动百度地图相关
{

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"s94ogAM4zA0DIk5kfC1jHhs9"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

}

-(void)creatPopView //创建引导提示
{
    
//    NSMutableDictionary* coachMarkDict1 =[NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ResidePoptip" ofType:@"plist"]];
//    NSMutableDictionary* coachMarkDict2 = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LogPoptip" ofType:@"plist"]];
//    
//    NSMutableDictionary* coachMarkDict3 = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RefreshPoptip" ofType:@"plist"]];

    
    NSDictionary *coachMarkDict1 =@{
                                    @"duration" : @"0.5",
                                    @"imageName" : @"ResidePoptip@x3.png",
                                    @"maskRect" : @"{{0,20},{44,44}}",
                                    @"maskRectCornerRadius" : @30,
                                    @"viewRect" : @"{{40,50},{100,100}}"
                                    };


    
    NSString *RefreshMaskRectstr =[NSString stringWithFormat:@"{{%f,%d},{%d,%d}}",Width-44,20,44,44];
    NSString *RefreshViewRectstr =[NSString stringWithFormat:@"{{%f,%d},{%d,%d}}",Width-44-100,50,100,100];
    
    NSDictionary *coachMarkDict2 =@{
                                    @"duration" : @"0.5",
                                    @"imageName" : @"RefreshPoptip@x3.png",
                                    @"maskRect" : RefreshMaskRectstr,
                                    @"maskRectCornerRadius" : @30,
                                    @"viewRect" : RefreshViewRectstr
                                    };
    
    
    PIImageCoachmark* coachmark1 = [[PIImageCoachmark alloc] initWithDictionary:coachMarkDict1];
    PIImageCoachmark* coachmark2 = [[PIImageCoachmark alloc] initWithDictionary:coachMarkDict2];
    
    
    PICoachmarkScreen* screen1 = [[PICoachmarkScreen alloc] initWithCoachMarks:@[coachmark1]];
    PICoachmarkScreen* screen2 = [[PICoachmarkScreen alloc] initWithCoachMarks:@[coachmark2]];
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    PICoachmarkView *coachMarksView = [[PICoachmarkView alloc]
                                       initWithFrame:window.bounds];
    [window addSubview:coachMarksView];
    [coachMarksView setScreens:@[screen1,screen2]]; //添加
    [coachMarksView start]; //开始交互
    
}

//强行禁止用户横屏
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


//建立数据库
-(void)CreateSqlite
{
    //沙盒路径
    NSString *path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //数据库绝对路径
    path = [path stringByAppendingPathComponent:@"aiaiData.db"];
    NSLog(@"%@",path);
    //建立数据库
    self.db =[FMDatabase databaseWithPath:path];
    //能成功打开就开始添加表格
    if ([self.db open]) {
        
        NSLog(@"打开数据库成功");
        
        //目前需要创建的数据库表(用户信息表,新闻列表,新闻详情表,浏览历史表)
        NSString *creatUserTable =@"create table if not exists UserTable(userId text,nickname text,userImg blob,email text,gender text,birthday text,location text,phoneNum text)";//用户信息表
        
        NSString *creatNewDetailTable =@"create table if not exists NewsTable(newsId integer,title text,imageSrc text,content text,views integer,commentNum interger,publishTime text,source text,contentType integer,descriptions text,imgPath text)";  //新闻详情表
        
        NSString *creatBrowsHistoryTable =@"create table if not exists BrowsHistoryTable(newsId text,contentType integer,title text,titleImg blob,publishTime text,source text,browsTime text,shareUrl text)";//浏览历史表
        
        //首页新闻表(推荐区和其他区)
        NSString *creatRecommendNewTable =@"create table if not exists RecommendNewTable(newsId text,contentType integer,commentNum integer,imageSrc text,publishTime text,title text,views text)";
        NSString *creatOtherNewTable =@"create table if not exists OtherNewTable(baseObjectId text,newsDateId text,commentNum integer,contentType integer,imageSrc text,newsId text,publishTime text,title text,views text,pictures text)";
        
        //离线阅读表
        NSString *offlineNewsDataTable =@"create table if not exists offlineNewsDataTable(title text,content text,imageSrc text,source text,publishTime text,views text,newsId text,commentNum integer,contentType integer,titleImg blob,descriptions text,image blob)";
        
        //执行语句创建表格
        BOOL b=({
            
            [_db executeUpdate:creatUserTable];             //用户信息表
            
            [_db executeUpdate:creatBrowsHistoryTable];     //浏览历史表
            
            [_db executeUpdate:creatNewDetailTable];        //新闻详情表
            
            [_db executeUpdate:creatRecommendNewTable];     //推荐区缓存表
            [_db executeUpdate:creatOtherNewTable];         //其他区缓存表
            
            [_db executeUpdate:offlineNewsDataTable];       //离线阅读缓存表

        });
        if (b) {
            NSLog(@"建表成功");
        }else
        {
            NSLog(@"建表失败");
        }
    }
}



-(void)loadNewMainView      //加载新的主界面
{
    //根视图
//    self.rootViewController =[[FirstViewTabBarVC alloc]init];
    
    //创建UITabBarController
    tabBarVC =[[UITabBarController alloc]init];
    tabBarVC.view.backgroundColor=[UIColor whiteColor];
    
    UIColor *color =tabBarVC.tabBar.barTintColor;
    
    self.tabbarController =tabBarVC;
    
    self.tabbarController.delegate=self;
    
    //字体颜色
    tabBarVC.tabBar.dk_tintColorPicker=DKColorWithColors(MainThemeColor, TitleTextColorNight);
    //背景色
    tabBarVC.tabBar.dk_barTintColorPicker=DKColorWithColors(color, SecondaryNightBackgroundColor);
    
    //资讯页
    JTNavigationController *firstVC = [[JTNavigationController alloc]initWithRootViewController:[[NewsVC alloc]init]];
    firstVC.tabBarItem.title = @"资 讯";
    firstVC.tabBarItem.image = [[UIImage imageNamed:@"newsNotSelected_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]; ///(防止添加的图片被更改为填充色)
    firstVC.tabBarItem.selectedImage =[[UIImage imageNamed:@"newsSelected_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    firstVC.closePopGesture = YES;
    firstVC.fullScreenPopGestureEnabled = YES;
    
    //酒店页
    JTNavigationController *hotelVC = [[JTNavigationController alloc]initWithRootViewController:[[HotelReservationVC alloc]init]];
    hotelVC.tabBarItem.title = @"酒 店";
    hotelVC.tabBarItem.image = [[UIImage imageNamed:@"hotelNotSelected_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];  ///(防止添加的图片被更改为填充色)
    hotelVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"hotelSelected_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    hotelVC.closePopGesture = YES;
    hotelVC.fullScreenPopGestureEnabled = YES;
    
    //"我的"页
    JTNavigationController *mineVC = [[JTNavigationController alloc]initWithRootViewController:[[MineDataVC alloc]init]];
    mineVC.tabBarItem.title = @"我";
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"meNotSelected_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];  ///(防止添加的图片被更改为填充色)
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"meSelected_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    mineVC.closePopGesture = YES;
    mineVC.fullScreenPopGestureEnabled = YES;
    
    tabBarVC.viewControllers=[NSArray arrayWithObjects:firstVC,hotelVC,mineVC, nil];
    
    // 矫正TabBar图片位置，使之垂直居中显示
//    CGFloat offset = 5.0;
//    for (UITabBarItem *item in tabBarVC.tabBar.items) {
//        item.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//    }
 /*
    //取消侧边栏(以后再整理)
//    NewSliderViewController *leftView = [[NewSliderViewController alloc]init];
    
    _sideViewController = [[YRSideViewController alloc]init];
    _sideViewController.leftViewController=nil;
    _sideViewController.rootViewController=tabBarVC;
    
    _sideViewController.leftViewShowWidth=Width*2/3;    //侧边栏的宽度
    _sideViewController.needSwipeShowMenu=YES;//默认开启可滑动展示
    _sideViewController.showBoundsShadow=YES;    //显示阴影
    [_sideViewController setRootViewMoveBlock:^(UIView *rootView, CGRect orginFrame, CGFloat xoffset) {
        //使用简单的平移动画
        rootView.frame=CGRectMake(xoffset, orginFrame.origin.y, orginFrame.size.width, orginFrame.size.height);
    }];
  
    */
    
    self.rootViewController =firstVC;
    self.hotelViewController=hotelVC;
    self.userDataViewController=mineVC;
    self.window.rootViewController=tabBarVC;
    [self.window makeKeyAndVisible];
    
    [tabBarVC setSelectedIndex:2];  //为避免通知无法被用户界面接收到，使用一个比较低劣的手法
    [self performSelector:@selector(selectHomeView) withObject:nil afterDelay:0.3f];
    
    
    //向通知中心注册开启/关闭侧滑功能的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableRESideMenu) name:@"disableRESideMenu" object:nil];//关闭
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableRESideMenu) name:@"enableRESideMenu" object:nil];//开启
//  

    
}

//设定首页
-(void)selectHomeView
{

    [tabBarVC setSelectedIndex:1];  //手动选定某页

}

- (void)enableRESideMenu {
    //开启侧滑跳出侧边栏
    sideMenuViewController.panGestureEnabled = YES;
    _sideViewController.needSwipeShowMenu=YES;
}

- (void)disableRESideMenu {
    //关闭侧滑跳出侧边栏
    sideMenuViewController.panGestureEnabled = NO;
    _sideViewController.needSwipeShowMenu=NO;
}



-(void)initShareSDK //初始化shareSDK
{
    [ShareSDK registerApp:@"eaafc0ca0400"];
    [ShareSDK version];
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    //    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
    //                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
    //                             redirectUri:@"http://www.sharesdk.cn"
    //                             ];
    [ShareSDK connectSinaWeiboWithAppKey:@"2801504395"
                               appSecret:@"ed82a5c219190c00b103e815c0b3ffa7"
                             redirectUri:@"http://www.aiai.com"
                             weiboSDKCls:[WeiboSDK class]];
    
    
    // 下面这个方法，如果不想用新浪客户端授权，只用web的话可以使用
    //    [ShareSDK connectSinaWeiboWithAppKey:@"" appSecret:@"" redirectUri:@""];
    
    
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectQZoneWithAppKey:@"1105110492"
                           appSecret:@"VhSgluZaKqg2QNxX"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //    //开启QQ空间网页授权开关(optional), 开启授权一定要在上面注册方法之后
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];
    
    [QQApiInterface isQQInstalled];
    
    
    //连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
    //http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
    //**/
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wx2e6224a289bf2540"
                           appSecret:@"a3e58b1dd053be0ccc9de34ba81182e3"
                           wechatCls:[WXApi class]];
    //
    
    /**
     连接豆瓣应用以使用相关功能，此应用需要引用DouBanConnection.framework
     http://developers.douban.com上注册豆瓣社区应用，并将相关信息填写到以下字段
     **/
//    [ShareSDK connectDoubanWithAppKey:@"02e2cbe5ca06de5908a863b15e149b0b"
//                            appSecret:@"9f1e7b4f71304f2f"
//                          redirectUri:@"http://www.sharesdk.cn"];
    
}

#pragma mark - WXApiDelegate(optional)
-(void) onReq:(BaseReq*)req
{
    
    
}

-(void) onResp:(BaseResp*)resp
{
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
#pragma mark ----- 支付宝回调相关
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK if ([url.host isEqualToString:@"safepay"]) {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
//        NSString *message = @"";
        int result = [[resultDic objectForKey:@"resultStatus"] intValue];
//        switch(result)
//        {
//            case 9000:message = @"订单支付成功";break;
//            case 8000:message = @"正在处理中";break;
//            case 4000:message = @"订单支付失败";break;
//            case 6001:message = @"用户中途取消";break;
//            case 6002:message = @"网络连接错误";break;
//            default:message = @"未知错误";
//        }
//        
//        UIAlertController *aalert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//        [aalert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil]];
//        UIViewController *root = self.window.rootViewController;
//        [root presentViewController:aalert animated:YES completion:nil];
        
        //将返回结果以通知的方式传递到填写订单的页面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayResult" object:@(result)];
        
//        NSLog(@"result = %@",resultDic);
    }];
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
#pragma mark -----
    
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {  //将要进入后台
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//应用程序进入前台时调用
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"程序将要进入前台");
    
    if(_SettingVCHaveCreated==YES)  //修改推送开关状态的通知相关
    {
        
        NSLog(@"发送修改推送状态的通知");
        
        //标记数据
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"notification",nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"SetNotification" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    
    if (_before!=_after) {  //默认都为0，如果不相等，说明进行过修改，此时需要发送通知
        
        NSLog(@"发送修改定位状态的通知");
        
        _before = _after;   //同步，防止反复发送通知
        
        //标记数据
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"2",@"notification",nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"SetLocation" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

#pragma mark ----- UITabbarController delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    static int clickNum=0;    //计算点击次数
    
//    NSLog(@"点击前clickNum:%d",clickNum);

    if (self.tabbarController.selectedIndex==0) {
        
        clickNum++;
        
//        NSLog(@"点击后clickNum:%d",clickNum);
        
        if (clickNum>=2) {  //此时说明点了2次以上了,可以刷新界面了
            
            FirstViewController *fv =self.rootViewController.jt_viewControllers[0];
            
            //不在刷新状态时才会刷新
            if (fv.mytableView.mj_header.state!=MJRefreshStateRefreshing) {
                
                [fv.mytableView.mj_header beginRefreshing];
                
            }
            
        }
        
    }else{
    
        clickNum=0;
    
    }

}




#pragma mark ----- 信鸽推送相关

- (void)registerPushForIOS8
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    //    [acceptAction release];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    //    [inviteCategory release];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
//    NSLog(@"设置完成反馈");
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush Demo]register successBlock");
        
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush Demo]register errorBlock");
    };
    
    // 设置账号(直接使用当前设备的设备号注册)
//    [XGPush setAccount:@"15623906285"];
    //[[NSString alloc]initWithData:deviceToken encoding:NSUTF8StringEncoding]
    
    //注册设备
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
//    [XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"[XGPush Demo] deviceTokenStr is %@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"[XGPush Demo]%@",str);
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    
    //回调版本示例
    /*
     void (^successBlock)(void) = ^(void){
     //成功之后的处理
     NSLog(@"[XGPush]handleReceiveNotification successBlock");
     };
     
     void (^errorBlock)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[XGPush]handleReceiveNotification errorBlock");
     };
     
     void (^completion)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[xg push completion]userInfo is %@",userInfo);
     };
     
     [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
     */
}







@end
