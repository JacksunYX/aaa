//
//  FillOrderVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/26.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

//#import "CalendarHomeViewController.h"
//#import "CalendarViewController.h"
//#import "CalendarDayModel.h"
//#import "Color.h"

#import "AFViewShaker.h"    //视图震动库

#import "UIImageView+ProgressView.h"

#import "RMCalendarController.h"    //带价格的日期选择
#import "MJExtension.h"

#import "AlipayHeader.h"    //引入一键集成支付宝库的头文件

//配图的宽和高
#define ImgViewWidth  (Width -10*3)/2
#define ImgViewHeight ImgViewWidth*9/16

//平均高度
#define averageHeight ((ImgViewHeight-5*2)/3)


#define HotelNameHeight 20
//图片视图的高度
#define HotelViewBackViewHeight (ImgViewHeight+30+HotelNameHeight)


#define DownViewHeight  50  //下方控件视图的高度

//浪漫服务单个视图的宽度
#define ServiceViewWidth    80

#define BookCycleTime 30 //可以预订的周期范围(单位:天)


#import "FillOrderVC+Methods.h"
#import "OrderDetailVC.h"   //订单详情页面


#import "ThemeRoomModel.h"
#import "HotelModel.h"


@implementation FillOrderVC (Methods)
static float totalCost;   //总价

#pragma mark ----- 统一视图加载方法
-(void)loadBaseView  //加载基本视图
{

//    [self creatVirtualNavigationView];  //导航栏
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    datePriceArr = [NSMutableArray new];
    
    [self updataTheNavigationbar];      //导航栏设置
    
    [self getRoomPriceList];            //获取房间价格列表

}


#pragma mark ----- 视图创建方法

-(void)creatVirtualNavigationView  //创建虚拟导航栏
{

    UIView *navigationView =[UIView new];
    
    [self.view addSubview:navigationView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    backBtn.layer.cornerRadius=backBtn.frame.size.width/2;
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setBackgroundColor:RGBA(50, 50, 50, 0.5)];
    [backBtn addTarget:self action:@selector(touchToDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    //标题
    UILabel *titleLabel =[UILabel new];
    titleLabel.textAlignment=1;
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textColor=[UIColor blackColor];
    [titleLabel setText:@"填写订单"];
    [titleLabel sizeToFit];
    [self.view addSubview:titleLabel];
    
    
    
    //开始布局
    navigationView.sd_layout
    .heightIs(44)
    .topSpaceToView(self.view,20)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    ;
    
    
    titleLabel.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(navigationView)
    ;
    
    
    
}

-(void)updataTheNavigationbar   //导航栏设置
{
    
    //左按钮
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
    
    
    //修改标题字体大小和颜色
    self.title=@"填写订单";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNormal);
        
    }else{
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNight);
        
    }
    
    
}

-(void)creatDownControl     //创建下方控件
{
    
    UIView *downView =[[UIView alloc]initWithFrame:CGRectMake(0, Height-DownViewHeight, Width, DownViewHeight)];
    downView.backgroundColor=[UIColor whiteColor];
    //总价按钮
    totalPriceBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, Width/3, DownViewHeight)];
    [totalPriceBtn setBackgroundColor:[UIColor whiteColor]];
    totalPriceBtn.titleLabel.font = [UIFont fontWithName:PingFangSCX size:16];
    [totalPriceBtn setTitle:@"¥ 0" forState:UIControlStateNormal];
    [totalPriceBtn setTitleColor:MainThemeColor forState:UIControlStateNormal];
    totalPriceBtn.backgroundColor=RGBA(240, 240, 240, 1);
    [downView addSubview:totalPriceBtn];
    
    
    //预订按钮
    UIButton *bookBtn =[[UIButton alloc]initWithFrame:CGRectMake(Width/3, 0, Width*2/3, DownViewHeight)];
    [bookBtn setBackgroundColor:MainThemeColor];
    [bookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bookBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [bookBtn addTarget:self action:@selector(touchToSubmitTheOrder) forControlEvents:UIControlEventTouchUpInside];
    bookBtn.titleLabel.font = [UIFont fontWithName:PingFangSCC size:20];
    [downView addSubview:bookBtn];
    
    [self.view addSubview:downView];
}


-(void)creatScrollView  //创建滚动视图和上面的展示控件
{

    myscrollView = [UIScrollView new];
    [self.view addSubview:myscrollView];
    
    myscrollView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .topSpaceToView(self.view,NavigationBarHeight)
    .bottomSpaceToView(self.view,DownViewHeight)
    ;

    //背景
    UIView *hotelBackView =[UIView new];
    [self addHotelViewOnView:hotelBackView];    //酒店视图上添加信息
    hotelBackView.backgroundColor=RGBA(240, 240, 240, 0.5);
    
    
    //选择入住日期
    UIView *selectDateView =[UIView new];
//    selectDateView.backgroundColor=[UIColor lightGrayColor];
    UITapGestureRecognizer *singletap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToSelectDate2:)];
    singletap.delegate=self;
    [selectDateView addGestureRecognizer:singletap];
    [self addLabelOnSelectView:selectDateView];    //在选择日期上添加控件
    
    //联系人
    UIView *contactView =[UIView new];
