//
//  NewsWebVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define  tableF mytableView.mj_footer
#import "UIImageView+ProgressView.h"
#import "YSWebView.h"
#import "MJRefresh.h"
#import <ShareSDK/ShareSDK.h>


#import "NewsWebVC.h"
#import "QuickLoginVC.h"
#import "WKWebView+Motheds.h"   //引入wkwebview的类别


@interface NewsWebVC ()<YSWebViewDelegate,UIGestureRecognizerDelegate,WKNavigationDelegate,WKUIDelegate,UIActionSheetDelegate,UIScrollViewDelegate>

{

    YSWebView *headerWebView; //作为表头
    
    UITableView *mytableView;
    
    DGActivityIndicatorView *activityIndicatorView; //加载指示器
    
    NSMutableArray *commentsArr;    //评论数组
    
    UIAlertView *myAlert;               //提示框
    
    UIButton *collectbtn;       //收藏按钮
    
    UIView *bgView;             //用于展示大图的背景
    
    UIImageView *imgView;       //用于展示大图的图片视图
    
    WKWebView *WkwebView;       //网页视图
    
    NSMutableArray *imageArr;   //保存图片的数组
    
}

@end

@implementation NewsWebVC




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    commentsArr = [NSMutableArray new];
    
    imageArr = [NSMutableArray new];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self updataTheNavigationbar];
    
    [self getTheNewsCommand];   //获取收藏状况
    
//    NSLog(@"新闻的字典内容:%@",self.newsModel);
}

-(void)viewDidDisappear:(BOOL)animated
{

    WkwebView.scrollView.delegate = nil;    //加上这样一句话才不会崩溃

}

#pragma mark ----- 视图加载方法

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
    
    
//    [self.navigationController setNavigationBarHidden:YES];
    

    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle(18, RGBA(50, 50, 50, 1));
        
    }else{
        
        SetNavigationBarTitle(18, [UIColor whiteColor]);
        
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
}

-(void)addCollectBtnAndShareBtn //添加右边的分享和收藏按钮
{

    //右边按钮
    //收藏
    collectbtn =[UIButton new]; //收藏按钮
    [collectbtn setBackgroundImage:[UIImage imageNamed:@"bookmark_icon"] forState:UIControlStateNormal];
    [collectbtn setBackgroundImage:[UIImage imageNamed:@"bookmarked_icon"] forState:UIControlStateSelected];
    [collectbtn sizeToFit];
    [collectbtn addTarget:self action:@selector(touchToCollect:) forControlEvents:UIControlEventTouchUpInside];
    collectbtn.selected = [[self.newsModel objectForKey:@"isStore"] integerValue];
    UIBarButtonItem *collectBtn = [[UIBarButtonItem alloc]initWithCustomView:collectbtn];
    
    //分享
    UIButton *sharebtn =[UIButton new]; //分享按钮
    [sharebtn setBackgroundImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [sharebtn sizeToFit];
    [sharebtn addTarget:self action:@selector(touchToShare) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc]initWithCustomView:sharebtn];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    
    self.navigationItem.rightBarButtonItems = @[collectBtn,space,shareBtn];

}

-(void)loadWebView  //加载网页
{

    headerWebView = [YSWebView new];
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    [self.view addSubview:headerWebView];
    
    headerWebView.sd_layout
    .topSpaceToView(self.view,64)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    ;
    
    headerWebView.delegate =self;
    
    [headerWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewUrlStr]]];

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

-(void)loadWkWebView    //加载wkwebview
{
    //创建配置对象
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    
    
    
    WkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, Width, Height-NavigationBarHeight) configuration:config];
    [self.view addSubview:WkwebView];
    
    WkwebView.allowsBackForwardNavigationGestures =YES; //允许左滑返回
    
    [WkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webViewUrlStr]]];
    
    // 导航代理
    WkwebView.navigationDelegate = self;
    // 与wkwebview UI交互代理
    WkwebView.UIDelegate = self;
    
}

-(void)stopLoadProgress //隐藏加载动画
{

    [activityIndicatorView stopAnimating]; //隐藏加载动画

}


#pragma mark -----  WkWebView Delegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{

    NSLog(@"didStartProvisionalNavigation");

}

