//
//  UserDataViewController+Methods.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/1.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#define BtnNum  7   //cell的个数

#define ORIGINAL_MAX_WIDTH 640.0f

#import "UserDataViewController+Methods.h"

#import "UserSourceModel.h"

#import "AFNetworking.h"
#import "ZHPickView.h"  //地域选择器库


@implementation UserDataViewController (Methods)

#pragma mark --- 加载视图集成方法

-(void)loadMainView //统一加载视图方法
{
    
    [self updataTheNavigationbar];  //修改导航栏
    
    [self creatArr];        //初始化数组

    [self creatTableView];  //创建表视图
    
    [self getUserInfo];     //进来就先获取当前用户的信息
    
    //右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(touchToSaveUserData)];
    self.navigationItem.rightBarButtonItem.dk_tintColorPicker=DKColorWithColors([UIColor blueColor], MainThemeColor);
    self.navigationItem.rightBarButtonItem.enabled=NO; //关闭上传功能

}

#pragma  mark ----- 视图创建

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
    self.title=@"我的信息";
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
    
}

-(void)creatArr                 //初始化全局数组
{
    section1Arr =[[NSMutableArray alloc]initWithObjects:@"昵称",@"性别",@"生日",@"所在地", nil];
    section2Arr =[[NSMutableArray alloc]initWithObjects:@"爱爱号",@"登录密码",@"绑定手机", nil];
}

-(void)creatTableView           //创建表视图
{

    //头像
    self.userImg = [[UIImageView alloc]initWithFrame:CGRectMake(Width/2-72/2, 64+20, 72, 72)];
    [self.userImg setImage:[UIImage imageNamed:@"userImg_icon"]];   //测试图片
    self.userImg.userInteractionEnabled=YES;
    
    UIImageView *photo =[[UIImageView alloc]initWithFrame:CGRectMake(self.userImg.frame.size.width*3/4, self.userImg.frame.size.height*3/4, 24, 24)];
    [photo setImage:[UIImage imageNamed:@"camera_icon"]];
    [self.userImg addSubview:photo];
    
    [self.view addSubview:self.userImg];
    
    //头像添加点击事件
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToChangePicture)];
    singleTap.delegate=self;
    [self.userImg addGestureRecognizer:singleTap];
    
    //表视图
    self.myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, self.userImg.frame.origin.y+self.userImg.frame.size.height+(40-(CellHeight-30)/2), Width, 20+BtnNum*CellHeight+80) style:UITableViewStylePlain];
    
    self.myTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.myTableView.dataSource=self;
    self.myTableView.delegate=self;
    self.myTableView.scrollEnabled=NO;
    self.myTableView.tableFooterView=[[UIView alloc]init];
    
    if (self.myTableView.frame.size.height+self.myTableView.frame.origin.y>Height) {
        
        self.myTableView.scrollEnabled=YES; //使表视图可以滚动
        self.myTableView.showsVerticalScrollIndicator=NO;   //隐藏滚动条
        self.myTableView.frame = CGRectMake(self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width, Height-self.myTableView.frame.origin.y);
        
    }
    
    [self.view addSubview:self.myTableView];
    
}


-(void)loadLocationUserData     //加载本地用户数据
{

    //加载数据
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    FMDatabase *db = app.db;
    
    FMResultSet *userResult =[db executeQuery:@"select * from UserTable where userId = ?",CurrentUserId];
    
    //    遍历结果集
    while ([userResult next]) { //将数据获取并保存到模型中
        
        UserSourceModel *userModel =[[UserSourceModel alloc]init];
        //        userModel.nickname=[userResult stringForColumn:@"nickname"];
        userModel.userImg=[UIImage imageWithData:[userResult dataNoCopyForColumn:@"userImg"]];
        
        //        self.userModel=userModel;
        
        self.userModel.phoneNum=[userResult stringForColumn:@"phoneNum"];
        
        [self.userImg setImage:userModel.userImg];
        self.userImg.userInteractionEnabled=YES;
    }
    [self.myTableView reloadData];

}


#pragma mark ----- 交互方法

