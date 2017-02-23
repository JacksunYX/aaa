//
//  PureImageViewController+Methods.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/28.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define ToolViewHeight 49           //下方评论栏的高度
#define TitleWidth Width*3/4-20*2   //标题的宽
#define NormalScrollViewHeight       (Height-64-ToolViewHeight) //正常状态下展示图片的滚动视图的高度
#define OfflineScrollViewHeight      (Height-64)                //离线模式下展示图片的滚动视图的高度
#define NormalDescriptionViewHeight  (Height-64-ToolViewHeight)/3    //正常状态下描述视图的最大高度
#define OfflineDescriptionViewHeight (Height-64)/3                      //离线模式下描述视图的最大高度
#define ImageSpacing    30  //图片间距

#define ScrollViewWidth Width+ImageSpacing    //滚动视图的宽度(每页)

#define SHOW_VIEW   @"showView" //显示动画
#define HIDDEN_VIEW @"hidView"  //隐藏动画

#import "PureImageViewController+Methods.h"

#import "FirstCommentViewController.h"  //一级评论页面
#import "NewLoginViewController.h"      //登录界面


#import <ShareSDK/ShareSDK.h>
#import "WZLBadgeImport.h"  //小圆点库
#import "UIImageView+WebCache.h"





@implementation PureImageViewController (Methods)


#pragma mark ----- 视图加载统一方法

-(void)creatCurrentView    //统一调用方法
{
    
//    NSLog(@"newsModel:%@",self.newsModel);
    
    ImgArr =[NSMutableArray new];
    scrollArr=[NSMutableArray new];
    
    [self changeNavigationBarState];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
        //离线模式
        //下方无评论控件时的滚动视图高度
        ScrollViewHeight=OfflineScrollViewHeight;
        DescriptionViewHeight=OfflineDescriptionViewHeight;
        
        //加载滚动视图(图片载体,里面包含了下方的文字描述视图)
        [self loadmyScrollViewWithImgNumber:self.newsModel.contentPictures.count];
        
    }else{
        //非离线模式
        //下方有评论控件时的滚动视图高度
        ScrollViewHeight=NormalScrollViewHeight;
        DescriptionViewHeight=NormalDescriptionViewHeight;
    
        [self getImageNews];   //发送请求获取数据
    
    }
    
}

#pragma mark ----- 视图加载方法

-(void)changeNavigationBarState //修改导航栏
{
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
    
    self.view.backgroundColor=[UIColor blackColor];
    
//    self.navigationController.navigationBar.barTintColor = RGBA(50.0f, 50.0f, 50.0f, 1.0); //导航栏背景色
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    //修改状态栏的颜色
    
//    if (!self.statusView) {
//        self.statusView =[[UIView alloc]initWithFrame:CGRectMake(0, -20, Width, 20)];
//        self.statusView.backgroundColor=RGBA(19, 19, 19, 1.0);
//        [self.navigationController.navigationBar addSubview:self.statusView];
//    }
    
    //关闭侧边栏侧滑
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
}

