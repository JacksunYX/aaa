//
//  FirstViewController+Methods.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/19.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define tableH self.mytableView.mj_header//刷新头
#define tableF self.mytableView.mj_footer//刷新尾








#import "FirstViewController+Methods.h"

#import "FirstViewTabBarVC.h"

#import "TableViewCell5.h"  ///多图
#import "TableViewCell7.h"  ///普通

#import "MJRefresh.h"       ///刷新库


#import "UIImageView+WebCache.h"

#import "Reachability.h"    ///网络监测库
#import "PICoachmark/PICoachmark.h"     ///引导提示库

#import "MapViewDebugVC.h"  ///地图测试页面
#import "MapTextVC.h"       ///百度地图测试页面
#import "CalendarSelectVC.h"///日期选择测试页面
#import "HotelsLocationVC.h"///周边酒店定位测试页面
#import "QuickLoginVC.h"    ///快速登录测试页面


@implementation FirstViewController (Methods)
static int i;


#pragma mark --- 统一加载方法

-(void)loadMainView //加载主界面
{

    [self updataTheNavigation];//修改导航栏显示
    
    [self creatTableView];  //加载视图
    
    [self loadLogImage];    //加载log

    [self loadArr];         //初始化全局数组
    
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
        
        //因为要获取大量数据,这里还是开辟一个新的线程来执行
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            [self loadLocationNewData]; //首先加载本地数据
            
        });
    
    }
    
    [tableH beginRefreshing];          //刷新界面
    
//    [self loadPopTips]; //加载提示
    
//    [self creatPopView]; //创建提示

}



#pragma mark --- 视图创建方法

-(void)loadArr  //初始化全局数组
{

    otherNews =[NSMutableArray new];
    otherNews2 =[NSMutableArray new];
    
    recommendNews =[NSMutableArray new];
    processArr=[NSMutableArray new];
    
    normalnewsArr=[NSMutableArray new];
    
    recomendNewsListArr=[NSMutableArray new];
    normalNewsListArr=[NSMutableArray new];

}

-(void)loadLogImage     //加载log图片
{
    if (recommendNews.count==0&&processArr.count==0) {
        logImage =[[UIImageView alloc]initWithFrame:CGRectMake(Width*0.4, Height*0.3, 69, 24)];
        [logImage setImage:[UIImage imageNamed:@"log_small.png"]];
        [self.view addSubview:logImage];
    }
}

-(void)creatTableView       //创建表视图
{
    
    MyTableView *table =[[MyTableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, Width, Height-NavigationBarHeight-49)];
    self.mytableView=table;
    [self.view addSubview:self.mytableView];
    self.mytableView.dataSource=self;
    self.mytableView.delegate=self;
    self.mytableView.tableFooterView=[[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mytableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    //下拉刷新
    tableH = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upData)];

//    [self loadNewRefreshHeader];    //加载刷新头
    
}

