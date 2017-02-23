
//
//  PhoneNumberBandingViewController+Methods.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/20.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "AFNetworking.h"    //请求封装库
#import "AFViewShaker.h"    //视图震动库

#import "PhoneNumberBandingViewController+Methods.h"

#define kAlphaNum @"0123456789"


@implementation PhoneNumberBandingViewController (Methods)

#pragma  mark ----- 视图创建

-(void)creatBaseView        //加载基本视图
{
    
    [self updataTheNavigationbar];  //加载导航栏
    
    [self creatBaseControll];       //加载基本控件
    
}

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
    
    
    
    
    //修改标题字体大小和颜色
    self.title=@"绑定手机";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNormal);
        
    }else{
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNight);
        
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    //打开手势侧滑功能
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //关闭侧边栏
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
    
}

-(void)creatBaseControll        //加载控件
{
    
    CGFloat  lineSpace ;    //统一行距
    
    if (Height==480||Height==568) { //4s或5、5s时
        
        lineSpace = 10;
        
    }else if(Height==667||Height==736){
        
        lineSpace = 20;
        
    }
    
    //统一圆角
    CGFloat corner = 5 ;

    //手机号
    phoneNum =[[UITextField alloc]initWithFrame:CGRectMake(20,NavigationBarHeight+20, Width-20*2, 40)];
    [phoneNum setValue:[UIFont fontWithName:PingFangSCX size:18] forKeyPath:@"_placeholderLabel.font"];
    phoneNum.placeholder=@"输入手机号";
    phoneNum.delegate=self;
    phoneNum.keyboardType=UIKeyboardTypeNumberPad;
    phoneNum.clearButtonMode=UITextFieldViewModeWhileEditing;   //一键清除
    phoneNum.spellCheckingType=UITextSpellCheckingTypeNo;       //关闭拼写检查
    phoneNum.leftView=[[UIView alloc]init];
    phoneNum.leftViewMode = UITextFieldViewModeAlways;
    phoneNum.borderStyle = UITextBorderStyleRoundedRect;  //修改边框显示效果
    [self.view addSubview:phoneNum];
    
    
    //获取验证码的按钮
    getTestCode=[[UIButton alloc]initWithFrame:CGRectMake(Width-125-20, phoneNum.frame.origin.y+phoneNum.frame.size.height+lineSpace, 125, 40)];
    [getTestCode setTitle:@"获取手机验证码" forState:UIControlStateNormal];
    getTestCode.titleLabel.font=[UIFont fontWithName:PingFangSCX size:16];//修改字体大小
    getTestCode.backgroundColor= [UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0];
    
    [getTestCode addTarget:self action:@selector(getTestCode:) forControlEvents:UIControlEventTouchUpInside];//添加点击事件
    getTestCode.layer.cornerRadius = corner;
    [self.view addSubview:getTestCode];
    
    
    
    
    //验证码
    testCode =[[UITextField alloc]initWithFrame:CGRectMake(phoneNum.frame.origin.x, getTestCode.frame.origin.y, Width-20*2-getTestCode.frame.size.width-10, phoneNum.frame.size.height)];
    [testCode setValue:[UIFont fontWithName:PingFangSCX size:18] forKeyPath:@"_placeholderLabel.font"];
    testCode.placeholder=@"输入验证码";
    testCode.delegate=self;
    testCode.keyboardType=UIKeyboardTypeNumberPad;
    testCode.returnKeyType=UIReturnKeyGo;
    testCode.leftView=[[UIView alloc]init];
    testCode.leftViewMode = UITextFieldViewModeAlways;
    testCode.borderStyle = UITextBorderStyleRoundedRect;  //修改边框显示效果
    [self.view addSubview:testCode];

    
    //绑定按钮
    bandPhone =[[UIButton alloc]initWithFrame:CGRectMake(20, testCode.frame.origin.y+testCode.frame.size.height+lineSpace, Width-20*2, 40)];
    bandPhone.layer.cornerRadius = corner;
    bandPhone.titleLabel.font = [UIFont fontWithName:PingFangSCX size:18];
    
    [bandPhone setTitle:@"绑定" forState:UIControlStateNormal];
    
    bandPhone.enabled=YES;
    bandPhone.backgroundColor= [UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0];
    
    [self.view addSubview:bandPhone];
    
    [bandPhone addTarget:self action:@selector(touchToBandPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewArr =[NSArray arrayWithObjects:phoneNum,testCode, nil];
}


#pragma mark ----- 交互方法


-(IBAction)getTestCode:(UIButton *)sender       //获取手机验证码点击事件
{
    
    if (phoneNum.text.length!=11) {
        [[[AFViewShaker alloc]initWithView:self.viewArr[0]]shake];
        return;
    }else if(![[phoneNum.text substringToIndex:1] isEqualToString:@"1"]){
        
        showHudString(@"手机号有误!");
        return;
        
    }
    
    sender.enabled=NO;
    [sender setBackgroundColor:[UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0]];
    sender.layer.shadowColor=[UIColor clearColor].CGColor;
    sender.layer.shadowOffset=CGSizeMake(0, 0);
    
    //发送获取手机验证码请求
    [self sendRequestToGetTestCodeWithPhoneNumber:phoneNum.text];
    
    //点击后生成一个计时器,倒计时60秒内无法点击
    [self creatTimer];
    
    [self.view endEditing:YES];//收起键盘
}

-(IBAction)touchToBandPhone:(UIButton *)sender  //绑定手机点击事件
{
    
    [self.view endEditing:YES];
    

   
    if (phoneNum.text.length!=11) {
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[0]]shake];
        return;
        
    }else if(![[phoneNum.text substringToIndex:1] isEqualToString:@"1"]){
        
        showHudString(@"手机号有误!");
        return;
        
    }else if(testCode.text.length!=6){
    
        [[[AFViewShaker alloc]initWithView:self.viewArr[1]]shake];
        return;
    
    }
    
    [self sendRequestToBandPhoneNumber];    //开始发送绑定请求

}


