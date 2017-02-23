//
//  QuickLoginVC.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/20.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define EdgeDistance    10  //左右边距

#define ViewHeight ((Height-NavigationBarHeight)/2) //上下部分视图的平均高度

#define ViewWidth (Width-(EdgeDistance)*2)  //上下部分视图的宽度



#import "QuickLoginVC.h"

#import "WKTextFieldFormatter.h"    //文本输入框字符过滤库
#import "JxbScaleButton.h"          //倒计时按钮
#import "AFViewShaker.h"    //视图震动库
#import <ShareSDK/ShareSDK.h>
#import <WeChatConnection/ISSWeChatApp.h>



@interface QuickLoginVC ()<WKTextFieldFormatterDelegate>
{

    UIView * topHalfView;       //上半部分视图
    
    UIView * bottomHalfView;    //下半部分
    
    UIButton *loginBtn;         //登录按钮
    
    UITextField *testCode;      //验证码输入框
    
    UITextField *phoneNum;      //手机号输入框
    
    JxbScaleButton* cutDownBtn; //验证码按钮
    
    JxbScaleSetting* setting;   //验证码显示格式
    
    WKTextFieldFormatter *phoneFormatter;       //手机号输入限制实例对象
    
    WKTextFieldFormatter *testCodeFormatter;    //验证码输入限制实例对象
    
    MBProgressHUD *myHud;   //用于第三方登录时使用的指示器
    
    UIButton *wechatLoginBtn;   //微信登陆按钮

}
@end

@implementation QuickLoginVC

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
//    [self updataTheNavigationbar];
    
    [self loadVackView];
    
    [self loadTopHalfView];
    
    [self loadBottomHalfView];
    
    [self wechatIsExist];
    
    [self addPopBtn];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //收起键盘
    [self.view endEditing:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- 视图创建方法

-(void)updataTheNavigationbar   //导航栏设置
{
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(touchtoPop)forControlEvents:UIControlEventTouchUpInside];
    
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
    self.title=@"快速登陆";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle(18, RGBA(50, 50, 50, 1));
        
    }else{

        SetNavigationBarTitle(18, [UIColor whiteColor]);
        
    }
    
    //    导航栏变为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //    让黑线消失的方法
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)addPopBtn    //模态视图的返回按钮
{

    UIView *naviBarBackView = [UIView new];
    [self.view addSubview:naviBarBackView];
    
    naviBarBackView.sd_layout
    .topSpaceToView(self.view,20)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(44)
    ;
    
    //添加标题
    UILabel *title = [UILabel new];
    [naviBarBackView addSubview:title];
    title.font = [UIFont fontWithName:PingFangSCX size:18];
    
    title.sd_layout
    .centerXEqualToView(naviBarBackView)
    .centerYEqualToView(naviBarBackView)
    .autoHeightRatio(0)
    ;
    
    [title setSingleLineAutoResizeWithMaxWidth:Width-100];
    
    [title setText:@"快速登录"];
    
    //添加返回按钮
    UIButton *backBtn = [UIButton new];
    [naviBarBackView addSubview:backBtn];
    
    backBtn.sd_layout
    .centerYEqualToView(naviBarBackView)
    .leftSpaceToView(naviBarBackView,10)
    .widthIs(44)
    .heightIs(44)
    ;
    
    [backBtn setBackgroundImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(touchToDismiss)forControlEvents:UIControlEventTouchUpInside];

}


-(void)loadVackView //加载背景
{

    UIImageView *backView = [UIImageView new];
    [backView setImage:[UIImage imageNamed:@"quickLoginBackImage.png"]];
    
    [self.view addSubview:backView];
    
    backView.sd_layout
    .topSpaceToView(self.view,0)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    ;

}

