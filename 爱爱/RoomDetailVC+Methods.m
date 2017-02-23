//
//  RoomDetailVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define DownViewHeight  50  //下方控件视图的高度

#import "RoomDetailVC+Methods.h"

#import "FillOrderVC.h" //填写订单页面

#import "RoomHeaderView.h"  //自定义表头视图

#import "HotelModel.h"  //酒店模型

#import "NewLoginViewController.h"  //登录界面
#import "QuickLoginVC.h"    //快速登录页面


#import "ParallaxHeaderView.h"  //表头动态模糊库

#import "ImageTextButton.h" //带图片的按钮

#import "UIImageView+ProgressView.h"

#import "MapTextVC.h"   //展示酒店地图方位页面

#import "RomanticVC.h"  //浪漫服务详情页


@implementation RoomDetailVC (Methods)

#pragma mark ----- 统一视图加载方法

-(void)loadBaseView     //加载基本视图
{
    [self creatTableView];      //加载表视图
    
    [self getCurrentRoomDetail];    //获取当前房间的详情
    
//    [self getRoomDeviceList];     //获取当前房间的设施

}

-(void)loadOtherView    //加载剩余视图
{

    [self.HeaderView setViewWithRoomModel:self.roomModel];
    
    [self loadTableViewHeaderView]; //加载表头部分
    
    [self.mytableView reloadData];
    
    [self creatDownControl];    //创建下方控件
}


#pragma mark ----- 视图创建方法

-(void)loadTableViewHeaderView  //加载表头部分
{

    if (!self.HeaderView) {
        
        self.HeaderView = [[RoomHeaderView alloc]initWithWidth:Width];
        self.HeaderView.roomName.font = [UIFont fontWithName:PingFangSCX size:20];
        
    }
    
    //视图转image
    UIImage *headImage =[self convertViewToImage:self.HeaderView];
    
    ParallaxHeaderView *headView =[ParallaxHeaderView parallaxHeaderViewWithImage:headImage forSize:headImage.size];
    
    [self.mytableView setTableHeaderView:headView];

}

