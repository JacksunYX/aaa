//
//  NewLoginViewController+Metheods.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/26.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//


//限制键盘输入情况
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"


#import "NewLoginViewController+Metheods.h"
#import "AppDelegate.h"
#import "FirstViewController.h"             //首页
#import "NormalRegisterViewController.h"    //注册界面
#import "ResetPasswordVC.h"                 //重置密码页面


#import "AFViewShaker.h"    //视图震动库
#import "AFNetworking.h"    //请求封装库
#import "MyMD5.h"           //md5加密库
#import "RESideMenu.h"

@interface NewLoginViewController ()

@end



@implementation NewLoginViewController (Metheods)


#pragma mark --- 集成所有加载视图的方法

-(void)creatView    //集成所有加载视图的方法
{

    [self updataTheNavigationbar];  //加载导航栏
    
    [self loadLoginView];   //加载控件

}



#pragma  mark ----- 视图创建

-(void)updataTheNavigationbar//导航栏设置
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
    self.title=@"用户登陆";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:18],
           NSForegroundColorAttributeName:RGBA(50, 50, 50, 1)}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:18],
           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    //打开手势侧滑功能
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

-(void)loadLoginView//加载注册界面
{
    
    CGFloat  lineSpace ;    //统一行距
    
    if (Height==480||Height==568) { //4s或5、5s时
        
        lineSpace = 10;
        
    }else if(Height==667||Height==736){
        
        lineSpace = 20;
        
    }
    
    //统一圆角
    CGFloat corner = 5 ;
    
#pragma mark ----- 用户名
    
    //背景框

    UIView *admin =[[UIView alloc]initWithFrame:CGRectMake(20, 64+20, Width-20*2, 40)];
    admin.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    [self.view addSubview:admin];
    
    //头像
    UIImageView *user =[[UIImageView alloc]initWithFrame:CGRectMake(10, admin.frame.size.height/2-17/2, 17, 17)];
    [user setImage:[UIImage imageNamed:@"user_icon"]];
    [admin addSubview:user];
    
    //输入框
    self.userName=[self creatUITextFieldWithFrame:CGRectMake(user.frame.origin.x+user.frame.size.width+10, 0, admin.frame.size.width-user.frame.origin.x-user.frame.size.width-10, 40)];
    self.userName.returnKeyType=UIReturnKeyNext;//返回键
    self.userName.keyboardType =UIKeyboardTypeASCIICapable;//键盘类型
    self.userName.clearButtonMode=UITextFieldViewModeWhileEditing;//一键清除
    self.userName.spellCheckingType=UITextSpellCheckingTypeNo;
    self.userName.placeholder=@"用户名/手机号";
    
    [self updataTheTextFieldWith:self.userName];
    
    [admin addSubview:self.userName];
    
    admin.layer.borderWidth=1;//边框粗细
    admin.layer.borderColor=[UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0].CGColor;//边框色
    admin.layer.cornerRadius = corner ;//圆角
    
#pragma mark ----- 密码
    
    UIView *password =[[UIView alloc]initWithFrame:CGRectMake(20, admin.frame.origin.y+admin.frame.size.height+lineSpace, Width-20*2, 40)];
    
    [self.view addSubview:password];
    
    //密码
    UIImageView *passView =[[UIImageView alloc]initWithFrame:CGRectMake(10, password.frame.size.height/2-17/2, 17, 17)];
    [passView setImage:[UIImage imageNamed:@"password_icon"]];
    [password addSubview:passView];
    
    
    //密码输入框
    self.passWord=[self creatUITextFieldWithFrame:CGRectMake(passView.frame.origin.x+passView.frame.size.width+10, 0, password.frame.size.width-75-(passView.frame.origin.x+passView.frame.size.width+10), password.frame.size.height)];
    
    self.passWord.keyboardType =UIKeyboardTypeASCIICapable;
    self.passWord.returnKeyType=UIReturnKeyJoin;
    self.passWord.placeholder=@"密码";
    self.passWord.secureTextEntry=YES;
    self.passWord.spellCheckingType=UITextSpellCheckingTypeNo;
    
    [self updataTheTextFieldWith:self.passWord];
    
    
    [password addSubview:self.passWord];
    
    password.layer.borderWidth=1;//边框粗细
    password.layer.borderColor=[UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0].CGColor;//边框色
    password.layer.cornerRadius = corner ;//圆角
    
    //分割线
    UILabel *seperatLine = [[UILabel alloc]initWithFrame:CGRectMake(self.passWord.frame.origin.x+self.passWord.frame.size.width+5, 10, 1, 20)];
    [seperatLine setBackgroundColor:RGBA(200, 200, 200, 1)];
    [password addSubview:seperatLine];
    
    //忘记密码按钮
    UIButton *forgetPasswordBtn=[[UIButton alloc]init];
    [forgetPasswordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        [forgetPasswordBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }else{
    
        [forgetPasswordBtn setTitleColor:UnimportantContentTextColorNight forState:UIControlStateNormal];
    
    }
    
    forgetPasswordBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [forgetPasswordBtn sizeToFit];
    forgetPasswordBtn.frame=CGRectMake(seperatLine.frame.origin.x+seperatLine.frame.size.width+5, password.frame.size.height/2-forgetPasswordBtn.frame.size.height/2, forgetPasswordBtn.frame.size.width, forgetPasswordBtn.frame.size.height);
    [forgetPasswordBtn addTarget:self action:@selector(touchToResetPassword) forControlEvents:UIControlEventTouchUpInside];
    [password addSubview:forgetPasswordBtn];
    
#pragma mark --- 登录按钮
    
    self.loginbtn =[[UIButton alloc]initWithFrame:CGRectMake(20, password.frame.origin.y+password.frame.size.height+lineSpace, Width-20*2, 40)];
    
    self.loginbtn.layer.cornerRadius = corner;
    
    [self.loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    
    self.loginbtn.backgroundColor= [UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0];
    
//    self.loginbtn.layer.shadowColor=[UIColor blackColor].CGColor;
//    self.loginbtn.layer.shadowOffset=CGSizeMake(0, 1);
//    self.loginbtn.layer.shadowOpacity=0.5;
    
    [self.loginbtn addTarget:self action:@selector(touchToLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.loginbtn];
    
    self.viewArr = [NSArray arrayWithObjects:admin,password,nil];
    
    
#pragma mark --- 第三方登录提示标签
    
    UILabel *share =[[UILabel alloc]init];
    [share setText:@"第三方快速登录"];
    [share setFont:[UIFont systemFontOfSize:14]];
    [share setTextAlignment:1];
    share.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), ContentTextColorNight);
    [share sizeToFit];
    share.frame = CGRectMake(Width/2-share.frame.size.width/2, self.loginbtn.frame.origin.y+self.loginbtn.frame.size.height+30, share.frame.size.width, share.frame.size.height);
    
    CGFloat wid = (Width-share.frame.size.width-40)/2;
    
    UILabel *left =[[UILabel alloc]initWithFrame:CGRectMake(share.frame.origin.x-10-wid, share.frame.origin.y+share.frame.size.height/2, wid, 0.3)];
    left.backgroundColor=[UIColor blackColor];
    UILabel *right =[[UILabel alloc]initWithFrame:CGRectMake(share.frame.origin.x+share.frame.size.width+10, share.frame.origin.y+share.frame.size.height/2, wid, 0.3)];
    right.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:share];
    [self.view  addSubview:left];
    [self.view  addSubview:right];
    
    
#pragma mark ---  第三方登录按钮
    
    UIButton *qqlogin =[[UIButton alloc]init];
    [qqlogin setBackgroundImage:[UIImage imageNamed:@"qq_icon"] forState:UIControlStateNormal];
    [qqlogin sizeToFit];
    qqlogin.frame =CGRectMake(Width/2-qqlogin.frame.size.width/2, share.frame.origin.y+share.frame.size.height+30, qqlogin.frame.size.width, qqlogin.frame.size.height);
    [qqlogin addTarget:self action:@selector(qqLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *weibologin =[[UIButton alloc]init];
    [weibologin setBackgroundImage:[UIImage imageNamed:@"weibo_icon"] forState:UIControlStateNormal];
    [weibologin sizeToFit];
    weibologin.frame=CGRectMake(qqlogin.frame.origin.x-20-weibologin.frame.size.width, qqlogin.frame.origin.y, weibologin.frame.size.width, weibologin.frame.size.height);
    [weibologin addTarget:self action:@selector(sinaLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *weixinlogin =[[UIButton alloc]init];
    [weixinlogin setBackgroundImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [weixinlogin sizeToFit];
    weixinlogin.frame =CGRectMake(qqlogin.frame.origin.x+qqlogin.frame.size.width+20, qqlogin.frame.origin.y, weixinlogin.frame.size.width, weixinlogin.frame.size.height);
    [weixinlogin addTarget:self action:@selector(wechatLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:qqlogin];
    [self.view addSubview:weibologin];
    [self.view addSubview:weixinlogin];
    
#pragma mark --- 新用户注册按钮
    
    UIButton *registerbtn =[[UIButton alloc]init];
    [registerbtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        [registerbtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
        
    }else{
    
        [registerbtn setTitleColor:TitleTextColorNight forState:UIControlStateNormal];
    
    }
    registerbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    
    [registerbtn sizeToFit];
    registerbtn.frame =CGRectMake(Width/2-registerbtn.frame.size.width/2, qqlogin.frame.origin.y+qqlogin.frame.size.height+30, registerbtn.frame.size.width, registerbtn.frame.size.height);
    [registerbtn addTarget:self action:@selector(touchToNormalRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerbtn];
    
}



#pragma  mark --- 交互方法

-(IBAction)touchToLogin:(UIButton *)btn  //注册
{

    if (self.userName.text.length==0) {     //帐号
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[0]]shake];
        return;
    }else if(self.passWord.text.length<6){ //密码
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[1]]shake];

        return;
    }
    
    [self loginWithUsername:self.userName.text AndPassword:self.passWord.text];
    
}


-(void)loginWithUsername:(NSString *)userName AndPassword:(NSString *)passWord  //登录过程
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain",@"text/html", nil];
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    passWord =[MyMD5 md5:passWord];
    
    //构造请求体的字典
    NSDictionary *parameters = @{
                                 @"username":userName,
                                 @"password":passWord,
                                 @"deviceId":deviceId,
                                 
                                 };
    
    NSString *loginurl = [[MainUrl stringByAppendingString:loginUrl]mutableCopy];
    
    [manager POST:loginurl parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"responseObject:%@",responseObject);
        if ([[responseObject objectForKey:@"resultCode"]integerValue]==1) { //表示登录成功
            
            
            [self creatNotificationWithUsername:[responseObject objectForKey:@"nickname"] AndUserImg:[responseObject objectForKey:@"userImg"] AndUid:[responseObject objectForKey:@"userId"]];
            
            
        }else{
        
            [self showString:@"用户名或密码错误"];
        
        }
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [hud hide:YES];
        [self showString:@"登录超时"];
        
    }];

}


-(void)creatNotificationWithUsername:(NSString *)username AndUserImg:(NSString *)userImg AndUid:(NSString *)uid     //根据传进来的用户信息进行通知
{
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@1,@"loginStatus",username,@"nickname",userImg,@"userImg", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"LoginTongZhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    //设定一个登录标记
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"LoginRoNot"];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"userId"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];    //立即写入
    
    [self showString:@"登录成功"];
    
    [self delayTimeToExecute];  //延时1s跳回前一个页面
    
}