-(void)loadTopHalfView  //加载上半部分视图
{

    topHalfView = [UIView new];
    [self.view addSubview:topHalfView];
    
    topHalfView.sd_layout
    .heightIs(ViewHeight)
    .widthIs(ViewWidth)
    .topSpaceToView(self.view,NavigationBarHeight)
    .centerXEqualToView(self.view)
    ;
    
    CGFloat fontsize = 16;   //输入框的字体大小
    if (Height==736) {
        
        fontsize = 20;
        
    }
    
    //登录按钮控件
    loginBtn =[UIButton new];
    loginBtn.backgroundColor = MainThemeColor;
    
    //验证码输入框
    testCode = [UITextField new];
    testCode.backgroundColor=[UIColor whiteColor];
    testCode.textColor = MainThemeColor;
    testCode.returnKeyType = UIReturnKeyDone;
//    testCode.autocorrectionType = UITextAutocorrectionTypeNo;
    testCode.keyboardType=UIKeyboardTypeNumberPad;
//    testCode.clearButtonMode =UITextFieldViewModeWhileEditing;
    testCode.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, testCode.frame.size.height)];
    testCode.leftViewMode = UITextFieldViewModeAlways;
    testCode.font = [UIFont fontWithName:PingFangSCC size:fontsize];
    [testCode setValue:[UIFont fontWithName:PingFangSCX size:fontsize] forKeyPath:@"_placeholderLabel.font"];
    testCodeFormatter = [[WKTextFieldFormatter alloc] initWithTextField:testCode controller:self];
    testCodeFormatter.formatterType = WKFormatterTypeCustom;
    testCodeFormatter.characterSet = @"0123456789";
    testCodeFormatter.limitedLength = 6;
    
    
    cutDownBtn = [JxbScaleButton new];
    cutDownBtn.layer.cornerRadius = 5;
    cutDownBtn.titleLabel.font = [UIFont fontWithName:PingFangSCX size:fontsize];
    [cutDownBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [cutDownBtn setTitleColor:MainThemeColor forState:UIControlStateNormal];
    [cutDownBtn addTarget:self action:@selector(touchToGetTestCode) forControlEvents:UIControlEventTouchUpInside];
    [testCode addSubview:cutDownBtn];
    
    
    //手机号输入框
    phoneNum = [UITextField new];
    phoneNum.backgroundColor=[UIColor whiteColor];
    phoneNum.textColor = MainThemeColor;
    phoneNum.returnKeyType = UIReturnKeyNext;
    phoneNum.keyboardType=UIKeyboardTypeNumberPad;
    phoneNum.clearButtonMode =UITextFieldViewModeWhileEditing;
    phoneNum.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, phoneNum.frame.size.height)];
    phoneNum.leftViewMode = UITextFieldViewModeAlways;
    phoneNum.font = [UIFont fontWithName:PingFangSCC size:fontsize];
    [phoneNum setValue:[UIFont fontWithName:PingFangSCX size:fontsize] forKeyPath:@"_placeholderLabel.font"];
    phoneFormatter = [[WKTextFieldFormatter alloc] initWithTextField:phoneNum controller:self];
    phoneFormatter.formatterType = WKFormatterTypePhoneNumber;
    phoneFormatter.limitedLength = 11;
    
    
    
    [topHalfView sd_addSubviews:@[loginBtn,testCode,phoneNum]];
    
    CGFloat avgHeight; //每个控件的平均高度
    CGFloat avgSpace = 20;  //每两个控件的平均间距
    
    if (Height==480||Height==568) {
        
        avgHeight = 40;
        
    }else if (Height==667||Height==736){
    
        avgHeight = 50;
    
    }
    
    loginBtn.sd_layout
    .heightIs(avgHeight)
    .bottomSpaceToView(topHalfView,0)
    .leftSpaceToView(topHalfView,EdgeDistance)
    .rightSpaceToView(topHalfView,EdgeDistance)
    ;
    
    testCode.sd_layout
    .heightIs(avgHeight)
    .bottomSpaceToView(loginBtn,avgSpace)
    .leftSpaceToView(topHalfView,EdgeDistance)
    .rightSpaceToView(topHalfView,EdgeDistance)
    ;
    
    cutDownBtn.sd_layout
    .heightIs(avgHeight-10)
    .widthIs(100)
    .rightSpaceToView(testCode,5)
    .centerYEqualToView(testCode)
    ;
    
    
    phoneNum.sd_layout
    .heightIs(avgHeight)
    .bottomSpaceToView(testCode,avgSpace)
    .leftSpaceToView(topHalfView,EdgeDistance)
    .rightSpaceToView(topHalfView,EdgeDistance)
    ;
    
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(touchToQuickLogin:) forControlEvents:UIControlEventTouchUpInside];
    testCode.placeholder = @"验证码";
    phoneNum.placeholder = @"手机号";
    
}