//加载完网页后显示会延迟，可能是绘制需要时间
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{

    NSLog(@"didFinishNavigation");

    [self performSelector:@selector(stopLoadProgress) withObject:nil afterDelay:2];
    
    [self saveNewsDataToLocation];  //更新浏览历史
    
    [self addTapOnWebView]; //添加点击事件
    
    // 禁用用户选择
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    
    // 禁用长按弹出框
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    
    //记得要加这句话，才能确保完美缩放到适配当前屏幕大小
    [webView evaluateJavaScript:@"document.body.style.zoom=1.0" completionHandler:nil];
    
    
    WkwebView.scrollView.delegate = self;


}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{

    NSLog(@"didFailProvisionalNavigation");

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    [webView showBigImage:navigationAction.request];
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

//禁止WKWebView自带的滚动视图可以任意缩放的问题
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return nil;
    
}



////////////-----暂停使用-----

#pragma mark ---- YSWebView Delegate
//开始加载时调用
- (void)webViewDidStartLoad:(YSWebView *)webView
{

    

}

//完成加载后调用
- (void)webViewDidFinishLoad:(YSWebView *)webView
{
    
    [activityIndicatorView stopAnimating]; //隐藏加载动画
    
    [self saveNewsDataToLocation];  //更新浏览历史
    
    [self addTapOnWebView]; //添加点击事件

}
//加载失败时调用
- (void)webView:(YSWebView *)webView didFailLoadWithError:(NSError *)error
{

    showHudString(@"加载失败啦...");

}


////////////-----暂停使用-----



#pragma mark ----- 请求方法

-(IBAction)touchToCollect:(UIButton *)sender   //收藏资讯
{

    //登录状态下
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
        
        
        sender.selected=!sender.selected;
        [sender.layer addAnimation:[self creatAnimation] forKey:@"SHOW"];
        if (sender.isSelected) {
            
            showHudString(@"已收藏");
            [self sendRequestToGetDataWithDiffentCommand:1 AndcontentType:1 AndobjectId:[NSString stringWithFormat:@"%@",[self.newsModel objectForKey:@"newsId"]]];
            
        }else{
            [self sendRequestToGetDataWithDiffentCommand:0 AndcontentType:1 AndobjectId:[NSString stringWithFormat:@"%@",[self.newsModel objectForKey:@"newsId"]]];
            showHudString(@"已取消");
            
        }
    }else{//非登录状态下,提示登录
        
        myAlert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用了" otherButtonTitles:@"登录", nil];
        [myAlert show];
    }

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
            
            showHudString(@"请求超时");
            
        }
        
    }];
}


#pragma mark ----- 分享相关
///***********///
-(void)touchToShare     //分享资讯
{

    NSLog(@"准备分享...");
    
    //因为微博无法分享网络图片，暂时先不添加图片
//    NSString *imgsrc =[MainUrl stringByAppendingString:[_newsModel objectForKey:@"imageSrc"]];
    
    //构造分享内容 
    id<ISSContent> publishContent = [ShareSDK content:@""
                                       defaultContent:@""
                                                image:nil
                                                title:[_newsModel objectForKey:@"title"]
                                                  url:@"http://www.aiai.com"//分享点击的url
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //自定义分享数组
    NSArray *shareArr = [self creatShareArrWithPublishContent:publishContent];
    
    //弹出分享菜单(只需要传入自定义好的分享数组即可)
    [ShareSDK showShareActionSheet:nil shareList:shareArr content:nil statusBarTips:NO authOptions:nil shareOptions:nil result:nil];
    

}

-(NSArray *)creatShareArrWithPublishContent:(id<ISSContent>) publishContent    //自定义分享数组
{
    
    //微博
    id<ISSShareActionSheetItem> weiboShare = [ShareSDK shareActionSheetItemWithTitle:@"微博" icon:[UIImage imageNamed:@"weibo_icon"] clickHandler:^{
        
        [self creatShareItemViewWithPublishContent:publishContent ShareType:ShareTypeSinaWeibo];
        
    }];
    
    //qq空间
    id<ISSShareActionSheetItem> qqShare = [ShareSDK shareActionSheetItemWithTitle:@"qq空间" icon:[UIImage imageNamed:@"qq_icon"] clickHandler:^{
        
        [self creatShareItemViewWithPublishContent:publishContent ShareType:ShareTypeQQSpace];
        
    }];
    
    //微信
    id<ISSShareActionSheetItem> wechatShare = [ShareSDK shareActionSheetItemWithTitle:@"微信" icon:[UIImage imageNamed:@"weixin"] clickHandler:^{
        
        [self creatShareItemViewWithPublishContent:publishContent ShareType:ShareTypeWeixiTimeline];
        
    }];
    
    //存入分享数组
    NSArray *arr = @[weiboShare,qqShare,wechatShare];
    
    return arr;
}

//根据传过来的分享类型及内容构建分享视图
-(void)creatShareItemViewWithPublishContent:(id<ISSContent>)publishContent ShareType:(ShareType)sharetype
{

    [ShareSDK showShareViewWithType:sharetype
                          container:nil
                            content:publishContent
                      statusBarTips:YES
                        authOptions:nil
                       shareOptions:nil
                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                 
                                 if (state == SSPublishContentStateSuccess)
                                 {
                                     showHudString(@"分享成功~");
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"发表成功"));
                                 }
                                 else if (state == SSPublishContentStateFail)
                                 {
                                     showHudString(@"网络出错啦!");
                                     NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"发布失败!error code == %d, error code == %@"), [error errorCode], [error errorDescription]);
                                 }
                             }];

}

