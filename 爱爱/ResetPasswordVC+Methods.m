//
//  ResetPasswordVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/9.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

//限制键盘输入情况
#define kAlphaNum1 @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlphaNum2 @"0123456789"

#import "ResetPasswordVC+Methods.h"


#import "AFNetworking.h"    //请求封装库
#import "AFViewShaker.h"    //视图震动库
#import "MyMD5.h"           //md5加密库

#import "UIViewController+JTNavigationExtension.h"  //用于导航栏处理



@implementation ResetPasswordVC (Methods)

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
    self.title=@"重置密码";
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
    //关闭侧边栏
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
    
}

-(void)creatBaseControll        //加载控件
{
    
    CGFloat  lineSpace ;    //行距
    
    if (Height==480||Height==568) { //4s或5、5s时
        
        lineSpace = 10;
        
    }else if(Height==667||Height==736){
        
        lineSpace = 20;
        
    }
    
    //手机号
    originalPhoneNum =[[UITextField alloc]initWithFrame:CGRectMake(20,NavigationBarHeight+20, Width-20*2, 40)];
    originalPhoneNum.placeholder=@"手机号";
    originalPhoneNum.delegate=self;
    originalPhoneNum.keyboardType=UIKeyboardTypeNumberPad;
    originalPhoneNum.clearButtonMode=UITextFieldViewModeWhileEditing;   //一键清除
    originalPhoneNum.spellCheckingType=UITextSpellCheckingTypeNo;       //关闭拼写检查
    originalPhoneNum.leftView=[[UIView alloc]init];
    originalPhoneNum.leftViewMode = UITextFieldViewModeAlways;
    originalPhoneNum.borderStyle = UITextBorderStyleRoundedRect;  //修改边框显示效果
    originalPhoneNum.returnKeyType=UIReturnKeyNext;
    [self.view addSubview:originalPhoneNum];
    
    
    //新密码
    newPassword =[[UITextField alloc]initWithFrame:CGRectMake(originalPhoneNum.frame.origin.x, originalPhoneNum.frame.origin.y+originalPhoneNum.frame.size.height+lineSpace, Width-20*2, originalPhoneNum.frame.size.height)];
    newPassword.placeholder=@"输入新密码";
    newPassword.delegate=self;
    newPassword.keyboardType=UIKeyboardTypeDefault;
    newPassword.clearButtonMode=UITextFieldViewModeWhileEditing;   //一键清除
    newPassword.spellCheckingType=UITextSpellCheckingTypeNo;       //关闭拼写检查
    newPassword.leftView=[[UIView alloc]init];
    newPassword.leftViewMode = UITextFieldViewModeAlways;
    newPassword.borderStyle = UITextBorderStyleRoundedRect;  //修改边框显示效果
    newPassword.returnKeyType=UIReturnKeyNext;
    newPassword.secureTextEntry=YES;    //隐藏显示
    [self.view addSubview:newPassword];
    
    
    //重复新密码
    repeatPassword =[[UITextField alloc]initWithFrame:CGRectMake(originalPhoneNum.frame.origin.x, newPassword.frame.origin.y+newPassword.frame.size.height+lineSpace, Width-20*2, originalPhoneNum.frame.size.height)];
    repeatPassword.placeholder=@"重复新密码";
    repeatPassword.delegate=self;
    repeatPassword.keyboardType=UIKeyboardTypeDefault;
    repeatPassword.clearButtonMode=UITextFieldViewModeWhileEditing;   //一键清除
    repeatPassword.spellCheckingType=UITextSpellCheckingTypeNo;       //关闭拼写检查
    repeatPassword.leftView=[[UIView alloc]init];
    repeatPassword.leftViewMode = UITextFieldViewModeAlways;
    repeatPassword.borderStyle = UITextBorderStyleRoundedRect;  //修改边框显示效果
    repeatPassword.returnKeyType=UIReturnKeyNext;
    repeatPassword.secureTextEntry=YES;    //隐藏显示
    [self.view addSubview:repeatPassword];
    
    
    //获取验证码
    getTest=[[UIButton alloc]initWithFrame:CGRectMake(Width-20-125, repeatPassword.frame.origin.y+repeatPassword.frame.size.height+lineSpace, 125, 40)];
    [getTest setTitle:@"获取手机验证码" forState:UIControlStateNormal];
    getTest.titleLabel.font=[UIFont systemFontOfSize:14];//修改字体大小
    getTest.backgroundColor= [UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0];
    [getTest addTarget:self action:@selector(getTestCode:) forControlEvents:UIControlEventTouchUpInside];//添加点击事件
    getTest.layer.cornerRadius=5;
    
//    getTest.layer.shadowColor=[UIColor blackColor].CGColor;
//    getTest.layer.shadowOffset=CGSizeMake(0, 1);
//    getTest.layer.shadowOpacity=0.3;
    
    [self.view addSubview:getTest];
    
    
    
    //验证码
    testCode = [[UITextField alloc]initWithFrame:CGRectMake(originalPhoneNum.frame.origin.x, repeatPassword.frame.origin.y+repeatPassword.frame.size.height+lineSpace, Width-20*2-getTest.frame.size.width-10, originalPhoneNum.frame.size.height)];
    testCode.placeholder=@"输入验证码";
    testCode.delegate=self;
    testCode.clearButtonMode=UITextFieldViewModeWhileEditing;   //一键清除
    testCode.spellCheckingType=UITextSpellCheckingTypeNo;       //关闭拼写检查
    testCode.leftView=[[UIView alloc]init];
    testCode.leftViewMode = UITextFieldViewModeAlways;
    testCode.borderStyle = UITextBorderStyleRoundedRect;  //修改边框显示效果
    testCode.returnKeyType=UIReturnKeyGo;
    testCode.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:testCode];
    
    
    //确认按钮
    updataBtn =[[UIButton alloc]initWithFrame:CGRectMake(20, testCode.frame.origin.y+testCode.frame.size.height+lineSpace, Width-20*2, 40)];
    updataBtn.layer.cornerRadius = 5;
    [updataBtn setTitle:@"确定" forState:UIControlStateNormal];
    updataBtn.backgroundColor= [UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0];