-(void)getUserInfo      //获取用户信息列表
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableString *url =[[MainUrl stringByAppendingString:GetUserInfo]mutableCopy];
    
    [url appendString:[NSString stringWithFormat:@"?userId=%@&&deviceId=%@",CurrentUserId,[self getDeviceId]]];
    
    //    NSLog(@"CurrentUserId:%@",CurrentUserId);
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"获取用户信息返回dic:%@",dic);
            
            if ([[dic objectForKey:@"resultCode"]isEqualToString:@"9"]) {
                
                [self showString:@"用户不存在"];
                
                [self delayTimeToExecute];  //延时1s跳回侧边栏
                
                return ;
            }else{
                
                NSArray *keyArr =[dic allKeys];
                
                UserSourceModel *userModel =[[UserSourceModel alloc]init];
                
                for (int i=0; i<keyArr.count; i++) {
                    
                    [userModel setValue:[dic objectForKey:keyArr[i]] forKey:keyArr[i]];
                    
                }
                
                self.userModel=userModel;
                
                self.userModel.userId=CurrentUserId;
                
                [self saveUserDataWithUserModel:self.userModel];    //保存数据到本地
                
                [hud hide:YES];
                
                [self.myTableView reloadData];
                
            }
            
        }else{
            
            [hud hide:YES];
            [self showString:@"请求超时"];
            
            [self delayTimeToExecute];  //延时1s跳回侧边栏
            
        }
        
    }];
    
}

-(void)uploaduserImgWithImgdata:(NSData *)data  //根据传入的图片data发送请求上传图片
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    //上传头像
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain",@"text/html",@"multipart/form-data", nil];
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //构造请求体的字典
    NSDictionary *parameters = @{
                                 @"file":data,
                                 @"userId":CurrentUserId,
                                 @"imgType":@1,
                                 @"deviceId":[self getDeviceId],
                                 
                                 };
    
    NSString *urlString = [MainUrl stringByAppendingString:UploadImgUrl];
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:@"file" fileName:@".png" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [self showString:@"头像上传成功"];
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:data,@"userImagedata", nil];
        //创建更换头像的通知
        NSNotification *notification =[NSNotification notificationWithName:@"UpdataUserImgTongZhi" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [hud hide:YES];
        
        AppDelegate *app=[UIApplication sharedApplication].delegate;
        FMDatabase *db=app.db;
        
        BOOL b =[db executeUpdate:@"update UserTable set userImg=? where userId=?",data,CurrentUserId];
        
        if (b) {
            
            NSLog(@"头像保存到本地成功");
            
            [self.userImg setImage:[UIImage imageWithData:data]];
            
        }else{
            NSLog(@"头像保存到本地失败");
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        
        [hud hide:YES];
        [self showString:@"头像上传失败"];
        
    }];


}

//alertView提示框的代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==myAlert)
    {   //注销框选项
        
        if (buttonIndex==0) {
            
            NSLog(@"取消");
            
        }else if(buttonIndex==1){
            
            NSLog(@"开始注销...");
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            [hud show:YES];
            
            //需要向后台发送注销请求
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain",@"text/html",@"multipart/form-data", nil];
            manager.securityPolicy.allowInvalidCertificates = YES;
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            NSDictionary *paramars =@{
                                      
                                      @"userId":CurrentUserId,
                                      @"deviceId":[self getDeviceId],
                                      
                                      };
            
            [manager POST:[MainUrl stringByAppendingString:LogoutUrl] parameters:paramars success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                if (responseObject) {
                    
                    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    
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
                                
                                [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"LoginRoNot"];//本地状态注销
                                [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"userId"];//本地id注销
                                [[NSUserDefaults standardUserDefaults] synchronize];    //立即写入
                                
                                [hud hide:YES];
                                
                                [self showString:@"注销成功"];
                                
                                NSDictionary *dict2 =[[NSDictionary alloc] initWithObjectsAndKeys:@"yes",@"loginout", nil];
                                //创建注销通知
                                NSNotification *notification =[NSNotification notificationWithName:@"LogoutTongZhi" object:nil userInfo:dict2];
                                //通过通知中心发送通知
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                                
                                ForceLoginout;  //强制注销
                                
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
                                
                                NSLog(@"该用户已在其他设备上登录");
                                
                                [hud hide:YES];
                                
                                [self showString:@"当前用户已在其他设备登录了!"];
                                
                                ForceLoginout;  //强制注销
                                
                            }
                                break;
                                
                                
                            default:
                            {
                            
                                [hud hide:YES];
                                [self showString:@"请检查网络"];
                            
                            }
                                break;
                        }
                        
                    }else{  //不存在resultCode字段
                        
                        
                        
                    }
                    
                    
                }
                
                
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                
                [self showString:@"请求超时"];
                
                [hud hide:YES];
            }];
            
            
            
        }
        
    }else if(alertView ==nicknameAlert)     //昵称框选项
    {
    
        if (buttonIndex==1) {
            
            NSString *nickname =[alertView textFieldAtIndex:0].text; //获取输入的昵称字符串
            if ([self isEmpty:nickname]) {
                
                [self showString:@"昵称不能为空哟~"];
                
            }else{  //处理字符串
            
                self.navigationItem.rightBarButtonItem.enabled=YES; //开启上传功能
                [self.userModel setValue:nickname forKey:@"nickname"];
                [self.myTableView reloadData];
            
            }
            
        }
    
    }
}

