//
//  OrderDetailVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/6.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define DownControlViewHeight 50

#define Margin 20   //左右边距 


#import "OrderDetailVC+Methods.h"

#import "UIImageView+ProgressView.h"    //带进度圈的图片加载库

#import "CZCountDownView.h" //倒计时视图

#import "MapTextVC.h"

#import "AlipayHeader.h"    //引入一键集成支付宝库的头文件


@implementation OrderDetailVC (Methods)

#pragma mark ----- 统一视图加载方法
-(void)loadBaseView //加载基本视图
{

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self updataTheNavigationbar];  //修改导航栏
    
    if (!self.orderDic) {   //此时通过网络请求订单的详情
        
        [self getCurrnentOrderStatus];
        
    }else{
    
        //已经有数据久可以直接加载视图了
        [self loadAllView];
    
    }
    
}

//开始加载视图
-(void)loadAllView
{

    [self loadScrollView];          //加载滚动视图
    
    if (self.hideLeftBtn) {
        
        [self creatOrderNotice];
        
        return;
        
    }
    
    [self loadDownControl];         //加载下方控件
    
    NSLog(@"orderDic:%@",self.orderDic);

}

-(void)updataTheNavigationbar   //导航栏设置
{
    //左按钮
    self.leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [self.leftButton setBackgroundImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [self.leftButton addTarget:self action:@selector(touchToPop)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
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
    
    //修改右侧按钮
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [rightButton setBackgroundImage:[[UIImage imageNamed:@"home_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(touchToPoprootView)forControlEvents:UIControlEventTouchUpInside];
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
    
    
    //修改标题字体大小和颜色
    self.title=@"订单详情";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNormal);
        
    }else{
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNight);
        
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    if (self.hideLeftBtn) {
        
        self.leftButton.hidden=YES;
        
        self.leftButton.enabled = NO;
        
//        self.title=@"预定成功";
//        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], MainThemeColor);
        
    }
    
}

-(void)loadScrollView   //加载滚动视图上的相关信息
{
    
    UIScrollView *scrollView =[UIScrollView new];
    [self.view addSubview:scrollView];

    //等待入住
    UIView *waitView =[UIView new];
    waitView.backgroundColor=MainThemeColor;
    
    
    
    //分割线1
    UILabel *seperatorline1 =[UILabel new];
    seperatorline1.backgroundColor=SeperatorLineColor;
    
    //订单相关
    UIView *orderView = [UIView new];
    
    
    //分割线2
    UILabel *seperatorline2 =[UILabel new];
    seperatorline2.backgroundColor=SeperatorLineColor;
    

    //酒店相关
    UIView *hotelView = [UIView new];
    
    
    //分割线3
    UILabel *seperatorline3 =[UILabel new];
    seperatorline3.backgroundColor=SeperatorLineColor;
    
    
    //方位
    UIView *locationView = [UIView new];
    
    //分割线4
    UILabel *seperatorline4 =[UILabel new];
    seperatorline4.backgroundColor=SeperatorLineColor;
    
    
    NSArray *viewsArr = @[waitView,seperatorline1,orderView,seperatorline2,hotelView,seperatorline3,locationView,seperatorline4];
    
    //按顺序一次性添加
    [scrollView sd_addSubviews:viewsArr];
    
    //开始布局
    scrollView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,NavigationBarHeight)
    .bottomSpaceToView(self.view,DownControlViewHeight)
    ;
    
    //等待入住视图部分
    [self addViewOnWaitView:waitView AndSuperView:scrollView];  //添加控件
    
    seperatorline1.sd_layout
    .topSpaceToView(waitView,0)
    .leftSpaceToView(scrollView,0)
    .rightSpaceToView(scrollView,0)
    .heightIs(10)
    ;
    
    //订单信息视图部分
    [self addViewOnOrderView:orderView AndSuperView:scrollView AndLastView:seperatorline1];  //添加控件
    
    seperatorline2.sd_layout
    .topSpaceToView(orderView,0)
    .leftSpaceToView(scrollView,0)
    .rightSpaceToView(scrollView,0)
    .heightIs(10)
    ;
    
    
    //酒店信息视图部分
    [self addViewOnHotelView:hotelView AndSuperView:scrollView AndLastView:seperatorline2]; //添加控件
    
    
    seperatorline3.sd_layout
    .topSpaceToView(hotelView,0)
    .leftSpaceToView(scrollView,0)
    .rightSpaceToView(scrollView,0)
    .heightIs(10)
    ;
    
    //方位视图部分
    [self addViewOnLocationView:locationView AndSuperView:scrollView AndLastView:seperatorline3];
    
    
    seperatorline4.sd_layout
    .topSpaceToView(locationView,0)
    .leftSpaceToView(scrollView,0)
    .rightSpaceToView(scrollView,0)
    .heightIs(10)
    ;
    
    [scrollView setupAutoContentSizeWithBottomView:seperatorline4 bottomMargin:0];
    
}

//在等待入住视图上添加控件
-(void)addViewOnWaitView:(UIView *)waitView AndSuperView:(UIView *)superView
{
    //等待入住
    UILabel *waitLabel =[UILabel new];
    waitLabel.textColor=[UIColor whiteColor];
    waitLabel.font=[UIFont fontWithName:PingFangSCX size:18];
    
    //剩余时间
//    UILabel *surplusLabel =[UILabel new];
//    surplusLabel.textColor=[UIColor whiteColor];
//    surplusLabel.font=[UIFont boldSystemFontOfSize:16];
    
    CZCountDownView *countDown  = [CZCountDownView cz_countDown];   //非单例
    [countDown setHidden:YES];
    
    countDown.dayTextColor      = [UIColor whiteColor];
    countDown.hourTextColor     = [UIColor whiteColor];
    countDown.minuteTextColor   = [UIColor whiteColor];
    countDown.secondsTextColor  = [UIColor whiteColor];
    countDown.separateLabelColor= [UIColor whiteColor];
    countDown.backgroundColor   = MainThemeColor;
    
    
    NSArray *viewsArr = @[waitLabel,countDown];
    
    [waitView sd_addSubviews:viewsArr];
    
    //开始布局
    waitView.sd_layout
    .topSpaceToView(superView,0)
    .leftSpaceToView(superView,0)
    .rightSpaceToView(superView,0)
    ;
    
    
    waitLabel.sd_layout
    .leftSpaceToView(waitView,Margin)
    .topSpaceToView(waitView,20)
    .autoHeightRatio(0)
    ;
    
    [waitLabel setSingleLineAutoResizeWithMaxWidth:Width-Margin*2];    //单行文本自适应宽度

    countDown.sd_layout
    .leftEqualToView(waitLabel)
    .topSpaceToView(waitLabel,20)
    .widthIs(200)
    .heightIs(30)
    ;
    
//    [surplusLabel setSingleLineAutoResizeWithMaxWidth:Width-Margin*2];    //单行文本自适应宽度
    
    
    //整体高度适配
    [waitView setupAutoHeightWithBottomViewsArray:viewsArr bottomMargin:20];
    
    
    //虚拟数据
    NSString *orderStatus;
    int a = [[self.orderDic objectForKey:@"orderStatus"]intValue];
    switch (a) {
        case 0: //用户取消
            
            
            break;
        case 1: //用户已下单，酒店还未确认
            
            orderStatus = @"待处理";
            
            break;
        case 2: //酒店取消
            
            orderStatus = @"无库存";
            
            break;
        case 3: //酒店确认订单
            
            orderStatus = @"待入住";
            
            break;
        case 4: //已入住
            
            orderStatus = @"已入住";
            
            break;
            
            
            
        default:
            break;
    }
    [waitLabel setText:orderStatus];

//    [surplusLabel setText:@"23小时后自动关闭"];
    
    countDown.timestamp = [self getCountdownTime];
    
    countDown.timerStopBlock        = ^{    //倒计时结束的回调
        NSLog(@"时间停止");
        
//        [self cancelOrder]; //取消订单
    };
    
}

//在订单信息视图上添加控件
-(void)addViewOnOrderView:(UIView *)orderView AndSuperView:(UIView *)superView AndLastView:(UIView *)lastView
{
    //订单号
    UILabel *orderNum  = [UILabel new];
    [self processLabel:orderNum AndTextColor:TitleTextColorNormal AndFont:14];
    
    //下单时间
    UILabel *orderDate = [UILabel new];
    [self processLabel:orderDate AndTextColor:TitleTextColorNormal AndFont:14];
    
    //入住时间
    UILabel *intakeDates = [UILabel new];
    [self processLabel:intakeDates AndTextColor:TitleTextColorNormal AndFont:14];
    
    //联系人
    UILabel *contact = [UILabel new];
    [self processLabel:contact AndTextColor:TitleTextColorNormal AndFont:14];
    
    //联系方式
    UILabel *phoneNum = [UILabel new];
    [self processLabel:phoneNum AndTextColor:TitleTextColorNormal AndFont:14];
    
    //支付方式
    payMethod = [UILabel new];
    [self processLabel:payMethod AndTextColor:TitleTextColorNormal AndFont:14];
    
    
    NSArray *viewsArr = @[orderNum,orderDate,intakeDates,contact,phoneNum,payMethod];
    
    //按顺序一次性添加
    [orderView sd_addSubviews:viewsArr];

    //开始布局
    orderView.sd_layout
    .topSpaceToView(lastView,0)
    .leftSpaceToView(superView,0)
    .rightSpaceToView(superView,0)
    ;
    
    orderNum.sd_layout
    .leftSpaceToView(orderView,Margin)
    .topSpaceToView(orderView,10)
    .autoHeightRatio(0)
    ;
    
    [orderNum setSingleLineAutoResizeWithMaxWidth:Width-Margin*2];    //单行文本自适应宽度
    
    
    orderDate.sd_layout
    .leftSpaceToView(orderView,Margin)
    .topSpaceToView(orderNum,10)
    .autoHeightRatio(0)
    ;
    
    [orderDate setSingleLineAutoResizeWithMaxWidth:Width-Margin*2];    //单行文本自适应宽度
    
    
    intakeDates.sd_layout
    .leftSpaceToView(orderView,Margin)
    .topSpaceToView(orderDate,10)
    .autoHeightRatio(0)
    ;
    
    [intakeDates setSingleLineAutoResizeWithMaxWidth:Width-Margin*2];    //单行文本自适应宽度
    
    
    contact.sd_layout
    .leftSpaceToView(orderView,Margin)
    .topSpaceToView(intakeDates,10)
    .autoHeightRatio(0)
    ;
    
    [contact setSingleLineAutoResizeWithMaxWidth:Width-Margin*2];    //单行文本自适应宽度
    
    phoneNum.sd_layout
    .leftSpaceToView(orderView,Margin)
    .topSpaceToView(contact,10)
    .autoHeightRatio(0)
    ;
    
    [phoneNum setSingleLineAutoResizeWithMaxWidth:Width-Margin*2];    //单行文本自适应宽度
    
    payMethod.sd_layout
    .leftSpaceToView(orderView,Margin)
    .topSpaceToView(phoneNum,10)
    .autoHeightRatio(0)
    ;
    
    [payMethod setSingleLineAutoResizeWithMaxWidth:Width-Margin*2];    //单行文本自适应宽度
    
    
    [orderView setupAutoHeightWithBottomViewsArray:viewsArr bottomMargin:10];
    
    
    //添加数据
    [orderNum       setText:[NSString stringWithFormat:@"订单编号  : %@",[self.orderDic objectForKey:@"orderCode"]]];
    [orderDate      setText:[NSString stringWithFormat:@"下单时间  : %@",[self.orderDic objectForKey:@"orderTime"]]];
    [intakeDates    setText:[NSString stringWithFormat:@"入住时间  : %@",[self.orderDic objectForKey:@"stayTimes"]]];
    [contact        setText:[NSString stringWithFormat:@"联系用户  : %@",[self.orderDic objectForKey:@"contactName"]]];
    [phoneNum       setText:[NSString stringWithFormat:@"联系方式  : %@",[self.orderDic objectForKey:@"phoneNum"]]];
    
    if ([self.orderDic objectForKey:@"accountType"]) {
        
        switch ([(NSString *)[self.orderDic objectForKey:@"accountType"] intValue]) {
            case 1:
                
                [payMethod       setText:[NSString stringWithFormat:@"支付方式  : %@",@"支付宝"]];
                
                break;
                
            default:
                break;
        }
        
    }else{
    
       [payMethod       setText:[NSString stringWithFormat:@"支付方式  : %@",@"未知"]];
    
    }
    
    
}

//在酒店信息视图上添加控件
-(void)addViewOnHotelView:(UIView *)hotelView AndSuperView:(UIView *)superView AndLastView:(UIView *)lastView
{
    //配图
    UIImageView *hotelImgv =[UIImageView new];
    
    
    //标题
    UILabel *title = [UILabel new];
    title.textColor=MainThemeColor;
    title.font=[UIFont fontWithName:PingFangSCX size:18];
    
    
    //所属酒店
    UILabel *belongHotel = [UILabel new];
    belongHotel.textColor=TitleTextColorNormal;
    belongHotel.font=[UIFont fontWithName:PingFangSCX size:14];
    belongHotel.numberOfLines=0;
    
    
    //总价
    UILabel *totalPrice = [UILabel new];
    totalPrice.textColor=MainThemeColor;
    totalPrice.font=[UIFont fontWithName:PingFangSCX size:18];
    
    
    NSArray *viewsArr = @[hotelImgv,title,belongHotel,totalPrice];
    
    //按顺序一次性添加
    [hotelView sd_addSubviews:viewsArr];
    
    CGFloat averageWidth = (Width-Margin*2-10)/2;
    CGFloat imgvHeight = averageWidth*9/16;
    CGFloat space = 10;
    CGFloat labelHeight = (imgvHeight-space)/2;
    
    //开始布局
    hotelView.sd_layout
    .topSpaceToView(lastView,0)
    .leftSpaceToView(superView,0)
    .rightSpaceToView(superView,0)
    ;
    
    hotelImgv.sd_layout
    .topSpaceToView(hotelView,10)
    .leftSpaceToView(hotelView,Margin)
    .widthIs(averageWidth)
    .heightIs(imgvHeight)
    ;
    
    
    title.sd_layout
    .topEqualToView(hotelImgv)
    .leftSpaceToView(hotelImgv,10)
    .widthIs(averageWidth)
    .heightIs(labelHeight)
    ;
    
    
    belongHotel.sd_layout
    .topSpaceToView(title,space)
    .leftSpaceToView(hotelImgv,10)
    .widthIs(averageWidth)
    .heightIs(labelHeight)
    ;
    
    
    totalPrice.sd_layout
    .topSpaceToView(hotelImgv,20)
    .leftSpaceToView(hotelView,Margin)
    .autoHeightRatio(0)
    ;
    
    [totalPrice setSingleLineAutoResizeWithMaxWidth:Width-Margin*2];
    
    
    //虚拟数据
    
    [hotelView setupAutoHeightWithBottomViewsArray:viewsArr bottomMargin:10];
    
    NSString *imageStr = [MainUrl stringByAppendingString:[self.orderDic objectForKey:@"pictureAddress"]];
    
    [hotelImgv sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(20, 20)];
    
    [title setText:[NSString stringWithString:[self.orderDic objectForKey:@"roomType"]]];
    
    [belongHotel setText:[NSString stringWithString:[self.orderDic objectForKey:@"hotelName"]]];
    
    [totalPrice setText:[NSString stringWithFormat:@"总价 :¥ %@",[self.orderDic objectForKey:@"totalCost"]]];
    

}

//在方位视图上添加控件
-(void)addViewOnLocationView:(UIView *)locationView AndSuperView:(UIView *)superView AndLastView:(UIView *)lastView
{
    //地标图标
    UIImageView *landmarkView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"landmark_icon"]];
    
    //地址
    UILabel *locationLabel = [UILabel new];
    locationLabel.font = [UIFont fontWithName:PingFangSCX size:18];
    
    NSArray *viewsArr = @[landmarkView,locationLabel];
    
    //按顺序一次性添加
    [locationView sd_addSubviews:viewsArr];
    
    
    //开始布局
    locationView.sd_layout
    .topSpaceToView(lastView,0)
    .leftSpaceToView(superView,0)
    .rightSpaceToView(superView,0)
    ;
    
    landmarkView.sd_layout
    .widthIs(15)
    .heightIs(15)
    .leftSpaceToView(locationView,Margin)
    .centerYEqualToView(locationView)
    ;
    
    locationLabel.sd_layout
    .leftSpaceToView(landmarkView,5)
    .centerYEqualToView(landmarkView)
    .widthIs(Width*2/3)
    .autoHeightRatio(0)
    ;
    
    [locationView setupAutoHeightWithBottomViewsArray:viewsArr bottomMargin:15];
    
    
    //赋值
    [locationLabel setText:[NSString stringWithString:[self.orderDic objectForKey:@"hotelAddress"]]];
    
    locationLabel.userInteractionEnabled = YES;
    
    //添加点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToCheckHotelDirection:)];
    singleTap.delegate = self;
    [locationLabel addGestureRecognizer:singleTap];

}