//将第三方得到的用户信息发送到后台进行保存
-(void)sendRequestToSaveUserDataWithNickname:(NSString *)nickname AndUserImg:(NSString *)userImg AndThirdKey:(NSString *)thirdKey AndThirdType:(NSInteger)thirdType
{
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain",@"text/html", nil];
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //构造请求体的字典
    NSDictionary *parameters = @{
                                 @"nickname":nickname,
                                 @"userImg":userImg,
                                 @"thirdKey":thirdKey,
                                 @"thirdType":@(thirdType),
                                 @"deviceId":deviceId,
                                 
                                 };
    
    NSString *thirdlogin =[[MainUrl stringByAppendingString:thirdLogin]mutableCopy];
    
    [manager POST:thirdlogin parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSLog(@"%@",responseObject);
        
        [self creatNotificationWithUsername:[responseObject objectForKey:@"nickname"] AndUserImg:[responseObject objectForKey:@"userImg"]  AndUid:[responseObject objectForKey:@"userId"]];
        
        [myHud hide:YES];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        [myHud hide:YES];
        [self showString:@"登录超时"];
        
    }];
}


//第三方登录

- (IBAction)sinaLogin:(UIButton *)sender    //新浪微博
{
    
    myHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    myHud.mode = MBProgressHUDModeIndeterminate;
    [myHud show:YES];
    
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:NO
//                                                                scopes:@{@(ShareTypeSinaWeibo): @[@"follow_app_official_microblog"]}
//                                                         powerByHidden:YES // 隐藏右上角的图片。。。。。。。
//                                                        followAccounts:nil
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:nil];
    
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        
        if (result) {
            
            //传入用户信息并保存、发送通知
            [self sendRequestToSaveUserDataWithNickname:[userInfo nickname] AndUserImg:[userInfo profileImage] AndThirdKey:[userInfo uid] AndThirdType:3];
            

        } else {
            
            [myHud hide:YES];
 
            [self showString:@"登录失败,请检查网络是否畅通~"];
        }
        
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    }];
    
}