//    contactView.backgroundColor=[UIColor lightGrayColor];
    contactName =[UITextField new];
    contactName.delegate=self;
    [self addTextFieldWith:contactName AndPlaceholder:@"用于确认用户信息" AndNotice:@"联系人" ToView:contactView];
    
    //手机号
    UIView *phoneView =[UIView new];
//    phoneView.backgroundColor=[UIColor lightGrayColor];
    phoneNum =[UITextField new];
    phoneNum.delegate=self;
    [self addTextFieldWith:phoneNum AndPlaceholder:@"用于接收预订信息" AndNotice:@"手机号" ToView:phoneView];
    [self addLimitToTextField:phoneNum AndWKFormatterType:1];
    phoneNum.returnKeyType=UIReturnKeyDone;

    
    //开始布局
    //一次性添加
    NSArray *viewsArr =@[hotelBackView,selectDateView,contactView,phoneView];
    
    [myscrollView sd_addSubviews:viewsArr];
    
    
    //开始布局
    
    
    hotelBackView.sd_layout
    .topSpaceToView(myscrollView,0)
    .leftSpaceToView(myscrollView,0)
    .rightSpaceToView(myscrollView,0)
    .heightIs(HotelViewBackViewHeight)
    ;
    
    
    selectDateView.sd_layout
    .topSpaceToView(hotelBackView,5)
    .leftSpaceToView(myscrollView,0)
    .rightSpaceToView(myscrollView,0)
    .heightIs(50)
    ;
    
    contactView.sd_layout
    .topSpaceToView(selectDateView,5)
    .leftSpaceToView(myscrollView,0)
    .rightSpaceToView(myscrollView,0)
    .heightIs(50)
    ;
    
    phoneView.sd_layout
    .topSpaceToView(contactView,5)
    .leftSpaceToView(myscrollView,0)
    .rightSpaceToView(myscrollView,0)
    .heightIs(50)
    ;
    
    //滚动视图的contentsize自适应
    [myscrollView setupAutoContentSizeWithBottomView:phoneView bottomMargin:20];
}


-(void)addHotelViewOnView:(UIView *)hotelBackView //添加上部分酒店相关信息
{
    
    //酒店名
    hotelName = [UILabel new];
//    hotelName.backgroundColor=[UIColor redColor];
    hotelName.textColor=TitleTextColorNormal;
    hotelName.font=[UIFont fontWithName:PingFangSCX size:18];
    
    
    //配图
    backImgView = [UIImageView new];
    //    backImgView.backgroundColor=[UIColor orangeColor];
    
    
    //房间主题名
    roomName = [UILabel new];
    //    roomName.backgroundColor=[UIColor yellowColor];
    roomName.textColor=MainThemeColor;
    roomName.font=[UIFont fontWithName:PingFangSCX size:18];
    
    
    //描述文字
    detail =[UILabel new];
    //    detail.backgroundColor=[UIColor greenColor];
    detail.textColor=ContentTextColorNormal;
    detail.numberOfLines=0;
    detail.font=[UIFont fontWithName:PingFangSCQ size:13];
    
    
    //价格
    price=[UILabel new];
    //    price.backgroundColor=[UIColor blueColor];
    price.textColor=TitleTextColorNormal;
    price.font=[UIFont fontWithName:PingFangSCX size:18];
    
    NSArray *arr =@[hotelName,backImgView,roomName,detail,price];
    
    [hotelBackView sd_addSubviews:arr];
    
    //布局
    CGFloat margin = 10;    //间隔
    
    hotelName.sd_layout
    .topSpaceToView(hotelBackView,margin)
    .leftSpaceToView(hotelBackView,margin)
    .rightSpaceToView(hotelBackView,margin)
    .heightIs(HotelNameHeight)
    ;
    
    backImgView.sd_layout
    .topSpaceToView(hotelName,margin)
    .leftSpaceToView(hotelBackView,margin)
    .widthIs(ImgViewWidth)
    .heightIs(ImgViewHeight)
    ;
    
    roomName.sd_layout
    .topEqualToView(backImgView)
    .leftSpaceToView(backImgView,margin)
    .widthIs(ImgViewWidth)
    .heightIs(averageHeight)
    ;
    
    detail.sd_layout
    .topSpaceToView(roomName,5)
    .leftEqualToView(roomName)
    .widthIs(ImgViewWidth)
    .heightIs(averageHeight)
    ;
    
    price.sd_layout
    .topSpaceToView(detail,5)
    .leftEqualToView(roomName)
    .widthIs(ImgViewWidth)
    .heightIs(averageHeight)
    ;
    
//    [self addVirtualData];
    
    [hotelName setText:self.roomModel.belongHotel];
    
    if (self.roomModel.roomPictures.count) {
        
        NSDictionary *dict = [self.roomModel.roomPictures firstObject];
        
        NSString *imageUrlStr = [MainUrl stringByAppendingString:[dict objectForKey:@"pictureAddress"]];
        
        [backImgView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:nil AndProgressBackgroundColor:MainThemeColor AndProgressTintColor:[UIColor whiteColor] AndSize:CGSizeMake(30, 30)];
        
    }

    [roomName setText:self.roomModel.theme];
    [detail setText:self.roomModel.introduction];
    [price setText:[NSString stringWithFormat:@"¥ %@",self.roomModel.unitPrice]];
    
    
}