-(void)updataTheNavigation  //修改导航栏显示
{
//    UIColor *color = self.navigationController.navigationBar.barTintColor;
    
    //导航栏颜色
    self.navigationController.navigationBar.dk_barTintColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    self.mytableView.scrollsToTop=YES;  //允许点击状态栏返回到顶部
    
    //修改左侧按钮    (已取消侧边栏)
//    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
//    [leftButton setBackgroundImage:[[UIImage imageNamed:@"function_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(showSliderView:)forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
//    
//    //处理左按钮靠右的情况(当前设备的版本>=ios7.0)
//    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
//        
//    {
//        
//        UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemFixedSpace
//                                           
//                                                                                          target : nil action : nil ];
//        
//        negativeSpacer. width = - 20 ;//这个数值可以根据情况自由变化
//        
//        self.navigationItem.leftBarButtonItems = @[ negativeSpacer, leftItem ] ;
//        
//    }else{//低于7.0版本不需要考虑
//        
//        self.navigationItem.leftBarButtonItem= leftItem;
//        
//    }
    
    //修改标题logo
    UIImageView *title =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    title.frame=CGRectMake(0, 0, 79, 26);
    //添加一个点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchtToMoveTop:)];
    singleTap.delegate=self;
    [title addGestureRecognizer:singleTap];
    
    self.navigationItem.titleView=title;
    self.navigationItem.titleView.userInteractionEnabled=YES;   //一定要记得打开交互功能(默认关闭)

    
    
    //修改导航栏右边的按钮
    //静态按钮图片
    StaticrightBtnImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh"]];
    StaticrightBtnImageView.autoresizingMask = UIViewAutoresizingNone;
    StaticrightBtnImageView.contentMode = UIViewContentModeScaleToFill;
    StaticrightBtnImageView.bounds=CGRectMake(0, 0, 44, 44);
    //设置视图为圆形
    StaticrightBtnImageView.layer.masksToBounds=YES;
    
    //动态按钮图片
    DynamicrightBtnImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_1"]];
    DynamicrightBtnImageView.autoresizingMask = UIViewAutoresizingNone;
    DynamicrightBtnImageView.contentMode = UIViewContentModeScaleToFill;
    DynamicrightBtnImageView.bounds=CGRectMake(0, 0, 44, 44);
    //设置视图为圆形
    DynamicrightBtnImageView.layer.masksToBounds=YES;
    //    rightBtnImageView.layer.cornerRadius=22.f;

    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    
    [rightButton addSubview:DynamicrightBtnImageView];    //动态在下,静态在上
    [rightButton addSubview:StaticrightBtnImageView];
    [rightButton addTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
    StaticrightBtnImageView.center = rightButton.center;
    DynamicrightBtnImageView.center = rightButton.center;
    
    //让静态的显示,动态的隐藏
    [StaticrightBtnImageView setHidden:NO];
    [DynamicrightBtnImageView setHidden:YES];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //处理右按钮靠左的情况(当前设备的版本>=ios7.0)
    if (([[[ UIDevice currentDevice ] systemVersion ] floatValue ]>= 7.0 ? 20 : 0 ))
        
    {
        
        UIBarButtonItem *negativeSpacer = [[ UIBarButtonItem alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemFixedSpace
                                           
                                                                                          target : nil action : nil ];
        
        negativeSpacer. width = -15 ;//这个数值可以根据情况自由变化
        
        self.navigationItem.rightBarButtonItems = @[ negativeSpacer,rightItem ] ;
        
    }else{      //低于7.0版本不需要考虑
        
        self.navigationItem.rightBarButtonItem= rightItem;
        
    }
    
    //打开手势侧滑功能
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    // 关闭侧滑效果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
}

-(void)loadScrollViewWithArr:(NSArray *)arr //加载推荐区滚动视图
{
    if (!self.myscrollView) {
        
        
        CGRect frame =CGRectMake(0, 0, Width, 0);
        
        self.myRecommendView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 0)];
        
        //滚动视图
        self.myscrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Width/2)];//宽高比例为2:1
        
        self.myscrollView.pagingEnabled=YES;
        self.myscrollView.scrollEnabled=YES;
        self.myscrollView.showsHorizontalScrollIndicator=NO;
        
        [self.myRecommendView addSubview:self.myscrollView];
        
        self.myscrollView.delegate=self;
        self.myscrollView.bounces=NO;
        
        //下方指示器
        self.mypageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(Width/2-(22*arr.count)/2,Width/2, 22*arr.count, 22)];
        
        self.mypageControl.currentPageIndicatorTintColor = MainThemeColor;//当前点的颜色
        self.mypageControl.pageIndicatorTintColor=[UIColor grayColor];//其它点的颜色
        
        
        [self.myRecommendView addSubview:self.mypageControl];
        
        frame.size.height=self.myscrollView.frame.size.height+self.mypageControl.frame.size.height+10;
        
        self.myRecommendView.frame=frame;   //更新高度
   
    }
    
    for (UIView *view in self.myscrollView.subviews) {
        
        if (view!=self.mypageControl) {
            
            [view removeFromSuperview];
            
        }
        
    }
    
    self.mypageControl.currentPage=self.myscrollView.contentOffset.x/self.myscrollView.frame.size.width;//当前页
    self.mypageControl.numberOfPages=arr.count;
    
    self.myscrollView.contentSize=CGSizeMake(Width*arr.count, Width/2); //内部视图大小
    
    self.myscrollView.contentOffset=CGPointMake(0, 0);  //返回滚动视图的初始方位
    
    for (int i=0; i<arr.count; i++) {
        
        NewsSourceModel *newsModel =arr[i];//取值
        
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(Width*i, 0, Width, self.myscrollView.frame.size.height)];
        [self.myscrollView addSubview:imgv];
        
        //推荐图标
        UIImageView *recommendIcon =[[UIImageView alloc]initWithFrame:CGRectMake(Width*i, 0, 25, 25)];
        [recommendIcon setImage:[UIImage imageNamed:@"recommend_icon"]];
        [self.myscrollView addSubview:recommendIcon];
        
        NSMutableString *imgurl =[MainUrl mutableCopy];
        
        if (newsModel.imageSrc) {
            [imgurl appendString:newsModel.imageSrc];
        }
        
        [imgv sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //将加载完成的image转化为data然后进行保存
            NSData *data;
            if (UIImagePNGRepresentation(image) == nil) {
                
                data = UIImageJPEGRepresentation(image, 1);
                
            } else {
                
                data = UIImagePNGRepresentation(image);
            }
            
            
        }];
        
        imgv.userInteractionEnabled=YES;//开启交互功能
        imgv.tag=i;
        
        //图片添加点击事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchToDisplay:)];
        [imgv addGestureRecognizer:singleTap];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(Width*i, self.myscrollView.frame.size.height*3/4, Width, self.myscrollView.frame.size.height/4)];
        title.textAlignment=NSTextAlignmentCenter;
        title.textColor=[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        title.backgroundColor=[UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:0.2];
        title.font=[UIFont systemFontOfSize:18];
        title.text=newsModel.title;
        [self.myscrollView addSubview:title];
        
    }
    
    //移除定时器
    
    if (autoScrollTimer.isValid) {
        [autoScrollTimer invalidate];
    }
    autoScrollTimer=nil;
    i=0;
    
}

-(void)addMjfooter  //添加上拉加载
{
    
    if (tableF) {
        
        return;
        
    }else{
    
        MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [footer setTitle:TableViewMJFooterUpLoadText forState:MJRefreshStateIdle];
        [footer setTitle:TableViewMJFooterRefreshingText forState:MJRefreshStateRefreshing];
        [footer setTitle:TableViewMJFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
        tableF=footer;
        
    }
    
}

-(void)loadPopTips  //加载首页提示
{

    [AMPopTip appearance].font = [UIFont fontWithName:@"Avenir-Medium" size:12];
    
    //侧边栏提示
    ResidePopTip = [AMPopTip popTip];
    [self addAttributeOnPopTip:ResidePopTip];
    
    //log提示
    LogoPopTip = [AMPopTip popTip];
    [self addAttributeOnPopTip:LogoPopTip];
    
    //刷新提示
    RefreshPopTip = [AMPopTip popTip];
    [self addAttributeOnPopTip:RefreshPopTip];

}

-(void)addAttributeOnPopTip:(AMPopTip *)popTip  //给poptip添加属性
{

//    popTip.shouldDismissOnTap = YES;  //点击消失
//    popTip.actionAnimationOut=1.0;
    popTip.edgeMargin = 5;
    popTip.offset = 2;
    popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    popTip.tapHandler = ^{    //点击回调方法
        NSLog(@"Tap!");
    };
    popTip.dismissHandler = ^{//消失的回调方法
        NSLog(@"Dismiss!");
    };

}

-(UILabel *)creatPopTipsTextWith:(NSString *)textString //创建popTip的文字
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 80)];
    label.numberOfLines = 0;
    label.text = textString;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    label.frame=CGRectMake(0, 0, label.frame.size.width, 40);
    
    return label;
}


-(void)creatPopView //创建提示
{

    NSDictionary* coachMarkDict =
    [NSDictionary
     dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                   pathForResource:@"ResidePoptip"
                                   ofType:@"plist"]];
    PIImageCoachmark* coachmark1 = [[PIImageCoachmark alloc] initWithDictionary:coachMarkDict];
    
    PICoachmarkScreen* screen1 = [[PICoachmarkScreen alloc] initWithCoachMarks:@[coachmark1]];
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    PICoachmarkView *coachMarksView = [[PICoachmarkView alloc]
                                       initWithFrame:window.bounds];
    [window addSubview:coachMarksView];
    [coachMarksView setScreens:@[screen1]];
    [coachMarksView start];

}

