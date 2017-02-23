//
//  DetailNewsViewController+Method.m
//  爱爱
//
//  Created by 爱爱网 on 15/12/21.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.
//



#import "DetailNewsViewController+Method.h"
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





@implementation DetailNewsViewController (Method)


#pragma mark --- 创建视图及发送请求统一方法
-(void)creatViewandSendRequest//创建视图及发送请求统一方法
{
    tableNews = [NSMutableArray new] ;
    tableData = [NSMutableArray new] ;
    tableHotComment =[NSMutableArray new];
    backView =[[NewsBackView alloc]initWithFrame:CGRectMake(0, 0, Width, 0)];
    
    ToUpdataComend=NO;
    
    [self changeNavigationBarState];//调整导航栏显示
    
    [self loadLogImage];            //加载log
    
    [self initTableView];           //加载tableview
    
    [self sendRequestToGetData];    //进来第一件事就是加载新闻
    
}






#pragma mark ---视图创建方法

-(void)loadLogImage     //加载log图片
{
    if (tableNews.count==0) {
        logImage =[[UIImageView alloc]initWithFrame:CGRectMake(Width*0.4, Height*0.3, 69, 24)];
        [logImage setImage:[UIImage imageNamed:@"log_small.png"]];
        logImage.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
        [self.view addSubview:logImage];
    }
}

-(void)initTableView    //初始化tableView以及视图上的相关按钮
{

    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, Width, Height-NavigationBarHeight-44) style:UITableViewStylePlain];
    //代理类
    
    self.tableView.delegate = self;
    
    //数据源
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    
    
    //tableView的背景色
    
    self.tableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    //    _tableView.dk_separatorColorPicker =DKColorWithColors([UIColor whiteColor], [UIColor grayColor]);
    
    
    
    //    // 设置字体
    //    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    //
    //    // 设置颜色
    //    footer.stateLabel.textColor = [UIColor grayColor];
    
//    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(3, 20, 3, 20);//统一修改cell分割线的缩进(上，左，下，右)
    self.tableView.tableFooterView=[[UIView alloc]init];
    
}

-(void)creatMjfooter    //添加刷新尾
{
    //添加上拉加载功能
    
    if (self.tableView.mj_footer) {
        
        return;
        
    }else{
        
        MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(sendRequestToGetData)];
        //设置显示文字
        [footer setTitle:TableViewMJFooterUpLoadText forState:MJRefreshStateIdle];
        [footer setTitle:TableViewMJFooterRefreshingText forState:MJRefreshStateRefreshing];
        [footer setTitle:TableViewMJFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
        self.tableView.mj_footer=footer;
        
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

-(void)touchToSuspend   //发表评论的跳转页面(使用第三方库YIPopupTextView)
{
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
        myAlert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用啦" otherButtonTitles:@"登录", nil];
        [myAlert show];
        
    }else{
        
        popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"写点什么呗..." maxCount:150 buttonStyle:YIPopupTextViewButtonStyleLeftCancelRightDone doneButtonColor:[UIColor colorWithRed:230.0f/255.0f green:23.0f/255.0f blue:115.0f/255.0f alpha:1.0]];
        
        popupTextView.delegate = self;//代理
        popupTextView.caretShiftGestureEnabled = YES;   // default = NO
        popupTextView.outerBackgroundColor=[UIColor clearColor];//弹出输入框后的背景色
        popupTextView.layer.borderColor=[[UIColor colorWithRed:230.0f/255.0f green:23.0f/255.0f blue:115.0f/255.0f alpha:1.0]CGColor];//边框线颜色
        popupTextView.layer.borderWidth=0.5;//边框线粗细
        popupTextView.topUIBarMargin=self.view.frame.size.height/2.5;//上间距
        popupTextView.bottomUIBarMargin=self.view.frame.size.height/2.5;//下间距
        popupTextView.keyboardType=UIKeyboardTypeDefault;
        [popupTextView showInView:self.view];//显示
        
    }
}

- (void)popupTextView:(YIPopupTextView*)textView didDismissWithText:(NSString*)text cancelled:(BOOL)cancelled   //YIPopupTextViewDelegate代理方法
{
    if (cancelled) {
        NSLog(@"取消");
        
    }else{
        
        if ([text isEqualToString:@""]||[self isEmpty:text]) {
            
            [self showString:@"评论内容不能为空哟~"];
            
        }else{
        
            NSString *userId = CurrentUserId;
            
            [self issueComentWithString:text WithuserId:userId];
        
        }
        
        
    }
}

#pragma mark --- 最新修改区

