//
//  UpdataPasswordViewController+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/2/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

//限制键盘输入情况
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#import "UpdataPasswordViewController+Methods.h"

#import "UpdataPasswordWithPhone.h" //使用手机号修改密码页面

#import "SSKeychain.h"  //获取唯一标识符并且保存到钥匙串的库
#import "AFNetworking.h"    //请求封装库
#import "AFViewShaker.h"    //视图震动库
#import "MyMD5.h"           //md5加密库


@implementation UpdataPasswordViewController (Methods)

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
    self.title=@"修改密码";
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNormal);
        
    }else{
        
        SetNavigationBarTitle2([UIFont fontWithName:PingFangSCX size:18], TitleTextColorNight);
        
    }
    
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    
}

-(void)creatBaseControll        //加载控件
{
    
    CGFloat  lineSpace ;    //统一行距
    
    if (Height==480||Height==568) { //4s或5、5s时
        
        lineSpace = 10;
        
    }else if(Height==667||Height==736){
        
        lineSpace = 20;
        
    }
    
    //原密码
    originalPassword =[[UITextField alloc]initWithFrame:CGRectMake(20,NavigationBarHeight+20, Width-20*2, 40)];
    [originalPassword setValue:[UIFont fontWithName:PingFangSCX size:18] forKeyPath:@"_placeholderLabel.font"];
    originalPassword.placeholder=@"输入原密码";
    originalPassword.delegate=self;
    originalPassword.keyboardType = UIKeyboardTypeASCIICapable;
    originalPassword.clearButtonMode=UITextFieldViewModeWhileEditing;   //一键清除
    originalPassword.spellCheckingType=UITextSpellCheckingTypeNo;       //关闭拼写检查
    originalPassword.leftView=[[UIView alloc]init];
    originalPassword.leftViewMode = UITextFieldViewModeAlways;
    originalPassword.borderStyle = UITextBorderStyleRoundedRect;  //修改边框显示效果
    originalPassword.returnKeyType=UIReturnKeyNext;
    [self.view addSubview:originalPassword];
    
    
    //新密码
    newPassword =[[UITextField alloc]initWithFrame:CGRectMake(originalPassword.frame.origin.x, originalPassword.frame.origin.y+originalPassword.frame.size.height+lineSpace, Width-20*2, originalPassword.frame.size.height)];
    [newPassword setValue:[UIFont fontWithName:PingFangSCX size:18] forKeyPath:@"_placeholderLabel.font"];
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
    repeatPassword =[[UITextField alloc]initWithFrame:CGRectMake(originalPassword.frame.origin.x, newPassword.frame.origin.y+newPassword.frame.size.height+lineSpace, Width-20*2, originalPassword.frame.size.height)];
    [repeatPassword setValue:[UIFont fontWithName:PingFangSCX size:18] forKeyPath:@"_placeholderLabel.font"];
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
    getTestCode=[[UIImageView alloc]initWithFrame:CGRectMake(Width-20-125, repeatPassword.frame.origin.y+repeatPassword.frame.size.height+lineSpace, 125, 40)];
    getTestCode.contentMode = UIViewContentModeScaleAspectFill;
    getTestCode.backgroundColor=[UIColor whiteColor];
    getTestCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    getTestCode.layer.borderWidth = 0.3;
    getTestCode.layer.masksToBounds = YES;
    
    getTestCode.userInteractionEnabled=YES;
    
    [self.view addSubview:getTestCode];
    
    //view添加点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchLabelToDisplay:)];
    [getTestCode addGestureRecognizer:singleTap];
    singleTap.delegate=self;
    
    
    //验证码
    testCode = [[UITextField alloc]initWithFrame:CGRectMake(originalPassword.frame.origin.x, repeatPassword.frame.origin.y+repeatPassword.frame.size.height+lineSpace, Width-20*2-getTestCode.frame.size.width-10, originalPassword.frame.size.height)];
    [testCode setValue:[UIFont fontWithName:PingFangSCX size:18] forKeyPath:@"_placeholderLabel.font"];
    testCode.placeholder=@"输入验证码";
    testCode.delegate=self;
    testCode.clearButtonMode=UITextFieldViewModeWhileEditing;   //一键清除
    testCode.spellCheckingType=UITextSpellCheckingTypeNo;       //关闭拼写检查
    testCode.leftView=[[UIView alloc]init];
    testCode.leftViewMode = UITextFieldViewModeAlways;
    testCode.borderStyle = UITextBorderStyleRoundedRect;  //修改边框显示效果
    testCode.returnKeyType=UIReturnKeyGo;
    testCode.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:testCode];
    
    
    //验证码提示文字
    noticeLabel =[[UILabel alloc]init];
    [noticeLabel setFont:[UIFont fontWithName:PingFangSCX size:16]];
    [noticeLabel setTextColor:RGBA(255, 151, 203, 1.0)];
    noticeLabel.numberOfLines=1;
    [noticeLabel setTextAlignment:1];
    [noticeLabel setText:@"点击获取验证码"];
    [noticeLabel sizeToFit];
    noticeLabel.frame=CGRectMake(getTestCode.frame.origin.x+getTestCode.frame.size.width/2-noticeLabel.frame.size.width/2, getTestCode.frame.origin.y+getTestCode.frame.size.height/2-noticeLabel.frame.size.height/2, noticeLabel.frame.size.width, noticeLabel.frame.size.height);
    [self.view addSubview:noticeLabel];
    
    
    //确认按钮
    updataBtn =[[UIButton alloc]initWithFrame:CGRectMake(20, testCode.frame.origin.y+testCode.frame.size.height+lineSpace, Width-20*2, 40)];
    updataBtn.layer.cornerRadius = 5;
    [updataBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCX size:18]];
    [updataBtn setTitle:@"确定" forState:UIControlStateNormal];
    updataBtn.backgroundColor= [UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0];

    
    [self.view addSubview:updataBtn];
    
    [updataBtn addTarget:self action:@selector(touchToUpdataPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewArr =[NSArray arrayWithObjects:originalPassword,newPassword,repeatPassword,testCode, nil];
    
    
    //添加手机号修改密码方式
    UIButton *otherBtn =[[UIButton alloc]init];
    [otherBtn setTitle:@"通过手机号修改" forState:UIControlStateNormal];
    [otherBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCX size:16]];
    
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        [otherBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [otherBtn setTitleColor:ContentTextColorNight forState:UIControlStateNormal];
    }
    
    [otherBtn sizeToFit];
    otherBtn.frame=CGRectMake(Width-20-otherBtn.frame.size.width, updataBtn.frame.origin.y+updataBtn.frame.size.height+lineSpace, otherBtn.frame.size.width, otherBtn.frame.size.height);
    [otherBtn addTarget:self action:@selector(touchToPhoneUpdataPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherBtn];
}


#pragma mark ----- 交互方法

- (void)touchLabelToDisplay:(UITapGestureRecognizer *)tapGesture    //获取验证码
{
    
    if(tapGesture.view==getTestCode)
    {
        
        [noticeLabel setHidden:YES];
        
        NSMutableString *verifycodeUrl = [[MainUrl stringByAppendingString:VerifyCodeUrl]mutableCopy];
        
        [verifycodeUrl appendFormat:@"?deviceId=%@&verifyCodeType=2",[self getDeviceId]];
        
        //        NSLog(@"verifycodeUrl:%@",verifycodeUrl);
        
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:verifycodeUrl] cachePolicy:0 timeoutInterval:5.0];
        
        //发送请求
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            if (data) {
                
                UIImage *img =[UIImage imageWithData:data];
                
                [getTestCode setImage:img];
                
            }else{
                
                NSLog(@"获取图片验证码失败");
                
            }
            
        }];
        
    }
}