//    updataBtn.layer.shadowColor=[UIColor blackColor].CGColor;
//    updataBtn.layer.shadowOffset=CGSizeMake(0, 1);
//    updataBtn.layer.shadowOpacity=0.5;
    
    [self.view addSubview:updataBtn];
    
    [updataBtn addTarget:self action:@selector(touchToUpdataPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewArr =[NSArray arrayWithObjects:originalPhoneNum,newPassword,repeatPassword,testCode, nil];
    
}


-(IBAction)touchToUpdataPassword:(UIButton *)sender  //点击修改密码事件
{
    
    [self.view endEditing:YES];
    
    if (originalPhoneNum.text.length<=0||originalPhoneNum.text.length!=11) {
        [[[AFViewShaker alloc]initWithView:self.viewArr[0]]shake];
        return;
    }else if(newPassword.text.length<=0){
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[1]]shake];
        return;
        
    }else if(repeatPassword.text.length<=0){
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[2]]shake];
        return;
        
    }else if (newPassword.text.length<=6||repeatPassword.text.length<=6){
        
        [self showString:@"密码长度不可以少于6位哟"];
        return;
        
    }else if(testCode.text.length!=6){
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[3]]shake];
        return;
        
    }else if(![newPassword.text isEqualToString:repeatPassword.text]){
        
        [self showString:@"两次密码不一致哟~"];
        return;
    }
    
    NSLog(@"开始修改密码");
    
    [self updataPassWord];  //发送修改密码的请求
    
}




#pragma mark ----- 交互方法


-(void)updataPassWord   //修改密码请求过程
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    
    //构造请求体的字典
    NSDictionary *parameters = @{
                                 
                                 @"userId"      :CurrentUserId,
                                 @"modifyType"  :@2,
                                 @"newPassword" :[MyMD5 md5:newPassword.text],  //加密
                                 @"oldPassword" :testCode.text,
                                 @"phoneNum"    :originalPhoneNum.text,
                                 @"deviceId"    :deviceId,
                                 
                                 };
    
    //    NSLog(@"parameters:%@",parameters);
    
    NSString *updataPasswordUrl = [[MainUrl stringByAppendingString:UpdataPasswordUrl]mutableCopy];
    
    [manager POST:updataPasswordUrl parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        
        [self chooseHudWithResult:[[responseObject objectForKey:@"resultCode"] integerValue]];
        
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        [hud hide:YES];
        [self showString:@"请求超时"];
        
    }];
    
}