-(void)loadBottomHalfView  //加载下半部分视图
{
    
    bottomHalfView = [UIView new];
    [self.view addSubview:bottomHalfView];
    
    bottomHalfView.sd_layout
    .heightIs(ViewHeight)
    .widthIs(ViewWidth)
    .bottomSpaceToView(self.view,0)
    .centerXEqualToView(self.view)
    ;
    
    //分割线和提示标签
    UILabel *noticeLabel = [UILabel new];
    noticeLabel.font = [UIFont fontWithName:PingFangSCC size:18];
    noticeLabel.textColor = RGBA(255, 255, 255, 1);
    [noticeLabel setText:@"第三方登录"];
    [noticeLabel sizeToFit];
    
    [bottomHalfView addSubview:noticeLabel];
    
    noticeLabel.sd_layout
    .centerYEqualToView(bottomHalfView)
    .centerXEqualToView(bottomHalfView)
    ;
    
    UIView *separatorLineL = [UIView new];
    separatorLineL.backgroundColor = [UIColor whiteColor];
    
    UIView *separatorLineR = [UIView new];
    separatorLineR.backgroundColor = [UIColor whiteColor];
    
    [bottomHalfView sd_addSubviews:@[separatorLineL,separatorLineR]];

    
    separatorLineL.sd_layout
    .heightIs(2)
    .leftSpaceToView(bottomHalfView,EdgeDistance)
    .rightSpaceToView(noticeLabel,EdgeDistance)
    .centerYEqualToView(noticeLabel)
    ;
    
    separatorLineR.sd_layout
    .heightIs(2)
    .leftSpaceToView(noticeLabel,EdgeDistance)
    .rightSpaceToView(bottomHalfView,EdgeDistance)
    .centerYEqualToView(noticeLabel)
    ;
    
    
    //添加第三方登录的控件
    CGFloat bottomSpace = 20;   //第三方提示距离下方图片的距离
    CGFloat ImgVHeight = 44;    //图片控件高度
    CGFloat avgSpace = (ViewWidth-ImgVHeight*3)/4;    //平均间距
//    NSLog(@"avgSpace:%f",avgSpace);

    
    //qq
    UIButton *qqLoginBtn = [UIButton new];
//    qqImgV.backgroundColor = [UIColor blueColor];
    [qqLoginBtn setBackgroundImage:[UIImage imageNamed:@"qq_quick"] forState:UIControlStateNormal];
    
    
    //微信
    wechatLoginBtn = [UIButton new];
//    wechatImgV.backgroundColor = [UIColor grayColor];
    [wechatLoginBtn setBackgroundImage:[UIImage imageNamed:@"wechat_quick"] forState:UIControlStateNormal];
    
    
    //微博
    UIButton *weiboLoginBtn = [UIButton new];
//    weiboImgV.backgroundColor = [UIColor purpleColor];
    [weiboLoginBtn setBackgroundImage:[UIImage imageNamed:@"weibo_quick"] forState:UIControlStateNormal];
    
    
    NSArray *viewsArr = @[qqLoginBtn,wechatLoginBtn,weiboLoginBtn];
    
    // ------------------设置3个水平等宽子view----------------(切记，一定要先添加，😢)
    [bottomHalfView sd_addSubviews:viewsArr];
    bottomHalfView.sd_equalWidthSubviews = viewsArr;
    
    qqLoginBtn.sd_layout
    .leftSpaceToView(bottomHalfView, avgSpace)
    .topSpaceToView(noticeLabel, bottomSpace)
    .heightEqualToWidth()
    ;
    
    wechatLoginBtn.sd_layout
    .leftSpaceToView(qqLoginBtn, avgSpace)
    .topEqualToView(qqLoginBtn)
    .heightEqualToWidth()
    ;
    
    weiboLoginBtn.sd_layout
    .leftSpaceToView(qqLoginBtn, avgSpace)
    .topEqualToView(qqLoginBtn)
    .heightEqualToWidth()
    .rightSpaceToView(bottomHalfView, avgSpace)
    ;
    
    // ------------------------------------------------------
    
    //添加点击事件
    [qqLoginBtn addTarget:self action:@selector(qqLogin:) forControlEvents:UIControlEventTouchUpInside];
    [wechatLoginBtn addTarget:self action:@selector(wechatLogin:) forControlEvents:UIControlEventTouchUpInside];
    [weiboLoginBtn addTarget:self action:@selector(sinaLogin:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)wechatIsExist    //是否有安装微信，没有则隐藏微信登陆的按钮
{

    //检测手机是否安装了微信(微信不支持网页登陆)
    id<ISSWeChatApp> currentApp =(id<ISSWeChatApp>)[ShareSDK getClientWithType:ShareTypeWeixiTimeline];
    
    if (![currentApp isClientInstalled]) {
        
        [wechatLoginBtn setHidden:YES];
        
    }

}

//倒计时按钮的点击事件
- (void)touchToGetTestCode
{
    [self.view endEditing:YES];
    
    if (phoneNum.text.length<11) {      //手机号
        
        [[[AFViewShaker alloc]initWithView:phoneNum]shake];
        return;
    }else if(![[phoneNum.text substringToIndex:1]isEqualToString:@"1"]){   //手机号第一位不为'1'
        
        showHudString(@"手机号有误哟~");
        
        return;
    }
    
    if (!setting) {
        
        setting = [[JxbScaleSetting alloc] init];
        setting.strPrefix = @"";         //倒计时前缀
        setting.strSuffix = @"s";       //后缀
        setting.strCommon = @"重新获取";  //可点击时的文字
        setting.indexStart = 59;         //从多少开始倒计时
        setting.colorCommon = [UIColor whiteColor];   //可点击时的背景颜色
        setting.colorDisable = [UIColor whiteColor];  //倒计时的背景颜色
        setting.colorTitle = MainThemeColor;          //文本颜色

    }
    
    
    [self sendRequestToGetTestCodeWithPhoneNumber:phoneNum.text];
    
}


//登录按钮的点击事件
-(IBAction)touchToQuickLogin:(id)sender
{

    [self.view endEditing:YES];
    
    if (phoneNum.text.length<11) {      //手机号
        
        [[[AFViewShaker alloc]initWithView:phoneNum]shake];
        return;
    }else if(![[phoneNum.text substringToIndex:1]isEqualToString:@"1"]){   //手机号第一位不为'1'
        
        showHudString(@"手机号有误哟~");
        
        return;
    }else if(testCode.text.length<6){   //验证码
        
        [[[AFViewShaker alloc]initWithView:testCode]shake];
        
        return;
    }
    
    [self quickLoginWithPhoneNum:phoneNum.text AndTestCode:testCode.text];

}







#pragma mark ----- 交互方法

///快速登录请求
-(void)quickLoginWithPhoneNum:(NSString *)phonenum AndTestCode:(NSString *)testcode
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *loginStr = [[MainUrl stringByAppendingString:loginUrl]mutableCopy];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:loginStr] cachePolicy:0 timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *body = [NSString stringWithFormat:@"loginType=%d&&verifyCode=%@&&username=%@&&deviceId=%@",4,testcode,phonenum,deviceId];
    
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"快速登录返回dict:%@",dict);
            
            if ([[dict objectForKey:@"resultCode"]isEqualToString:@"1"]) {
                
                [self creatNotificationWithUsername:[dict objectForKey:@"nickname"] AndUserImg:[dict objectForKey:@"userImg"] AndUid:[dict objectForKey:@"userId"]];
                
            }else{
            
                showHudString(@"验证码有误");
            
            }
            
            [hud hide:YES];
            
        }else{
        
            [hud hide:YES];
            
            showHudString(@"请求超时,请检查网络后重试...");
        
        }
        
    }];

}

