//
//  NormalRegisterViewController+Methods.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/21.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//


//限制键盘输入情况
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"



#import "NormalRegisterViewController+Methods.h"




#import "UIImageView+WebCache.h"
#import "RESideMenu.h"



@implementation NormalRegisterViewController (Methods)

#pragma mark --- 视图加载方法

-(void)updataTheNavigationbar//导航栏设置
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
    
    self.title=@"用户注册";
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
    
    //关闭侧边栏侧滑
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    self.navigationController.navigationBarHidden=NO;   //显示导航栏
    
}

-(void)loadRegisterView//加载注册界面
{
    
    CGFloat  lineSpace ;    //行距
    
    if (Height==480||Height==568) { //4s或5、5s时
        
        lineSpace = 10;
        
    }else if(Height==667||Height==736){
    
        lineSpace = 20;
    
    }
    
#pragma mark--------用户名
    
    //背景框
    UIView *admin = [self creatUIViewWithFrame:CGRectMake(20, 64+20, Width-20*2, 40)];
    
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
    self.userName.placeholder=@"用户名长度不超过11个字符哟";
    
    [self updataTheTextFieldWith:self.userName];

    
    [admin addSubview:self.userName];
    
    
    
#pragma mark--------昵称
    
    UIView *nick =[self creatUIViewWithFrame:CGRectMake(20, admin.frame.origin.y+admin.frame.size.height+lineSpace, Width-20*2, 40)];
    [self.view addSubview:nick];
    
    //昵称
    UIImageView *nickView =[[UIImageView alloc]initWithFrame:CGRectMake(10, nick.frame.size.height/2-17/2, 17, 17)];
    [nickView setImage:[UIImage imageNamed:@"user_icon"]];
    [nick addSubview:nickView];
    
    //昵称输入框
    self.nickName=[self creatUITextFieldWithFrame:CGRectMake(nickView.frame.origin.x+nickView.frame.size.width+10, 0, nick.frame.size.width-nickView.frame.origin.x-nickView.frame.size.width-10, 40)];
    self.nickName.returnKeyType=UIReturnKeyNext;
    self.nickName.placeholder =@"取个好听的名字吧";
    self.nickName.spellCheckingType=UITextSpellCheckingTypeNo;
    
    //修改输入框左边空间
    UIView *leftView2 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, self.userName.frame.size.height)];
    self.nickName.leftView=leftView2;
    self.nickName.leftViewMode=UITextFieldViewModeAlways;
    
    [self updataTheTextFieldWith:self.nickName];
    
    [nick addSubview:self.nickName];
    
    
#pragma mark--------密码
    
    UIView *password =[self creatUIViewWithFrame:CGRectMake(20, nick.frame.origin.y+nick.frame.size.height+lineSpace, Width-20*2, 40)];
    [self.view addSubview:password];
    
    //密码
    UIImageView *passView =[[UIImageView alloc]initWithFrame:CGRectMake(10, password.frame.size.height/2-17/2, 17, 17)];
    [passView setImage:[UIImage imageNamed:@"user_icon"]];
    [password addSubview:passView];
    
    
    //密码输入框
    self.passWord=[self creatUITextFieldWithFrame:CGRectMake(passView.frame.origin.x+passView.frame.size.width+10, 0, password.frame.size.width-40-(passView.frame.origin.x+passView.frame.size.width+10), password.frame.size.height)];
    self.passWord.keyboardType =UIKeyboardTypeASCIICapable;
    self.passWord.returnKeyType=UIReturnKeyNext;
    self.passWord.placeholder=@"不能短于6cm哟";
    self.passWord.secureTextEntry=YES;
    self.passWord.spellCheckingType=UITextSpellCheckingTypeNo;
    
    [self updataTheTextFieldWith:self.passWord];
    
    [password addSubview:self.passWord];
    
    //密码是否可见按钮
    self.eyes =[[UIButton alloc]initWithFrame:CGRectMake(self.passWord.frame.origin.x+self.passWord.frame.size.width, password.frame.size.height/2-(40/2), 40, 40)];
    [self.eyes setBackgroundImage:[UIImage imageNamed:@"eye_closed_icon"] forState:UIControlStateNormal];//正常状态(闭眼)
    [self.eyes setBackgroundImage:[UIImage imageNamed:@"eye_opened_icon"] forState:UIControlStateSelected];//选中状态(睁开)
    self.eyes.layer.borderColor=[UIColor clearColor].CGColor;
    
    [self.eyes addTarget:self action:@selector(touchToChangeState:) forControlEvents:UIControlEventTouchUpInside];
    
    [password addSubview:self.eyes];
    