-(void)creatToolbarWithCommentNum:(NSInteger)commentNum //下方评论控件
{
    
    //防治重复创建
    if (creatOrNot) {
        return;
    }

    
    //下方交互框
    self.toolbar =[[UIView alloc]initWithFrame:CGRectMake(0, Height-ToolViewHeight, Width, ToolViewHeight)];
    
    //四个按钮的frame (分享按钮,收藏按钮,查看评论按钮,评论按钮)
    UIButton *sharebtn =[[UIButton alloc]initWithFrame:CGRectMake(Width-20-28, (self.toolbar.frame.size.height-28)/2, 28, 28)];
    
    UIButton *collectbtn =[[UIButton alloc]initWithFrame:CGRectMake(sharebtn.frame.origin.x-10-28, sharebtn.frame.origin.y, 28, 28)];
    
    UIButton *checkcommentsbtn =[[UIButton alloc]initWithFrame:CGRectMake(collectbtn.frame.origin.x-10-28, collectbtn.frame.origin.y, 28, 28)];
    
    UIButton *commentbtn =[[UIButton alloc]initWithFrame:CGRectMake(20, (self.toolbar.frame.size.height-30)/2, Width-28*3-20*2-10*3, 30)];
    
    
    //设置属性
    [sharebtn setBackgroundImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [collectbtn setBackgroundImage:[UIImage imageNamed:@"bookmark_icon"] forState:UIControlStateNormal];
    [collectbtn setBackgroundImage:[UIImage imageNamed:@"bookmarked_icon"] forState:UIControlStateSelected];
    [checkcommentsbtn setBackgroundImage:[UIImage imageNamed:@"comment_icon"] forState:UIControlStateNormal];
    

    
    [commentbtn.layer setBorderColor:RGBA(255.0f,151.0f,203.0f,1.0).CGColor];
    [commentbtn.layer setCornerRadius:commentbtn.frame.size.height/2];
    [commentbtn.layer setBorderWidth:TextFieldBorderWidth];
    [commentbtn setTitle:@"写点东西呗~" forState:UIControlStateNormal];
    [commentbtn setTitleColor:RGBA(100.0f,100.0f,100.0f,1.0) forState:UIControlStateNormal];

    
    collectbtn.selected = self.newsModel.isStore ;
    
    [self addBdageNumOnBtn:checkcommentsbtn AndNum:commentNum]; //添加小红点
    
    
    
    [self.toolbar addSubview:sharebtn];
    [self.toolbar addSubview:collectbtn];
    [self.toolbar addSubview:checkcommentsbtn];
    [self.toolbar addSubview:commentbtn];

    
    self.toolbar.backgroundColor = RGBA(50, 50, 50, 0.8);
    self.toolbar.layer.shadowColor=[UIColor blackColor].CGColor;
    self.toolbar.layer.shadowOpacity=0.3;
    self.toolbar.layer.shadowOffset=CGSizeMake(0, 1);
    
    
    
    [self.view addSubview:self.toolbar];
    
    
    //给按钮添加点击事件
    [sharebtn addTarget:self action:@selector(touchToSend) forControlEvents:UIControlEventTouchUpInside];
    
    [collectbtn addTarget:self action:@selector(touchToCollect:) forControlEvents:UIControlEventTouchUpInside];
    
    [commentbtn addTarget:self action:@selector(touchToSuspend) forControlEvents:UIControlEventTouchUpInside];
    
    [checkcommentsbtn addTarget:self action:@selector(touchtToGetComments) forControlEvents:UIControlEventTouchUpInside];
    creatOrNot=YES;
    
    NSLog(@"下方控件加载完毕");
    
    [self loadmyScrollViewWithImgNumber:self.newsModel.contentPictures.count];

}

-(void)loadmyScrollViewWithImgNumber:(NSInteger)number   //加载滚动视图用于承载图片
{

    self.myScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(-ImageSpacing, NavigationBarHeight, ScrollViewWidth, ScrollViewHeight)];
    self.myScrollView.delegate=self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    self.myScrollView.bounces=NO;   //禁止弹性

    self.myScrollView.backgroundColor=[UIColor blackColor];
    
//    NSLog(@"number:%ld",number);
    
    self.myScrollView.contentSize =CGSizeMake(self.myScrollView.frame.size.width*number, self.myScrollView.frame.size.height);
    self.myScrollView.pagingEnabled=YES;
    self.myScrollView.showsHorizontalScrollIndicator=NO;    //隐藏横条

    //加载图片
    for (int i =0; i<number; i++) {

        UIImageView *imgv =[[UIImageView alloc]init];
        
        //添加一个可以用于图片缩放的滚动视图
        UIScrollView *ZoomScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(self.myScrollView.frame.size.width*i+ImageSpacing, 0, Width, Height-NavigationBarHeight)];
        ZoomScrollView.minimumZoomScale=1.0;  //缩小倍数
        ZoomScrollView.maximumZoomScale=3.0;  //放大倍数
        ZoomScrollView.delegate=self;
        ZoomScrollView.showsHorizontalScrollIndicator=NO;
        ZoomScrollView.showsVerticalScrollIndicator=NO;
        ZoomScrollView.backgroundColor=[UIColor blackColor];
        [scrollArr addObject:ZoomScrollView];

        [ImgArr addObject:imgv];    //添加进数组
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
            
            NSDictionary *dict = self.newsModel.contentPictures[i];
            
            UIImage *img = (UIImage *)[dict objectForKey:@"image"];
            
            if (img) {
                
                imgv.frame=CGRectMake(0, 0, Width, 0);
                
                [imgv setImage:img];
                
                [self processTheImageView:imgv];
            }
            
        }else{  //非离线模式
            
            if ([self.newsModel.contentPictures[i] objectForKey:@"imgPath"]) { //监测是否有值
                
                [imgv sd_setImageWithURL:[NSURL URLWithString:[MainUrl stringByAppendingString:[self.newsModel.contentPictures[i] objectForKey:@"imgPath"]]] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image) {
                        
                        [self processTheImageView:imgv];
                        
                    }
                    
                }];
                
            }
            
        }
        
        //添加点击事件
        [self addTapGestureWithScrollView:ZoomScrollView AndImageView:imgv];
        
        [self.myScrollView addSubview:ZoomScrollView];
        
        
        
    }
    
    [self.view addSubview:self.myScrollView];
    
    self.descriptionView =[[UIScrollView alloc]init];
    
    NSLog(@"滚动视图加载完毕");
    
    [self loadDescriptionViewWithNumber:0];
}