-(void)addLabelOnSelectView:(UIView *)_selectDateView     //在选择日期上添加控件
{
    
    //左边的提示文字
    UILabel *notice =[UILabel new];
    notice.textColor=TitleTextColorNormal;
    notice.font=[UIFont fontWithName:PingFangSCX size:16];
    [notice setText:[NSString stringWithFormat:@"入住日期"]];
    [notice sizeToFit];
    [_selectDateView addSubview:notice];
    
    //中间的label用于显示选择的日期
    if (!selectedDate) {
        selectedDate =[UILabel new];
        [_selectDateView addSubview:selectedDate];
        selectedDate.textColor=TitleTextColorNormal;
//        selectedDate.backgroundColor=[UIColor grayColor];
        selectedDate.font=[UIFont fontWithName:PingFangSCX size:14];
    }
    
    if (!dateString) {  //如果为空
        dateString=@"";
    }
    [selectedDate setText:[NSString stringWithFormat:@"您选择了:%@",dateString]];
    
    
    //右边的label用于显示总的预订天数
    if (!totalDays) {
        
        totalDays =[UILabel new];
        [_selectDateView addSubview:totalDays];
        totalDays.textColor=[UIColor redColor];
//        totalDays.backgroundColor=[UIColor yellowColor];
        totalDays.font=[UIFont fontWithName:PingFangSCX size:16];
        totalDays.textAlignment=1;
        
    }
    
    [totalDays setText:[NSString stringWithFormat:@"共%ld晚",daysNum]];
    
    
    //开始布局
    notice.sd_layout
    .leftSpaceToView(_selectDateView,10)
    .centerYEqualToView(_selectDateView)
    .widthIs(notice.frame.size.width)
    ;
    
    CGFloat centetTextfieldWidth =(Width-10*4-notice.frame.size.width)*2/3;
    CGFloat rightTextfieldWidth =(Width-10*4-notice.frame.size.width)/3;
    
    selectedDate.sd_layout
    .leftSpaceToView(notice,10)
    .centerYEqualToView(_selectDateView)
    .widthIs(centetTextfieldWidth)
    .heightIs(30)
    ;
    
    totalDays.sd_layout
    .leftSpaceToView(selectedDate,10)
    .centerYEqualToView(_selectDateView)
    .widthIs(rightTextfieldWidth)
    .heightIs(30)
    ;
    
    
}


//根据传入的数据创建输入框
-(void)addTextFieldWith:(UITextField *)textFild  AndPlaceholder:(NSString *)placeholder AndNotice:(NSString *)noticeString ToView:(UIView *)view
{
    
    //输入框左边的提示文字
    UILabel *notice =[UILabel new];
    notice.textColor=TitleTextColorNormal;
    notice.font=[UIFont fontWithName:PingFangSCX size:16];
    [notice setText:[NSString stringWithFormat:@"%@:",noticeString]];
    [notice sizeToFit];
    [view addSubview:notice];
    
    
    //输入框
    textFild.placeholder=placeholder;
    [textFild setValue:[UIFont fontWithName:PingFangSCX size:16] forKeyPath:@"_placeholderLabel.font"];
    textFild.clearButtonMode =UITextFieldViewModeWhileEditing;
    textFild.textColor=MainThemeColor;
    [view addSubview:textFild];
    
    //下划线
    UILabel *line =[UILabel new];
    line.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:line];
    
    
    //开始布局
    notice.sd_layout
    .leftSpaceToView(view,10)
    .centerYEqualToView(view)
    .widthIs(notice.frame.size.width)
    .heightIs(notice.frame.size.height)
    ;
    
    textFild.sd_layout
    .leftSpaceToView(notice,10)
    .rightSpaceToView(view,50)
    .centerYEqualToView(view)
    .heightIs(30)
    ;
    
    line.sd_layout
    .leftEqualToView(textFild)
    .rightEqualToView(textFild)
    .topSpaceToView(textFild,0)
    .heightIs(0.5)
    ;
    
}