-(void)creatToolbarWithCommentNum:(NSInteger)commentNum //下方评论控件
{
    
   //防治重复创建
    if (creatOrNot) {
        return;
    }
    
    NewsSourceModel *newModel = [tableNews firstObject];
    
    //下方交互框
    UIView *toolbar =[[UIView alloc]initWithFrame:CGRectMake(0, Height-44, Width, 44)];
    
    //四个按钮的frame
    UIButton *sharebtn =[[UIButton alloc]initWithFrame:CGRectMake(Width-20-28, (toolbar.frame.size.height-28)/2, 25, 25)]; //分享按钮
     UIButton *collectbtn =[[UIButton alloc]initWithFrame:CGRectMake(sharebtn.frame.origin.x-10-28, sharebtn.frame.origin.y, 25, 25)]; //收藏按钮
     UIButton *checkcommentsbtn =[[UIButton alloc]initWithFrame:CGRectMake(collectbtn.frame.origin.x-10-28, collectbtn.frame.origin.y, 25, 25)]; //查看评论按钮
    
     UIButton *commentbtn =[[UIButton alloc]initWithFrame:CGRectMake(20, (toolbar.frame.size.height-30)/2, Width-28*3-20*2-10*3, 30)]; //评论按钮
//    self.textView =[[UITextView alloc]initWithFrame:commentbtn.frame];
    
    
    //设置属性
    [sharebtn setBackgroundImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [collectbtn setBackgroundImage:[UIImage imageNamed:@"bookmark_icon"] forState:UIControlStateNormal];
    [collectbtn setBackgroundImage:[UIImage imageNamed:@"bookmarked_icon"] forState:UIControlStateSelected];
    [checkcommentsbtn setBackgroundImage:[UIImage imageNamed:@"comment_icon"] forState:UIControlStateNormal];
    
    collectbtn.selected = newModel.isStore ;
    
    [commentbtn.layer setBorderColor:RGBA(255.0f,151.0f,203.0f,1.0).CGColor];
    [commentbtn.layer setCornerRadius:commentbtn.frame.size.height/2];
    [commentbtn.layer setBorderWidth:TextFieldBorderWidth];
    [commentbtn setTitle:@"写点东西呗~" forState:UIControlStateNormal];
    commentbtn.titleLabel.font=[UIFont systemFontOfSize:12];
    
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        [commentbtn setTitleColor:RGBA(100.0f,100.0f,100.0f,1.0) forState:UIControlStateNormal];
    }else{
        [commentbtn setTitleColor:UnimportantContentTextColorNight forState:UIControlStateNormal];
    }
    
    [self addBdageNumOnBtn:checkcommentsbtn AndNum:commentNum]; //添加小红点
    
//    self.textView.layer.borderColor = RGBA(255.0f,151.0f,203.0f,1.0).CGColor;
//    self.textView.layer.cornerRadius = 10;
//    self.textView.layer.borderWidth = 0.8;
//    self.textView.delegate=self;
//    
//    [self.textView setFont:[UIFont systemFontOfSize:16]];
    
    
    [toolbar addSubview:sharebtn];
    [toolbar addSubview:collectbtn];
    [toolbar addSubview:checkcommentsbtn];
    [toolbar addSubview:commentbtn];
//    [toolbar addSubview:self.textView];
    
    toolbar.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    toolbar.layer.shadowColor=[UIColor blackColor].CGColor;
    toolbar.layer.shadowOpacity=0.3;
    toolbar.layer.shadowOffset=CGSizeMake(0, 1);
    
    
    [self.view addSubview:toolbar];
    
    
    //给按钮添加点击事件
    [sharebtn addTarget:self action:@selector(touchToSend) forControlEvents:UIControlEventTouchUpInside];
    
    [collectbtn addTarget:self action:@selector(touchToCollect:) forControlEvents:UIControlEventTouchUpInside];
    
    [commentbtn addTarget:self action:@selector(touchToSuspend) forControlEvents:UIControlEventTouchUpInside];
    
    [checkcommentsbtn addTarget:self action:@selector(touchtToGetComment) forControlEvents:UIControlEventTouchUpInside];
    creatOrNot=YES;
}


-(void)creatViewAtOfflineMode   //在离线模式下创建视图
{
    
    self.tableView.frame =CGRectMake(0, NavigationBarHeight, Width, Height-NavigationBarHeight);
    
    [tableNews addObject:self.newsModel];
    
    [self.tableView reloadData];

}

-(void)addTapGesturesOnBackView //给新闻上的图片视图添加点击事件
{
    
    for (int i=0; i<backView.imageViewArr.count; i++) {
        
        //给图片视图添加点击事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToSeePictures:)];
        singleTap.delegate=self;
        
        [backView.imageViewArr[i] addGestureRecognizer:singleTap];
        
    }
    
}

-(void)touchToSeePictures:(UITapGestureRecognizer *)tapGesture  //点击弹出图片事件
{
    
    NSLog(@"tag:%ld",tapGesture.view.tag);
    
#pragma  mark-----多图展示测试
    WyzAlbumViewController *wyzAlbumVC = [[WyzAlbumViewController alloc]init];
    
    wyzAlbumVC.currentIndex =tapGesture.view.tag;   //这个参数表示当前图片的index，默认是0
    
    //图片数组，必须是url
    //第一种用url,第二种直接用image
    wyzAlbumVC.imgArr = backView.imgArr;
    
    //进入动画
    [self presentViewController:wyzAlbumVC animated:YES completion:^{
        
    }];
    
}



#pragma mark---请求方法

-(void)sendRequestToGetData //发送上拉加载的请求并获取数据
{
    //判断是否有网络
    Reachability *re =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status =[re currentReachabilityStatus];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"])     //离线阅读的模式下(取本地数据)
    {
        
//        NSLog(@"离线模式self.newsModel:%@",self.newsModel);
        
        [self creatViewAtOfflineMode];  //在离线模式下创建视图
        
    }else if(status==0){                //无网络
        
        [self showAlertView:@"请检查网络环境~"];
        
    }else//有网络
    {
        
        if (ToUpdataComend) {
            NSLog(@"刷新评论");
            [self UrlComment];//发送评论请求
        }else{
            [tableNews removeAllObjects];
            
            [self UrlNews];//发送新闻请求
            
        }
    }
}