-(void)loadDownControl  //加载下方控件
{

    UIView *downView = [UIView new];
    [self.view addSubview:downView];
    downView.backgroundColor=RGBA(240, 240, 240, 0.8);
    
    
    downView.sd_layout
    .heightIs(DownControlViewHeight)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    ;
    
    //取消订单按钮
    self.actionBtn = [UIButton new];
    self.actionBtn.titleLabel.font=[UIFont fontWithName:PingFangSCX size:15];
    [self.actionBtn setTitleColor:ContentTextColorNormal forState:UIControlStateNormal];
    self.actionBtn.layer.borderColor=RGBA(200, 200, 200, 1).CGColor;
    self.actionBtn.layer.borderWidth=1;
    self.actionBtn.layer.cornerRadius=5;
    [downView addSubview:self.actionBtn];
    
    self.actionBtn.sd_layout
    .widthIs(80)
    .heightIs(30)
    .rightSpaceToView(downView,10)
    .centerYEqualToView(downView)
    ;
    
    
    [self.actionBtn addTarget:self action:@selector(btnActions) forControlEvents:UIControlEventTouchUpInside];

    int a = [[self.orderDic objectForKey:@"orderStatus"]intValue];
    int b = 10;
    if ([self.orderDic objectForKey:@"payPlan"]) {  //如果有这个字段说明是线上付款
        
        b = [[self.orderDic objectForKey:@"payPlan"]intValue];
        
    }
    if (a==1&&b==10) {  //说明是线下支付
        
        [self.actionBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        
    }else if(a==1&&b==0){  //线上支付并且还未支付
        
        [self.actionBtn setTitle:@"付款" forState:UIControlStateNormal];
    
    }else if(b==1){ //线上已支付
    
        [self.actionBtn setTitle:@"退款" forState:UIControlStateNormal];
    
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
    
//    self.view.userInteractionEnabled = NO;
    
}

-(void)restoreUserInteractionEnabled    //隐藏进度圈并恢复视图交互
{
    
    [activityIndicatorView stopAnimating];
    
//    self.view.userInteractionEnabled = YES;
    
}

-(void)creatOrderNotice //创建预定成功的提示框
{

    UIView * downView = [[[NSBundle mainBundle] loadNibNamed:@"popUp" owner:nil options:nil] firstObject];
    //downView.origin = CGPointMake(0, -150);
    downView.center = CGPointMake(Width/2, -150);
    [self.view addSubview:downView];
    
    UIView *boldView = (UIView *)[downView viewWithTag:102];
    boldView.layer.cornerRadius = 5;
    self.downView = downView;
    self.downView.hidden = YES;
    
    self.downView.hidden = NO;
    
    //确定按钮
    UIButton * sureButton = (UIButton *)[downView viewWithTag:101];
    [sureButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    //"x"按钮
    UIButton *xBtn = (UIButton *)[downView viewWithTag:100];
    [xBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    //背景灰色
    UIView * bgView = [[UIView alloc] initWithFrame:self.view.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.3;
    [self.view addSubview:bgView];
    self.bgView = bgView;
    
    
    [self.view bringSubviewToFront:self.downView];
    
    //下拉动画
    [UIView animateWithDuration:0.2 animations:^{
        self.downView.center =  CGPointMake(Width/2, Height/2);
    }];

}


- (void)buttonAction    //确认后移除所有view
{
    
    //下拉隐藏
    [UIView animateWithDuration:0.2 animations:^{
        
        self.downView.center =  CGPointMake(Width/2, Height+150);
        
    } completion:^(BOOL finished) {
        
        [self.bgView removeFromSuperview];
        [self.downView removeFromSuperview];
        self.bgView = nil;
        self.downView = nil;
        
    }];
    
}


#pragma mark ----- 交互方法

//取消当前订单
-(void)cancelOrder
{
 
    [self loadIndicator];
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSString *cancelOrderStr = [MainUrl stringByAppendingString:CancelOrder];
    
    NSURL *url = [NSURL URLWithString:cancelOrderStr];

    NSString *parm = [NSString stringWithFormat:@"deviceId=%@&&orderId=%@&&cancelReason=%@",deviceId,[self.orderDic objectForKey:@"orderId"],@"不想要了"];

    NSLog(@"parm:%@",parm);

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[parm dataUsingEncoding:NSUTF8StringEncoding]];
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"取消订单反馈dict:%@",dict);
            [self restoreUserInteractionEnabled];
            
            //返回成功或订单已取消则执行提示并返回销毁当前订单
            if ([[dict objectForKey:@"resultCode"]isEqualToString:@"1"]||[[dict objectForKey:@"resultCode"]isEqualToString:@"18"]) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"订单已取消" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                
                alert.tag = 80; //代表取消完订单的提示框
                
                [alert show];
                
            }else{
                
                [self restoreUserInteractionEnabled];
            
                [self showString:@"请求失败"];
            
            }
            
        }else{
            
            [self restoreUserInteractionEnabled];
        
            [self showString:@"请求超时"];
        
        }
        
    }];

}