-(void)loadIndicator1    //加载指示器
{
    
    if (!activityIndicatorView) {
        
        activityIndicatorView = [[DGActivityIndicatorView alloc]initWithType:7 tintColor:MainThemeColor size:Width/8];
        
    }
    
    activityIndicatorView.type = 7;
    
    [self.view addSubview:activityIndicatorView];
    
    //布局下
    activityIndicatorView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    ;
    
    [activityIndicatorView startAnimating]; //加载等待视图
    
    self.view.userInteractionEnabled = NO;
    
}

-(void)loadIndicator2    //加载指示器2
{
    
    if (!activityIndicatorView) {
        
        activityIndicatorView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeCookieTerminator tintColor:MainThemeColor size:Width/8];
        
    }
    
    activityIndicatorView.type = DGActivityIndicatorAnimationTypeCookieTerminator;
    
    [self.view addSubview:activityIndicatorView];
    
    //布局下
    activityIndicatorView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    ;
    
    [activityIndicatorView startAnimating]; //加载等待视图
    
    self.view.userInteractionEnabled = NO;
    
}

-(void)restoreUserInteractionEnabled    //隐藏进度圈并恢复视图交互
{

    [activityIndicatorView stopAnimating];
    
    self.view.userInteractionEnabled = YES;

}


#pragma mark ----- 交互方法

-(void)touchToSubmitTheOrder    //提交订单按钮点击事件
{
    
    if (daysNum<=0) {
        
        [self showString:@"请选择住店时间"];
        
        return;
        
    }else if (contactName.text.length<=0){
        
        [[[AFViewShaker alloc]initWithView:contactName] shake];
        
        return;
        
    }else if ([self isEmpty:contactName.text]){ //全为空格组成
    
        [self showString:@"名字不要留白呀~"];
        
        return;
    
    }else if (phoneNum.text.length!=11){
    
        [[[AFViewShaker alloc]initWithView:phoneNum] shake];
        
        return;
    
    }else if ([phoneNum.text characterAtIndex:0]!='1'){
    
        [self showString:@"手机号有误~"];
        
        return;
    
    }
    
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"请确认订单" message:[NSString stringWithFormat:@"住店时间为%ld晚\n联系人:%@\n手机号:%@",daysNum,contactName.text,phoneNum.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alert.tag = 888;    //支付标记
    
    [alert show];
    
//    NSLog(@"住店时间为%ld晚",daysNum);
//    NSLog(@"联系人:%@",contactName.text);
//    NSLog(@"手机号:%@",phoneNum.text);
    
    
}

-(void)getRoomPriceList //获取房间的价格列表
{
    [self loadIndicator1];
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    //开始和结束时间
    NSString *startTime = [self getTheCurrentDate];
    NSString *endTime   = [self getTheDateWithDayNum:BookCycleTime];
    
//    NSLog(@"startTime:%@",startTime);
//    NSLog(@"endTime:%@",endTime);
    
    
    
    NSMutableString *roomPriceListUrl= [[MainUrl stringByAppendingString:GetRoomPriceList]mutableCopy];
    [roomPriceListUrl appendFormat:@"?roomId=%@&&deviceId=%@&&startDate=%@&&endDate=%@",self.roomModel.roomId,deviceId,startTime,endTime];
    
//    NSLog(@"roomPriceListUrl:%@",roomPriceListUrl);
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:roomPriceListUrl] cachePolicy:0 timeoutInterval:10.0];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"价格列表:%@",dict);
            
            NSArray *priceListArr = [dict objectForKey:@"result"];
            
            if (priceListArr.count) {
                
                [datePriceArr addObjectsFromArray:priceListArr];    //添加到全局数组
                
            }
            
            [self restoreUserInteractionEnabled]; //隐藏进度圈并恢复视图交互
            
            [self creatDownControl];            //下方控件
            
            [self creatScrollView];             //中间滚动视图
            
        }else{
            
            [self restoreUserInteractionEnabled]; //隐藏进度圈并恢复视图交互
            
            [self showString:@"请检查网络"];
            
        }
        
    }];

}