-(void)creatTableView       //创建用于展示酒店列表的表视图
{
    
    UITableView *table =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-DownViewHeight)];
    self.mytableView=table;
    [self.view addSubview:self.mytableView];
    self.mytableView.dataSource=self;
    self.mytableView.delegate=self;
    self.mytableView.tableFooterView=[[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mytableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.mytableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    //返回按钮
    [self setBackBtn];
    
    //快速返回首页
    UIButton *rightBackBtn =[[UIButton alloc]initWithFrame:CGRectMake(Width-20-44, 20, 44, 44)];
    [rightBackBtn setTitle:@"首页" forState:UIControlStateNormal];
    rightBackBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBackBtn.layer.cornerRadius=backBtn.frame.size.width/2;
    [rightBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBackBtn setBackgroundColor:RGBA(50, 50, 50, 0.5)];
    [rightBackBtn addTarget:self action:@selector(touchToPopRootView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBackBtn];
    
    [self loadTableViewHeaderView];
    
}

-(void)creatDownControl     //创建下方控件
{

    UIView *downView =[[UIView alloc]initWithFrame:CGRectMake(0, Height-DownViewHeight, Width, DownViewHeight)];
    downView.backgroundColor=[UIColor whiteColor];
    //咨询按钮
//    UIButton *ConsultingBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width/3, DownViewHeight)];
//    [ConsultingBtn setBackgroundColor:[UIColor whiteColor]];
//    [ConsultingBtn setTitle:@"咨询" forState:UIControlStateNormal];
//    [ConsultingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
//    ImageTextButton *ConsultingBtn =[[ImageTextButton alloc]initWithFrame:CGRectMake(0, 0, Width/3, DownViewHeight) image:[UIImage imageNamed:@"phonedebug_icon"] title:@"电话预订"];
//    [ConsultingBtn addTarget:self action:@selector(touchToCallHotel) forControlEvents:UIControlEventTouchUpInside];
//    ConsultingBtn.buttonTitleWithImageAlignment = UIButtonTitleWithImageAlignmentRight;
//    [downView addSubview:ConsultingBtn];
    
    //预订按钮
    UIButton *bookBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width, DownViewHeight)];
    [bookBtn setBackgroundColor:MainThemeColor];
    [bookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [bookBtn setTitle:@"订单预订" forState:UIControlStateNormal];
    if ([self.roomModel.canOrder isEqualToString:@"0"]) {
        
        [bookBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
        
    }
    
    [bookBtn addTarget:self action:@selector(touchToFillOrder) forControlEvents:UIControlEventTouchUpInside];
    bookBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [downView addSubview:bookBtn];
    
    [self.view addSubview:downView];
}

-(void)setBackBtn           //返回按钮
{
    if (backBtn) {
        
        return;
        
    }

    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 44, 44)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    backBtn.layer.cornerRadius=backBtn.frame.size.width/2;
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:RGBA(50, 50, 50, 0.5)];
    [backBtn addTarget:self action:@selector(touchToPop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

}

-(void)setRefreshBtn        //网络不好时的返回按钮添加
{
    [refreshBtn setHidden:NO];
    
    if (refreshBtn) {
        
        return;
        
    }

    refreshBtn = [UIButton new];
    [refreshBtn setTitleColor:MainThemeColor forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [refreshBtn setTitle:@"刷新一下" forState:UIControlStateNormal];
    refreshBtn.layer.borderColor = MainThemeColor.CGColor;
    refreshBtn.layer.borderWidth = 1;
    
    [self.view addSubview:refreshBtn];
    
    //布局
    refreshBtn.sd_layout
    .widthIs(80)
    .heightIs(40)
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    ;
    
    refreshBtn.sd_cornerRadius = @(5);
    
    //添加点击事件
    [refreshBtn addTarget:self action:@selector(getCurrentRoomDetail) forControlEvents:UIControlEventTouchUpInside];
    
}

//图片视图里的过度动画
-(void)loadNewImageAnimationWith:(UIImageView *)imageView AndImage:(UIImage *)image
{
    
    imageView.image = image;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [imageView.layer addAnimation:transition forKey:nil];
    
}


#pragma mark ----- 交互方法

-(void)getCurrentRoomDetail //获取当前房间的详情
{
    if (!refreshBtn.hidden) {
        
        [refreshBtn setHidden:YES];
        
    }
    
    [self loadIndicator];   //加载指示器
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *roomDetailUrl= [[MainUrl stringByAppendingString:GetRoomDetail]mutableCopy];
    [roomDetailUrl appendFormat:@"?roomId=%@&deviceId=%@",self.roomModel.roomId,deviceId];
    
//    NSLog(@"roomLisUrl:%@",roomDetailUrl);
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:roomDetailUrl] cachePolicy:0 timeoutInterval:10.0];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *resultDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"房间详情:%@",resultDic);
            
            NSDictionary *dict1 = [resultDic objectForKey:@"result"];
            
            self.hotelModel = [HotelModel new];
            //给酒店模型赋值
            [self.hotelModel setValue:[dict1 objectForKey:@"hotelId"]       forKey:@"hotelId"];
            [self.hotelModel setValue:[dict1 objectForKey:@"hotelName"]     forKey:@"hotelName"];
            [self.hotelModel setValue:[dict1 objectForKey:@"hotelAddress"]  forKey:@"hotelAddress"];
            [self.hotelModel setValue:[dict1 objectForKey:@"hotelLogo"]     forKey:@"hotelLogo"];
            
            //给房间模型赋值
            [self.roomModel setValue:[dict1 objectForKey:@"roomPrice"]      forKey:@"unitPrice"];
            [self.roomModel setValue:[dict1 objectForKey:@"roomStory"]      forKey:@"roomStory"];
            [self.roomModel setValue:[dict1 objectForKey:@"roomType"]       forKey:@"theme"];
            [self.roomModel setValue:[dict1 objectForKey:@"stayNotice"]     forKey:@"stayNotice"];
            [self.roomModel setValue:[dict1 objectForKey:@"roomPictures"]   forKey:@"roomPictures"];
            [self.roomModel setValue:[dict1 objectForKey:@"hotelLogo"]      forKey:@"belongHotelLogSrc"];
            [self.roomModel setValue:[dict1 objectForKey:@"hotelId"]        forKey:@"belongHotelID"];
            [self.roomModel setValue:[dict1 objectForKey:@"roomDevice"]     forKey:@"roomDevice"];
            [self.roomModel setValue:[dict1 objectForKey:@"hotelRomantics"] forKey:@"hotelRomantics"];
            [self.roomModel setValue:[dict1 objectForKey:@"canOrder"]       forKey:@"canOrder"];
            
            
            self.roomModel.location = [dict1 objectForKey:@"hotelAddress"];
            self.roomModel.belongHotelLogSrc = @"hotelLogo.png";
            
            //保存数据到字典，用于查看当前酒店的方位
            self.hotelDic = [NSMutableDictionary new];
            [self.hotelDic setValue:[dict1 objectForKey:@"hotelName"]       forKey:@"hotelName"];
            [self.hotelDic setValue:[dict1 objectForKey:@"hotelAddress"]    forKey:@"hotelAddress"];
            [self.hotelDic setValue:[dict1 objectForKey:@"hotelLogo"]       forKey:@"hotelPicture"];
            [self.hotelDic setValue:[dict1 objectForKey:@"roomPrice"]       forKey:@"totalCost"];
            [self.hotelDic setValue:[dict1 objectForKey:@"latitude"]        forKey:@"latitude"];
            [self.hotelDic setValue:[dict1 objectForKey:@"longitude"]       forKey:@"longitude"];
            
            [self loadViewAndHideIndicatorView];    //创建余下视图并隐藏指示器
            
            GCDWithMain(^{
            
                [self.mytableView reloadData];
            
            });
            
        }else{
            
            [activityIndicatorView stopAnimating];  //移除指示器
            
            [self showString:@"请求超时"];
            
//            [self setBackBtn];
            
            [self setRefreshBtn];
            
        }
        
    }];

}