-(IBAction)touchToUpdataPassword:(UIButton *)sender  //点击修改密码事件
{

    [self.view endEditing:YES];
    
    if (originalPassword.text.length<=0) {
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[0]]shake];
        return;
        
    }else if(newPassword.text.length<=0){
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[1]]shake];
        return;
        
    }else if(repeatPassword.text.length<=0){
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[2]]shake];
        return;
        
    }else if(testCode.text.length!=4){
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[3]]shake];
        return;
        
    }else if(![newPassword.text isEqualToString:repeatPassword.text]){
    
        [self showString:@"两次密码不一致哟~"];
        return;
    }

    NSLog(@"开始修改密码");
    
    [self updataPassWord];  //发送修改密码的请求
    
}

-(void)updataPassWord   //修改密码请求过程
{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
                                 
                                 @"userId"      :CurrentUserId,
                                 @"modifyType"  :@1,
                                 @"newPassword" :[MyMD5 md5:newPassword.text],  //加密
                                 @"oldPassword" :[MyMD5 md5:originalPassword.text],
                                 @"deviceId"    :[self getDeviceId],
                                 @"verifyCode"  :testCode.text,
                                 
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

-(void)touchToPhoneUpdataPassword   //跳转到使用手机号修改密码页面
{

    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db =app.db;
    FMResultSet *userResult =[db executeQuery:@"select * from UserTable where userId = ?",CurrentUserId];
    
    //    遍历结果集
    while ([userResult next]) { //将数据获取并保存到模型中
        
        if ([userResult stringForColumn:@"phoneNum"].length>0) {    //说明存在绑定手机
            
            self.hidesBottomBarWhenPushed=YES;
            
            [self.navigationController pushViewController:[[UpdataPasswordWithPhone alloc]init] animated:YES];
            
        }else{
        
            [self showString:@"您还没有绑定手机号哟~"];
        
        }
    
    }

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
    
    if (textField==testCode){
        
        if (string.length>=4) {            //避免一次性输入超过4位
            return NO;
        }
        if (string.length==0) { //代表删除键
            return YES;
        }
        
        return textField.text.length>=4?NO: canChange;
        
    }else{
        
        return canChange;
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField  //文本输入框renturn键的代理方法
{
    if (textField==originalPassword) {
        
        [newPassword becomeFirstResponder];
        
    }else if (textField==newPassword){
        
        [repeatPassword becomeFirstResponder];
        
    }else if (textField==repeatPassword){
        
        [testCode becomeFirstResponder];
        
    }else{
        
        [testCode resignFirstResponder];
        
        if (updataBtn.enabled) {
            
            [updataBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }
    
    return YES;
    
}



@end