-(void)loadDescriptionViewWithNumber:(NSInteger)number //根据数组加载描述视图
{
    
    //每次视图都是重新创建
    if (self.descriptionView.subviews.count) {
        
        for (UIView *view in self.descriptionView.subviews) {
            
            [view removeFromSuperview]; //从视图上移除控件
            
        }
        
    }
    
    //暂时不给高度,以便自适应后再计算
    
    self.descriptionView.frame = CGRectMake(0, 0, Width, 0);
    self.descriptionView.backgroundColor = RGBA(50, 50, 50, 0.8);
    
    //标题
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(20, 10, TitleWidth, 0)];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont systemFontOfSize:20]];
    title.numberOfLines=0;
    
    [title setText:self.newsModel.title];
    [title sizeToFit];  //高度自适应
    [self.descriptionView addSubview:title];
    
    
    
    //下方文字描述
    UILabel *description = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+title.frame.size.height+40, self.descriptionView.frame.size.width-20*2, 0)];
    [description setTextColor:RGBA(250, 250, 250, 1.0)];
    description.numberOfLines=0;
    [description setFont:[UIFont systemFontOfSize:16]];
    
    [description setText:[self.newsModel.contentPictures[number] objectForKey:@"descriptions"]];

    [description sizeToFit];
    
    if (description.numberOfLines>0) {  //多行
        description = [self resetContentWithLabel:description];
    }
    

    //计算出能留给描述文字的高度
    CGFloat leaveHeight = DescriptionViewHeight-description.frame.origin.y-20;
    
    CGFloat minY ;  //记录描述文字的y坐标
    
    if (description.frame.size.height>leaveHeight) {
        
        //如果自适应的高度大于这个高度,将文字描述放到临时的滚动视图上
        
        UIScrollView *textscroll =[[UIScrollView alloc]initWithFrame:CGRectMake(description.frame.origin.x, description.frame.origin.y, description.frame.size.width, leaveHeight)];
        
        CGFloat desWidth =  description.frame.size.width;   //记录描述的原始宽度,用作滚动描述的宽度
        
        description.frame = CGRectMake(0, 0, desWidth, 0);  //修改描述label的宽度,防治滚动条遮挡文字
        
        textscroll.showsVerticalScrollIndicator=NO;
        
        [description sizeToFit];
        
        textscroll.contentSize =CGSizeMake(desWidth, description.frame.size.height);
        
        [textscroll addSubview:description];
        
        [self.descriptionView addSubview:textscroll];
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
            //离线
            self.descriptionView.frame =CGRectMake(0, Height-DescriptionViewHeight, self.descriptionView.frame.size.width, DescriptionViewHeight);
            
        }else{  //非离线
        
            self.descriptionView.frame =CGRectMake(0, Height-DescriptionViewHeight-ToolViewHeight, self.descriptionView.frame.size.width, DescriptionViewHeight);
        
        }
        
        minY = textscroll.frame.origin.y;
        
    }else{      //相反情况则可以直接加上
    
        [self.descriptionView addSubview:description];
        
        CGFloat finalheight = description.frame.origin.y+description.frame.size.height+20 ;
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"]) {
            //离线
            self.descriptionView.frame = CGRectMake(0, Height-finalheight, self.descriptionView.frame.size.width, finalheight);
            
        }else{  //非离线
            
            self.descriptionView.frame = CGRectMake(0, Height-ToolViewHeight-finalheight, self.descriptionView.frame.size.width, finalheight);
            
        }
        
        minY = description.frame.origin.y;
    
    }
    
    [self.view addSubview:self.descriptionView];
    
    //右边的页数提示
    UILabel *notice =[[UILabel alloc]init];
    [notice setTextColor:[UIColor whiteColor]];
    
    //文字做处理
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld/ %ld",(long)number+1,(unsigned long)self.newsModel.contentPictures.count]];

    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:24.0] range:NSMakeRange(0, 2)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0] range:NSMakeRange(2, 1)];
    
    

    notice.attributedText = str;
    
    [notice sizeToFit];
    notice.frame = CGRectMake(Width-20-notice.frame.size.width, minY-50, notice.frame.size.width, notice.frame.size.height);
    [self.descriptionView addSubview:notice];
    
    
}