#pragma mark ---- 交互方法

-(void)upData       //下拉刷新
{
    if (autoScrollTimer) {  //下拉刷新时暂停定时器
        
        [autoScrollTimer setFireDate:[NSDate distantFuture]];
        
    }
    
    //需要把两个新闻区刷新的判定参数都先置为no
    recommendNewsRefreshFinished=NO;
    otherNewsRefreshFinished=NO;
    
    downPull =YES;  //代表下拉
    
    //判断是否有网络
    Reachability *re =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status =[re currentReachabilityStatus];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"])     //无网络或在离线阅读的模式下(取本地数据)
    {
        
        if (processArr.count<=0) {
            
            [self showString:@"离线模式下只会加载离线资源哟~"];
            
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self loadOfflineNewsData]; //加载离线资源
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableH endRefreshing];
            });
            
        });
        
    }else if(status==0){//无网络
        
        [self showString:@"请检查网络情况"];
        
        [self addMjfooter];
        
        [tableH endRefreshing];
        
    }else            //有网络(传入数据接口)
    {
        
//        if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"NO"]&&recommendNews.count<=0) {
//            
//            [recommendNews removeAllObjects];
//            [processArr removeAllObjects];
//            
//            [self.mytableView reloadData];
//            
//        }
        
        NSLog(@"下拉刷新最新新闻");
        
        refreshNewsNum=0;
        
        [self sendRequestToGetAllNews];
        
    }
    
}

-(void)loadNewData  //上拉加载
{
    
    downPull =NO;   //代表上拉
    
    //判断是否有网络
    Reachability *re =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status =[re currentReachabilityStatus];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"])     //无网络或在离线阅读的模式下(取本地数据)
    {
        [tableF endRefreshing];
        
        [tableF setState:MJRefreshStateNoMoreData];
        
    }else if(status==0){//无网络
        
        [self showString:@"请检查网络情况"];
        [tableF endRefreshing];
        
    }else               //有网络(传入数据接口)
    {
        
        [self sendRequestToGetOtherNews];
        
    }

}


-(void)sendRequestToGetAllNews      //获取所有新闻(包括推荐区和其它区)
{
    
    [self refreshRecommendNews];//获取推荐区新闻
    
    [self refreshOtherNews];    //获取其它区新闻
    
}


-(void)sendRequestToGetOtherNews    //只加载其它区新闻
{

    [self refreshOtherNews];    //获取其它区新闻

}


-(void)refreshRecommendNews         //加载推荐区新闻
{

    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    //请求推荐区新闻
    NSMutableString *newsUrl= [[MainUrl stringByAppendingString:newsList]mutableCopy];
    [newsUrl appendString:[NSString stringWithFormat:@"?category=%d&newsDateId=%@&number=%d&contentType=%d&baseObjectId=&deviceId=%@",11,[self getTheCurrentDate],3,1,deviceId]];
    
//    NSLog(@"newsUrl:%@",newsUrl);
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:newsUrl] cachePolicy:0 timeoutInterval:10.0];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {//有数据过来
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"推荐区数据字典dict:%@",dict);
            
            
            
            NSArray *newsArr = [dict objectForKey:@"result"];
            
            if (newsArr.count>0) {
                
                [otherNews2 removeAllObjects];
                
                //遍历数组
                for (NSDictionary *dic in newsArr) {
                    
                    NSArray *keyarr =[dic allKeys];//获取所有键
                    
                    NewsSourceModel *newsModel =[[NewsSourceModel alloc]init];
                    
                    //赋值
                    for (NSString *str in keyarr) {
                        //给模型赋值
                        [newsModel setValue:[dic objectForKey:str] forKey:str];
                        
                    }
                    
                    [otherNews2 addObject:newsModel];
                    
                }
                
                refreshNewsNum+=otherNews2.count;
                
                [self processRecommendNewsWith:otherNews2]; //处理数据到对应的数组里
                
                [self loadScrollViewWithArr:recommendNews]; //创建推荐区的视图

                [self saveFirstNewsToLocationWithRecommendNews:recommendNews];    //保存到本地

            }else{
            
                [tableH endRefreshing];
                [self stopBtnAnimationAndChangeTheEnableToYes]; //停止导航栏右按钮的动画,并且使之可以点击
            
            }
            
            if (downPull==YES&&otherNewsRefreshFinished==YES) {    //其它区新闻是否已处理完毕
                
                [tableH endRefreshing];
//                [tableF setState:MJRefreshStateIdle];
                
//                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self showNewStatusCount:refreshNewsNum]; //提示更新资讯数量
                    
                    [self stopBtnAnimationAndChangeTheEnableToYes]; //停止导航栏右按钮的动画,并且使之可以点击
                    
                    [self.mytableView reloadData];
                    
//                });
                
            }
            
            [self addMjfooter];
            
            recommendNewsRefreshFinished=YES;   //代表推荐区新闻已处理完毕
            
            if (!autoScrollTimer.isValid) {
                
                autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(autoScrollView) userInfo:nil repeats:YES];
                
            }
            
        }else{
            
            recommendNewsRefreshFinished=YES;
            
            if (downPull==YES&&otherNewsRefreshFinished==YES) {
                
                [tableH endRefreshing];
                
//                dispatch_async(dispatch_get_main_queue(), ^{
                
                if(recommendNews.count>0||processArr.count>0){
                
                    [self addMjfooter];
                
                }
                    
                    [self stopBtnAnimationAndChangeTheEnableToYes]; //停止导航栏右按钮的动画,并且使之可以点击
                    
//                });
                
            }
            
        }
        
    }];

}