-(void)UrlComment   //加载评论
{
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    if ([self.newsModel.commentNum integerValue]>=30&&tableHotComment.count<=0) {  //避免网络差时没有加载出热评
        
        [self UrlHotComments];  //加载热门评论
        
    }
    
    if (self.baseDate.length<=0) {
        
        self.baseDate=@"";
        [tableData removeAllObjects];
        
    }

    NSMutableString *commentUrl = [[MainUrl stringByAppendingString:commentCheckUrl]mutableCopy];
    
    NSString *userId;//如果存在就附上，不存在就给个没有的值
    if (CurrentUserId) {
        userId=CurrentUserId;
    }else{
        userId=@"";
    }
    
//    NSLog(@"baseObjectId:%@",self.baseObjectId);
    
    if (self.baseObjectId.length==0) {
        
        [commentUrl appendFormat:@"?objectId=%@&baseDate=%@&num=%d&sortBy=%d&userId=%@&objectType=%d&deviceId=%@",self.newsModel.newsId,self.baseDate,5,0,userId,1,deviceId];
        
    }else{
    
        [commentUrl appendFormat:@"?objectId=%@&baseDate=%@&num=%d&sortBy=%d&userId=%@&objectType=%d&baseObjectId=%@&deviceId=%@",self.newsModel.newsId,self.baseDate,5,0,userId,1,self.baseObjectId,deviceId];
    
    }
    
    
    
    NSLog(@"commentUrl:%@",commentUrl);
    
//    NSLog(@"----构建完成----");
    NSLog(@"---开始刷新评论列表---");
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:commentUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(data){
            NSLog(@"---开始解析评论数据---");
            
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"dic:%@",dic);
            
            if ([dic objectForKey:@"baseDate"]) {
                self.baseDate=[dic objectForKey:@"baseDate"];
            }else{

                [self.tableView.mj_footer endRefreshing];
                
                [(MJRefreshAutoStateFooter *)self.tableView.mj_footer setTitle:TableViewMJFooterNoMoreDataText forState:MJRefreshStateIdle];

                return ;
                
            }
            
            if ([dic objectForKey:@"baseObjectId"]) {
                
                NSNumber *number=[dic objectForKey:@"baseObjectId"];
                
                self.baseObjectId =[NSString stringWithFormat:@"%@",number];
            }
            
            
            
            NSArray *result =[dic objectForKey:@"result"];
            
            
            
            for (NSDictionary *dict in result) {
                

                NSArray *keyArr=[dict allKeys];//获取所有键
                CommendSourceModel *commentModel =[[CommendSourceModel alloc]init];
                //        遍历键数组
                for (NSString *str in keyArr) {
                    //给模型赋值

                    if ([str isEqualToString:@"isUps"]) {           //是否被点赞
                        
                        commentModel.isUps = [[dict objectForKey:str] boolValue];
                        
                    }else if([str isEqualToString:@"isComment"]){   //是否评论过
                        
                        commentModel.isComment = [[dict objectForKey:str] boolValue];
                    
                    }else{
                        
                        [commentModel setValue:[dict objectForKey:str] forKey:str];
                    }
                    
                }
                
                NSString *cellHeight =[NSString stringWithFormat:@"%f",[self getTheCellHeightWithModelContent:commentModel.commentContent]];
                
                [commentModel setValue:cellHeight forKey:@"cellHeight"];
                
                [tableData addObject:commentModel];//添加到全局评论数组中
            }
            
            
            NSLog(@"------解析完成------");
            
            if (tableData.count) {
                
                NSLog(@"刷新评论列表~~~");
                [self.tableView reloadData];
                
                [self.tableView.mj_footer endRefreshing];
                
            }else{
                
                [self showString:@"暂无评论"];
                
            }
            
            [self.tableView.mj_footer endRefreshing];
        }else{
            
            [self.tableView.mj_footer endRefreshing];
            [self showString:@"评论加载超时"];
            
        }
    }];
    
}