//获取当前订单的详情
-(void)getCurrnentOrderStatus
{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSString *orderStr = [NSString stringWithFormat:@"%@?deviceId=%@&&orderId=%@",[MainUrl stringByAppendingString:GetOrderStatus],deviceId,self.orderId];
    
    NSLog(@"请求订单详情orderStr:%@",orderStr);
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:orderStr]];
    
    
    //发送请求(异步)
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"订单状态返回dict:%@",dict);
            
            if ([dict objectForKey:@"resultCode"]) {
                
                self.orderDic = [dict objectForKey:@"result"];
                
            }
            
            [hud hide:YES];
            
            [self loadAllView]; //开始加载视图
            
        }else{
            
            
            [hud hide:YES];
            
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

-(void)touchToPoprootView   //返回首页
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

//查看地图点击事件
-(void)touchToCheckHotelDirection:(UITapGestureRecognizer *)tapView
{

    MapTextVC *mtvc = [MapTextVC new];
    
    self.hidesBottomBarWhenPushed=YES;
    
    mtvc.orderDic = self.orderDic;
    
    [self.navigationController pushViewController:mtvc animated:YES];
    
    self.hidesBottomBarWhenPushed=NO;

}



-(void)showString:(NSString *)str   //提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

//处理label属性
-(void)processLabel:(UILabel *)label AndTextColor:(UIColor *)textcolor AndFont:(CGFloat)font
{

    label.textColor = textcolor;
    label.font = [UIFont fontWithName:PingFangSCX size:font];

}

-(void)btnActions   //下方按钮的点击事件(取消订单、待付款、退款等操作)
{
    if ([self.actionBtn.titleLabel.text isEqualToString:@"取消订单"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您真的要取消当前订单吗?" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是的", nil];
        
        alert.tag = 120;    //作为提示框的标记
        
        [alert show];
        
    }else if([self.actionBtn.titleLabel.text isEqualToString:@"付款"]){
    
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择付款方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝", nil];
        
        sheet.tag = 121;    //标记
        
        [sheet showInView:self.view];
    
    }else if([self.actionBtn.titleLabel.text isEqualToString:@"退款"]){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您真的要退掉当前订单的款项吗?" delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"是的", nil];
        
        alert.tag = 122;    //作为提示框的标记
        
        [alert show];
        
    }
    
}

//获取倒计时需要的时间
-(int)getCountdownTime
{
    NSString  *currentDate;
    
    getTheCurrentDate(currentDate);
    
//    NSLog(@"currentDate:%@",currentDate);

    
    //先将下单时的字符串转化为date
    NSDate *orderTimeDate = [self getTheafterDateFromTheDate:[self.orderDic objectForKey:@"orderTime"]];
//    NSLog(@"orderTimeDate:%@",orderTimeDate);
    
    //然后得到下单的后一天(也就是截止日期)的字符串
    NSDate *lastDayDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:orderTimeDate];
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateDue = [nsdf2 stringFromDate:lastDayDate];
//    NSLog(@"dateDue:%@",dateDue);
    
    //最后计算剩余时间(即当前时间到截止时间的差值)
    int surplusTime = [self intervalFromLastDate:currentDate toTheDate:dateDue];
//    NSLog(@"surplusTime:%d",surplusTime);
    
    return surplusTime;
}