-(void)CommitOrderWithpayMethod:(int)payMethod      //提交订单到服务器(1代表在线，2代表到付)
{
    
//    [self loadIndicator2];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识

    NSString *commitOrderUrl = [MainUrl stringByAppendingString:MakeOrderRoomRelation];
    
    NSURL *url = [NSURL URLWithString:commitOrderUrl];
    
    NSString *parm = [NSString stringWithFormat:@"deviceId=%@&&hotelId=%@&&roomId=%@&&roomPrices=%@&&stayTimes=%@&&phoneNum=%@&&totalCost=%@&&userId=%@&&payMethod=%d&&contactName=%@",deviceId,self.hotelModel.hotelId,self.roomModel.roomId,totalPriceString,totalDateString,phoneNum.text,[NSString stringWithFormat:@"%.1f",totalCost],CurrentUserId,payMethod,contactName.text];
    
    NSLog(@"parm:%@",parm);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[parm dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    BOOL SorAS = YES;   //(YSE代表异步，NO代表同步)
    
    if (SorAS) {
        
        //发送请求(异步)
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            if (data) {
                
                [self processTheData:data WithpayMethod:payMethod];
                
                [self restoreUserInteractionEnabled]; //隐藏进度圈并恢复视图交互
                
                [hud hide:YES];
                
            }else{
                
                [self restoreUserInteractionEnabled]; //隐藏进度圈并恢复视图交互
                
                self.view.userInteractionEnabled = YES;
                
                [hud hide:YES];
                
                [self showString:@"请求超时"];
                
            }
            
        }];
        
    }else{
    
        //防止用户误操作，换用同步请求
        NSURLResponse *reponse = nil;
        NSError *erro = nil;
        NSData *syData = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&erro];
        if (erro == nil) {  //无错误返回
            
            if (syData) {    //获取到后台数据
                
                [self processTheData:syData WithpayMethod:payMethod];
                
                [self restoreUserInteractionEnabled]; //隐藏进度圈并恢复视图交互
                
                [hud hide:YES];
                
            }else{
                
                [self restoreUserInteractionEnabled]; //隐藏进度圈并恢复视图交互
                
                [hud hide:YES];
                
                showHudString(@"服务器异常");
                
            }
            
        }else{  //请求出错
            
            [self restoreUserInteractionEnabled]; //隐藏进度圈并恢复视图交互
            
            [hud hide:YES];
            
            showHudString(@"请求超时");
            
        }
    
    }
    
    

    
}

//处理返回的data
-(void)processTheData:(NSData *)data WithpayMethod:(int)payMethod
{

    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"订单反馈dict:%@",dict);
    
    self.orderDict = [NSDictionary dictionaryWithDictionary:[dict objectForKey:@"result"]];
    
//    NSLog(@"提交订单反馈result:%@",self.orderDict);
    
    if ([dict objectForKey:@"resultCode"]) {
        
        //对反馈结果做选择
        switch ([[dict objectForKey:@"resultCode"]intValue]) {  //存在resultCode字段
                
            case 0:
            {
                
                NSLog(@"失败");
                
            }
                break;
                
            case 1:
            {
                
                NSLog(@"成功");
                
                switch (payMethod) {
                    case 1: //支付宝
                    {
                        
                        [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:[self.orderDict objectForKey:@"orderCode"] productName:@"爱爱网酒店预订" productDescription:[self.orderDict objectForKey:@"roomType"] amount:@"0.01" notifyURL:[MainUrl stringByAppendingString:kNotifyURL] itBPay:@"30m"];
                        
                    }
                        break;
                        
                    case 2: //到付
                        
                    {
                        
                        [self jumpToOrderVCWith:self.orderDict];
                        
                    }
                        
                        break;
                        
                    default:
                        break;
                }
                
                
            }
                break;
                
            case 9:
            {
                
                NSLog(@"用户不存在");
                
            }
                break;
                
            case 14:
            {
                
                NSLog(@"请求没有带deviceId");
                
            }
                break;
                
            case 15:
            {
                
                showHudString(@"用户已在其他设备上登录");
                
            }
                break;
            case 20:
            {
                showHudString(@"房间没啦~");
            }
                
                
            default:
                NSLog(@"未知错误");
                break;
        }
        
    }else{  //不存在resultCode字段
        
        showHudString(@"服务器异常");
        
    }

}

//获取当前订单的详情
-(void)getCurrnentOrderStatus
{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSString *orderStr = [NSString stringWithFormat:@"%@?deviceId=%@&&orderId=%@",[MainUrl stringByAppendingString:GetOrderStatus],deviceId,[self.orderDict objectForKey:@"orderId"]];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:orderStr]];
    
    NSURLResponse *reponse = nil;
    NSError *erro = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&erro];

    BOOL SorAS = YES;   //(YSE代表异步，NO代表同步)
    
    if (SorAS==YES) {
        
        //发送请求(异步)
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            if (data) {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSLog(@"订单状态返回dict:%@",dict);
                
                if ([dict objectForKey:@"resultCode"]) {
                    
                    self.orderDict = [dict objectForKey:@"result"];
                    
                }
                
                [hud hide:YES];
                
                [self jumpToOrderVCWith:self.orderDict];
                
            }else{
                
                
                [hud hide:YES];
                
                [self showString:@"请求超时"];
                
            }
            
        }];
        
    }else{
    
        if (erro==nil) {
            
            if (data) {
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSLog(@"订单状态返回dict:%@",dict);
                
                if ([dict objectForKey:@"resultCode"]) {
                    
                    self.orderDict = [dict objectForKey:@"result"];
                    
                }
                
                [hud hide:YES];
                
                [self jumpToOrderVCWith:self.orderDict];
                
            }else{
                
                [hud hide:YES];
                
                showHudString(@"请求超时");
                
            }
            
        }
    
    }

}