-(void)UrlNews  //发送请求详细新闻数据的请求
{
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db = app.db;
    FMResultSet *result =[db executeQuery:@"select * from NewsTable where newsId=?",self.newsModel.newsId];
    
    if ([result next]) {
        
        NSLog(@"已保存过");
        
        //耗时操作放在子线程中执行
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self getLocationNewsDataWithNewsId];   //从本地获取新闻数据
            
            [self saveNewsDataToLocation];  //保存或更新浏览记录
            
        });
        
        [tableNews addObject:self.newsModel];
        
        [self getTheNewsCommand];       //获取此条新闻的相关参数(是否被收藏过、评论数等),里面包含是否加载热门评论
        
    }else{
    
        NSLog(@"未保存过");
        
        DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc]initWithType:7 tintColor:MainThemeColor size:Width/8];
        [self.view addSubview:activityIndicatorView];
        
        //布局下
        activityIndicatorView.sd_layout
        .centerXEqualToView(self.view)
        .centerYEqualToView(self.view)
        ;
        
        [activityIndicatorView startAnimating];
        
        
        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeIndeterminate;
        
        NSMutableString *Urlstr = [[MainUrl stringByAppendingString:newsDetail]mutableCopy];
        
        if (CurrentUserId) {    //是否登录
            
            [Urlstr appendFormat:@"?newsId=%@&userId=%@&deviceId=%@",self.newsModel.newsId,CurrentUserId,deviceId];
            
        }else{
            
            [Urlstr appendFormat:@"?newsId=%@&userId=&deviceId=%@",self.newsModel.newsId,deviceId];
            
        }
        //拼接完整url
        
        //    NSLog(@"Urlstr:%@",Urlstr);
        
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:Urlstr] cachePolicy:0 timeoutInterval:10.0];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            if(data){
                
                NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
//                NSLog(@"dic:%@",dic);
                
                if ([[dic objectForKey:@"resultCode"]isEqualToString:@"9"]) {
                    
                    [self showString:@"用户不存在"];
                    
                    double delayInSeconds = 1.0;
                    __block DetailNewsViewController* bself = self;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        
                        [bself.navigationController popViewControllerAnimated:YES];
                    
                    });
                    
                    return ;
                    
                }else if ([[dic objectForKey:@"resultCode"]isEqualToString:@"15"]){
                    //已在其他手机登录,强制注销
                    [self showString:@"当前用户已在其他设备登录了"];
                    
                
                }
                
                if (dic) {
                    
                    //获取字典里的所有键
                    NSArray *keyArr =[dic allKeys];
                    NewsSourceModel *newsModel =[[NewsSourceModel alloc]init];
                    
                    
                    // 遍历键数组
                    for (NSString *str in keyArr) {
                        //给模型赋值
                        if ([str isEqualToString:@"isStore"]) {
                            newsModel.isStore = [[dic objectForKey:str] boolValue];
                            
                        }else{
                            [newsModel setValue:[dic objectForKey:str] forKey:str];
                        }
                        
                    }
                    
                    
                    newsModel.contentType=self.newsModel.contentType;
                    newsModel.newsId=self.newsModel.newsId;
                    
                    self.newsModel=newsModel;
                    
//                    NSLog(@"newsModel:%@",newsModel);
                    
                    [tableNews addObject:newsModel];
                    
                    //耗时操作放在子线程中执行
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [self saveNewsDataToLocationWithModel:self.newsModel];  //保存新闻数据到本地
                        
                        [self saveNewsDataToLocation];  //保存或更新浏览记录
                        
                    });
                    
                    
                    
                    
                    NSLog(@"------解析完成------");

                    [self loadHotCommentsOrNot];    //是否加载热门评论
                    
//                    [hud hide:YES];
                    [activityIndicatorView stopAnimating];
                    
                }
                
                
                
            }else{
                
                [self showString:@"请求超时"];
//                [hud show:NO];
                [activityIndicatorView stopAnimating];
                
            }
        }];
    
    }
    
    
    
    
}

-(void)UrlHotComments   //加载热评
{
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *commentUrl = [[MainUrl stringByAppendingString:commentCheckUrl]mutableCopy];
    
    NSString *userId;//如果存在就附上，不存在就给个没有的值
    if (CurrentUserId) {
        userId=CurrentUserId;
    }else{
        userId=@"";
    }
        
    [commentUrl appendFormat:@"?objectId=%@&baseDate=%@&num=%d&sortBy=%d&baseUps=%d&userId=%@&objectType=%d&deviceId=%@",self.newsModel.newsId,[self getTheCurrentDate],5,1,-1,userId,1,deviceId];
    
    
//    NSLog(@"commentUrl:%@",commentUrl);
    
    //    NSLog(@"----构建完成----");
    NSLog(@"---开始刷新评论列表---");
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:commentUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(data){
            NSLog(@"---开始解析评论数据---");
            
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"dic:%@",dic);
            
            NSArray *result =[dic objectForKey:@"result"];
            
            for (NSDictionary *dict in result) {
                
    
                NSArray *keyArr=[dict allKeys];//获取所有键
                CommendSourceModel *commentModel =[[CommendSourceModel alloc]init];
                //        遍历键数组
                for (NSString *str in keyArr) {
                    //给模型赋值
                    
                    if ([str isEqualToString:@"isUps"]) {           //是否被点赞
                        
                        commentModel.isUps = [[dict objectForKey:str] boolValue];
                        
                    }else if([str isEqualToString:@"isComment"]){   //是否评论过
                        
                        commentModel.isComment = [[dict objectForKey:str] boolValue];
                        
                    }else{
                        
                        [commentModel setValue:[dict objectForKey:str] forKey:str];
                    }
                    
                }
                
                NSString *cellHeight =[NSString stringWithFormat:@"%f",[self getTheCellHeightWithModelContent:commentModel.commentContent]];
                
                [commentModel setValue:cellHeight forKey:@"cellHeight"];
                
                [tableHotComment addObject:commentModel];//添加到全局评论数组中
            }
            
            NSLog(@"------解析完成------");
                
            NSLog(@"刷新热评~~~");
            
            [self.tableView reloadData];

        }else{
            
            [self showString:@"热评加载超时"];
            
        }
    }];

}