-(void)sendRequestToGetTestCodeWithPhoneNumber:(NSString *)phonenumber//获取验证码请求的发送
{
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    //构造请求体的字典
    NSDictionary *parameters = @{
                                 
                                 @"messageType":@3,
                                 @"phoneNum":phonenumber,
                                 @"deviceId":deviceId,
                                 
                                 };
    
    
    NSString *phonetestcode =[[MainUrl stringByAppendingString:PhoneTestCode]mutableCopy];
    
    [manager POST:phonetestcode parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        [self showString:@"短信发送失败"];
        
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

-(void)chooseHudWithResult:(NSInteger)result    //根据不同的返回码,给予不同的提示
{
    
    switch (result) {
        case 0:
            
            [self showString:@"修改失败"];
            
            break;
            
        case 1:
        {
            [self showString:@"修改成功"];
            [self delayTimeToExecute];  //延时1s跳回前一个页面
        }
            
            break;
            
        case 3:
            
            [self showString:@"验证码超时"];
            
            break;
        case 4:
            
            [self showString:@"验证码错误"];
            
            break;
        case 8:
            
            [self showString:@"原密码错误"];
            
            break;
            
        default:
            break;
    }
    
}

-(void)delayTimeToExecute   //延时执行
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self touchToPop];  //返回上页
        
    });
    
}

-(IBAction)getTestCode:(UIButton *)sender      //获取手机验证码点击事件
{
    [self.view endEditing:YES];
    
    NSString *firstStr;
    
    if (originalPhoneNum.text.length>0) {
        
       firstStr = [originalPhoneNum.text substringWithRange:NSMakeRange(0, 1)];
        
    }
    
    if(originalPhoneNum.text.length!=11||![firstStr isEqualToString:@"1"]){
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[0]]shake];
        
        return;
        
    }
    
    sender.enabled=NO;
    [sender setBackgroundColor:[UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0]];
    sender.layer.shadowColor=[UIColor clearColor].CGColor;
    sender.layer.shadowOffset=CGSizeMake(0, 0);
    
    //发送获取手机验证码请求
    
    [self sendRequestToGetTestCodeWithPhoneNumber:originalPhoneNum.text];
    
    //点击后生成一个计时器,倒计时60秒内无法点击
    [self creatTimer];
    
    [self.view endEditing:YES];//收起键盘
}

-(void)creatTimer       //创建定时器
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
                getTest.enabled=YES;
                getTest.backgroundColor= [UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0];
                [getTest setTitle:@"获取手机验证码" forState:UIControlStateNormal];
                getTest.layer.shadowColor=[UIColor blackColor].CGColor;
                getTest.layer.cornerRadius=10;
                getTest.layer.shadowOffset=CGSizeMake(0, 1);
                getTest.layer.shadowOpacity=0.3;
                
            });
            
        }else{
            
            NSString *time =[NSString stringWithFormat:@"(%ds)后再次获取",timeout];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [getTest setTitle:time forState:UIControlStateNormal];
                
            });
            
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}


#pragma mark ----- TextField delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *cs1;
    cs1 = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum1] invertedSet];
    NSString *filtered1 = [[string componentsSeparatedByCharactersInSet:cs1] componentsJoinedByString:@""];
    BOOL canChange1 = [string isEqualToString:filtered1];
    
    NSCharacterSet *cs2;
    cs2 = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum2] invertedSet];
    NSString *filtered2 = [[string componentsSeparatedByCharactersInSet:cs2] componentsJoinedByString:@""];
    BOOL canChange2 = [string isEqualToString:filtered2];
    
    if (textField==testCode){
        
        if (string.length>=6) {            //避免一次性输入超过4位
            return NO;
        }
        if (string.length==0) { //代表删除键
            return YES;
        }
        
        return textField.text.length>=6?NO: canChange2;
        
    }else if (textField==originalPhoneNum){ //手机号
    
        if (string.length>=11) {
            return NO;
        }
        if (string.length==0) {
            return YES;
        }
    
        return textField.text.length>=11?NO:canChange2;
        
    }else{
        
        return canChange1;
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField  //文本输入框renturn键的代理方法
{
    if (textField==originalPhoneNum) {
        
        [newPassword becomeFirstResponder];
        
    }else if (textField==newPassword) {
        
        [repeatPassword becomeFirstResponder];
        
    }else if (textField==repeatPassword){
        
        [testCode becomeFirstResponder];
        
    }else{
        
        [self.view endEditing:YES];
        
        [updataBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    return YES;
    
}

@end