-(void)getRoomDeviceList    //获取当前房间设施列表
{
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *roomDeviceListUrl= [[MainUrl stringByAppendingString:GetRoomDeviceList]mutableCopy];
    [roomDeviceListUrl appendFormat:@"?roomId=%@&deviceId=%@",self.roomModel.roomId,deviceId];
    
//    NSLog(@"roomDeviceListUrl:%@",roomDeviceListUrl);
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:roomDeviceListUrl] cachePolicy:0 timeoutInterval:10.0];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if ([dict objectForKey:@"result"]) {
                
                devicesArr = [dict objectForKey:@"result"]; //保存下来
                
            }
            
            [self loadViewAndHideIndicatorView];
            
        }else{
            
            [activityIndicatorView stopAnimating];  //移除指示器
            
            [self showString:@"请求超时"];
            
        }
        
    }];

}







#pragma mark ----- 辅助方法

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

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
}

-(void)showAlertView:(NSString *)string     //警告框
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}

-(void)showString:(NSString *)str           //提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}



-(void)touchToDismiss   //返回上一页
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        
    }];

}

-(void)touchToPop       //返回上一页
{

    [self.navigationController popViewControllerAnimated:YES];

}

-(void)touchToPopRootView    //返回首页
{

    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)touchToFillOrder //跳转到填写订单的页面
{

    
    if ([self.roomModel.canOrder isEqualToString:@"0"]) {   //代表不可预定
        
        [self touchToCallHotelWithPhoneNum];
        
        return;
        
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
        
        //如果登录了，跳转到填写订单的页面
        FillOrderVC *fvc =[FillOrderVC new];
        self.hidesBottomBarWhenPushed=YES;
        
        fvc.roomModel = self.roomModel;
        
        fvc.hotelModel = self.hotelModel;
        
        [self.navigationController pushViewController:fvc animated:YES];
        
        self.hidesBottomBarWhenPushed=NO;
        
    }else{  //反之弹出提示登录
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用了" otherButtonTitles:@"去登录", nil];
        alert.tag = 109 ;   //代表登录的标记
        
        [alert show];
        
    }

}


#pragma mark ----- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 109) { //代表是登录的提示框
        
        if (buttonIndex==1) {
            
            self.hidesBottomBarWhenPushed = YES ;
            
            QuickLoginVC *loginVC =[QuickLoginVC new];
            
//            [self.navigationController pushViewController:loginVC animated:YES];
            
            loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;    // 设置动画效果
            [self presentViewController:loginVC animated:YES completion:nil];
            
            self.hidesBottomBarWhenPushed = NO ;
            
        }
        
    }
    
}


-(void)touchToCallHotelWithPhoneNum     //电话咨询预订(号码根据后台获取)
{
    
    //    使用这种方式拨打电话时，当用户结束通话后，iphone界面会停留在电话界面。
    //    用如下方式，可以使得用户结束通话后自动返回到应用：
    NSString *phoneNum = @"10010";
    if (self.hotelModel.contactPhoneNum.length>0) {
        
        phoneNum = self.hotelModel.contactPhoneNum;
        
    }
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
    
}