-(void)issueComentWithString:(NSString *)string WithuserId:(NSString *)userId   //发表评论
{
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain",@"text/html", nil];
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    string = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef) string,NULL,(CFStringRef) @"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8)); //对内容进行编码
    
    NSDictionary *params = @{
                             
                             @"newsId":self.newsModel.newsId,
                             @"userId":userId,
                             @"commentContent":string,
                             @"deviceId":deviceId
                                 };
    
    
    [manager POST:[MainUrl stringByAppendingString:issuecomentUrl] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSLog(@"responseObject:%@",responseObject);
        
        if (!responseObject) {
            
            [hud hide:YES];
            [self showString:@"服务器出错"];
            return ;
            
        }
        
        NSArray *keyArr=[responseObject allKeys];//获取所有键
        CommendSourceModel *commentModel =[[CommendSourceModel alloc]init];
        //        遍历键数组
        for (NSString *str in keyArr) {
            
            //给模型赋值
            if ([str isEqualToString:@"isUps"]) {
        
                commentModel.isUps = [[responseObject objectForKey:str] boolValue];
        
            }else{
        
                [commentModel setValue:[responseObject objectForKey:str] forKey:str];
            }
        
        }
        
        NSString *cellHeight =[NSString stringWithFormat:@"%f",[self getTheCellHeightWithModelContent:commentModel.commentContent]];
        
        [commentModel setValue:cellHeight forKey:@"cellHeight"];
        
        commentModel.childNum=@"0";
        
        [hud hide:YES];
        
        [tableData insertObject:commentModel atIndex:0];
        
        [self.tableView reloadData];
        
        [self showString:@"评论成功"];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"error:%@",error);
        
        [hud hide:YES];
        [self showString:@"请求超时"];
        
    }];
    
}


-(void)touchToSend  //更多分享按钮点击事件
{
    
    NSLog(@"分享中...");
    
    NewsSourceModel *newsModel =[tableNews firstObject];
    
    NSString *imgsrc =[MainUrl stringByAppendingString:newsModel.imageSrc];
    
    //构造分享内容 qq空间分享
    id<ISSContent> publishContent = [ShareSDK content:newsModel.contentDescription
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imgsrc]
                                                title:newsModel.title
                                                  url:@"http://www.aiai.com"//分享点击的url
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
    
    
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [self showString:@"分享成功~"];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
}


-(IBAction)touchToCollect:(UIButton *)sender    //收藏按钮点击事件
{
    //登录状态下
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
        
        
        sender.selected=!sender.selected;
        [sender.layer addAnimation:[self creatAnimation] forKey:@"SHOW"];
        if (sender.isSelected) {
            
            [self showString:@"已收藏"];
            [self sendRequestToGetDataWithDiffentCommand:1 AndcontentType:1 AndobjectId:[NSString stringWithFormat:@"%@",self.newsModel.newsId]];
            
        }else{
            [self sendRequestToGetDataWithDiffentCommand:0 AndcontentType:1 AndobjectId:[NSString stringWithFormat:@"%@",self.newsModel.newsId]];
            [self showString:@"已取消"];
            
        }
    }else{//非登录状态下,提示登录
        
        myAlert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用啦" otherButtonTitles:@"登录", nil];
        [myAlert show];
    }
    
}


-(IBAction)changeSelectState:(UIButton *)sender //点赞按钮事件
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
        
        if (!sender.isSelected) {//非赞状态下
            
            [self zanProcessWithArr:tableHotComment AndCommendId:sender];
            [self zanProcessWithArr:tableData AndCommendId:sender];
            
            [self sendRequestToGetDataWithDiffentCommand:2 AndcontentType:2 AndobjectId:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
            
            sender.selected=!sender.selected;
            [sender.layer addAnimation:[self creatAnimation] forKey:@"SHOW"];
        }else{
        
            [self showString:@"您已经赞过啦!"];
        
        }
        
    }else{//非登录状态下,提示登录
        
        myAlert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用啦" otherButtonTitles:@"登录", nil];
        [myAlert show];
    }
    
}

-(void)zanProcessWithArr:(NSArray *)arr  AndCommendId:(UIButton *)sender   //点赞处理数组展示过程
{

    for (int i=0; i<arr.count; i++) {     //遍历评论数组,获取当前点赞的评论的对象
        
        CommendSourceModel *comentModel =arr[i];
        
        if ([comentModel.commentId integerValue]==sender.tag) {
            
            NSLog(@"%@",comentModel.commentId);
            NSLog(@"%ld",(long)sender.tag);
            
            [comentModel setValue:@1 forKey:@"isUps"];  //修改是否点赞
            
            NSNumber *ups =[NSNumber numberWithInteger:[comentModel.ups integerValue]+1];
            
            [comentModel setValue:ups forKey:@"ups"];
            
            [self addBdageNumOnBtn:sender AndNum:[comentModel.ups integerValue]];
            
        }
        
    }

}


-(void)touchToSearch//点击查看用户信息
{
    NSLog(@"点击查看用户信息");
}