-(void)refreshOtherNews     //加载其它区新闻
{
    NSString *deviceId = [self getDeviceId]; //获取设备标识

    //请求普通区新闻
    NSMutableString *newsUrl=[[MainUrl stringByAppendingString:newsList]mutableCopy];
    
    if (downPull) { //如果是下拉,使用最新的时间基点获取数据
        
        [newsUrl appendString:[NSString stringWithFormat:@"?category=%d&newsDateId=%@&number=%d&contentType=%d&baseObjectId=&deviceId=%@",11,@"",8,2,deviceId]];
        
    }else{  //反之则是上拉加载,使用之前保存的时间基点
        
        [newsUrl appendString:[NSString stringWithFormat:@"?category=%d&newsDateId=%@&number=%d&contentType=%d&baseObjectId=%@&deviceId=%@",11,self.myDatebase,5,2,self.baseObjectId,deviceId]];
        
    }
    
    
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:newsUrl] cachePolicy:0 timeoutInterval:10.0];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {//有数据过来
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"普通区新闻dict:%@",dict);
            
            if ([dict objectForKey:@"newsDateId"]&&[dict objectForKey:@"baseObjectId"]) {
                self.myDatebase=[dict objectForKey:@"newsDateId"];
                self.baseObjectId=[dict objectForKey:@"baseObjectId"];
                
            }else{
                
                [tableF endRefreshing];
                
                [(MJRefreshAutoStateFooter *)tableF setTitle:TableViewMJFooterNoMoreDataText forState:MJRefreshStateIdle];
                
                [self stopBtnAnimationAndChangeTheEnableToYes]; //停止导航栏右按钮的动画,并且使之可以点击
                
                return ;
            }

            
            NSArray *newsArr = [dict objectForKey:@"result"];//取值
            
            [otherNews removeAllObjects];
            
            //遍历数组
            for (NSDictionary *dic in newsArr) {
                
                NSArray *keyarr =[dic allKeys];//获取所有键
                
                NewsSourceModel *newsModel =[[NewsSourceModel alloc]init];
                
                //赋值
                for (NSString *str in keyarr) {
                    //给模型赋值
                    [newsModel setValue:[dic objectForKey:str] forKey:str];
                    
                }
                
                [otherNews addObject:newsModel];
                
            }
            
//            NSLog(@"otherNews:%@",otherNews);
            
            if (downPull) {
                
                refreshNewsNum+=otherNews.count;
                    
                [self saveFirstNewsToLocationWithOtherNews:otherNews AndBaseObjectId:self.baseObjectId AndNewsDateId:self.myDatebase];  //保存刷新的其他区新闻(只保存下拉刷新的最新数据)
                
            }
            
            //把填充好的其它区数组进行处理操作
            [self processTheNewsArr:otherNews];
            
            
            if (downPull==YES&&recommendNewsRefreshFinished==YES) {
                    
                [tableH endRefreshing];
                
                [tableF setState:MJRefreshStateIdle];
                
                [self showNewStatusCount:refreshNewsNum]; //提示更新资讯数量
                
                [self stopBtnAnimationAndChangeTheEnableToYes]; //停止导航栏右按钮的动画,并且使之可以点击
                
                [self.mytableView reloadData];
                
            }else if (downPull==NO){
            
                [tableF endRefreshing];
                
                [self.mytableView reloadData];
            
            }
            
            otherNewsRefreshFinished=YES;   //代表其它区新闻已加载完毕
            
        }else{
            
            otherNewsRefreshFinished=YES;   //代表其它区新闻已加载完毕
            
            if (downPull==YES&&recommendNewsRefreshFinished==YES) {
                
                [tableH endRefreshing];
                
                if (recommendNews.count>0||processArr.count>0) {
                    
                    [self addMjfooter];
                    
                }
                
                [self stopBtnAnimationAndChangeTheEnableToYes]; //停止导航栏右按钮的动画,并且使之可以点击
                
            }else if(downPull==NO){
            
                [self showString:@"加载超时"];
                
                [tableF endRefreshing];
            
            }
            
        }
            
    }];

}

-(void)getTheNewsListIndex  //获取新闻列表索引
{

    NSMutableString *indexUrl= [[MainUrl stringByAppendingString:NewsIndexUrl]mutableCopy];
    [indexUrl appendString:[NSString stringWithFormat:@"?startTime=%@&endTime=%@&indexType=%d",[self getTheCurrentDate],@"20120101020000",2]];
    
    NSLog(@"indexUrl:%@",indexUrl);
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:indexUrl] cachePolicy:0 timeoutInterval:8.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        //        NSLog(@"请求中...r");
        
        if (data) {
            
            NSArray *str =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"str:%@",str);
            
//            [tableH endRefreshing];
            
        }else{
            
//            [tableH endRefreshing];
            
        }
        
    }];

}

-(void)saveFirstNewsToLocationWithRecommendNews:(NSArray *)recommendNewsArr  //保存推荐页刷新的最新新闻
{
    
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db =app.db;
    //记得要先清空所有数据,保证本地只留最新的推荐
    BOOL delete = [db executeUpdate:@"delete from RecommendNewTable"];
    if (delete) {
//        NSLog(@"原推荐区新闻已清除");
    }
//    NSLog(@"开始插入新的推荐区数据");
    for (NewsSourceModel *newsModel in recommendNewsArr) {  //遍历数据
        
        BOOL insert = [db executeUpdate:@"insert into RecommendNewTable (commentNum,contentType,imageSrc,newsId,publishTime,title,views) values(?,?,?,?,?,?,?)",newsModel.commentNum,newsModel.contentType,newsModel.imageSrc,newsModel.newsId,newsModel.publishTime,newsModel.title,[NSString stringWithFormat:@"%@",newsModel.views]]; //执行插入
        
        if (insert) {
//            NSLog(@"插入成功%lu",(unsigned long)[recommendNewsArr indexOfObject:newsModel]);
        }
        
    }
    NSLog(@"推荐区数据更新完毕");
    
}

