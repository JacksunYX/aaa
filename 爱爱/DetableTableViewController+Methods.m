//
//  DetableTableViewController+Methods.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/12.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#pragma mark--统一接口


#define commentUpsUrl @"http://119.29.80.151/mobile/comment/commentUps.jspx"//评论点赞
#define collectUrl @""

#import "DetableTableViewController+Methods.h"

//static const CGFloat MJDuration = 1.0;//延迟执行的时间
@implementation DetableTableViewController (Methods)

#pragma mark-----------------------视图加载
-(void)loadmyTableView//加载tableview
{
    CGRect frame = self.view.frame;
    
    self.mytableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height)];
    
    self.mytableView.delegate = self;
    
    //数据源
    
    self.mytableView.dataSource = self;
    
    [self.view addSubview:self.mytableView];
    
}

-(void)touchToPop//返回方法
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updataTheView//调整视图显示
{
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    
    //修改左侧按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"back@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(touchToPop)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem= leftItem;
    
    self.navigationController.toolbarHidden=YES;
    
    //打开手势侧滑功能
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    // 关闭侧边栏效果
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
    self.mytableView.tableFooterView=[[UIView alloc]init];
    
    [self addTableMJFoot];
}

-(void)addBtn//添加一个悬浮点击按钮
{
    
    UIButton *suspendBtn =[[UIButton alloc]initWithFrame:CGRectMake(Width-80, Height-80, 50, 50)];
    //[suspendBtn setTitle:@"biu!!!" forState:UIControlStateNormal];
    [suspendBtn setBackgroundImage:[UIImage imageNamed:@"pl@2x.png"] forState:UIControlStateNormal];
    //    [suspendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [suspendBtn addTarget:self action:@selector(touchToSuspend) forControlEvents:UIControlEventTouchUpInside];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"offLineReadState"]isEqualToString:@"YES"])     //离线阅读的模式下(取本地数据)
    {
        [suspendBtn setHidden:YES];
        
    }else{
        [suspendBtn setHidden:NO];
    }
    
    [self.view addSubview:suspendBtn];
}

-(void)loadWebViewWithUrl:(NSURL *)url//加载webView
{
    //目前只作展示，所以取消与用户的交互功能
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width, 0)];
    self.webView.delegate = self;   //设置代理
    self.webView.scrollView.scrollEnabled = NO; //关闭滚动
    self.webView.userInteractionEnabled=NO;     //取消交互
    //预先加载url
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
    
    tableData=[NSMutableArray new];
}

-(void)loadLogImage//加载log图片
{
    self.logImage =[[UIImageView alloc]initWithFrame:CGRectMake(Width*0.4, Height*0.3, 69, 24)];
    [self.logImage setImage:[UIImage imageNamed:@"log_small.png"]];
    [self.view addSubview:self.logImage];
    self.mytableView.tableFooterView=[[UIView alloc]init];
}

-(void)loadHud//加载hud指示器
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self.hud show:YES];
}



-(IBAction)changeSelectState:(UIButton *)sender//点赞按钮事件
{
    sender.selected=!sender.selected;
}

-(void)touchToSearch
{
    NSLog(@"点击查看用户信息");
}

-(void)touchToSuspend//发表评论的跳转页面
{
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

-(void)addNavigationRightBtn//添加导航栏右边的按钮
{
    
    //收藏按钮
    UIButton *rightbtn1 = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [rightbtn1 setBackgroundImage:[[UIImage imageNamed:@"sc2@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [rightbtn1 setBackgroundImage:[UIImage imageNamed:@"ysc@2x.png"] forState:UIControlStateSelected];
    [rightbtn1 addTarget:self action:@selector(touchToCollect:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc]initWithCustomView:rightbtn1];
    
    //分享按钮
    UIButton *rightbtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
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
        
        if (self.newsModel.isStore) {
            rightbtn2.selected=!rightbtn2.selected;
        }
    }
}

-(void)addTableMJFoot//添加上拉加载功能
{
    self.mytableView.backgroundColor =[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    
    //添加上拉加载功能
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(UrlComment)];
    [footer setTitle:@"点击加载更多..." forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已加载全部~" forState:MJRefreshStateNoMoreData];
    
    //    // 设置字体
    //    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    //
    //    // 设置颜色
    //    footer.stateLabel.textColor = [UIColor grayColor];
    
    self.mytableView.mj_footer=footer;
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"offLineReadState"]isEqualToString:@"YES"])     //离线阅读的模式下(取本地数据)
    {
        //        [self showString:@"请检查网络..."];
        [self.mytableView setHidden:YES];
        
    }
}

#pragma mark------------------------视图加载


#pragma mark------------------交互过程处理相关

-(void)issueCommentWithString:(NSString *)string//发表评论
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];
    
    NSMutableString *issueComment =[issuecomentUrl mutableCopy];

    string = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef) string,NULL,(CFStringRef) @"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));//编码
    
    [issueComment appendFormat:@"?newsId=%@&userId=%@&commentContent=%@",@571,@"",string];

    NSLog(@"issueComment:%@",issueComment);
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:issueComment] cachePolicy:0 timeoutInterval:5.f];
    NSLog(@"发送'发表评论请求'~");
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            NSString *str=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@",str);
            
            //此处调用刷新最新评论,即可看到最新发出的评论
            self.baseDate=@"";//要记得把时间基点设置为空，这样它才能真正刷新最新的评论
            [self UrlComment];
            [hud hide:YES];
            [self showString:@"发表成功"];
            
            NSLog(@"发表完成");
        }else{
            
            [hud hide:YES];
            [self showString:[NSString stringWithFormat:@"评论失败:%@",connectionError]];
        }
        
        
    }];
    
}

