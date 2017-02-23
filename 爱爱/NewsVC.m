//
//  NewsVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/21.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
#define  tableF self.mytableView.mj_footer
#define DisposableNewsNum   5   //一次性加载的新闻条数


#import "NewsVC.h"

#import "UIScrollView+PullToRefreshCoreText.h"  //刷新头
#import "UIImageView+ProgressView.h"
#import "MJRefresh.h"       ///刷新库
#import "Reachability.h"

#import "NewsCell.h"    //自定义cell
#import "NewsWebVC.h"   //带网页的新闻界面



@interface NewsVC ()<NewCellImageDelegate>
{

    NSMutableArray *newsArr;    //新闻数组
    
    DGActivityIndicatorView *activityIndicatorView; //加载指示器
    
    UILabel *refreshNotice;   //提示刷新的按钮

}

@end


@implementation NewsVC




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    newsArr = [NSMutableArray new];
    
//    [self.navigationController.navigationBar setHidden:YES];
    
    [self updataTheNavigation];
    
    [self creatTableView];  //创建表视图
    
    //注册cell
    [self.mytableView registerClass:[NewsCell class] forCellReuseIdentifier:NSStringFromClass([NewsCell class])];
    
    [self.mytableView scrollRectToVisible:CGRectMake(0, 0, Width, 30) animated:YES];
    
    [self upData];  //下拉刷新
}





#pragma mark ----- 视图创建

-(void)updataTheNavigation  //修改导航栏显示
{

    //修改标题logo
//    UIImageView *title =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
//    title.frame=CGRectMake(0, 0, 79, 26);
//    self.navigationItem.titleView=title;

    
    self.title = @"发现";
//    SetNavigationBarTitle(20, MainThemeColor);
    SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:20],MainThemeColor);
//    self.navigationController.navigationBar.dk_barTintColorPicker=DKColorWithColors(MainThemeColor, MainThemeColor);
    //230, 23, 115, 1.0
//    [self.navigationController.navigationBar setBarTintColor:MainThemeColor];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]]; //去除下边线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

}