-(void)saveFirstNewsToLocationWithOtherNews:(NSArray *)otherNewsArr AndBaseObjectId:(NSString *)baseObjectId AndNewsDateId:(NSString *)newsDateId //保存其他区刷新的最新新闻
{
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db =app.db;
    //记得要先清空所有数据,保证本地只留最新的推荐
    BOOL delete = [db executeUpdate:@"delete from OtherNewTable"];
    if (delete) {
//        NSLog(@"原其他区新闻已清除");
    }
//    NSLog(@"开始插入新的其他区数据");
    
    for (NewsSourceModel *newsModel in otherNewsArr) {  //遍历数据
        
        if (newsModel.pictures.count>0) {   //多图
            
            for (int j=0; j<newsModel.pictures.count; j++) {
                
                [db executeUpdate:@"insert into OtherNewTable (baseObjectId ,newsDateId ,commentNum ,contentType ,imageSrc ,newsId ,publishTime ,title ,views ,pictures ) values(?,?,?,?,?,?,?,?,?,?)",baseObjectId,newsDateId,newsModel.commentNum,newsModel.contentType,newsModel.imageSrc,newsModel.newsId,newsModel.publishTime,newsModel.title,newsModel.views,newsModel.pictures[j]];     //执行插入语句
                
//                NSLog(@"插入多图数据%d",i);
                
            }
            
        }else{  //普通
        
            [db executeUpdate:@"insert into OtherNewTable (baseObjectId ,newsDateId ,commentNum ,contentType ,imageSrc ,newsId ,publishTime ,title ,views) values(?,?,?,?,?,?,?,?,?)",baseObjectId,newsDateId,newsModel.commentNum,newsModel.contentType,newsModel.imageSrc,newsModel.newsId,newsModel.publishTime,newsModel.title,newsModel.views];
            
            
//            NSLog(@"插入普通新闻%lu",(unsigned long)[otherNewsArr indexOfObject:newsModel]);
        }
        
    }
    NSLog(@"其他区数据更新完毕");
    
}

-(void)loadLocationNewData  //加载之前保存到本地的新闻数据,填充到对应的数组里
{

    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db =app.db;
    //加载推荐区新闻
    FMResultSet *result1 = [db executeQuery:@"select * from RecommendNewTable"];
    [otherNews2 removeAllObjects];
    while ([result1 next]) {    //填充推荐区数组
        
        NewsSourceModel *newModel =[[NewsSourceModel alloc]init];
        
        newModel.commentNum=[NSNumber numberWithInteger:[result1 intForColumn:@"commentNum"]];
        newModel.contentType=[NSNumber numberWithInteger:[result1 intForColumn:@"contentType"]];
        newModel.newsId=[NSNumber numberWithInteger:[result1 intForColumn:@"newsId"]];
        newModel.views=[NSNumber numberWithInteger:[result1 intForColumn:@"views"]];
        
        newModel.imageSrc=[result1 stringForColumn:@"imageSrc"];
        newModel.publishTime=[result1 stringForColumn:@"publishTime"];
        newModel.title=[result1 stringForColumn:@"title"];
        
        [otherNews2 addObject:newModel];
        
    }
    
    NSLog(@"推荐区数据就绪");
    
    [self processRecommendNewsWith:otherNews2]; //处理推荐区数据
    
    
    
    //加载其他区新闻
    FMResultSet *result2 = [db executeQuery:@"select * from OtherNewTable"];
    [otherNews removeAllObjects];
    while ([result2 next]) {    //填充其他区数组
        
        NewsSourceModel *newModel =[[NewsSourceModel alloc]init];
        
        newModel.commentNum=[NSNumber numberWithInteger:[result2 intForColumn:@"commentNum"]];
        newModel.contentType=[NSNumber numberWithInteger:[result2 intForColumn:@"contentType"]];
        newModel.newsId=[NSNumber numberWithInteger:[result2 intForColumn:@"newsId"]];
        newModel.views=[NSNumber numberWithInteger:[result2 intForColumn:@"views"]];
        
        newModel.imageSrc=[result2 stringForColumn:@"imageSrc"];
        newModel.publishTime=[result2 stringForColumn:@"publishTime"];
        newModel.title=[result2 stringForColumn:@"title"];
        
        NSArray *centerArr =[NSArray arrayWithArray:otherNews];   //中专数组
        
        if ([result2 stringForColumn:@"pictures"]) {    //如果存在图片,说明是图片新闻
            
            for (NewsSourceModel *model in centerArr) { //遍历数组,如果有相同新闻id的数据,只把图片地址添加进去即可
                
                if ([model.newsId integerValue]==[newModel.newsId integerValue]) {
                    
                    [newModel.pictures addObjectsFromArray:[model.pictures copy]];
                    
                    [otherNews removeObject:model];  //记得不能添加重复的新闻
                    
                }
                
            }
            
            [newModel.pictures addObject:[result2 stringForColumn:@"pictures"]];
            
        }
        
        self.myDatebase=[result2 stringForColumn:@"newsDateId"];
        self.baseObjectId=[result2 stringForColumn:@"baseObjectId"];
        
        [otherNews addObject:newModel];
        
    }
    NSLog(@"其他区数据就绪");
    [self processTheNewsArr:otherNews]; //把填充好的其它区数组进行处理操作
    
//    NSLog(@"recommendArr:%ld\nprocessArr:%ld",recommendNews.count,processArr.count);
    
    dispatch_async(dispatch_get_main_queue(), ^{    //在主线程中加载视图
    
        [self loadScrollViewWithArr:recommendNews];
        [self.mytableView reloadData];
        
    });
    
}