#pragma mark ----- 辅助方法

//通过传过来的字典进行订单页跳转
-(void)jumpToOrderVCWith:(NSDictionary *)resultDic
{

    OrderDetailVC *Ovc = [OrderDetailVC new];
    
    if (resultDic) {
        
      Ovc.orderDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
        
    }
    
    Ovc.orderId = [self.orderDict objectForKey:@"orderId"];
    
    Ovc.hideLeftBtn = YES;
    
    self.hidesBottomBarWhenPushed = YES ;
    
    [self.navigationController pushViewController:Ovc animated:YES];
    
    self.hidesBottomBarWhenPushed = NO ;

}


//创建请求(POST)
-(NSMutableURLRequest *)creatRequestWithUrl:(NSURL *)url AndParm:(NSString *)parm
{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[parm dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;

}


- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
}

-(void)touchToPop  //返回上一页
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)showAlertView:(NSString *)string     //警告框
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}

-(void)showString:(NSString *)str           //提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;

    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

//取得当前日期字符串数据
-(NSString *)getTheCurrentDate
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYY-MM-dd"];
    
    NSString *date=[nsdf2 stringFromDate:[NSDate date]];//取得当前时间的字符串
    
    return date;
}

//取得后多少天的日期字符串数据
-(NSString *)getTheDateWithDayNum:(int)days
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *afterDay = [NSDate dateWithTimeInterval:(24*60*60)*days sinceDate:[NSDate date]];
    
    NSString *date=[nsdf2 stringFromDate:afterDay];
    
    return date;
}


-(void)touchToDismiss   //返回上一页
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        
    }];
    
}

#pragma mark ----- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 888) { //代表是确认订单,可以开始生成订单了
        
        if (buttonIndex==1) {
            
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择付款方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"到付",@"支付宝", nil];
            
            [sheet showInView:self.view];
            
        }
        
    }
    
}

#pragma mark ----- UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    switch (buttonIndex) {
        case 0: //到付
        {
        
            [self CommitOrderWithpayMethod:2]; //提交当前订单
        
        }
            break;
        case 1: //支付宝
        {
            
            [self CommitOrderWithpayMethod:1]; //提交当前订单
        
        }
            break;
            
            
        default:
            break;
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
            
//            [self getCurrnentOrderStatus];  //获取订单状态
            
            
        }
        
        //直接跳转到订单页面进行数据请求
        [self jumpToOrderVCWith:nil];
        
    }]];
    
    [self presentViewController:aalert animated:YES completion:nil];
    
}


//给指定的输入框添加输入限制
-(void)addLimitToTextField:(UITextField *)textfield AndWKFormatterType:(NSInteger)formatterType
{
    
    self.formatter = [[WKTextFieldFormatter alloc] initWithTextField:textfield controller:self];
    
    switch (formatterType) {
        case 0:
            
            break;
            
        case 1: //代表手机号限制
            self.formatter.formatterType = WKFormatterTypePhoneNumber;
            textfield.keyboardType=UIKeyboardTypeNumberPad;
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
            
        default:
            break;
    }
    


}