-(void)creatTableView       //创建表视图
{
    
    UITableView *table =[[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, Width, Height-49-NavigationBarHeight)];
    self.mytableView=table;
    [self.view addSubview:self.mytableView];
    self.mytableView.dataSource=self;
    self.mytableView.delegate=self;
    self.mytableView.tableFooterView=[[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mytableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);   //分割线的缩进
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mytableView.backgroundColor = [UIColor whiteColor];
    
    
    
    //表头间隔
//    [self.mytableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 10)]];
    
}


-(void)upData       //下拉刷新
{
    
    downPull = YES; //代表下拉
    
    //判断是否有网络
    Reachability *re =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status =[re currentReachabilityStatus];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"])     //无网络或在离线阅读的模式下(取本地数据)
    {
        
        
        
    }else if(status==0){//无网络
        
        showHudString(@"当前无可用网络");
        
        [self endHeaderRefresh];
        
        if (newsArr.count<=0) {
            
            [self setRefreshBtn];
            
        }
        
    }else            //有网络
    {
        
        [self refreshOtherNews];    //加载新闻
        
    }
    
}

-(void)loadNewData  //上拉加载
{
    //如果正在刷新界面，则不允许加载更多数据
    if (self.mytableView.pullToRefreshView.status==2) {
        
        [self endHeaderRefresh];
        
    }
    
    downPull = NO;  //代表上拉
    
    //判断是否有网络
    Reachability *re =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status =[re currentReachabilityStatus];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"])     //无网络或在离线阅读的模式下(取本地数据)
    {
        [tableF endRefreshing];
        
        [tableF setState:MJRefreshStateNoMoreData];
        
    }else if(status==0){//无网络
        
        showHudString(@"当前无可用网络");
        
        [tableF endRefreshing];
        
    }else               //有网络
    {
        
        [self refreshOtherNews];    //加载新闻
    }
    
}

-(void)addRefreshHeader
{
    
    if (self.mytableView.pullToRefreshView) {
        
        return;
        
    }
    __weak typeof(self) weakSelf = self;

    [self.mytableView addPullToRefreshWithPullText:@"从此,生活有情趣" pullTextColor:MainThemeColor pullTextFont:[UIFont fontWithName:PingFangSCQ size:18] refreshingText:@"Refreshing..." refreshingTextColor:DefaultTextColor refreshingTextFont:DefaultTextFont action:^{
        
        //如果正在加载更多数据，不允许重新刷新 新的数据
        if (weakSelf.mytableView.mj_footer.state==MJRefreshStateRefreshing) {
            
            return ;
            
        }
        
        [weakSelf upData];  //加载最新数据
        
    }];

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


-(void)endHeaderRefresh
{
    
    [self.mytableView finishLoading];
    
}

-(void)setRefreshBtn    //添加一个刷新按钮，防止网络不好时无法获取城市列表及主题列表
{
    
    [refreshNotice setHidden:NO];
    
    if (refreshNotice) {
        
        return;
        
    }else{
        
        refreshNotice = [UILabel new];
        refreshNotice.textColor = MainThemeColor;
        refreshNotice.font = [UIFont systemFontOfSize:16];
        [refreshNotice setText:@"网络不太好哟,下拉一下试试呗~"];
//        refreshNotice.layer.borderColor = MainThemeColor.CGColor;
//        refreshNotice.layer.borderWidth = 1;
        
        [self.view addSubview:refreshNotice];
        
        //布局
        refreshNotice.sd_layout
        .centerXEqualToView(self.view)
        .centerYEqualToView(self.view)
        .autoHeightRatio(0)
        ;
        
//        refreshNotice.sd_cornerRadius = @(5);
        [refreshNotice setSingleLineAutoResizeWithMaxWidth:Width];
        
    }
    
}


#pragma mark ----- UITableView Datasource 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return newsArr.count;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Class currentClass = [NewsCell class];
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    
    cell.delegate=self;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSMutableDictionary *model = newsArr[indexPath.row];
    
    cell.model = model;
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (newsArr.count>0) {
        
        NSMutableDictionary *model = newsArr[indexPath.row];
        
        CGFloat height = 0.0;
        
//        if ([model objectForKey:@"imageSrc"]) {
//            
//            UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[model objectForKey:@"imageSrc"]];
//            
//            if (img) {
//                
//                height = img.size.height *Width/img.size.width;//Image宽度为屏幕宽度 ，计算宽高比求得对应的高度
//                
//            }else{
//                
//                height = 0;
//                
//            }
//            
//        }
        
        if ([model objectForKey:@"otherControllHeight"]) {
            
            height = height + [[model objectForKey:@"otherControllHeight"] integerValue];
            
        }
        
//        NSLog(@"cell图片以外的高度%f",[[model objectForKey:@"otherControllHeight"] floatValue]);
        
        return height;
        
    }else{
        
        return 0;
        
    }
    
}





#pragma mark ----- UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
    
    NewsWebVC *wvc = [NewsWebVC new];
    
    NSMutableDictionary *newModel = newsArr[indexPath.row];
    
    wvc.webViewUrlStr = [MainUrl stringByAppendingString:[newModel objectForKey:@"shareUrl"] ];
    
    wvc.newsModel = newModel;
    
    [self.navigationController pushViewController:wvc animated:YES];
    
    self.hidesBottomBarWhenPushed=NO;

}


///cell的图片下载代理方法
-(void)reloadCellAtIndexPathWithUrl:(NSString *)url
{
    
    GCDWithMain(^{
        
        if (url) {
            for (int i = 0; i< newsArr.count; i++) {
                //遍历当前数据源中并找到ImageUrl
                NSDictionary *dict  =   newsArr.count >i ? newsArr[i] :nil;
                NSString *imgURL = [dict objectForKey:@"imageSrc"];
                
                if ([imgURL isEqualToString:url]) {
                    //获取当前可见的Cell NSIndexPaths
                    NSArray *paths  = self.mytableView.indexPathsForVisibleRows;
                    //判断回调的NSIndexPath 是否在可见中如果存在则刷新页面
                    NSIndexPath *pathLoad = [NSIndexPath indexPathForItem:i inSection:0];
                    for (NSIndexPath *path in paths) {
                        if (path && path == pathLoad ) {
                            
                            [self.mytableView reloadData];
                            
                            break;
                            
                        }
                    }
                }
            }
        }
        
    });
}