- (IBAction)qqLogin:(UIButton *)sender      //qq
{
    myHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    myHud.mode = MBProgressHUDModeIndeterminate;
    [myHud show:YES];
    
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:NO
//                                                                scopes:@{@(ShareTypeSinaWeibo): @[@"follow_app_official_microblog"]}
//                                                         powerByHidden:YES // 隐藏右上角的图片。。。。。。。
//                                                        followAccounts:nil
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:nil];
    // 登录类型传 QQ空间的类型才能使用网页授权 QQ登录
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
        
        if (result) {
            
            //            NSLog(@"用户资料：%@", [userInfo profileImage]);
            //
            //            LogOutViewController *logOutCtrl = [[LogOutViewController alloc] initWithAPPType:kQQZone];
            //            [self presentViewController:logOutCtrl animated:YES completion:nil];
            
            //传入用户信息并保存、发送通知
            [self sendRequestToSaveUserDataWithNickname:[userInfo nickname] AndUserImg:[userInfo profileImage] AndThirdKey:[userInfo uid] AndThirdType:2];
            
        } else {
            
            [myHud hide:YES];

            [self showString:@"登录失败,请检查网络是否畅通~"];
        }
        
        [ShareSDK cancelAuthWithType:ShareTypeQQ];
    }];
    
}