///将UIView重绘为UIImage
-(UIImage*)convertViewToImage:(UIView*)view
{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark ----- UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mytableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.mytableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

//给滚动视图上的view添加点击事件
-(void)addtapgestureToViewsWithViewsArr:(NSArray *)viewsArr
{
    
    if (loadRecommandViewOrNot) {   //为YES说明已经对该控件进行修改过了
        
        return;
        
    }
    
    int i=0;
    
    NSArray *imageArr = [self creatImageViewsWithPageNum:5];

    for (UIImageView *view in viewsArr) {
        
        //添加点击事件
        UITapGestureRecognizer *singletap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosePicture:)];
        singletap.delegate=self;
        [view addGestureRecognizer:singletap];
        //设置图片
//        [view setImage:imageArr[i]];
        [view sd_setImageWithURL:imageArr[i] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(30, 30)];
        
        //价格
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.origin.y+20, Width/5, 30)];
        priceLabel.backgroundColor=RGBA(50, 50, 50, 0.7);
        priceLabel.textColor=[UIColor whiteColor];
        priceLabel.font=[UIFont fontWithName:PingFangSCX size:16];
        priceLabel.textAlignment=1;
        [self processAssignedAngleWith:priceLabel AndCornerRadius:priceLabel.frame.size.width];
        [view addSubview:priceLabel];
        [priceLabel setText:@"¥2333"];
        
        i++;
        
    }
    

    
    loadRecommandViewOrNot = YES;
    
}

//给方位标签添加点击事件，跳转到地图页面
-(void)addtapGestureToLocationLabel:(UIView *)mapLabel
{

    //添加方位点击事件(跳转到地图页)
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToShowMap:)];
    singleTap.delegate=self;
    [mapLabel addGestureRecognizer:singleTap];

}

//给浪漫服务视图上的view添加点击事件
-(void)addtapGestureToRomanticViewWithViewsArr:(NSArray *)viewsArr
{

//    if (loadRomanticViewOrNot) {    //为yes代表已经添加过点击事件
//        
//        return;
//        
//    }
    
    int i=0;
    
    for (UIImageView *view in viewsArr) {
        
        //添加点击事件
        UITapGestureRecognizer *singletap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchRomanticService:)];
        singletap.delegate=self;
        [view addGestureRecognizer:singletap];
        view.tag = i;
        i++;
        
    }
    
    loadRomanticViewOrNot = YES;

}

//浪漫服务视图的点击事件
-(void)touchRomanticService:(UITapGestureRecognizer *)tapView
{

//    NSLog(@"点击了第个%ld浪漫服务",tapView.view.tag);
//    
//    NSLog(@"浪漫服务数组:%@",self.roomModel.hotelRomantics);
    
    NSMutableDictionary *dic = self.roomModel.hotelRomantics[tapView.view.tag];
    
    RomanticVC *RVC = [RomanticVC new];
    
    RVC.romanticDic = dic;
    
    self.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:RVC animated:YES];
    
    self.hidesBottomBarWhenPushed=NO;
    
}


//图片点击事件
-(void)choosePicture:(UITapGestureRecognizer *)tapView
{
    
    RoomDetailVC *rvc =[RoomDetailVC new];
    
    rvc.roomModel = self.roomModel;
    
    self.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:rvc animated:YES];
    
    self.hidesBottomBarWhenPushed=NO;
    
}

//地址Label点击事件
-(void)touchToShowMap:(UITapGestureRecognizer *)tapView
{

    NSLog(@"跳转到地图页");
    
    MapTextVC *mtVC = [MapTextVC new];
    
    mtVC.orderDic = self.hotelDic;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mtVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

//第一次进入清空浪漫服务的选取项
-(void)clearSingleExampleSelectedData
{
    
    RomanticSingleExample *single = [RomanticSingleExample shareExample];
    [single.serviceArr removeAllObjects];   //清空

}




//指定切角方位(目前是切右边的上下2个角)
-(void)processAssignedAngleWith:(UIView *)view AndCornerRadius:(CGFloat)cornerRadius
{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
}

-(void)loadViewAndHideIndicatorView //加载视图并隐藏指示器
{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self loadOtherView];   //加载余下视图
        
        [activityIndicatorView stopAnimating];  //移除指示器
        
    });

}


#pragma mark ----- 虚拟数据区

//创建图片数组
-(NSArray *)creatImageViewsWithPageNum:(NSInteger)pageNum
{
    
    NSArray *imageStrArr = @[@"http://upload.17u.net/uploadpicbase/2010/08/06/aa/2010080613352820173.jpg",
                             
                             @"http://pic12.nipic.com/20110105/6586686_140058039101_2.jpg",
                             
                             @"http://imgsrc.baidu.com/baike/pic/item/3bb22487f7d81e73c75cc346.jpg",
                             
                             @"http://pic28.nipic.com/20130331/12255077_174006563121_2.jpg",
                             
                             @"http://www.elongstatic.com/imageapp/hotels/hotelimages/1801/41801005/ceed69c5-b525-4480-893b-9bd7ff020c17.png"
                             
                             ];
    
    NSMutableArray *imagesArr = [NSMutableArray new];
    
    for (int i=0; i<pageNum; i++) {
        
        [imagesArr addObject:imageStrArr[i]];
    }
    
    return imagesArr;
    
}











@end