//处理承载图片的UIImageView
-(void)processTheImageView:(UIImageView *)imgv
{

    [imgv sizeToFit];      //自适应大小
    
    imgv.userInteractionEnabled=YES;
    
    //最终高度
    CGFloat imgvheight = imgv.frame.size.height * (Width/imgv.frame.size.width);
    
    imgv.frame=CGRectMake(0, self.myScrollView.frame.size.height/2-imgvheight/2, Width, imgvheight);

}



#pragma mark ----- 交互方法

-(void)touchToSend  //分享按钮点击事件
{
    NSLog(@"分享中...");
//    NewsSourceModel *newsModel =[tableNews firstObject];
//    
//    NSString *imgsrc =[MainUrl stringByAppendingString:newsModel.imageSrc];
    
    //构造分享内容 qq空间分享
    id<ISSContent> publishContent = [ShareSDK content:nil//newsModel.contentDescription
                                       defaultContent:@""
                                                image:nil//[ShareSDK imageWithUrl:imgsrc]
                                                title:nil//newsModel.title
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
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用啦" otherButtonTitles:@"登录", nil];
        [alert show];
    }
    
}


-(void)sendRequestToGetDataWithDiffentCommand:(NSInteger)command AndcontentType:(NSInteger)contentType AndobjectId:(NSString *)objectId     //根据不同指令发送点赞或收藏请求
{
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *Urlstr = [[MainUrl stringByAppendingString:commandUrl]mutableCopy];
    //拼接完整url
    [Urlstr appendFormat:@"?objectId=%@&userId=%@&command=%ld&contentType=%lD&deviceId=%@",objectId,CurrentUserId,(long)command,(long)contentType,deviceId];
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:Urlstr]cachePolicy:0 timeoutInterval:5.f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"resultCode:%@",[dict objectForKey:@"resultCode"]);
            
        }else{
            
            [self showString:@"请求超时"];
            
        }
        
    }];
}


-(void)getImageNews     //获取新闻(从后台或是本地)
{
    
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db = app.db;
    FMResultSet *result =[db executeQuery:@"select * from NewsTable where newsId=?",self.newsModel.newsId];
    if([result next]) { //进入循环说明已经有缓存了,直接在本地获取之前保存的数据
        
        NSLog(@"已保存过");
        
        //耗时操作放在子线程中执行
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self getLocationNewsDataWithNewsId];   //获取本地保存的新闻数据
            
            //保存或更新浏览记录
            [self saveNewsDataHistoryToLocation];
            
        });
        
        [self getTheNewsCommand];    //获取此条新闻的相关参数(是否被收藏过、评论数等),里面包含下方控件的创建
        
    }else{              //反之说明是第一次阅览,此时需要向服务器获取数据
    
        NSLog(@"未保存过");
        
        NSString *deviceId = [self getDeviceId]; //获取设备标识
        
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
        
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:Urlstr] cachePolicy:0 timeoutInterval:10.0];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            if(data){
                
                NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
//                NSLog(@"图片资讯dic:%@",dic);
                
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
//                    [hud hide:YES];
                    [activityIndicatorView stopAnimating];
                    
                    newsModel.newsId=self.newsModel.newsId;
                    newsModel.contentType=self.newsModel.contentType;
                    self.newsModel=newsModel;
                    
                    //                NSLog(@"newsModel:%@",newsModel);
                    
                    
                    //保存数据到本地数据库
                    [self saveNewsDataToLocationWithModel:newsModel];
                    
                    //保存或更新浏览记录
                    [self saveNewsDataHistoryToLocation];
                    
                    //创建下方控件
                    [self creatToolbarWithCommentNum:[self.newsModel.commentNum integerValue]];
                    
                }
                
                
                
            }else{
                
                
//                [hud hide:YES];
                [activityIndicatorView stopAnimating];
                [self showString:@"请求超时"];
                
                
                
            }
            
            
        }];
    
    }
    
}