-(void)sendRequestToGetDataWithDiffentCommand:(NSInteger)command AndcontentType:(NSInteger)contentType AndobjectId:(NSString *)objectId     //根据不同指令发送点赞或收藏请求
{
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    NSMutableString *Urlstr = [[MainUrl stringByAppendingString:commandUrl]mutableCopy];
    //拼接完整url
    [Urlstr appendFormat:@"?objectId=%@&userId=%@&command=%ld&contentType=%lD&deviceId=%@",objectId,CurrentUserId,(long)command,(long)contentType,deviceId];
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:Urlstr]cachePolicy:0 timeoutInterval:10.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
                NSLog(@"收藏或点赞resultCode:%@",[dict objectForKey:@"resultCode"]);
            
        }else{
        
            [self showString:@"请求超时"];
            
        }
        
    }];
}

-(void)touchToShareWithWeibo    //分享到微博
{
    
    NSLog(@"微博分享中...");
    NewsSourceModel *newsModel =[tableNews firstObject];
    
    NSString *imgsrc =[MainUrl stringByAppendingString:newsModel.imageSrc];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:newsModel.contentDescription
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imgsrc]
                                                title:newsModel.title
                                                  url:@"http://www.aiai.com"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareViewWithType:ShareTypeSinaWeibo
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:nil
                       shareOptions:nil
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [self showString:@"分享成功"];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     [self showString:@"网络出错啦!"];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];

}

-(void)touchToShareWithQQZone   //分享到qq空间
{
    
    NSLog(@"qq空间分享中...");
    NewsSourceModel *newsModel =[tableNews firstObject];
    
    NSString *imgsrc =[MainUrl stringByAppendingString:newsModel.imageSrc];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:newsModel.contentDescription
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imgsrc]
                                                title:newsModel.title
                                                  url:@"http://www.aiai.com"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareViewWithType:ShareTypeQQSpace
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:nil
                       shareOptions:nil
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [self showString:@"分享成功"];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     [self showString:@"网络出错啦!"];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];
    
}

-(void)touchToShareWithFriend   //分享到微信朋友圈
{

    NSLog(@"微信朋友圈分享中...");
    NewsSourceModel *newsModel =[tableNews firstObject];
    
    NSString *imgsrc =[MainUrl stringByAppendingString:newsModel.imageSrc];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:newsModel.contentDescription
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imgsrc]
                                                title:newsModel.title
                                                  url:@"http://www.aiai.com"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareViewWithType:ShareTypeWeixiTimeline
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:nil
                       shareOptions:nil
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     [self showString:@"分享成功"];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     [self showString:@"网络出错啦!"];
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];

}

-(void)saveNewsDataToLocation   //保存或更新浏览记录
{

    //保存到数据库的浏览历史表里
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db=app.db;
    
    //先查看是否有浏览过
    FMResultSet *result = [db executeQuery:@"select * from BrowsHistoryTable where newsId  = ?",self.newsModel.newsId];
    
    if ([result next]) {    //如果已经存在,修改其浏览的时间为当前时间即可
        
        NSLog(@"已经浏览过了");
        BOOL update = [db executeUpdate:@"update BrowsHistoryTable set browsTime =? where newsId =? ",[self getTheCurrentDate],self.newsModel.newsId];
        
        if (update) {
            
            NSLog(@"更新浏览历史时间成功");
            
        }else{
            
            NSLog(@"更新浏览历史时间失败");
            
        }
        
    }else{                  //如果不存在,添加到数据库
        NSLog(@"没有浏览过");
        //图片的data
        UIImageView *view =[[UIImageView alloc]init];
        [view sd_setImageWithURL:[NSURL URLWithString:[MainUrl stringByAppendingString:self.newsModel.imageSrc]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            NSData *data;
            if (UIImagePNGRepresentation(image) == nil) {
                
                data = UIImageJPEGRepresentation(image, 1);
                
            } else {
                
                data = UIImagePNGRepresentation(image);
            }
            
            BOOL insert = [db executeUpdate:@"insert into BrowsHistoryTable (newsId ,contentType ,title ,titleImg ,publishTime ,source ,browsTime) values (?,?,?,?,?,?,?)",self.newsModel.newsId,self.newsModel.contentType,self.newsModel.title,data,self.newsModel.publishTime,self.newsModel.source,[self getTheCurrentDate]];
            
            
            if (insert) {
                
                NSLog(@"插入浏览历史成功");
                
            }else{
                
                NSLog(@"插入浏览历史失败");
                
            }
            
        }];
        
    }

}

-(void)saveNewsDataToLocationWithModel:(NewsSourceModel *)newsModel   //保存新闻数据到本地
{

    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db = app.db;
    
    BOOL insert = [db executeUpdate:@"insert into NewsTable (newsId,title,commentNum,contentType,publishTime,source,imageSrc,content) values(?,?,?,?,?,?,?,?)",newsModel.newsId,newsModel.title,newsModel.commentNum,newsModel.contentType,newsModel.publishTime,newsModel.source,newsModel.imageSrc,newsModel.content];

    if (insert) {
        NSLog(@"保存完毕");
    }else{
        NSLog(@"保存失败");
    }

}