//计算2个时间的差值(返回总秒数)
- (int)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    dateString1=[timeArray1 objectAtIndex:0];
    
    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    dateString2=[timeArray2 objectAtIndex:0];
    
    NSLog(@"%@.....%@",dateString1,dateString2);
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    
    sen = [NSString stringWithFormat:@"%2d", (int)cha%60];
    //        min = [min substringToIndex:min.length-7];
    //    秒
    sen=[NSString stringWithFormat:@"%@", sen];
    
    min = [NSString stringWithFormat:@"%2d", (int)cha/60%60];
    //        min = [min substringToIndex:min.length-7];
    //    分
    min=[NSString stringWithFormat:@"%@", min];
    
    //    小时
    house = [NSString stringWithFormat:@"%2d", (int)cha/3600];
    //        house = [house substringToIndex:house.length-7];
    house=[NSString stringWithFormat:@"%@", house];
    
    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    
    //总秒数
    int totalSeconds = [house intValue]*3600 + [min intValue]*60 + [sen intValue];
    
    return totalSeconds;
}

//字符串转时间
-(NSDate *)getTheafterDateFromTheDate:(NSString *)date
{

    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_CN"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSDate* inputDate = [inputFormatter dateFromString:date];

    return inputDate;
}


#pragma mark ----- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 120) { //说明是询问取消订单的提示框
        
        if (buttonIndex == 1) {
            
//            NSLog(@"取消了");
            [self cancelOrder];
            
            
        }
        
    }else if (alertView.tag == 80){ //说明是提示已经取消订单的提示框
    
        if (buttonIndex == 0) {
            
            UserDefaultSetObjectForKey([self.orderDic objectForKey:@"orderId"],@"DeleteOrderId");    //标记要删除的订单号
            
            [self.navigationController popViewControllerAnimated:YES];  //返回上一页
            
        }
    
    }else if (alertView.tag == 122){
    
        if (buttonIndex==1) {   //选择了退款
            
            showHudString(@"功能正在开发中...");
            
        }
    
    }
        

}