#pragma mark --------重复密码
    
    UIView *repeatPassWord  = [self creatUIViewWithFrame:CGRectMake(20, password.frame.origin.y+password.frame.size.height+lineSpace, Width-20*2, 40)];
    [self.view addSubview:repeatPassWord];
    
    UIImageView *repeatView =[[UIImageView alloc]initWithFrame:CGRectMake(10, repeatPassWord.frame.size.height/2-17/2, 17, 17)];
    [repeatView setImage:[UIImage imageNamed:@"user_icon"]];
    [repeatPassWord addSubview:repeatView];
    
    
    self.repeatPassWord = [self creatUITextFieldWithFrame:CGRectMake(repeatView.frame.origin.x+repeatView.frame.size.width+10, 0, repeatPassWord.frame.size.width-repeatView.frame.origin.x-repeatView.frame.size.width-10, 40)];
    self.repeatPassWord.returnKeyType = UIReturnKeyNext;
    self.repeatPassWord.keyboardType =UIKeyboardTypeASCIICapable;
    self.repeatPassWord.placeholder=@"再输入一遍呗~";
    self.repeatPassWord.secureTextEntry=YES;
    self.repeatPassWord.spellCheckingType=UITextSpellCheckingTypeNo;
    
    [self updataTheTextFieldWith:self.repeatPassWord];
    
    [repeatPassWord addSubview:self.repeatPassWord];
    
    
#pragma mark -------验证码
    
    UIView *testCode =[self creatUIViewWithFrame:CGRectMake(20, repeatPassWord.frame.origin.y+repeatPassWord.frame.size.height+lineSpace, 100, 40)];
    [self.view addSubview:testCode];
    
    self.testCode =[self creatUITextFieldWithFrame:testCode.frame];
    self.testCode.placeholder=@"验证码";
    self.testCode.returnKeyType=UIReturnKeyGo;
    self.testCode.keyboardType = UIKeyboardTypeASCIICapable;
    self.testCode.delegate=self;
    [self updataTheTextFieldWith:self.testCode];
    
    [self.view addSubview:self.testCode];
    self.testCode.spellCheckingType=UITextSpellCheckingTypeNo;
    
    
    self.test=[[UIImageView alloc]initWithFrame:CGRectMake(self.testCode.frame.origin.x+self.testCode.frame.size.width+10, self.testCode.frame.origin.y, 125, 40)];
    self.test.backgroundColor=[UIColor whiteColor];
    self.test.contentMode = UIViewContentModeScaleAspectFill;
    self.test.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.test.layer.borderWidth = 0.3;
//    self.test.layer.shadowColor=[UIColor blackColor].CGColor;
//    self.test.layer.shadowOffset=CGSizeMake(0, 1);
//    self.test.layer.shadowOpacity =0.3;
    self.test.userInteractionEnabled=YES;
    self.test.layer.masksToBounds = YES;    //不显示超出边缘的部分
    
    [self.view addSubview:self.test];
    
    //Label添加点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchLabelToDisplay:)];
    [self.test addGestureRecognizer:singleTap];
    singleTap.delegate=self;
    
    
    //验证码提示文字
    self.noticeLabel =[[UILabel alloc]init];
    [self.noticeLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.noticeLabel setTextColor:RGBA(255, 151, 203, 1.0)];
    self.noticeLabel.numberOfLines=1;
    [self.noticeLabel setTextAlignment:1];
    [self.noticeLabel setText:@"点击获取验证码"];
    [self.noticeLabel sizeToFit];
    self.noticeLabel.frame=CGRectMake(self.test.frame.origin.x+self.test.frame.size.width/2-self.noticeLabel.frame.size.width/2, self.test.frame.origin.y+self.test.frame.size.height/2-self.noticeLabel.frame.size.height/2, self.noticeLabel.frame.size.width, self.noticeLabel.frame.size.height);
    [self.view addSubview:self.noticeLabel];
    
    