-(void)getLocationNewsDataWithNewsId    //根据当前新闻Id从本地获取保存的新闻数据
{
    
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db = app.db;
    
    FMResultSet *result =[db executeQuery:@"select * from NewsTable where newsId = ?",self.newsModel.newsId];
    
    while ([result next]) {
        
        self.newsModel.title=[result stringForColumn:@"title"];
        self.newsModel.content=[result stringForColumn:@"content"];
        self.newsModel.commentNum = [NSNumber numberWithInt:[result intForColumn:@"commentNum"]];
        self.newsModel.contentType = [NSNumber numberWithInt:[result intForColumn:@"contentType"]];
        self.newsModel.publishTime = [result stringForColumn:@"publishTime"];
        self.newsModel.source = [result stringForColumn:@"source"];
        self.newsModel.imageSrc = [result stringForColumn:@"imageSrc"];
    }
    
//    NSLog(@"self.newsModel:%@",self.newsModel);
    
}


-(void)loadHotCommentsOrNot  //是否加载热门评论(内附创建新闻视图)
{

    //创建新闻视图
    [self creatToolbarWithCommentNum:[self.newsModel.commentNum integerValue]];
    
    if ([self.newsModel.commentNum integerValue]>=30) {  //当这条新闻的评论数大于等于30条才会加载热门评论
        
        [self UrlHotComments];  //加载热门评论
        
    }
    
    [self creatMjfooter];//添加上拉加载评论的功能
    //                    [suspendBtn setHidden:NO];
    
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
    [self.tableView.mj_footer setHidden:NO];
    [logImage setHidden:YES];//隐藏背景log
    ToUpdataComend=YES;//开启评论功能

}

-(void)getTheNewsCommand     //获取此条新闻的相关参数(是否被收藏过、评论数等)
{
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *Urlstr = [[MainUrl stringByAppendingString:NewsCommandUrl]mutableCopy];
    
    if (CurrentUserId) {    //是否登录
        
        [Urlstr appendFormat:@"?objectId=%@&userId=%@&deviceId=%@",self.newsModel.newsId,CurrentUserId,deviceId];
        
    }else{
        
        [Urlstr appendFormat:@"?objectId=%@&userId=&deviceId=%@",self.newsModel.newsId,deviceId];
        
    }

    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:Urlstr] cachePolicy:0 timeoutInterval:10.0];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
//            NSLog(@"dict:%@",dict);
            
            self.newsModel.commentNum = [NSNumber numberWithInteger:[[dict objectForKey:@"commentNum"] integerValue]];
            
            self.newsModel.isStore=[[dict objectForKey:@"isStore"]boolValue];
            
//            NSLog(@"self.newsModel.isStore:%d",self.newsModel.isStore);
            
            [self loadHotCommentsOrNot];    //是否加载热门评论
            
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
    hud.margin = 10.f;
//    hud.cornerRadius=20;
    hud.removeFromSuperViewOnHide = YES;
    [hud sizeToFit];
    [hud hide:YES afterDelay:1];
}



-(void)showAlertView:(NSString *)string //警告框
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}


//提示框按钮监听
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==myAlert) {
        
        if (buttonIndex==1) {
            NewLoginViewController *lgv =[[NewLoginViewController alloc]init];
            self.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:lgv animated:YES];
        }
        
    }
}


-(void)touchToPop   //返回
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchtToGetComment  //点击直接移动到评论顶端或新闻顶端
{
    
    if (self.news) {
        
        NSLog(@"跳转到新闻区");
        //让tableview滚动到新闻区最上方
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.news=NO;
        
    }else{
    
        NSLog(@"跳转到评论区");
        //让tableview滚动到新闻区最下方(也就是评论区的上方)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        self.news=YES;
    
    }
    
//    self.tableView.contentOffset=CGPointMake(0, backView.frame.size.height);

}

-(void)addBdageNumOnBtn:(UIButton *)btn AndNum:(NSInteger)value     //根据数量改变小红点的显示数量
{
    
    [btn showBadgeWithStyle:WBadgeStyleNumber value:value animationType:WBadgeAnimTypeBreathe];
    if (value>0) {
        
        btn.aniType = WBadgeAnimTypeBreathe;    //抖动效果
        
    }else{
        
        btn.aniType = WBadgeAnimTypeNone;       //无效果
        
    }
    btn.badgeBgColor = [UIColor purpleColor];      //底色
    btn.badgeCenterOffset = CGPointMake(0, 5);    //偏移量
    btn.badgeTextColor = [UIColor whiteColor];     //字体颜色
    
}


-(CGFloat)getTheCellHeightWithModelContent:(NSString *)content      //根据传入的内容事先计算出cell的高度并保存
{

    CGFloat cellHeight = 65;    //基础高度
    
    //评论内容
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width-20-45-20-10, 0)];
    
    contentLabel.text = content;
    
    //设置label的最大行数
    
    contentLabel.numberOfLines =0;
    
    if (Width==414&&Height==736) {
        contentLabel.font =[UIFont systemFontOfSize:16];
    }else{
        contentLabel.font =[UIFont systemFontOfSize:14];
    }
    
    //
    contentLabel.frame = CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, Width-20-45-20-10, 0);
    
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行距
    [paragraphStyle setLineSpacing:5];
    //需要添加行距的范围(添加范围为整个文本长度)
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentLabel.text length])];
    
    [contentLabel setAttributedText:attributedString];
    [contentLabel sizeToFit];      //自适应高度

    cellHeight=cellHeight+contentLabel.frame.size.height+10+24+10;
    