-(void)sendRequestToGetTestCodeWithPhoneNumber:(NSString *)phonenumber//获取验证码请求的发送
{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    //构造请求体的字典
    NSDictionary *parameters = @{
                                 
                                 @"messageType":@2,
                                 @"phoneNum":phonenumber,
                                 @"deviceId":[self getDeviceId],
                                 
                                 };
    
    
    NSString *phonetestcode =[[MainUrl stringByAppendingString:PhoneTestCode]mutableCopy];
    
    [manager POST:phonetestcode parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"获取验证码反馈responseObject:%@",responseObject);
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        [self showString:@"短信发送失败"];
        
    }];
    
    
}


-(void)sendRequestToBandPhoneNumber     //绑定请求的发送
{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain",@"text/html", nil];
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //构造请求体的字典
    NSDictionary *parameters = @{
                                 @"contactType":@1,
                                 @"contact":phoneNum.text,
                                 @"userId":CurrentUserId,
                                 @"verifyCode":testCode.text,
                                 @"deviceId":[self getDeviceId],
                                 };
    
//    NSLog(@"parameters:%@",parameters);
    
    NSString *bandUrl = [[MainUrl stringByAppendingString:BandPhoneUrl]mutableCopy];
    
    [manager POST:bandUrl parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSLog(@"responseObject:%@",responseObject);
        
        if ([[responseObject objectForKey:@"resultCode"]integerValue]==1) { //表示登录绑定成功
            
            [self showString:@"绑定成功"];
            
            AppDelegate *app =[UIApplication sharedApplication].delegate;
            FMDatabase *db =app.db;
            BOOL updataPhone =[db executeUpdate:@"update UserTable set phoneNum =? where userId =?",phoneNum.text,CurrentUserId];
            
            if (updataPhone==YES) {
                
                NSLog(@"手机号保存到本地成功");
                
            }else{
            
                NSLog(@"手机号保存到本地失败");
            
            }
            
            [self delayTimeToExecute];  //延时1s跳回前一个页面
            
        }else if([[responseObject objectForKey:@"resultCode"]integerValue]==2){
            
            [self showString:@"手机号已绑定"];
            
        }
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        [hud hide:YES];
        [self showString:@"请求超时"];
        
    }];

}




#pragma mark ----- 辅助方法

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
}

-(void)touchToPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showString:(NSString *)str//提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

-(void)creatTimer       //创建倒计时定时器定时器
{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){     //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                getTestCode.enabled=YES;
                getTestCode.backgroundColor= [UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0];
                [getTestCode setTitle:@"获取手机验证码" forState:UIControlStateNormal];
                getTestCode.layer.shadowColor=[UIColor blackColor].CGColor;
                getTestCode.layer.cornerRadius=10;
                getTestCode.layer.shadowOffset=CGSizeMake(0, 1);
                getTestCode.layer.shadowOpacity=0.3;
                
            });
            
        }else{
            
            NSString *time =[NSString stringWithFormat:@"(%ds)后再次获取",timeout];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [getTestCode setTitle:time forState:UIControlStateNormal];
                
            });
            
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

-(void)delayTimeToExecute   //延时执行
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self touchToPop];
        
    });
    
}

#pragma mark ----- TextField delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    //如果输入的内容是字符集里的某个，则返回yes，反之返回no
    BOOL canChange = [string isEqualToString:filtered];
    
    if (textField==phoneNum){
        
        if (string.length>=11) {            //避免一次性输入超过4位
            return NO;
        }
        if (string.length==0) { //代表删除键
            return YES;
        }
        
        return textField.text.length>=11?NO: canChange;
        
    }else{
        
        if (string.length>=6) {            //避免一次性输入超过4位
            return NO;
        }
        if (string.length==0) { //代表删除键
            return YES;
        }
        
        return textField.text.length>=6?NO: canChange;
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField  //文本输入框renturn键的代理方法
{
    if (textField==phoneNum) {
        
        [testCode becomeFirstResponder];
        
    }else{
    
        [self.view endEditing:YES];
        
        [bandPhone sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    }
    
    return YES;
    
}









@end