#pragma mark -----注册按钮
    
    self.regist =[[UIButton alloc]initWithFrame:CGRectMake(20, self.test.frame.origin.y+self.test.frame.size.height+lineSpace, Width-20*2, 40)];
    self.regist.layer.cornerRadius = 5;

    [self.regist setTitle:@"注册" forState:UIControlStateNormal];
    
    self.regist.backgroundColor= [UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0];
    
//    self.regist.layer.shadowColor=[UIColor blackColor].CGColor;
//    self.regist.layer.shadowOffset=CGSizeMake(0, 1);
//    self.regist.layer.shadowOpacity=0.5;
    
    [self.view addSubview:self.regist];
    
    [self.regist addTarget:self action:@selector(touchToRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    self.viewArr = [NSArray arrayWithObjects:admin,nick,password,repeatPassWord,testCode ,nil];
    
    
#pragma mark ----- 跳转到手机注册按钮
    
    UIButton *phoneRegister=[[UIButton alloc]init];
    [phoneRegister setTitle:@"手机注册点这里" forState:UIControlStateNormal];
    if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
        
        [phoneRegister setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
        
    }else{
        
        [phoneRegister setTitleColor:TitleTextColorNight forState:UIControlStateNormal];
        
    }
    phoneRegister.titleLabel.font=[UIFont systemFontOfSize:14];
    [phoneRegister sizeToFit];
    phoneRegister.frame = CGRectMake(Width/2-phoneRegister.frame.size.width/2, self.regist.frame.origin.y+self.regist.frame.size.height+30, phoneRegister.frame.size.width, phoneRegister.frame.size.height);
    
    [self.view addSubview:phoneRegister];
    
    [phoneRegister addTarget:self action:@selector(touchToPhoneRegister:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark ----- 交互方法

- (void)touchLabelToDisplay:(UITapGestureRecognizer *)tapGesture    //获取验证码
{
    
    if(tapGesture.view==self.test)
    {
        
        [self.noticeLabel setHidden:YES];
        
        NSMutableString *verifycodeUrl = [[MainUrl stringByAppendingString:VerifyCodeUrl]mutableCopy];
        
        [verifycodeUrl appendFormat:@"?deviceId=%@&verifyCodeType=1",[self getDeviceId]];
        
//        NSLog(@"verifycodeUrl:%@",verifycodeUrl);
        
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:verifycodeUrl] cachePolicy:0 timeoutInterval:5.0];
        
        //发送请求
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            if (data) {
                
                UIImage *img =[UIImage imageWithData:data];
                
                [self.test setImage:img];
                
            }else{
            
                NSLog(@"获取图片验证码失败");
            
            }
            
        }];
        
        
        
    }
}

-(IBAction)touchToRegister:(UIButton *)button  //注册按钮点击事件
{

    if (self.userName.text.length==0||self.userName.text.length<6) {     //帐号
        
        [self showString:@"用户名6~11位哟"];
        [[[AFViewShaker alloc]initWithView:self.viewArr[0]]shake];
        return;
    }else if(self.nickName.text.length==0||self.userName.text.length>=14){ //昵称
        
        [self showString:@"昵称最多14个字符哟~"];
        [[[AFViewShaker alloc]initWithView:self.viewArr[1]]shake];
        return;
    }else if(self.passWord.text.length<6){ //密码
        
        [self showString:@"密码要6位呀～"];
        [[[AFViewShaker alloc]initWithView:self.viewArr[2]]shake];
        return;
    }else if(self.repeatPassWord.text.length<6){//重复密码
        
        [[[AFViewShaker alloc]initWithView:self.viewArr[3]]shake];
        return;
    }else if(self.testCode.text.length<4){    //验证码
    
        [[[AFViewShaker alloc]initWithView:self.viewArr[4]]shake];
        return;
    }else if (![self.passWord.text isEqualToString:self.repeatPassWord.text]) {
        
        [self showString:@"两次密码不一致哟"];
        return;
    }

    [self registerWithUserName:self.userName.text AndPassWord:self.passWord.text AndverifyCode:self.testCode.text AndnickName:self.nickName.text];
    
}