-(void)saveNewsDataHistoryToLocation   //保存或更新浏览记录
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
    
    for (int i=0; i<newsModel.contentPictures.count; i++) {
        
        [db executeUpdate:@"insert into NewsTable (newsId,title,commentNum,descriptions,imgPath,contentType,publishTime,source,imageSrc) values(?,?,?,?,?,?,?,?,?)",newsModel.newsId,newsModel.title,newsModel.commentNum,[newsModel.contentPictures[i] objectForKey:@"descriptions"],[newsModel.contentPictures[i] objectForKey:@"imgPath"],newsModel.contentType,newsModel.publishTime,newsModel.source,newsModel.imageSrc];
        
    }
    
    NSLog(@"保存完毕");

}

-(void)getLocationNewsDataWithNewsId    //根据当前新闻Id从本地获取保存的新闻数据
{

    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db = app.db;
    
    FMResultSet *result =[db executeQuery:@"select * from NewsTable where newsId = ?",self.newsModel.newsId];

    while ([result next]) {
        
        self.newsModel.title=[result stringForColumn:@"title"];
        
        NSMutableDictionary *descriptionDic =[NSMutableDictionary new];
        
        [descriptionDic setValue:[result stringForColumn:@"descriptions"] forKey:@"descriptions"];
        [descriptionDic setValue:[result stringForColumn:@"imgPath"] forKey:@"imgPath"];
        
        [self.newsModel.contentPictures addObject:descriptionDic];
        
        self.newsModel.commentNum = [NSNumber numberWithInt:[result intForColumn:@"commentNum"]];
        self.newsModel.contentType = [NSNumber numberWithInt:[result intForColumn:@"contentType"]];
        self.newsModel.publishTime = [result stringForColumn:@"publishTime"];
        self.newsModel.source = [result stringForColumn:@"source"];
        self.newsModel.imageSrc = [result stringForColumn:@"imageSrc"];
    }
    
//    NSLog(@"self.newsModel:%@",self.newsModel);
    
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
            
            //创建下方控件
            [self creatToolbarWithCommentNum:[self.newsModel.commentNum integerValue]];
            
        }else{
        
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


-(void)showString:(NSString *)str   //提示框
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


-(CAAnimation *)creatAnimation  //创建动画
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    return k;
}

-(void)touchToSuspend       //跳转到评论页并弹出发表评论框
{
    self.hidesBottomBarWhenPushed=YES;
    
    FirstCommentViewController *fv=[[FirstCommentViewController alloc]init];
    fv.popKeyBoard=YES;
    fv.newsModel=self.newsModel;
    [self.navigationController pushViewController:fv animated:YES];
    
}

-(void)touchtToGetComments  //跳转到评论页查看评论
{
    self.hidesBottomBarWhenPushed=YES;
    
    FirstCommentViewController *fv =[[FirstCommentViewController alloc]init];
    
    fv.newsModel=self.newsModel;
    
    [self.navigationController pushViewController:fv animated:YES];
    
}

-(void)addBdageNumOnBtn:(UIButton *)btn AndNum:(NSInteger)value    //根据数量改变小红点的显示数量
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

-(void)ActionViewToSaveImage:(UILongPressGestureRecognizer *)gesture //弹出是否保存图片的选项
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
       
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"是否保存图片?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        [action showInView:self.view];
        
    }

}