//-(void)touchToSelectDate:(UITapGestureRecognizer *)singletap //选择日期的点击事件
//{
//    
//    typeof(selectedDate)    __weak weakselectedDate  = selectedDate;
//    typeof(totalDays)       __weak weaktotalDays    = totalDays;
//    typeof(totalPriceBtn)   __weak weaktotalPriceBtn = totalPriceBtn;
//    typeof(datePriceArr)    __weak weakdatePriceArr = datePriceArr;
//
//    
//    if (!chvc) {
//        chvc = [[CalendarHomeViewController alloc]init];
//        
//        [chvc setHotelToDay:BookCycleTime ToDateforString:nil];
//        
//        //设置已被预订过的日期
//        [chvc setCannotSelectDates:[self creatDateArrAndSetCannotSelectDateWithDateArr]];
//        
//    }
//    
//    chvc.calendarArrblock = ^(NSMutableArray *arr){
//        
//        NSMutableString *date = [@""mutableCopy];       //只用于展示的时间字符串
//        
//        NSMutableString *totalDate = [@""mutableCopy];   //完整的时间字符串
//        
//        NSMutableString *priceStr = [@""mutableCopy];   //完整的价格字符串
//        
//        int totle = 0; //先置0
//        
//        for (CalendarDayModel *model in arr) {
//            
//            NSString *str = [[model toString]substringWithRange:NSMakeRange(5, 5)];
//            
//            if (model == [arr lastObject]) {    //如果是最后一个,后面就不需要拼接','了
//                
//                [date appendString:[NSString stringWithFormat:@"%@",str]];
//                
//                [totalDate appendString:[NSString stringWithFormat:@"%@",[model toString]]];
//                
//                for (NSDictionary *datedic in weakdatePriceArr) {   //在时间数组中寻找对应房间在选择的日子里的价格
//                    
//                    if ([[model toString]isEqualToString:[datedic objectForKey:@"currentTime"]]) {
//                        
//                        //累加
//                        totle += [[datedic objectForKey:@"currentPrice"]integerValue];
//                        
//                        //拼接价格字符串
//                        [priceStr appendString:[NSString stringWithFormat:@"%@",[datedic objectForKey:@"currentPrice"]]];
//                        
//                    }
//                    
//                }
//                
//            }else{
//            
//                [date appendString:[NSString stringWithFormat:@"%@,",str]];
//                
//                [totalDate appendString:[NSString stringWithFormat:@"%@,",[model toString]]];
//                
//                for (NSDictionary *datedic in weakdatePriceArr) {   //在时间数组中寻找对应房间在选择的日子里的价格
//                    
//                    if ([[model toString]isEqualToString:[datedic objectForKey:@"currentTime"]]) {
//                        
//                        //累加
//                        totle += [[datedic objectForKey:@"currentPrice"]integerValue];
//                        
//                        //拼接价格字符串
//                        [priceStr appendString:[NSString stringWithFormat:@"%@,",[datedic objectForKey:@"currentPrice"]]];
//                        
//                    }
//                    
//                }
//            
//            }
//            
//            
//            
//        }
//        ///省掉删除的部分，避免出现越界的情况
////        if (arr.count>0) {  //将字符串最后的‘,’去掉
////            
////            [date deleteCharactersInRange:NSMakeRange(([date length]-1), 1)];
////            
////            [totalDate deleteCharactersInRange:NSMakeRange(([totalDate length]-1), 1)];
////            
////            [priceStr deleteCharactersInRange:NSMakeRange(([priceStr length]-1), 1)];
////        }
//        
//        [weakselectedDate setText:[NSString stringWithFormat:@"您选择了:%@",date]];
//        
//        [weaktotalDays setText:[NSString stringWithFormat:@"共%ld晚",arr.count]];
//        
//        //做以下保存
//        dateString = [NSString stringWithString:date];
//        
//        totalDateString = [NSString stringWithString:totalDate];
//        
//        totalPriceString = [NSString stringWithString:priceStr];
//        
//        daysNum =arr.count;
//        
//        //重新设置左下方的价格显示
//        [weaktotalPriceBtn setTitle:[NSString stringWithFormat:@"¥ %d",totle] forState:UIControlStateNormal];
//        
//        totalCost = totle;
//    };
//    
//    
//    [self presentViewController:chvc animated:YES completion:nil];
//
//}