-(void)touchToSaveUserData  //保存用户修改后的信息
{
    [myPickView remove];  //先移除
    
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
    
    
//    NSLog(@"CurrentUserId:%@",CurrentUserId);
//    NSLog(@"nickname:%@",self.userModel.nickname);
//    NSLog(@"gender:%@",self.userModel.gender);
//    NSLog(@"birthday:%@",self.userModel.birthday);
//    NSLog(@"location:%@",self.userModel.location);
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:CurrentUserId forKey:@"userId"];                   //用户的userId
    [params setObject:self.userModel.nickname forKey:@"nickname"];       //用户的nickname
    [params setObject:[self getDeviceId] forKey:@"deviceId"];
    
    if (self.userModel.gender) {
        [params setObject:self.userModel.gender forKey:@"gender"];       //用户性别
    }
    if (self.userModel.birthday) {
        [params setObject:self.userModel.birthday forKey:@"birthday"];   //用户生日
    }
    if (self.userModel.location) {
        [params setObject:self.userModel.location forKey:@"location"];   //用户所在地
    }
    
//    NSLog(@"params:%@",params);
    
    //发送修改用户信息的请求
    
    [manager POST:[MainUrl stringByAppendingString:UpdateUserInfoUrl] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"responseObject:%@",responseObject);
        
        [hud hide:YES];
        
        if ([[responseObject objectForKey:@"resultCode"] isEqualToString:@"1"]) {
            
            [self showString:@"已上传"];
            
            [self saveUserDataWithUserModel:self.userModel];    //保存数据到本地
            
            self.navigationItem.rightBarButtonItem.enabled=NO;  //无法使用
            
        }else{
        
            [hud hide:YES];
            
            [self showString:@"服务器出错"];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        [self showString:@"上传失败,请检查网络"];
        
        self.navigationItem.rightBarButtonItem.enabled=YES; //让用户选择再次上传
        
        [hud hide:YES];
        
    }];
    
}






#pragma mark ----- 辅助方法

- (NSString *)getDeviceId   //获取唯一标识符,如果没有则获取后保存
{
    NSString *token;
    
    GetCurrentToken(token);
    
    return token;
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

-(void)touchToPop       //返回上一页
{
    
    [self.navigationController popViewControllerAnimated:YES];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //获取侧边栏的视图
    YRSideViewController *sideViewController=[delegate sideViewController];
    
    [sideViewController  showLeftViewController:YES];
}

-(void)delayTimeToExecute   //延时执行
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
//        [self touchToPop];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    });
    
}


-(void)touchToCancel    //点击注销
{

    myAlert =[[UIAlertView alloc]initWithTitle:@"注销当前登录账号?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销" ,nil];
    myAlert.delegate=self;
    [myAlert show];

}