- (void)saveImage   //将图片保存至相册
{
    
    NSInteger a=self.myScrollView.contentOffset.x;
    NSInteger b=ScrollViewWidth;
    NSInteger c=a/b;
    UIImageView *currentImageView = ImgArr[c];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //写入相册
        UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
    });
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.view.center;
    _indicatorView = indicator;
    [self.view addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label];
    [self.view bringSubviewToFront:label];
    if (error) {
        label.text = @" >_< 保存失败 ";
    }   else {
        label.text = @" ^_^ 保存成功 ";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}


#pragma mark --- UIActionsheet代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    switch (buttonIndex) {
            
        case 0: //执行保存图片操作
        {
            [self saveImage];
        }
            break;
            
        default:
            break;
    }

}



#pragma mark --- 滚动视图的代理方法

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==self.myScrollView) {
        
        //直接相除会出现bug(暂不知情)
        CGFloat offset =  self.myScrollView.contentOffset.x/(Width+ImageSpacing);    //偏移页
        
//        NSLog(@"offset:%f",offset);
        [self loadDescriptionViewWithNumber:offset];
        
    }
    
}

//1.告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView!=self.myScrollView) {
        NSInteger a=self.myScrollView.contentOffset.x;
        NSInteger b=ScrollViewWidth;
        NSInteger c=a/b;
        UIImageView *imgv = ImgArr[c];

        return imgv;
    }
    
    return nil;
}

//2.重新确定缩放完后的缩放倍数
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark - 缩放大小获取方法
-(CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    
    NSInteger a=self.myScrollView.contentOffset.x;
    NSInteger b=ScrollViewWidth;
    NSInteger c=a/b;
    UIScrollView *scrollView = scrollArr[c];
    
    CGRect zoomRect;
    //大小
    zoomRect.size.height = [scrollView frame].size.height/scale;
    zoomRect.size.width = [scrollView frame].size.width/scale;
    //原点
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    return zoomRect;
}

//手势
-(void)pinGes:(UIPinchGestureRecognizer *)sender
{
    if ([sender state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    CGFloat scale = 1.0 - (lastScale -[sender scale]);
    lastScale = [sender scale];
    self.myScrollView.contentSize = CGSizeMake(self.newsModel.contentPictures.count*ScrollViewWidth, ScrollViewHeight*lastScale);
    //    NSLog(@"scale:%f   lastScale:%f",scale,lastScale);
    CATransform3D newTransform = CATransform3DScale(sender.view.layer.transform, scale, scale, 1);
    
    sender.view.layer.transform = newTransform;
    if ([sender state] == UIGestureRecognizerStateEnded) {
        //
    }
}

#pragma mark - 图片的点击，touch事件

//双击操作
-(void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"双击");
    
    NSInteger a=self.myScrollView.contentOffset.x;
    NSInteger b=ScrollViewWidth;
    NSInteger c=a/b;
    UIScrollView *scrollView = scrollArr[c];
    
    if (gestureRecognizer.numberOfTapsRequired == 2) {
        if(scrollView.zoomScale == 1){
            float newScale = [scrollView zoomScale] *2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [scrollView zoomToRect:zoomRect animated:YES];
        }else{
            float newScale = [scrollView zoomScale]/2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [scrollView zoomToRect:zoomRect animated:YES];
        }
    }
}

//两指操作
-(void)handleTwoFingerTap:(UITapGestureRecognizer *)gestureRecongnizer
{
    NSLog(@"2手指操作");
    
    NSInteger a=self.myScrollView.contentOffset.x;
    NSInteger b=ScrollViewWidth;
    NSInteger c=a/b;
    UIScrollView *scrollView = scrollArr[c];
    
    float newScale = [scrollView zoomScale]/2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecongnizer locationInView:gestureRecongnizer.view]];
    [scrollView zoomToRect:zoomRect animated:YES];
}