-(void)touchToSelectDate2:(UITapGestureRecognizer *)singletap //选择日期的点击事件(第二版，带价格显示)
{

    typeof(totalPriceBtn)   __weak weaktotalPriceBtn = totalPriceBtn;
    typeof(selectedDate)    __weak weakselectedDate  = selectedDate;
    typeof(totalDays)       __weak weaktotalDays    = totalDays;
    typeof(datePriceArr)    __weak weakdatePriceArr = datePriceArr;
    
    
    RMCalendarController *dateVC = [RMCalendarController calendarWithDays:30 showType:CalendarShowTypeMultiple];
    
    //设置需要显示价格的数组
    dateVC.modelArr = [TicketModel objectArrayWithKeyValuesArray:[self creatModelArr]];
    //    c.isEnable = YES; //无价格的cell也可以点击
    dateVC.title = @"选择日期";
    
    if ([totalDateString componentsSeparatedByString:@","].count>0) {
        
        NSArray *dateArr = [totalDateString componentsSeparatedByString:@","];
        
        NSMutableArray *selectDateArr =[NSMutableArray new];
        
        for (int j =0; j<dateArr.count; j++) {
            
            RMCalendarModel *bookingDate = [[RMCalendarModel alloc]init];
            
            [bookingDate setValue:dateArr[j] forKey:@"dateString"];
            
            [selectDateArr addObject:bookingDate];
            
        }
        
        dateVC.haveSelectrdDateArr = selectDateArr; //设置已经选过的日期
        
    }
    
    dateVC.calendarArrblock = ^(NSMutableArray *arr){
        
        NSMutableString *date = [@""mutableCopy];       //只用于展示的时间字符串
        
        NSMutableString *totalDate = [@""mutableCopy];   //完整的时间字符串
        
        NSMutableString *priceStr = [@""mutableCopy];   //完整的价格字符串
        
        float totle = 0; //先置0
        
        for (RMCalendarModel *model in arr) {
            
//            NSLog(@"日期:%@ 票价:%.1lf",model.toString,model.ticketModel.ticketPrice);
            NSString *str = [[model toString]substringWithRange:NSMakeRange(5, 5)];
            
            if (model == [arr lastObject]) {    //如果是最后一个,后面就不需要拼接','了
                
                [date appendString:[NSString stringWithFormat:@"%@",str]];
                
                [totalDate appendString:[NSString stringWithFormat:@"%@",[model toString]]];
                
                for (NSDictionary *datedic in weakdatePriceArr) {   //在时间数组中寻找对应房间在选择的日子里的价格
                    
                    if ([[model toString]isEqualToString:[datedic objectForKey:@"currentTime"]]) {
                        
                        //累加
                        totle += [[datedic objectForKey:@"currentPrice"]floatValue];
                        
                        //拼接价格字符串
                        [priceStr appendString:[NSString stringWithFormat:@"%@",[datedic objectForKey:@"currentPrice"]]];
                        
                    }
                    
                }
                
            }else{
                
                [date appendString:[NSString stringWithFormat:@"%@,",str]];
                
                [totalDate appendString:[NSString stringWithFormat:@"%@,",[model toString]]];
                
                for (NSDictionary *datedic in weakdatePriceArr) {   //在时间数组中寻找对应房间在选择的日子里的价格
                    
                    if ([[model toString]isEqualToString:[datedic objectForKey:@"currentTime"]]) {
                        
                        //累加
                        totle += [[datedic objectForKey:@"currentPrice"]floatValue];
                        
                        //拼接价格字符串
                        [priceStr appendString:[NSString stringWithFormat:@"%@,",[datedic objectForKey:@"currentPrice"]]];
                        
                    }
                    
                }
                
            }
            
            
//            totle +=model.ticketModel.ticketPrice;
            
        }
        
        
        [weakselectedDate setText:[NSString stringWithFormat:@"您选择了:%@",date]];
        
        [weaktotalDays setText:[NSString stringWithFormat:@"共%ld晚",arr.count]];
        
        //做以下保存
        dateString = [NSString stringWithString:date];
        
        totalDateString = [NSString stringWithString:totalDate];
        
        totalPriceString = [NSString stringWithString:priceStr];
        
        daysNum =arr.count;
        
        //重新设置左下方的价格显示
        [weaktotalPriceBtn setTitle:[NSString stringWithFormat:@"¥ %.1f",totle] forState:UIControlStateNormal];
        
        totalCost = totle;
        
    };
    
    [self.navigationController pushViewController:dateVC animated:YES];


}

-(NSArray *)creatModelArr    //将获取到的房间价格对象放到字典后存入数组再返回
{

    NSMutableArray *arr = [NSMutableArray new];
    
//    NSLog(@"datePriceArr:%@",datePriceArr);
    
    for (NSDictionary *roomdict in datePriceArr) {
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        
        NSString *date = [roomdict objectForKey:@"currentTime"];
        NSArray *separatorArr =[date componentsSeparatedByString:@"-"];
        
        //赋值
        [dict setValue:separatorArr[0] forKey:@"year"];
        [dict setValue:separatorArr[1] forKey:@"month"];
        [dict setValue:separatorArr[2] forKey:@"day"];
        [dict setValue:[roomdict objectForKey:@"currentStock"] forKey:@"ticketCount"];
        [dict setValue:[roomdict objectForKey:@"currentPrice"] forKey:@"ticketPrice"];
        
        [arr addObject:dict];
    }

    return arr;
}


//处理房间时间数组,使日历显示某些日期已被预订
//-(NSArray *)creatDateArrAndSetCannotSelectDateWithDateArr
//{
//    
//    NSMutableArray *modelArr = [NSMutableArray new] ;
//    
//    for (NSDictionary *roomdict in datePriceArr) {
//        
//        if ([[roomdict objectForKey:@"currentStock"]isEqualToString:@"0"]) {    //说明对应的时间没有该房间库存了
//            
//            CalendarDayModel *bookingDate = [[CalendarDayModel alloc]init];
//            
//            [bookingDate setValue:[roomdict objectForKey:@"currentTime"] forKey:@"dateString"];
//            
//            [modelArr addObject:bookingDate];
//            
//        }
//        
//    }
//    
//    return modelArr;
//    
//}

//判断内容是否全部为空格  yes 全部为空格  no 不是
-(BOOL)isEmpty:(NSString *) str
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







@end