-(void)registerWithUserName:(NSString *)userName AndPassWord:(NSString *)passWord AndverifyCode:(NSString *)verifyCode AndnickName:(NSString *)nickname     //发送注册请求
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain",@"text/html", nil];
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];
    
    //构造请求体的字典
    NSDictionary *parameters = @{
                                 
                                 @"username":userName,
                                 @"password":[MyMD5 md5:passWord],  //加密
                                 @"usernameType":@2,
                                 @"verifyCode":verifyCode,
                                 @"nickname":nickname,
                                 @"deviceId":[self getDeviceId],
                                 
                                 };
    
    NSString *registerurl =[[MainUrl stringByAppendingString:RegisterUrl]mutableCopy];
    
    
    [manager POST:registerurl parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [hud hide:YES];
        
        NSInteger result = [[dict objectForKey:@"resultCode"]integerValue];
        
        if (result==1) {
            
            [self showString:@"注册成功"];
            
            //发送通知及跳转界面
            
            [self creatNotificationWithUsername:[dict objectForKey:@"nickname"] AndUserImg:[dict objectForKey:@"userImg"] AndUid:[dict objectForKey:@"userId"]];
            
        }else{
            
            [self chooseHudWithResult:result];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        
        [hud hide:YES];
        [self showString:@"请求超时"];
        
    }];
    
    
}





#pragma mark --- 辅助方法
- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
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
    
//    [self showString:@"登录成功"];
    
    [self delayTimeToExecute];  //延时1s跳回前一个页面

}

-(void)chooseHudWithResult:(NSInteger)result    //根据不同的返回码,给予不同的提示
{

    switch (result) {
        case 0:
            
            [self showString:@"注册失败"];
            
            break;
            
        case 3:
            
            [self showString:@"验证码超时"];
            
            break;
        case 4:
            
            [self showString:@"验证码错误"];
            
            break;
        case 7:
            
            [self showString:@"用户名已存在"];
            
            break;
            
        default:
            break;
    }

}



-(void)touchToPop//返回上一页
{
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)touchToSlider   //跳转到侧边栏
{
    [self.navigationController popViewControllerAnimated:YES];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //获取侧边栏的视图
    YRSideViewController *sideViewController=[delegate sideViewController];
    
    [sideViewController  showLeftViewController:YES];
}


-(UIView *)creatUIViewWithFrame:(CGRect)frame//创建uiview
{
    UIView *view =[[UIView alloc]initWithFrame:frame];
    
    view.layer.borderWidth = 0.5;//边框粗细
    view.layer.borderColor =[UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0].CGColor;//边框色
    view.layer.cornerRadius = 5 ;//圆角
    
    return view;
}


-(UITextField *)creatUITextFieldWithFrame:(CGRect)frame//根据大小创建文本框
{

    UITextField *field =[[UITextField alloc]initWithFrame:frame];
    
    field.layer.cornerRadius=10;
    field.delegate=self;
    
    return field;
}



-(IBAction)touchToChangeState:(UIButton *)button    //密码是否可见按钮点击事件
{
    
    button.selected=!button.selected;
    
    if (button.isSelected) {
        
        self.passWord.secureTextEntry=NO;//关闭密码保护
        self.repeatPassWord.secureTextEntry=NO;
        NSLog(@"密码可见");
        
    }else{
        
        self.passWord.secureTextEntry=YES;//开启密码保护
        self.repeatPassWord.secureTextEntry=YES;
        NSLog(@"密码不可见");
        
    }
    
}


-(IBAction)touchToPhoneRegister:(UIButton *)sender  //跳转到手机注册页面
{
    
    self.hidesBottomBarWhenPushed=YES;

    PhoneResgisterViewController *pv =[[PhoneResgisterViewController alloc]init];
    [self.navigationController pushViewController:pv animated:YES];

}