//给图片视图添加点击事件
-(void)addTapGestureWithScrollView:(UIScrollView *)scrollView AndImageView:(UIImageView *)imageView
{
    
    [imageView setUserInteractionEnabled:YES];
    [scrollView addSubview:imageView];
    
    //长按弹出是否保存图片的选项
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(ActionViewToSaveImage:)];
    longPressGr.minimumPressDuration = 0.8; //长按事件响应时间
    [imageView addGestureRecognizer:longPressGr];
    
    
    //添加手势
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToHideView)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    doubleTap.numberOfTapsRequired = 2;//需要点两下
    twoFingerTap.numberOfTouchesRequired = 2;//需要两个手指touch
    
    [imageView addGestureRecognizer:singleTap];
    [imageView addGestureRecognizer:doubleTap];
    [imageView addGestureRecognizer:twoFingerTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];//如果双击了，则不响应单击事件
    
    [scrollView setZoomScale:1];

}

//- (void)doubleTapToZommWithScale:(CGFloat)scale //双击图片恢复原大小
//{
//
//    [UIView animateWithDuration:0.5 animations:^{
//        [self zoomWithScale:scale];
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer   //双击图片
//{
//    
//    NSInteger a = self.myScrollView.contentOffset.x;
//    NSInteger b = ScrollViewWidth;
//    NSInteger c = a/b;
//    UIImageView *imgv = ImgArr[c];
//    
//    CGFloat scale =imgv.frame.size.width/Width; //大于1缩小,小于1放大
//    NSLog(@"scale:%f",scale);
//    
//    if (scale<1) {
//        scale=1.0/scale;  //放大至1倍(比1倍小)
//    }else if(scale>1){
//        scale=2.0/scale;  //缩小至1倍(比1倍大)
//    }else{
//        scale=2.0;
//    }
//    
//    [self doubleTapToZommWithScale:scale];
//}
//
//- (void)zoomWithScale:(CGFloat)scale    //缩放过程
//{
//    NSInteger a = self.myScrollView.contentOffset.x;
//    NSInteger b = ScrollViewWidth;
//    NSInteger c = a/b;
//
//    UIImageView *imgv = ImgArr[c];
//    UIScrollView *scrollView=scrollArr[c];
//    
//    if (scale==1) {
//        imgv.transform = CGAffineTransformMakeScale(scale, scale);
//    }else{
//       imgv.transform = CGAffineTransformScale(imgv.transform, scale, scale);
//    }
//
//    imgv.center = CGPointMake(scrollView.frame.size.width*0.5, scrollView.frame.size.height * 0.5);
//    
////    NSLog(@"imgv.w:%f\timgv.h:%f",imgv.frame.size.width,imgv.frame.size.height);
//}




//自适应计算间距
- (UILabel *)resetContentWithLabel:(UILabel *)description
{
    //行高
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:description.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.maximumLineHeight = 60;          //最大的行高
    paragraphStyle.lineSpacing = 5;                 //行自定义行高度
    [paragraphStyle setFirstLineHeadIndent:description.font.pointSize*2];   //首行缩进,为2个字体大小的宽度
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [description.text length])];
    description.attributedText = attributedString;
    [description sizeToFit];
    
    return description;
}


-(void)touchToHideView  // 点击图片 渐显/渐隐 周围视图
{
    
    if (![(NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:FirstTimeToReadImageNew] isEqualToString:@"NO"]) {
        
        [self showAlertView:@"长按图片可以选择保存哟~"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:FirstTimeToReadImageNew];
    }
    
    if (hideControl) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.navigationController.navigationBar.alpha=1;
            
            self.descriptionView.alpha=0.8;
            
            self.toolbar.alpha=0.8;
            
        } completion:^(BOOL finished) {
            
            //            NSLog(@"已显示");
            
        }];
        
        hideControl =NO;
        
    }else{
    
        [UIView animateWithDuration:0.5 animations:^{
            
            self.navigationController.navigationBar.alpha=0;
            
            self.descriptionView.alpha=0;
            
            self.toolbar.alpha=0;
            
        } completion:^(BOOL finished) {
            
            //            NSLog(@"已隐藏");
            
        }];
        
        hideControl=YES;
    
    }
    
}



#pragma mark ----- UIAlertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1) {
        
        NewLoginViewController *lv =[[NewLoginViewController alloc]init];
        
        [self.navigationController pushViewController:lv animated:YES];
        
    }
    
}















@end