-(void)loadOfflineNewsData  //加载离线资源
{

    [recommendNews removeAllObjects];
    [otherNews removeAllObjects];   //清空原有数据
    
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    FMDatabase *db =app.db;
    
    FMResultSet *result = [db executeQuery:@"select * from offlineNewsDataTable"];
    
    while ([result next]) { //遍历取值
        
        NewsSourceModel *newsmodel=[[NewsSourceModel alloc]init];
        
        newsmodel.title=[result stringForColumn:@"title"];
        newsmodel.content=[result stringForColumn:@"content"];
        newsmodel.source=[result stringForColumn:@"source"];
        newsmodel.publishTime=[result stringForColumn:@"publishTime"];
        
        newsmodel.views=[NSNumber numberWithInteger:[[result stringForColumn:@"views"] integerValue]];
        newsmodel.newsId=[NSNumber numberWithInteger:[[result stringForColumn:@"newsId"] integerValue]];
        newsmodel.commentNum=[NSNumber numberWithInteger:[result intForColumn:@"commentNum"]];
        newsmodel.contentType=[NSNumber numberWithInteger:[result intForColumn:@"contentType"]];
        
        if ([result dataForColumn:@"titleImg"]) {   //有值代表普通新闻，无值代表图片新闻
            
            NSArray *centerArr =[NSArray arrayWithArray:otherNews];   //中转数组
            
            newsmodel.titleImg=[UIImage imageWithData:[result dataForColumn:@"titleImg"]];
            
            NSMutableDictionary *picDic =[NSMutableDictionary new];
            
            if ([UIImage imageWithData:[result dataForColumn:@"image"]]) {  //存在图片数据,说明是图文资讯
                
                [picDic setObject:[UIImage imageWithData:[result dataForColumn:@"image"]] forKey:@"image"];
                
                for (NewsSourceModel *model in centerArr) { //遍历看是否已有相同的新闻资讯
                    
                    if ([model.newsId integerValue]==[newsmodel.newsId integerValue]) { //存在相同id的新闻，进行拼接
                        
                        [newsmodel.pictures addObjectsFromArray:[model.pictures copy]];
                        
                        [otherNews removeObject:model];
                        
                    }
                    
                }
                
                [newsmodel.pictures addObject:picDic];
                
            }
            
            [otherNews addObject:newsmodel];
            
        }else{
            
            NSArray *centerArr =[NSArray arrayWithArray:otherNews];   //中转数组
            
            UIImage *img =[UIImage imageWithData:[result dataForColumn:@"image"]];  //转化为图片
            NSString *descriptions =[result stringForColumn:@"descriptions"];
            
            NSMutableDictionary *dic =[NSMutableDictionary new];
            
            [dic setValue:descriptions forKey:@"descriptions"];
            
            [dic setValue:img forKey:@"image"];
            
            for (NewsSourceModel *model in centerArr) {
                
                if ([model.newsId integerValue]==[newsmodel.newsId integerValue]) { //存在相同id的新闻，进行拼接
                    
                    [newsmodel.contentPictures addObjectsFromArray:[model.contentPictures copy]];
                    
                    [otherNews removeObject:model];
                    
                }
                
            }
            
            [newsmodel.contentPictures addObject:dic];
            
            [otherNews addObject:newsmodel];
            
        }
        
    }
    
    //加载视图
    NSLog(@"离线数据就绪");
    [self processTheNewsArr:otherNews]; //把填充好的其它区数组进行处理操作
    
    [self addMjfooter];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self stopBtnAnimationAndChangeTheEnableToYes]; //停止导航栏右按钮的动画,并且使之可以点击
        
        [self.mytableView reloadData];
        
    });
    
}

- (void)touchToDisplay:(UITapGestureRecognizer *)tapGesture //推荐区图片点击事件
{
    
    NewsSourceModel *newmodel = recommendNews[tapGesture.view.tag];
    
//    NSLog(@"点击了推荐区下标为%lu的新闻",tapGesture.view.tag);
    
    [self chooseContainerWithContentType:[newmodel.contentType integerValue] AndNewsId:[newmodel.newsId integerValue]];
    
}




#pragma mark --- 辅助方法

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
}

-(void)openTheTimer    //打开定时器
{
    
    if (autoScrollTimer) {
        
        [autoScrollTimer setFireDate:[NSDate distantPast]];
        
    }
    
}

-(void)closeTheTimer   //关闭定时器
{

    if (autoScrollTimer) {
        
        [autoScrollTimer setFireDate:[NSDate distantFuture]];
        
    }

}

- (void)touchtToMoveTop:(UITapGestureRecognizer *)tapGesture    //点击直接移动到顶端
{
    
    self.hidesBottomBarWhenPushed=YES;
    
//    [self jumpToMapViewDebugVC];    ///跳转到定位测试页
    
//    [self jumpToMapView];   ///跳转到地图页面(测试)
    
//    [self jumpToCalendarView];///跳转到日期选择页面(测试)
    
//    [self jumpToHotelsVC];  /////跳转到周边酒店展示页面
    
//    [self jumpToQuickVC];   /////跳转到快速登录页面
    
    self.hidesBottomBarWhenPushed=NO;
    
}

-(void)jumpToMapViewDebugVC //跳转到定位测试页(测试)
{

    MapViewDebugVC *mv =[[MapViewDebugVC alloc]init];
    [self.navigationController pushViewController:mv animated:YES];

}

-(void)jumpToMapView        //跳转到地图页面(测试)
{
        
    MapTextVC *mv =[[MapTextVC alloc]init];
    [self.navigationController pushViewController:mv animated:YES];

}

-(void)jumpToCalendarView   //跳转到日期选择页面
{
        
    CalendarSelectVC *cv =[[CalendarSelectVC alloc]init];
    [self.navigationController pushViewController:cv animated:YES];

}

-(void)jumpToHotelsVC   //跳转到周边酒店展示页面
{

    HotelsLocationVC *hv =[[HotelsLocationVC alloc]init];
    [self.navigationController pushViewController:hv animated:YES];

}

-(void)jumpToQuickVC    //跳转到快速登录页面
{

    QuickLoginVC *hv =[[QuickLoginVC alloc]init];
    [self.navigationController pushViewController:hv animated:YES];

}


-(IBAction)showSliderView:(UIButton*)sender   //导航栏左按钮功能(展示侧边栏)
{
    
//    if (ResidePopTip.isVisible) {
//        return;
//    }
//    
//    UILabel *label = [self creatPopTipsTextWith:@"除了点击还可以滑动哟~"];
//
//    //提示的背景色
//    ResidePopTip.popoverColor = [UIColor colorWithRed:0.95 green:0.65 blue:0.21 alpha:0.8];
//    ResidePopTip.layer.cornerRadius=5;
//    
//    //延迟一秒自动消失
//    [ResidePopTip showCustomView:label direction:AMPopTipDirectionDown inView:self.view fromFrame:sender.frame duration:2.0];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController showLeftViewController:YES];
    
}

#pragma mark 点击 RightBarButtonItem
- (IBAction)animate:(UIButton *)sender
{
    
    if (tableH.isRefreshing==YES||tableF.isRefreshing==YES) {
        
        return;
        
    }else{
        
        [self closeTheTimer];   //关闭定时器
        
        [tableH beginRefreshing];
        
        //改变ImageView旋转状态
        if (rotateState==RotateStateStop) {
            rotateState=RotateStateRunning;
            
            //让静态的隐藏,动态的显示并开启动画
            [StaticrightBtnImageView setHidden:YES];
            [DynamicrightBtnImageView setHidden:NO];
            
            [self rotateAnimate];
        }
    
    }
    
}