///获取手机验证码请求
-(void)sendRequestToGetTestCodeWithPhoneNumber:(NSString *)phonenumber//获取验证码请求的发送
{
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *loginStr = [[MainUrl stringByAppendingString:PhoneTestCode]mutableCopy];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:loginStr] cachePolicy:0 timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *body = [NSString stringWithFormat:@"messageType=%d&&phoneNum=%@&&deviceId=%@",4,phonenumber,deviceId];
    
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
//            NSLog(@"获取手机验证码返回dict:%@",dict);
            
            [hud hide:YES];
            
            if ([[dict objectForKey:@"resultCode"]isEqualToString:@"1"]) {
                
                showHudString(@"发送验证成功，请等待接受...");
                
                [cutDownBtn startWithSetting:setting];  //开始倒计时
                
            }else{
            
                showHudString(@"操作失败,请重试...");
            
            }
            
        }else{
            
            [hud hide:YES];
            
            showHudString(@"请求超时,请检查网络后重试...");
            
        }
        
    }];
    
    
}


-(void)creatNotificationWithUsername:(NSString *)username AndUserImg:(NSString *)userImg AndUid:(NSString *)uid     //根据传进来的用户信息进行通知
{
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:username,@"nickname",userImg,@"userImg", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"LoginTongZhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    //设定一个登录标记
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"LoginRoNot"];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"userId"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];    //立即写入
    
    showHudString(@"登录成功");
    
    [self delayTimeToExecute];  //延时1s跳回前一个页面
    
}