///***********///


-(void)saveNewsDataToLocation   //保存或更新浏览记录
{
    
    //保存到数据库的浏览历史表里
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db=app.db;
    
    //先查看是否有浏览过
    FMResultSet *result = [db executeQuery:@"select * from BrowsHistoryTable where newsId  = ?",[self.newsModel objectForKey:@"newsId"]];
    
    NSString *currentDate = [self getTheCurrentDate];   //获取当前时间节点
    
    if ([result next]) {    //如果已经存在,修改其浏览的时间为当前时间即可
        
        NSLog(@"已经浏览过了");
        
        BOOL update = [db executeUpdate:@"update BrowsHistoryTable set browsTime =? where newsId =? ",currentDate,[self.newsModel objectForKey:@"newsId"]];
        
        if (update) {
            
            NSLog(@"更新浏览历史时间成功");
            
        }else{
            
            NSLog(@"更新浏览历史时间失败");
            
        }
        
    }else{                  //如果不存在,添加到数据库
        NSLog(@"没有浏览过");
        //图片的data
//        UIImageView *view =[[UIImageView alloc]init];
//        [view sd_setImageWithURL:[NSURL URLWithString:[MainUrl stringByAppendingString:[self.newsModel objectForKey:@"imageSrc"]]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//            NSData *data;
//            if (UIImagePNGRepresentation(image) == nil) {
//                
//                data = UIImageJPEGRepresentation(image, 1);
//                
//            } else {
//                
//                data = UIImagePNGRepresentation(image);
//            }
//            
//            BOOL insert = [db executeUpdate:@"insert into BrowsHistoryTable (newsId ,contentType ,title ,titleImg ,publishTime ,source ,browsTime,shareUrl) values (?,?,?,?,?,?,?,?)",[self.newsModel objectForKey:@"newsId"],[self.newsModel objectForKey:@"contentType"],[self.newsModel objectForKey:@"title"],data,[self.newsModel objectForKey:@"publishTime"],[self.newsModel objectForKey:@"source"],currentDate,[self.newsModel objectForKey:@"shareUrl"]];
//            
//            
//            if (insert) {
//                
//                NSLog(@"插入浏览历史成功");
//                
//            }else{
//                
//                NSLog(@"插入浏览历史失败");
//                
//            }
//            
//        }];
        
        //使用下载的方法
        if ([self.newsModel objectForKey:@"imageSrc"]) {
            
            NSURL *imageUrl = [NSURL URLWithString:[MainUrl stringByAppendingString:[self.newsModel objectForKey:@"imageSrc"]]];
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imageUrl options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                
                BOOL insert = [db executeUpdate:@"insert into BrowsHistoryTable (newsId ,contentType ,title ,titleImg ,publishTime ,source ,browsTime,shareUrl) values (?,?,?,?,?,?,?,?)",[self.newsModel objectForKey:@"newsId"],[self.newsModel objectForKey:@"contentType"],[self.newsModel objectForKey:@"title"],data,[self.newsModel objectForKey:@"publishTime"],[self.newsModel objectForKey:@"source"],currentDate,[self.newsModel objectForKey:@"shareUrl"]];
                
                
                if (insert) {
                    
                    NSLog(@"插入浏览历史成功");
                    
                }else{
                    
                    NSLog(@"插入浏览历史失败");
                    
                }
                
            }];
            
        }else{
            
            NSLog(@"imageSrc不存在,无法保存浏览历史");
        
        }
        
        
    }
    
}