#pragma mark 旋转动画
-(void)rotateAnimate
{
    
    imageviewAngle+=180;
    
    if (imageviewAngle>360) {
        imageviewAngle=imageviewAngle-360;
    }
    
    //0.5秒旋转180度
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        DynamicrightBtnImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(imageviewAngle));
    } completion:^(BOOL finished) {
        if (rotateState==RotateStateRunning) {
            [self rotateAnimate];
        }
    }];
}

-(void)stopBtnAnimationAndChangeTheEnableToYes  //停止导航栏右按钮的动画,并且使之可以点击
{

    if (rotateState==RotateStateStop||rotateState==RotateStateRunning||(tableH.isRefreshing==NO&&tableF.isRefreshing==NO)) {
        
        //让静态的显示,动态的隐藏并关闭动画
        [StaticrightBtnImageView setHidden:NO];
        [DynamicrightBtnImageView setHidden:YES];
        
        rotateState=RotateStateStop;
        
        [self openTheTimer];    //开启定时器
        
    }

}

-(void)showAlertView:(NSString *)string     //警告框
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}

-(void)showString:(NSString *)str           //提示框
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    //    hud.cornerRadius=20;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

/** 提醒最新资讯数量 */
- (void)showNewStatusCount:(NSInteger)count
{
    if (count) {
        [[XZMStatusBarHUD sharedXZMStatusBarHUD] showNormal:[NSString stringWithFormat:@"更新了%ld条资讯" ,count] position:64 animaDelay:0 configuration:^{
            
            /** 设置需要添加到哪个View上 */
            [XZMStatusBarHUD sharedXZMStatusBarHUD].formView = self.view;
            [XZMStatusBarHUD sharedXZMStatusBarHUD].statusColor=MainThemeColor;
            
        }];
    } else {
        
        [[XZMStatusBarHUD sharedXZMStatusBarHUD] showNormal:@"没有新的资讯" position:64 animaDelay:0 configuration:^{
            
            /** 设置需要添加到哪个View上 */
            [XZMStatusBarHUD sharedXZMStatusBarHUD].formView = self.view;
            [XZMStatusBarHUD sharedXZMStatusBarHUD].statusColor=MainThemeColor;
        }];
    }
}

-(NSMutableString *)getTheCurrentDate       //取得当前时间字符串数据
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
    
    return str;
}

-(NSMutableString *)getTheYesterDate        //取得前一天的时间字符串数据
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]];//前一天
    
    NSString *date=[nsdf2 stringFromDate:lastDay];//取得前一天时间的字符串
    
    //    NSLog(@"nsdf2:%@",date);
    
    NSMutableString *str =[date mutableCopy];//copy为可变的
    
    //对时间字符串进行加工
    [str deleteCharactersInRange:NSMakeRange(16, 1)];
    [str deleteCharactersInRange:NSMakeRange(13, 1)];
    [str deleteCharactersInRange:NSMakeRange(10, 1)];
    [str deleteCharactersInRange:NSMakeRange(7, 1)];
    [str deleteCharactersInRange:NSMakeRange(4, 1)];
    
    return str;
}


-(void)processRecommendNewsWith:(NSMutableArray *)arr       //处理推荐区新闻数组
{
    
    [recommendNews removeAllObjects];
    
    if (arr.count<3) {
        
        [recommendNews addObjectsFromArray:arr];
        
    }else{
    
        for (int i=0; i<3; i++) {   //循环取3次对象
            
            int x = arc4random() % arr.count;
            
            NewsSourceModel *newsModel =arr[x];
            
            [recommendNews addObject:newsModel];
            
            [arr removeObject:newsModel];
            
        }
    
    }
    
//    if (otherNewsRefreshFinished==YES) {   //如果其它区刷新完毕,添加加载功能
//        
//    }
    
//    NSLog(@"推荐区数组处理完毕");
    
}

-(void)processTheNewsArr:(NSArray *)newsArr                 //处理其它区的新闻数组
{

    if (downPull==YES) {
        
        [processArr removeAllObjects];
        
    }
    
    for (int i=0; i<newsArr.count; i++) {   //首先遍历数组
        
        NewsSourceModel *newsModel =newsArr[i];
        
        if ([newsModel.contentType intValue]==1||[newsModel.contentType integerValue]==4) {           //如果是普通或视频新闻,添加到特定数组
            
            if(![normalnewsArr containsObject:newsModel]){   //先判断是否包含,不包含则添加
                
                
                [normalnewsArr addObject:newsModel];
                
                
                if (normalnewsArr.count==2) {               //数组中已经有2个对象时,将数组传入
                    NSArray *arr =[normalnewsArr copy];
                    
                    [processArr addObject:arr];   //将数组作为对象添加到数据源数组
                    
                    [normalnewsArr removeAllObjects];       //记得清空
                    
                }
                
            }
        
        }else if([newsModel.contentType intValue]==2){      //如果是多图的
        
            [processArr addObject:newsModel];               //直接添加对象到数据源数组
        
        }
        
    }
    
    //全部结束后,判断normalArr是否为空
    
    if (normalnewsArr.count) {          //大于零说明里面有一条普通新闻的对象,加到其它区数组中
        
        NewsSourceModel *newmodel =normalnewsArr.firstObject;
        
        [otherNews addObject:newmodel]; //此处保存的单条新闻可以之后在上拉加载时重新使用到
        
        [normalnewsArr removeAllObjects];
        
    }
    
    if (downPull==YES) {
        
        [otherNews removeAllObjects];       //下拉刷新时记得清空other区数组
        
    }

    if (recommendNewsRefreshFinished==YES) {   //如果推荐区刷新完毕添加加载功能
        [self addMjfooter];
    }
    
//    NSLog(@"其他区数据处理完毕");
}