///标题图错误代理移除cell
-(void)deleteCellAtIndexPathWithUrl:(NSString *)url
{

//    GCDWithMainSync(^{
//        
//        
//        
//    });
    
    GCDWithMain(^{
        
        if (url) {
            for (int i = 0; i< newsArr.count; i++) {
                //遍历当前数据源中并找到ImageUrl
                NSDictionary *dict  =   newsArr.count >i ? newsArr[i] :nil;
                
                NSString *imgURL = [dict objectForKey:@"imageSrc"];
                
                if ([imgURL isEqualToString:url]) {
                    
                    [newsArr removeObject:dict];
                    
                    //                NSLog(@"删除了cell");
                    [self.mytableView reloadData];
                    
                    break;
                    
                }
                
            }
        }
        
    });
    
}



#pragma  mark ----- 交互方法


-(void)refreshOtherNews     //加载新闻
{
    
    [refreshNotice setHidden:YES];
    
    static int firstload = 0;
    
    if (firstload!=1) {
        
        [self loadIndicator];   //如果是第一次加载，需要先显示下加载指示器
        
    }
    
    firstload = 1 ;
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    //请求普通区新闻
    NSMutableString *newsUrl=[[MainUrl stringByAppendingString:newsList]mutableCopy];
    
    if (downPull) { //如果是下拉,使用最新的时间基点获取数据
        
        [newsUrl appendString:[NSString stringWithFormat:@"?category=%d&newsDateId=%@&number=%d&contentType=%d&baseObjectId=&deviceId=%@",11,@"",DisposableNewsNum,2,deviceId]];
        
    }else{  //反之则是上拉加载,使用之前保存的时间基点
        
        [newsUrl appendString:[NSString stringWithFormat:@"?category=%d&newsDateId=%@&number=%d&contentType=%d&baseObjectId=%@&deviceId=%@",11,self.myDatebase,DisposableNewsNum,2,self.baseObjectId,deviceId]];
        
    }
    
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:newsUrl] cachePolicy:0 timeoutInterval:15.0];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {//有数据过来
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"普通区新闻dict:%@",dict);
            
             NSArray *arr = [dict objectForKey:@"result"];
            
            //添加头部刷新功能
            [self addRefreshHeader];
            
            if ([dict objectForKey:@"newsDateId"]&&[dict objectForKey:@"baseObjectId"]) {
                self.myDatebase=[dict objectForKey:@"newsDateId"];
                self.baseObjectId=[dict objectForKey:@"baseObjectId"];
                
            }else{
                
                [tableF endRefreshing];
                
                [(MJRefreshAutoStateFooter *)tableF setTitle:TableViewMJFooterNoMoreDataText forState:MJRefreshStateIdle];
                
                if (activityIndicatorView.animating) {
                    
                    [activityIndicatorView stopAnimating];
                    
                }
                
                if (self.mytableView.pullToRefreshView) {
                    
                    [self.mytableView.pullToRefreshView endLoading];
                    
                }
                
                return ;
            }
            
            
            if (downPull) {
                
                [newsArr removeAllObjects]; //如果时下拉刷新，先清空数组里的数据
                
            }
            
            //对数组中没有标题图的新闻直接删除
            NSMutableArray *arr2 = [arr mutableCopy];
            for (int i = 0; i<arr.count; i++) {
                
                NSDictionary *new = arr[i];
                if (![new objectForKey:@"imageSrc"]) {
                    
                    [arr2 removeObject:new];
                    
                }
                
            }
            
            [newsArr addObjectsFromArray:arr2];
            
            
            GCDWithMain(^{  //主线程刷新表视图
                
                [self.mytableView reloadData];
                
            });
            
            if (self.mytableView.pullToRefreshView.status==0||self.mytableView.pullToRefreshView.status==2) {
                
                [self endHeaderRefresh];
                
            }
            
            if (tableF.state==MJRefreshStateRefreshing) {
                
                [tableF endRefreshing];
                
            }
            
            [self addMjfooter]; //添加刷新尾巴
            
            if (activityIndicatorView.animating) {
                
                [activityIndicatorView stopAnimating];
                
            }
            
        }else{
            
            if (activityIndicatorView.animating) {
                
                [activityIndicatorView stopAnimating];
                
            }
            
            showHudString(@"加载超时");
            
            [self endHeaderRefresh];
            
            [tableF endRefreshing];
            
            //添加头部刷新功能
            [self addRefreshHeader];
            
            if (newsArr.count<=0) {
                
                [self setRefreshBtn];
                
            }
        
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




































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