//    NSLog(@"计算后得到的cellHeight:%f",cellHeight);
    
    return cellHeight;
}


#pragma mark ----- 动画创建区

- (CAAnimation*)pathAnimation   //滑动动画
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,self.tableView.contentOffset.y,offset);
//    CGPathAddLineToPoint(path, NULL, 0, self.tableView.contentOffset.y);
    //    CGPathAddCurveToPoint(path,NULL,50.0,275.0,150.0,275.0,150.0,120.0);
    //    CGPathAddCurveToPoint(path,NULL,150.0,275.0,250.0,275.0,250.0,120.0);
    //    CGPathAddCurveToPoint(path,NULL,250.0,275.0,350.0,275.0,350.0,120.0);
    //    CGPathAddCurveToPoint(path,NULL,350.0,275.0,450.0,275.0,450.0,120.0);
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath:path];
    [animation setDuration:2.0];
    [animation setAutoreverses:YES];
    CFRelease(path);
    
    return animation;
}


-(CAAnimation *)creatAnimation  //创建动画
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    return k;
}

-(CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y  //纵向上移
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.x的话就水平移动。
    animation.toValue = y;
    animation.duration = time;  //移动时长
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = 0;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate=self;
    return animation;
}


#pragma  mark ----- 图片处理方法

//图片重绘切圆
- (UIImage*)cutImage:(UIImage *)orImage WithRadius:(int)radius
{
    UIGraphicsBeginImageContext(orImage.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+orImage.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+orImage.size.height;
    float x4 = x1;
    float y4 = y3;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, orImage.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, orImage.size.width, orImage.size.height), orImage.CGImage);
    
    
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}

//对图片做压缩处理
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//重绘至期望大小(方法3)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


-(BOOL)isEmpty:(NSString *) str //判断一个字符串是否都为空格组成
{
    
    if (!str) {
        return YES;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}



#pragma mark---处理类(已未使用)

-(void)changeImageformatWithImage:(UIImage *)image//处理图片
{
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        
        data = UIImageJPEGRepresentation(image, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(image);
    }
    [self saveImageDataIntoSql:data];
}

-(void)saveImageDataIntoSql:(NSData *)data  //保存图片流
{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    FMDatabase *db=app.db;
    BOOL b =[db executeUpdate:@"update NewsTable set  backImage = ? where newsId = ?",data,self.newsModel.newsId];
    if (b) {
        //        NSLog(@"保存图片到本地成功");
    }else{
        //        NSLog(@"保存图片到本地失败");
    }
}

-(UIImage *)loadLocationImageData//加载本地保存的图片
{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    FMDatabase *db=app.db;
    FMResultSet *result =[db executeQuery:@"select * from NewsTable where newsId=?",self.newsModel.newsId];
    //    NSLog(@"开始获取本地图片数据流...");
    
    while ([result next]) {
        NSData *  data = [result dataNoCopyForColumn:@"backImage"];
        if (data) {
            //            NSLog(@"图片数据存在...");
            UIImage *img =[UIImage imageWithData:data];
            //            NSLog(@"数据流已接受...");
            return img;
        }
    }
    
    return nil;
}


-(void)addNavigationRightBtn    //添加导航栏右边的按钮
{
    
    //收藏按钮
    rightbtn1 = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [rightbtn1 setBackgroundImage:[[UIImage imageNamed:@"sc2@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [rightbtn1 setBackgroundImage:[UIImage imageNamed:@"ysc@2x.png"] forState:UIControlStateSelected];
    [rightbtn1 addTarget:self action:@selector(touchToCollect:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc]initWithCustomView:rightbtn1];
    
    //分享按钮
    rightbtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [rightbtn2 setBackgroundImage:[[UIImage imageNamed:@"fx@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [rightbtn2 addTarget:self action:@selector(touchToSend)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc]initWithCustomView:rightbtn2];
    
    NSArray *actionButtonItems = @[right1, right2];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"offLineReadState"]isEqualToString:@"YES"])     //离线阅读的模式下(取本地数据)
    {
        
        rightbtn1.userInteractionEnabled=NO;
        rightbtn2.userInteractionEnabled=NO;
        
    }else{
        rightbtn1.userInteractionEnabled=YES;
        rightbtn2.userInteractionEnabled=YES;
        NewsSourceModel *newModel =[tableNews lastObject];
        
        rightbtn1.selected = newModel.isStore ;
        
        
    }
}

-(void)addBtn   //添加一个悬浮点击按钮
{
    
    suspendBtn =[[UIButton alloc]initWithFrame:CGRectMake(Width-80, Height-80, 50, 50)];
    //[suspendBtn setTitle:@"biu!!!" forState:UIControlStateNormal];
    [suspendBtn setBackgroundImage:[UIImage imageNamed:@"pl@2x.png"] forState:UIControlStateNormal];
    //    [suspendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [suspendBtn addTarget:self action:@selector(touchToSuspend) forControlEvents:UIControlEventTouchUpInside];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"offLineReadState"]isEqualToString:@"YES"]||tableNews.count<=0)     //离线阅读的模式下(取本地数据)
    {
        [suspendBtn setHidden:YES];
        
    }else{
        [suspendBtn setHidden:NO];
    }
    [self.view addSubview:suspendBtn];
}

@end