-(void)touchToChangePicture     //点击用户头像触发事件
{
    
    userImgAction = [[UIActionSheet alloc]initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    
    [userImgAction showInView:self.view];
    
}

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


-(void)saveUserDataWithUserModel:(UserSourceModel *)userModel   //将获取到的用户信息保存到杯底数据库
{

    //本地存储
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    FMDatabase *db=app.db;
    
    
    BOOL a = [db executeUpdate:@"update UserTable set nickname =? where userId =?",userModel.nickname,CurrentUserId];
    BOOL b = [db executeUpdate:@"update UserTable set gender =? where userId =?",userModel.gender,CurrentUserId];
    BOOL c = [db executeUpdate:@"update UserTable set birthday =? where userId =?",userModel.birthday,CurrentUserId];
    BOOL d = [db executeUpdate:@"update UserTable set location =? where userId =?",userModel.location,CurrentUserId];
    BOOL e = [db executeUpdate:@"update UserTable set phoneNum =? where userId =?",userModel.phoneNum,CurrentUserId];
    
    
    if (a&&b&&c&&d&&e) {
        
        NSLog(@"数据保存到本地成功");
    }else{
        NSLog(@"数据保存到本地失败");
    }

}


//actionsheet代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (actionSheet==userImgAction) {

        
        if (buttonIndex == 0) {
            // 拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
            
        } else if (buttonIndex == 1) {
            // 从相册中选取
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = self;
                [self presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
        }
        
        
    }else if (actionSheet==userSex){
    
        switch (buttonIndex)
        {
            case 0:  //男
                self.navigationItem.rightBarButtonItem.enabled=YES; //开启上传功能
                [self.userModel setValue:@"1" forKey:@"gender"];
                [self.myTableView reloadData];
                break;
                
            case 1:  //女
                self.navigationItem.rightBarButtonItem.enabled=YES; //开启上传功能
                [self.userModel setValue:@"0" forKey:@"gender"];
                [self.myTableView reloadData];
                break;
                
            case 2:  //保密
                self.navigationItem.rightBarButtonItem.enabled=YES; //开启上传功能
                [self.userModel setValue:NULL forKey:@"gender"];
                [self.myTableView reloadData];
                break;
        }
    
    }
    

}


//处理获取的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //获取到图片，并且窗口消失后加入外部库来修改图片
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, Height/2-Width/2, Width, Width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        
        //弹出修改图片的窗口视图
        [self presentViewController:imgCropperVC animated:YES completion:^{
            
            
        }];
        
    }];
    
}



//图片重绘切圆
- (UIImage*)cutImage:(UIImage *)orImage WithRadius:(int)radius
{
    UIGraphicsBeginImageContext(orImage.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+orImage.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+orImage.size.height;
    float x4 = x1;
    float y4 = y3;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, orImage.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, orImage.size.width, orImage.size.height), orImage.CGImage);
    
    
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}

//重绘image切圆(方法2)
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, RGBA(255, 151, 203, 1.0).CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
    
}


//对图片做压缩处理(方法1)
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//对图片做压缩处理(方法2)
-(UIImage *) imageCompressForWidthWithImage:(UIImage *)sourceImage AndtargetWidth:(CGSize)size
{
    UIImage *newImage;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//重绘至期望大小(方法3)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}



#pragma mark VPImageCropperDelegate 
//修改图片的外部窗口出现时调用
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
        //压缩
//        UIImage *img = [self imageCompressForWidth:editedImage targetWidth:72];
        
        //压缩2
//        UIImage *img =[self imageCompressForWidthWithImage:editedImage AndtargetWidth:CGSizeMake(320, 320)];
        
        //重绘
        UIImage *img =[self scaleToSize:editedImage size:CGSizeMake(160, 160)];
        
        UIImage *image =[self cutImage:img WithRadius:img.size.width/2];
        
        NSData *data;
        //图片转data存储
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 1);
            
        } else {
            
            data = UIImagePNGRepresentation(image);
        }
        
        [self uploaduserImgWithImgdata:data];
    }];
}


//点击取消时调用
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark camera utility ----------    库相关自带
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage
{
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}






@end