#pragma mark ----- UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (actionSheet.tag==121) {
        
        
        switch (buttonIndex) {
                
            case 0: //支付宝
                
                [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:[self.orderDic objectForKey:@"orderCode"] productName:@"爱爱网酒店预订" productDescription:[self.orderDic objectForKey:@"roomType"] amount:@"0.01" notifyURL:[MainUrl stringByAppendingString:kNotifyURL] itBPay:@"30m"];
                
                break;
            case 1:
                
                
                
                break;
                
            default:
                break;
        }
        
    }

}


//通知的回调,根据返回的结果进行跳转
-(void)jumpToOrder:(NSNotification *)dict
{
    
    //    NSLog(@"通知回调结果:%@",dict.object);
    
    
    NSString *message;
    switch([[NSString stringWithFormat:@"%@",dict.object] intValue])
    {
        case 9000:message = @"订单支付成功";break;
        case 8000:message = @"正在处理中";break;
        case 4000: ;
        case 6001:message = @"订单支付失败，您可以到\"我的订单\"中再次支付";break;
        case 6002:message = @"网络连接错误,请重试";break;
        default:message = @"未知错误";
    }
    
    
    UIAlertController *aalert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [aalert addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {    //点击回调
        
        if ([message isEqualToString:@"订单支付成功"]) { //只有在订单支付成功了才获取订单的最新状态
            
//            [self.actionBtn setTitle:@"退款" forState:UIControlStateNormal];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        
    }]];
    
    [self presentViewController:aalert animated:YES completion:nil];
    
}

















@end