-(void)jumpToDetailViewWithNewsId:(NSInteger)newsId         //根据传过来的新闻id跳转到普通新闻
{

    NSLog(@"%ld",(long)newsId);
    
    NewsSourceModel *newsModel = [self getTheNewModelAtOfflineModeWithNewsId:newsId];    //获取对应的新闻
    
    newsModel.newsId=[NSNumber numberWithInteger:newsId];
    newsModel.contentType=[NSNumber numberWithInteger:1];
    
    DetailNewsViewController *dv=[[DetailNewsViewController alloc]init];
    dv.newsModel=newsModel;
    
    self.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:dv animated:YES];

}

-(void)jumpToPureImagesViewWithNewsId:(NSInteger)newsId     //根据传过来的新闻id跳转到图片新闻
{

    NSLog(@"%ld",newsId);
    
    NewsSourceModel *newsModel = [self getTheNewModelAtOfflineModeWithNewsId:newsId];    //获取对应的新闻
    
    newsModel.newsId=[NSNumber numberWithInteger:newsId];
    newsModel.contentType=[NSNumber numberWithInteger:2];
    
    PureImageViewController *pv =[[PureImageViewController alloc]init];
    pv.newsModel=newsModel;
    
    self.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:pv animated:YES];

}

-(void)jumpToVideoNewViewWithNewsId:(NSInteger)newsId     //根据传过来的新闻id跳转到视频新闻
{
    
    NSLog(@"%ld",newsId);
    
    NewsSourceModel *newsModel = [self getTheNewModelAtOfflineModeWithNewsId:newsId];    //获取对应的新闻
    
    newsModel.newsId=[NSNumber numberWithInteger:newsId];
    newsModel.contentType=[NSNumber numberWithInteger:4];
    
    VideoNewVC *vc =[[VideoNewVC alloc]init];
    vc.newsModel=newsModel;
    
    self.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(NewsSourceModel *)getTheNewModelAtOfflineModeWithNewsId:(NSInteger)newsId
{
    
    NewsSourceModel *newsModel;

    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
        
        for (int i=0; i<processArr.count; i++) {    //通过循环进行遍历获取新闻
            
            if ([processArr[i] isKindOfClass:[NSArray class]]) {    //包含2个普通资讯的数组
                
                NSArray *arr =processArr[i];
                
                for (int j=0; j<arr.count; j++) {   //遍历这个小数组
                    
                    if ([[(NewsSourceModel *)arr[j] newsId] integerValue]==newsId) {    //存在相同id的新闻
                        
                        newsModel=arr[j];
                        
                    }
                    
                }
                
            }else{  //包含一个图片资讯的对象
                
                if ([[(NewsSourceModel *)processArr[i] newsId] integerValue]==newsId) {    //存在相同id的新闻
                    
                    newsModel=processArr[i];
                    
                }
                
            }
            
        }
        
//        NSLog(@"newsModel:%@",newsModel);
        
    }else{
    
        newsModel=[[NewsSourceModel alloc]init];
    
    }
    
    return newsModel;
    
}


#pragma mark --- UIScrollView Delegate 滚动视图代理方法

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView  //每次滚动完成后系统调用
{

    CGFloat offset = scrollView.contentOffset.x/self.myscrollView.frame.size.width;
    self.mypageControl.currentPage=offset;
    
    i=offset;
    //开启定时器
    [autoScrollTimer setFireDate:[NSDate distantPast]];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView   //拖动滚动视图时调用
{
    
    //关闭定时器
    [autoScrollTimer setFireDate:[NSDate distantFuture]];

}


-(void)autoScrollView   //定时器的调用方法
{
    
    [self.myscrollView setContentOffset:CGPointMake(i*self.myscrollView.frame.size.width, 0) animated:YES];
        
    self.mypageControl.currentPage = i;

    i++;
    
    if (i>=recommendNews.count) {
        i=0;
    }
    
}

//根据不同的新闻类型选择不同的载体来承载新闻(推荐区)
-(void)chooseContainerWithContentType:(NSInteger)contentType AndNewsId:(NSInteger)newsId
{

//    NSLog(@"contentType:%ld newsId:%ld",(long)contentType,newsId);
    
    switch (contentType) {
            
        case 1: //普通
        {
            NSLog(@"跳转到普通咨询");
            [self jumpToDetailViewWithNewsId:newsId];
        }
            break;
            
        case 2: //多图
        {
            NSLog(@"跳转到多图咨询");
            [self jumpToPureImagesViewWithNewsId:newsId];
        }
            break;
            
        case 4: //暂留
        {
            NSLog(@"跳转到视频资讯");
            [self jumpToVideoNewViewWithNewsId:newsId];
        }
            break;
            
        default:
            break;
    }

}

//根据不同的新闻类型选择不同的载体来承载新闻(其他区(除图片资讯外))
-(void)chooseContainerWithNewsId:(NSInteger)newsId
{
    
    NSInteger contentType = 0;
    
    for (int i=0; i<processArr.count; i++) {    //通过循环进行遍历获取新闻
        
        if ([processArr[i] isKindOfClass:[NSArray class]]) {    //包含2个普通资讯的数组
            
            NSArray *arr =processArr[i];
            
            for (int j=0; j<arr.count; j++) {   //遍历这个小数组
                
                if ([[(NewsSourceModel *)arr[j] newsId] integerValue]==newsId) {    //存在相同id的新闻
                    
                    contentType = [[(NewsSourceModel *)arr[j] contentType]integerValue];
                    
                }
                
            }
            
        }else{  //包含一个图片资讯的对象
            
            if ([[(NewsSourceModel *)processArr[i] newsId] integerValue]==newsId) {    //存在相同id的新闻
                
                contentType = [[(NewsSourceModel *)processArr[i] contentType]integerValue];
                
            }
            
        }
        
    }
    
    
    switch (contentType) {
            
        case 1: //普通
        {
            NSLog(@"跳转到普通咨询");
            [self jumpToDetailViewWithNewsId:newsId];
        }
            break;
            
        case 2: //多图
        {
            NSLog(@"跳转到多图咨询");
            [self jumpToPureImagesViewWithNewsId:newsId];
        }
            break;
            
        case 4: //暂留
        {
            NSLog(@"跳转到视频资讯");
            [self jumpToVideoNewViewWithNewsId:newsId];
        }
            break;
            
        default:
            break;
    }
    
}





@end