- (IBAction)wechatLogin:(UIButton *)sender  //微信
{
    myHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    myHud.mode = MBProgressHUDModeIndeterminate;
    [myHud show:YES];
    
    [ShareSDK getUserInfoWithType:ShareTypeWeixiFav authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        
        if (result) {//登录成功
            
            
            //传入用户信息并保存、发送通知
            [self sendRequestToSaveUserDataWithNickname:[userInfo nickname] AndUserImg:[userInfo profileImage] AndThirdKey:[userInfo uid] AndThirdType:1];
            
        } else {
            
            [myHud hide:YES];

            [self showString:@"登录失败,请检查网络是否畅通~"];
            
        }
        
        [ShareSDK cancelAuthWithType:ShareTypeWeixiFav];
        
        //          NSLog(@"用户资料：%@", [userInfo profileImage]);
        //        // 获取token
        //        id <ISSPlatformCredential> Cred = [userInfo credential];
        //        NSLog(@"%@", [Cred extInfo]);
        
    }];
    
}


#pragma  mark ----- 辅助方法

-(void)touchtoPop   //返回上一页
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
}


-(void)touchToNormalRegister    //跳转到普通注册
{
    
    self.hidesBottomBarWhenPushed=YES;
    
    NormalRegisterViewController *nv =[[NormalRegisterViewController alloc]init];
    [self.navigationController pushViewController:nv animated:YES];
    
}

-(void)touchToResetPassword     //跳转到密码重置页面
{
    
    self.hidesBottomBarWhenPushed=YES;
    
    ResetPasswordVC *rv =[[ResetPasswordVC alloc]init];
    
    [self.navigationController pushViewController:rv animated:YES];

}


-(void)showAlertView:(NSString *)string //警告框
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
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


-(UITextField *)creatUITextFieldWithFrame:(CGRect)frame//根据大小创建文本框
{
    
    UITextField *field =[[UITextField alloc]initWithFrame:frame];
    
    field.layer.cornerRadius=10;
    field.delegate=self;
    
    return field;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  //点击屏幕收起键盘
{

    [self.view endEditing:YES];
    
}

-(void)delayTimeToExecute   //延时执行
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
//        [self touchtoPop];  //因为废除了侧边栏的缘故(目前停止使用)
        
        [self.navigationController popViewControllerAnimated:YES];  //返回首页即可
    });
    
}

//修改传过来的textfield的相关属性
-(void)updataTheTextFieldWith:(UITextField *)textfield
{
    
    //修改输入框左边空间
    UIView *leftView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, textfield.frame.size.height)];
    textfield.leftView=leftView;
    textfield.leftViewMode=UITextFieldViewModeAlways;
    
    //设置placeholder
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        [textfield setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    }else{
        [textfield setValue:UnimportantContentTextColorNight forKeyPath:@"_placeholderLabel.textColor"];
    }
    [textfield setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    //设置输入的字体颜色
    textfield.dk_textColorPicker=DKColorWithColors([UIColor blackColor], ContentTextColorNight);
    
}


#pragma mark -----  TextField   代理方法

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string //字符输入限制
{

    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    //如果输入的内容是字符集里的某个，则返回yes，反之返回no
    BOOL canChange = [string isEqualToString:filtered];
    
    if (textField==self.userName) {
        
        if (string.length>=11) {            //避免一次性输入超过11位
            return NO;
        }
        if (string.length==0) { //代表删除键
            return YES;
        }
        
        return textField.text.length>=11?NO: canChange;
        
    }else{
    
        return canChange;
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField  //文本输入框renturn键的代理方法
{
    if (textField==self.userName) {
        
        [self.passWord becomeFirstResponder];
        
    }else{
        
        [self.passWord resignFirstResponder];
        [self.loginbtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    return YES;
    
}


@end