-(void)UrlComment //请求评论列表
{
    NSLog(@"---构建baseDate---");
    if (self.baseDate.length==0) {
        self.baseDate=[self getTheCurrentDate];
        [tableData removeAllObjects];
    }
    NSMutableString *commentUrl = [commentCheckUrl mutableCopy];
    
    [commentUrl appendFormat:@"?newsId=%@&baseDate=%@&num=%d&sortBy=%d&userId=%@",@571,self.baseDate,5,0,@""];
    NSLog(@"commentUrl:%@",commentUrl);
    NSLog(@"----构建完成----");
    NSLog(@"---开始刷新评论列表---");
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:commentUrl] cachePolicy:0 timeoutInterval:5.f];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(data){
            NSLog(@"---开始解析评论数据---");
            
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *result =[dic objectForKey:@"result"];
            //                NSLog(@"%@",result);
            self.baseDate=[dic objectForKey:@"baseDate"];
            
            for (NSDictionary *dict in result) {
                NSArray *keyArr=[dict allKeys];//获取所有键
                CommendSourceModel *commentModel =[[CommendSourceModel alloc]init];
                //        遍历键数组
                for (NSString *str in keyArr) {
                    //给模型赋值
                    
                    if ([str isEqualToString:@"isUps"]) {
                        
                        commentModel.isUps = [[dic objectForKey:str] boolValue];
                        
                    }else{
                        
                        [commentModel setValue:[dict objectForKey:str] forKey:str];
                    }
                    
                }
                
                [tableData addObject:commentModel];//添加到全局评论数组中
            }
            NSLog(@"评论数组填充完毕:%@",tableData);
            
            
            NSLog(@"------解析完成------");
            
            if (tableData.count) {
                
                NSLog(@"刷新评论列表~~~");
                [self.mytableView reloadData];
                
                [self.mytableView.mj_footer endRefreshing];
                
            }else{
                
                [self showString:@"暂无评论"];
                
            }
            
            [self.mytableView.mj_footer endRefreshing];
        }else{
            [self.mytableView.mj_footer endRefreshing];
            [self showString:@"资讯信息解析出错"];
            
        }
    }];

}

-(void)touchToSend//转发按钮点击事件
{
    NSLog(@"分享中...");
    //构造分享内容 qq空间分享
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:@"333.jpg"]
                                                title:@"aiai"
                                                  url:@"http://www.aiai.cn"//分享点击的
                                          description:@"写点什么吧~"
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
                                    [self showString:@"分享成功"];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [self showString:@"分享失败，请重试"];
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
}

-(IBAction)touchToCollect:(UIButton *)sender//收藏按钮点击事件
{
    //登录状态下
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
        
        
        
        sender.selected=!sender.selected;
        if (sender.isSelected) {
            [self showString:@"已收藏"];
        }else{
            [self showString:@"取消收藏"];
        }
    }else{//非登录状态下,提示登录
        
        myAlert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用啦" otherButtonTitles:@"登录", nil];
        [myAlert show];
    }
    
}

//提示框按钮监听
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==myAlert) {
        
        if (buttonIndex==1) {
            
        }
        
    }
}


#pragma mark------------------交互过程处理相关


#pragma mark ----辅助方法
-(void)showString:(NSString *)str//提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.cornerRadius=20;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

-(NSMutableString *)getTheCurrentDate//取得当前时间字符串数据
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

@end