//第三方登录

- (IBAction)sinaLogin:(UIButton *)sender    //新浪微博
{
    
    myHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        
        if (result) {
            
            //传入用户信息并保存、发送通知
            [self sendRequestToSaveUserDataWithNickname:[userInfo nickname] AndUserImg:[userInfo profileImage] AndThirdKey:[userInfo uid] AndThirdType:3];
            
            
        } else {
            
            [myHud hide:YES];
            
            showHudString(@"登录失败,请检查网络是否畅通~");
            
        }
        
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    }];
    
}


- (IBAction)qqLogin:(UIButton *)sender      //qq
{
    myHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 登录类型传 QQ空间的类型才能使用网页授权 QQ登录
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        
        if (result) {
            
            //            NSLog(@"用户资料：%@", [userInfo profileImage]);
            //
            //            LogOutViewController *logOutCtrl = [[LogOutViewController alloc] initWithAPPType:kQQZone];
            //            [self presentViewController:logOutCtrl animated:YES completion:nil];
            
            //传入用户信息并保存、发送通知
            [self sendRequestToSaveUserDataWithNickname:[userInfo nickname] AndUserImg:[userInfo profileImage] AndThirdKey:[userInfo uid] AndThirdType:2];
            
        } else {
            
            [myHud hide:YES];
            
            showHudString(@"登录失败,请检查网络是否畅通~");
        }
        
        [ShareSDK cancelAuthWithType:ShareTypeQQ];
    }];
    
}


- (IBAction)wechatLogin:(UIButton *)sender  //微信
{
    
    myHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ShareSDK getUserInfoWithType:ShareTypeWeixiFav authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        
        if (result) {//登录成功
            
            
            //传入用户信息并保存、发送通知
            [self sendRequestToSaveUserDataWithNickname:[userInfo nickname] AndUserImg:[userInfo profileImage] AndThirdKey:[userInfo uid] AndThirdType:1];
            
        } else {
            
            [myHud hide:YES];
            
            showHudString(@"登录失败,请检查网络是否畅通~");
            
        }
        
        [ShareSDK cancelAuthWithType:ShareTypeWeixiFav];
        
        //          NSLog(@"用户资料：%@", [userInfo profileImage]);
        //        // 获取token
        //        id <ISSPlatformCredential> Cred = [userInfo credential];
        //        NSLog(@"%@", [Cred extInfo]);
        
    }];
    
}


//将第三方得到的用户信息发送到后台进行保存
-(void)sendRequestToSaveUserDataWithNickname:(NSString *)nickname AndUserImg:(NSString *)userImg AndThirdKey:(NSString *)thirdKey AndThirdType:(NSInteger)thirdType
{
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *thirdLoginStr = [[MainUrl stringByAppendingString:thirdLogin]mutableCopy];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:thirdLoginStr] cachePolicy:0 timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *body = [NSString stringWithFormat:@"nickname=%@&&userImg=%@&&thirdKey=%@&&thirdType=%ld&&deviceId=%@",nickname,userImg,thirdKey,thirdType,deviceId];
    
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"第三方登录返回:dict%@",dict);
            
            [self creatNotificationWithUsername:[dict objectForKey:@"nickname"] AndUserImg:[dict objectForKey:@"userImg"]  AndUid:[dict objectForKey:@"userId"]];
            
            [myHud hide:YES];
            
        }else{
        
            [myHud hide:YES];
            
            showHudString(@"登录超时,请检查网络后重试...");
        
        }
        
    }];
    
}


#pragma mark ----- 辅助方法

-(void)touchtoPop   //返回上一页
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)touchToDismiss   //模态视图的返回事件
{

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
}

///返回键
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==phoneNum) {
        
        [testCode becomeFirstResponder];
        
    }else if (textField==testCode){
    
        [self.view endEditing:YES];
    
    }

    return YES;

}


-(void)delayTimeToExecute   //延时执行
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
         //返回上一页
//        [self touchtoPop];
        
        [self touchToDismiss];
        
    });
    
}

#pragma mark ----- WKTextFieldDelegate

- (void)formatter:(WKTextFieldFormatter *)formatter didEnterCharacter:(NSString *)string
{

    

}




























@end