-(void)showString:(NSString *)str//提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;

    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}



-(void)delayTimeToExecute   //延时执行
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //        [self touchToSlider]; (因为侧边栏的废除,不用显示侧边栏了)
        
        [self.navigationController popToRootViewControllerAnimated:YES];  //返回首页即可
        
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    [self getCurrentStringWithTextField:textField.text Andcharacter:string];
//    
//    NSArray *arr =[NSArray arrayWithObjects:self.userName,self.passWord,self.nickName,self.repeatPassWord,self.testCode, nil];
//    for (UITextField *fid in arr) {
//        if (textField==fid) {
//            NSInteger s =fid.text.length+1;
//        }
//    }
    

    //监测所有输入框,是否可以开启注册按钮的点击权限
//    if (self.userName.text.length>=6&&self.nickName.text.length>0&&self.passWord.text.length>=5&&self.repeatPassWord.text.length>=5&&self.testCode.text.length>=3&&range.length==0){
//        
//        self.regist.enabled=YES;
//        self.regist.backgroundColor= [UIColor colorWithRed:255.0f/255.0f green:151.0f/255.0f blue:203.0f/255.0f alpha:1.0];
//
//        self.regist.layer.shadowColor=[UIColor blackColor].CGColor;
//        self.regist.layer.shadowOffset=CGSizeMake(0, 1);
        //self.regist.layer.shadowOpacity=0.5;
//    }else{
//        
//        self.regist.enabled=NO;
//        [self.regist setBackgroundColor:[UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0]];
//        self.regist.layer.shadowColor=[UIColor clearColor].CGColor;
//        self.regist.layer.shadowOffset=CGSizeMake(0, 0);
//        self.regist.layer.shadowOpacity=0.5;
//    }
//
//    NSLog(@"%lu,%lu",(unsigned long)range.location,(unsigned long)range.length);
    



    
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
        
    }else if (textField==self.testCode){
        
        if (string.length>=4) {            //避免一次性输入超过4位
            return NO;
        }
        if (string.length==0) { //代表删除键
            return YES;
        }
        
        return textField.text.length>=4?NO: canChange;
        
    }else if (textField==self.nickName){
        
        if (string.length>=14) {            //避免一次性输入超过11位
            return NO;
        }
        if (string.length==0) { //代表删除键
            return YES;
        }
        
        return textField.text.length>=14?NO:YES;
        
    }else{
        
        return canChange;
        
    }
    
    
//    if (textField==self.userName) {
//        
//        
//        
//    }else if (textField==self.nickName){
//        
//        NSLog(@"昵称");
//    
//    }else if (textField==self.passWord){
//        
//        NSLog(@"密码");
//    
//    }else if (textField==self.repeatPassWord){
//        
//        NSLog(@"重复密码");
//    
//    }else{
//        
//        NSLog(@"验证码");
//        
//    }
    
    


}


-(NSMutableString *)getCurrentStringWithTextField:(NSString *)text Andcharacter:(NSString *)string  //获取当前输入框里的完整内容
{
    NSMutableString *str =[text mutableCopy];
    if (string.length) {
        
        if (str.length<11) {
            [str appendString:string];
        }
        
        NSLog(@"str:%@",str);
        
    }
    
    if (string.length==0) {
        
        if (str.length==0) {
            
        }else{
            
            NSRange rang;
            rang.location = str.length-1;
            rang.length=1;
            [str deleteCharactersInRange:rang];
            NSLog(@"str:%@",str);
            
        }
        
    }
    return str;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField  //文本输入框renturn键的代理方法
{
    if (textField==self.userName) {
        
        [self.nickName becomeFirstResponder];
        
    }else if (textField==self.nickName){
        
        [self.passWord becomeFirstResponder];
        
    }else if (textField==self.passWord){
        
        [self.repeatPassWord becomeFirstResponder];
        
    }else if (textField==self.repeatPassWord){
        
        [self.testCode becomeFirstResponder];
        
    }else{
        
        [self.view endEditing:YES];
        
        if (self.regist.enabled) {
            
            [self.regist sendActionsForControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }
    
    return YES;
    
}













@end