-(void)getTheNewsCommand     //获取此条新闻的相关参数(是否被收藏过、评论数等)
{
    [self loadIndicator];
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *Urlstr = [[MainUrl stringByAppendingString:NewsCommandUrl]mutableCopy];
    
    if (CurrentUserId) {    //是否登录
        
        [Urlstr appendFormat:@"?objectId=%@&userId=%@&deviceId=%@",[self.newsModel objectForKey:@"newsId"],CurrentUserId,deviceId];
        
    }else{
        
        [Urlstr appendFormat:@"?objectId=%@&userId=&deviceId=%@",[self.newsModel objectForKey:@"newsId"],deviceId];
        
    }
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:Urlstr] cachePolicy:0 timeoutInterval:10.0];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
//            NSLog(@"新闻是否被收藏和评论数返回dict:%@",dict);
            
            [self.newsModel setValue:[NSNumber numberWithInteger:[[dict objectForKey:@"commentNum"] integerValue]] forKey:@"commentNum"];
            
            [self.newsModel setValue:[NSString stringWithFormat:@"%ld",[[dict objectForKey:@"isStore"] integerValue]] forKey:@"isStore"];
            
            
            GCDWithMain(^{
            
                [self addCollectBtnAndShareBtn];
                
//                [self loadWebView]; //然后再加载网页
                
                [self loadWkWebView];
                
            });
            
            
//            NSLog(@"newsModel:%@",_newsModel);
            
        }else{
        
            [activityIndicatorView stopAnimating]; //隐藏加载动画
            
            showHudString(@"请求超时");
        
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

-(CAAnimation *)creatAnimation  //创建动画
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    return k;
}


#pragma mark ----- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==myAlert) {
        
        if (buttonIndex==1) {
            
            self.hidesBottomBarWhenPushed=YES;
            
            QuickLoginVC *qvc =[QuickLoginVC new];
//            [self.navigationController pushViewController:qvc animated:YES];
            
            qvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;    // 设置动画效果
            [self presentViewController:qvc animated:YES completion:nil];
            
//            self.hidesBottomBarWhenPushed=NO;
            
        }
        
    }
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








#pragma mark ----- 图片点击事件相关



-(void)addTapOnWebView
{
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    [WkwebView addGestureRecognizer:singleTap];
    
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer) {
        
    }
    
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    
    if (imageArr.count>0) {
        
        return;
        
    }
    
    
//    [WkwebView getImageUrlByJS:WkwebView];
    
    [self getImageUrlByJS:WkwebView];
    
}

-(NSArray *)getImageUrlByJS:(WKWebView *)wkWebView  //通过js获取页面中的所有图片地址
{
    //查看大图代码
    
    //js方法遍历图片添加点击事件返回图片个数
    static  NSString * const jsGetImages =
    
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgUrlStr='';\
    for(var i=0;i<objs.length;i++){\
    if(i==0){\
    if(objs[i].alt==''){\
    imgUrlStr=objs[i].src;\
    }\
    }else{\
    if(objs[i].alt==''){\
    imgUrlStr+='#'+objs[i].src;\
    }\
    }\
    objs[i].onclick=function(){\
    if(this.alt==''){\
    document.location=\"myweb:imageClick:\"+this.src;\
    }\
    };\
    };\
    return imgUrlStr;\
    };";
    
    //用js获取全部图片
    
    [wkWebView evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {
        
        NSLog(@"js___Result==%@",Result);
        
        NSLog(@"js___Error -> %@", error);
        
    }];
    
    
    
    
    
    NSString *js2=@"getImages()";
    
    
    
//    __block NSArray *array=[NSArray array];
    
    __block typeof(imageArr) blockimageArr = imageArr;
    
    [wkWebView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        
        NSLog(@"js2__Result==%@",Result);
        
        NSLog(@"js2__Error -> %@", error);
        
        
        
        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        
        
        
        if([resurlt hasPrefix:@"#"])
            
        {
            
            resurlt=[resurlt substringFromIndex:1];
            
        }
        
        NSLog(@"result===%@",resurlt);
        
//        array = [resurlt componentsSeparatedByString:@"#"];
        
        [blockimageArr addObjectsFromArray:[resurlt componentsSeparatedByString:@"#"]];
        
        NSLog(@"array====%@",blockimageArr);
        
        [wkWebView setMethod:blockimageArr];
        
    }];
    
    return blockimageArr;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
