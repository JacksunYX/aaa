//
//  NewSliderViewController+Methods.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/29.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
#define BtnNum  6

#define ViewWidth Width*2/3

#import "NewSliderViewController+Methods.h"

#import "NewsSourceModel.h"

#import "TFHpple.h" //解析html库




@implementation NewSliderViewController (Methods)

static int titleImageNum=0;     //用来计算异步加载的标题图片的数量
static int otherImgNum=0;       //用来计算除标题图片以外的其他图片数量
static int contentImgNum=0;     //用来计算图文混排式新闻里包含的图片
#pragma mark ----- 视图加载方法

-(void)loadViewData //加载视图
{

    [self creatbtn];
    
    [self creatTableView];
}


-(void)creatbtn //创建相关按钮
{

    //头像
    userImg =[[UIImageView alloc]init];
    CGRect userframe = CGRectMake(ViewWidth/2-72/2, 60, 72, 72);
    userImg.frame=userframe;
    [userImg setImage:[UIImage imageNamed:@"userImg_icon"]];
    userImg.userInteractionEnabled=YES;
    userImg.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    [self.view addSubview:userImg];
    
    //头像添加点击事件
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToChangePicture)];
    [userImg addGestureRecognizer:singleTap];
    
    //用户昵称
    username =[[UILabel alloc]init];
    username.dk_textColorPicker=DKColorWithColors([UIColor blackColor], TitleTextColorNight);
    [self.view addSubview:username];
    
    //注册和登录按钮
    loginBtn =[[UIButton alloc]init];
    registerBtn =[[UIButton alloc]init];
    
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [loginBtn sizeToFit];
    loginBtn.frame=CGRectMake(ViewWidth/2-loginBtn.frame.size.width, userImg.frame.origin.y+userImg.frame.size.height+20, loginBtn.frame.size.width, loginBtn.frame.size.height);
    
    
    [registerBtn setTitle:@"/注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [registerBtn sizeToFit];
    registerBtn.frame=CGRectMake(ViewWidth/2, loginBtn.frame.origin.y, registerBtn.frame.size.width, registerBtn.frame.size.height);
    
    [loginBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    [registerBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    
    [loginBtn addTarget:self action:@selector(touchToLogin) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn addTarget:self action:@selector(touchToRegister) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:loginBtn];
    [self.view addSubview:registerBtn];
    
}

-(void)creatTableView   //创建表视图
{

    self.mytableView = ({
        
        UITableView *tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, loginBtn.frame.origin.y+loginBtn.frame.size.height+(50-(CellHeight-30)/2), ViewWidth, BtnNum*CellHeight) style:UITableViewStylePlain];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView;
    });
    
    [self.view addSubview:self.mytableView];
    
    //使表视图无法滑动
    self.mytableView.scrollEnabled=NO;
    //设置分割线的风格
    self.mytableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //设置分割线距边界的距离
//    self.mytableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 120);
//    [self.mytableView setSeparatorColor:RGBA(200, 200, 200, 1)];
    self.mytableView.dk_backgroundColorPicker =  DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    self.mytableView.dk_separatorColorPicker = DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    self.mytableView.tableFooterView=[[UIView alloc]init];
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    self.navigationController.navigationBarHidden=YES;  //隐藏导航栏
    
    if (self.mytableView.frame.size.height+self.mytableView.frame.origin.y>Height) {
        
        //使表视图可以滚动
        self.mytableView.scrollEnabled=YES;
        self.mytableView.showsVerticalScrollIndicator=NO;   //隐藏滚动条
        self.mytableView.frame = CGRectMake(self.mytableView.frame.origin.x, self.mytableView.frame.origin.y, self.mytableView.frame.size.width, Height-self.mytableView.frame.origin.y);
        
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;

}

-(void)changeNavigationView //修改导航栏相关设置
{
    
//    NSLog(@"LoginRoNot:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]);
//    NSLog(@"CurrentUserId:%@",CurrentUserId);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
        //如果用户登录了，获取本地数据库中用户信息来更新界面
        
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        FMDatabase *db = app.db;
        
        
        FMResultSet *userResult =[db executeQuery:@"select * from UserTable where userId = ?",CurrentUserId];
        
        //遍历结果集
        while ([userResult next]) {//将数据获取并保存到模型中
            
            UserSourceModel *userModel =[[UserSourceModel alloc]init];
            userModel.nickname=[userResult stringForColumn:@"nickname"];
            userModel.userImg=[UIImage imageWithData:[userResult dataNoCopyForColumn:@"userImg"]];
            
//            NSLog(@"取nickname:%@",userModel.nickname);
            
            [username setText:userModel.nickname];
            [username sizeToFit];
            username.frame=CGRectMake(userImg.frame.origin.x+userImg.frame.size.width/2-username.frame.size.width/2, userImg.frame.origin.y+userImg.frame.size.height+10, username.frame.size.width, username.frame.size.height);
            
            UIImage *img =[self scaleToSize:userModel.userImg size:CGSizeMake(160, 160)];
            
            UIImage *im =[self cutImage:img WithRadius:img.size.width/2];
            
            [userImg setImage:im];
            
            
        }
        [loginBtn setHidden:YES];//隐藏
        [registerBtn setHidden:YES];
        [username setHidden:NO];//显示
        userImg.userInteractionEnabled=YES;
        
    }else{
        
        userImg.userInteractionEnabled=NO;//头像不可点击
        [userImg setImage:[UIImage imageNamed:@"userImg_icon"]];
        [username setHidden:YES];
        
        [loginBtn setHidden:NO];
        [registerBtn setHidden:NO];
        
        
    }

}

-(void)creatProgressView    //创建进度圈(带文字百分比的)
{

    progressView = [[UCZProgressView alloc] initWithFrame:CGRectMake(self.mytableView.frame.size.width-10-25, CellHeight/2-25/2, 25, 25)];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    progressView.radius=progressView.frame.size.width/3*2;
    progressView.showsText = YES;
    progressView.textSize=8;    //字体大小
    progressView.backgroundColor=[UIColor clearColor];
    progressView.textLabel.backgroundColor=[UIColor clearColor];
    progressView.backgroundView.backgroundColor=[UIColor clearColor];
    progressView.backgroundView.frame=CGRectMake(progressView.backgroundView.frame.origin.x, progressView.backgroundView.frame.origin.y, progressView.backgroundView.frame.size.width-progressView.lineWidth, progressView.backgroundView.frame.size.height-progressView.lineWidth);
    progressView.textColor = [UIColor redColor];

}


-(void)creatNoemalProgressView  //创建普通进度圈(无限转圈)
{

    progressView=[[UCZProgressView alloc] initWithFrame:CGRectMake(self.mytableView.frame.size.width-10-25, CellHeight/2-25/2, 25, 25)];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    progressView.radius=progressView.frame.size.width/2;
    progressView.backgroundColor=[UIColor clearColor];
    progressView.textLabel.backgroundColor=[UIColor clearColor];
    progressView.backgroundView.backgroundColor=[UIColor clearColor];

}





#pragma mark ----交互事件

-(void)touchToLogin     //登陆点击事件
{
    
    [self jumpToViewWithNavi:[[NewLoginViewController alloc]init]];
    
}


-(void)touchToRegister  //注册点击事件
{
    
    [self jumpToViewWithNavi:[[NormalRegisterViewController alloc]init]];
    
}


-(void)downLoadData     //离线资源
{

    //请求普通区新闻
    NSMutableString *newsUrl=[[MainUrl stringByAppendingString:newsList]mutableCopy];
        
    [newsUrl appendString:[NSString stringWithFormat:@"?category=%d&newsDateId=%@&number=%d&baseObjectId=&offlineNews=%d&contentType=%d",11,@"",100,1,2]];
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:newsUrl]];
    
    NSURLConnection *connection =[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    didReceiveData=[[NSMutableData alloc]init]; //初始化
    
    contentLength=0;    //初始化
    
    [connection start]; //启动请求
    
}









#pragma mark ----- 辅助方法

-(void)touchToChangePicture     //点击用户头像触发事件
{
    
    [self jumpToViewWithNavi:[[UserDataViewController alloc]init]];
    
}


- (void)tongzhi:(NSNotification *)text  //通知回调
{
//        NSLog(@"%@",text.userInfo[@"loginStatus"]);
//        NSLog(@"%@",text.userInfo[@"userImg"]);
//        NSLog(@"存nickname:%@",text.userInfo[@"nickname"]);
    
    
    [loginBtn setHidden:YES];
    [registerBtn setHidden:YES];
    
    userImg.userInteractionEnabled=YES;
    
    NSString *imgurl =[MainUrl stringByAppendingString:text.userInfo[@"userImg"]];

    NSLog(@"imgurl:%@",imgurl);
    
    [userImg sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"userImg_icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UIImage *img =[self scaleToSize:image size:CGSizeMake(160, 160)];
        
        UIImage *im =[self cutImage:img WithRadius:img.size.width/2];
        
        [userImg setImage:im];
        
        //成功后将用户的信息保存到本地
        NSData *data;
        //图片转data存储
        if (UIImagePNGRepresentation(im) == nil) {
            
            data = UIImageJPEGRepresentation(im, 1);
            
        } else {
            
            data = UIImagePNGRepresentation(im);
        }
        
        
        AppDelegate *app=[UIApplication sharedApplication].delegate;
        FMDatabase *db=app.db;
        
//        NSLog(@"CurrentUserId:%@",CurrentUserId);
        
        FMResultSet *userResult =[db executeQuery:@"select * from UserTable where userId=?",CurrentUserId];
        
        if ([userResult next]) {    //已存在用户,无需再次插入
            
            NSLog(@"已存在用户");
            
            BOOL a = [db executeUpdate:@"update UserTable set nickname = ? where userId = ?",text.userInfo[@"nickname"],CurrentUserId];
            BOOL b = [db executeUpdate:@"update UserTable set userImg = ? where userId = ?",text.userInfo[@"nickname"],data];
            
            if (a&&b) {
                
                NSLog(@"数据保存到本地成功");
            }else{
                NSLog(@"数据保存到本地失败");
            }
        }else{
        
        
            BOOL b =[db executeUpdate:@"insert into UserTable (nickname,userId,userImg) values(?,?,?)",text.userInfo[@"nickname"],CurrentUserId,data];
            if (b) {
                
                NSLog(@"数据保存到本地成功");
            }else{
                NSLog(@"数据保存到本地失败");
            }

            
        }
        
    }];
    
    [username setText:text.userInfo[@"nickname"]];
    
    [username sizeToFit];
    username.frame=CGRectMake(userImg.frame.origin.x+userImg.frame.size.width/2-username.frame.size.width/2, userImg.frame.origin.y+userImg.frame.size.height+10, username.frame.size.width, username.frame.size.height);
    [username setHidden:NO];
    
}



-(void)showString:(NSString *)str       //提示框
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    hud.margin = 10.f;
    [hud sizeToFit];

    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

-(void)ShowStatueBarTextNoticeWithString:(NSString *)string     //使用状态栏进行文字提示
{

    CWStatusBarNotification *notice = [CWStatusBarNotification new];
    notice.notificationLabelBackgroundColor = [UIColor greenColor];
    notice.notificationLabelTextColor = [UIColor whiteColor];
    notice.notificationAnimationInStyle=CWNotificationAnimationStyleBottom;
    notice.notificationAnimationOutStyle=CWNotificationAnimationStyleTop;
    
    [notice displayNotificationWithMessage:string forDuration:1];

}

- (void)switchColor:(TableViewCell *)cell   //  切换夜间/日间模式
{
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNormal) {
        [DKNightVersionManager nightFalling];
        
        [loginBtn setTitleColor:RGBA(200, 200, 200, 1) forState:UIControlStateNormal];
        [registerBtn setTitleColor:RGBA(200, 200, 200, 1) forState:UIControlStateNormal];
        
        [cell.TextLabel setText:@"日间模式"];
    } else {
        [DKNightVersionManager dawnComing];
        
        [loginBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
        [registerBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
        
        [cell.TextLabel setText:@"夜间模式"];
    }
    
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


-(void)jumpToViewWithNavi:(UIViewController *)uv   //根据传入的视图进行跳转
{

    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //获取侧边栏的视图
    YRSideViewController *sideViewController=[delegate sideViewController];
    
    [sideViewController hideSideViewController:YES];
    
    JTNavigationController *fv =[delegate rootViewController];  //获取主界面
    
    FirstViewController *fv1 = fv.jt_viewControllers[0];
    
    //获取主页的tabbarController
    UITabBarController *tabbarVC = [delegate tabbarController];
    
    [tabbarVC setSelectedIndex:0];
    
    fv1.hidesBottomBarWhenPushed=YES;
    
    [fv1.navigationController pushViewController:uv animated:YES];

}


#pragma mark --- UIAlertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView==offlineData) {
        
        if (!offLineRead.isHidden) {    //如果开关出现说明不需要再离线资源了
            
        }
        
        if (buttonIndex==1) {
            
            NSLog(@"开始下载");
            
            progressView.progress=0;
            
            [progressView setHidden:NO];
            
            notification = [CWStatusBarNotification new];
            notification.notificationLabelBackgroundColor = [UIColor greenColor];
            notification.notificationLabelTextColor = [UIColor whiteColor];
            notification.notificationAnimationInStyle=CWNotificationAnimationStyleTop;
            notification.notificationAnimationOutStyle=CWNotificationAnimationStyleBottom;

            
//            NSDictionary *views = NSDictionaryOfVariableBindings(progressView);
//            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[progressView]-0-|" options:0 metrics:nil views:views]];
//            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[progressView]-0-|" options:0 metrics:nil views:views]];
            
            //此处开始离线过程
            [self downLoadData];
            
        }
        
    }

}



#pragma mark --- NSURLConnectionDataDelegate

//请求失败或错误时调用
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

    [self showString:@"网络出错"];

}

//接收到服务器反馈时调用
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

//    NSLog(@"接收到反馈response:%@",response);
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        
        NSHTTPURLResponse* hr = (NSHTTPURLResponse*)response;
        
        if (hr.statusCode == 200) {
            
            contentLength=hr.expectedContentLength;
            
        }
    }

//    NSLog(@"数据总长度contentLength:%ld",contentLength);
}

//接收到数据时调用(每接收到一批数据都会调用)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [didReceiveData appendData:data];
//    NSLog(@"didReceiveData.length:%lu",(unsigned long)didReceiveData.length);
//    progressView.progress=didReceiveData.length/contentLength;

}


//结束任务后回调
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //记得置空
    titleImageNum=0;
    otherImgNum=0;
    contentImgNum=0;
    
    //处理接受完毕的数据
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:didReceiveData options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"离线数据dict:%@",dict);
    
    NSArray *newsArr = [dict objectForKey:@"result"];//取值
    
    offlineDataArr =[NSMutableArray new];   //初始化数组
    
    
    //遍历数组
    for (NSDictionary *dic in newsArr) {
        
        NSArray *keyarr =[dic allKeys];//获取所有键
        
        NewsSourceModel *newsModel =[[NewsSourceModel alloc]init];
        
        //赋值
        for (NSString *str in keyarr) {
            //给模型赋值
            [newsModel setValue:[dic objectForKey:str] forKey:str];
            
        }
        titleImageNum+=1;    //每保存加上新闻的图片数(每个新闻都会带有标题图片)
        
        if ([newsModel.contentType integerValue]==2) {
            
            otherImgNum+=newsModel.contentPictures.count;
            
        }else if([newsModel.contentType integerValue]==1){
        
            if (newsModel.content) {    //不为空说明是图文混排式的资讯,需要进一步解析其内容中包含的图片
                
                [self resolveTheContentWithModelContent:newsModel];
                
            }
        
        }
        
//        NSLog(@"newsModel:%@",newsModel);
        
        [offlineDataArr addObject:newsModel];
        
    }
    
    //开启子线程进行费时操作,以免卡住界面
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    
        [self downloadPictures];//下载图片
        
    });
    
}

//解析图文混排式资讯里的图片地址
-(void)resolveTheContentWithModelContent:(NewsSourceModel *)newsModel
{
    
    
    NSData *htmlData = [newsModel.content dataUsingEncoding:NSUTF8StringEncoding];
    
    //处理数据
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//p"]; //分解节点
    
    for (TFHppleElement *element in elements) { //遍历数组
        
        if ([(NSString *)[element.node objectForKey:@"nodeContent"] length]>0) { //纯文本用textview接收
            
            
            
        }else{
            
            TFHppleElement *sss =(TFHppleElement *) [[element searchWithXPathQuery:@"//img"] firstObject];
            NSMutableString *img =[MainUrl mutableCopy];
            
            if ([sss objectForKey:@"src"]) {
                
                [img appendString:[sss objectForKey:@"src"]];
                
                [newsModel.pictures addObject:img];
                
                contentImgNum++;
                
            }
        }
        
    }
    
    
}



#pragma mark ----- 处理获取到的离线资源

//保存新闻的基本数据到本地数据库(只用来保存单个新闻,不包括已经下载好的图片)
-(void)saveBaseNewsDataToLocation:(NewsSourceModel *)newModel
{

    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db =app.db;
    
    if (newModel.contentPictures.count>0) { //说明是图片新闻
        
        for (int i=0; i<newModel.contentPictures.count; i++) {
            
            BOOL insertBaseData  = [db executeUpdate:@"insert into offlineNewsDataTable (title ,content ,imageSrc ,source ,publishTime ,views ,newsId ,commentNum ,contentType ,descriptions ,image ) values(?,?,?,?,?,?,?,?,?,?,?)",newModel.title,newModel.content,newModel.imageSrc,newModel.source,newModel.publishTime,[NSString stringWithFormat:@"%@",newModel.views],[NSString stringWithFormat:@"%@",newModel.newsId],newModel.commentNum,newModel.contentType,[newModel.contentPictures[i] objectForKey:@"descriptions"],[newModel.contentPictures[i] objectForKey:@"imgPath"]];
            if (insertBaseData) {
                
                NSLog(@"插入数据库成功");
                
            }
            
        }
     
    }else{  //说明是普通新闻
    
        BOOL insertBaseData  = [db executeUpdate:@"insert into offlineNewsDataTable (title ,content ,imageSrc ,source ,publishTime ,views ,newsId ,commentNum ,contentType ) values(?,?,?,?,?,?,?,?,?)",newModel.title,newModel.content,newModel.imageSrc,newModel.source,newModel.publishTime,[NSString stringWithFormat:@"%@",newModel.views],[NSString stringWithFormat:@"%@",newModel.newsId],newModel.commentNum,newModel.contentType];
        if (insertBaseData) {
            
            NSLog(@"插入数据库成功");
            
        }
    
    }
    
    titleImageNum=0;
    otherImgNum=0;

}

-(void)downloadPictures  //下载图片
{

    static int imgNum1;
    static int imgNum2;
    static int imgNum3;
    //记得置空
    imgNum1=0;
    imgNum2=0;
    imgNum3=0;
    
    titleImgFinishLoad=NO;
    otherImgFinishLoad=NO;
    contentImgFinishLoad=NO;
    
    //下载图片
    for (NewsSourceModel *model in offlineDataArr) {
        
        NSURL *imgurl =[NSURL URLWithString:[[MainUrl copy]stringByAppendingString:model.imageSrc]];
        
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:imgurl];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            if (data) {
                
                model.titleImg=[UIImage imageWithData:data];    //保存进模型
                
                imgNum1++;
                
//                NSLog(@"%f",(float)(imgNum1+imgNum2)/(titleimageNum+otherImgNum));
                
                [progressView setProgress:(float)(imgNum1+imgNum2+imgNum3)/(titleImageNum+otherImgNum+contentImgNum) animated:YES];
                
                if (imgNum1==titleImageNum) {
                    
                    NSLog(@"标题图片已经下载完毕");
                    
                    titleImgFinishLoad=YES; //标记
                    
                    if (otherImgFinishLoad&&contentImgFinishLoad) {   //所有图片下载完毕
                        
                        //开启子线程进行费时操作,以免卡住界面
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                            
                            //将所有数据进行本地持久化
                            [self hideProgressViewAndSaveNewsDataWithNewsArr:offlineDataArr];
                            
                        });
                        
                    }
                    
                }
                
            }
            
        }];
        
        if ([model.contentType integerValue]==2) {    //说明是图片新闻
            
            for (int i=0; i<model.contentPictures.count; i++) { //遍历下载图片
                
                NSURL *descriptionsImgUrl=[NSURL URLWithString:[[MainUrl copy]stringByAppendingString:[model.contentPictures[i] objectForKey:@"imgPath"]]];
                
                NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:descriptionsImgUrl];
                
                [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                    
                    if (data) {
                        
                        //重新赋值
                        NSMutableDictionary *dic =[model.contentPictures[i] mutableCopy];
                        
                        [dic removeObjectForKey:@"imgPath"];    //先移除
                        [dic setObject:data forKey:@"imgPath"]; //再重新添加
                        
                        
                        //添加到模型自带的另一个暂时无用的数组(用于中转)
                        
                        [model.pictures addObject:dic];
                        
                        imgNum2++;
//                        NSLog(@"%f",(float)(imgNum1+imgNum2)/(titleimageNum+otherImgNum));
                        [progressView setProgress:(float)(imgNum1+imgNum2+imgNum3)/(titleImageNum+otherImgNum+contentImgNum) animated:YES];
                        
                        if (imgNum2==otherImgNum) {
                            
                            NSLog(@"其他图片已经下载完毕");
                            
                            otherImgFinishLoad=YES; //标记
                            
                            if (titleImgFinishLoad&&contentImgFinishLoad) {   //所有图片下载完毕
                                
                                //开启子线程进行费时操作,以免卡住界面
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                                    
                                    //将所有数据进行本地持久化
                                    [self hideProgressViewAndSaveNewsDataWithNewsArr:offlineDataArr];
                                    
                                });
                                
                            }
                            
                        }
                        
                    }
                    
                }];
                
            }
            
        }else if ([model.contentType integerValue]==1){ //普通资讯
            
            NSMutableArray *pictureArr=[[NSMutableArray alloc]initWithArray:model.pictures copyItems:YES];
            
            [model.pictures removeAllObjects];  //清空先
        
            if (pictureArr.count>0) {   //说明是已经解析过的图文资讯
                
//                NSLog(@"pictureArr:%@",pictureArr);
                for (int i=0; i<pictureArr.count; i++) {    //开始下载图片
                    
                    NSURL *pictureUrl =[NSURL URLWithString:(NSString *)pictureArr[i]];
                    
                    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:pictureUrl];
                    
                    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                        
                        if (data) {
                            
                            NSMutableDictionary *pictureDic =[NSMutableDictionary new];
                            [pictureDic setObject:data forKey:@"image"];
                            
                            [model.pictures addObject:pictureDic];
                            
                            imgNum3++;
                            
                            [progressView setProgress:(float)(imgNum1+imgNum2+imgNum3)/(titleImageNum+otherImgNum+contentImgNum) animated:YES];
                            
                            if (imgNum3==contentImgNum) {
                                
                                NSLog(@"图文图片已经下载完毕");
                                
                                contentImgFinishLoad=YES; //标记
                                
                                if (titleImgFinishLoad&&otherImgFinishLoad) {   //所有图片下载完毕
                                    
                                    //开启子线程进行费时操作,以免卡住界面
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                                        
                                        //将所有数据进行本地持久化
                                        [self hideProgressViewAndSaveNewsDataWithNewsArr:offlineDataArr];
                                        
                                    });
                                    
                                }
                                
                            }
                            
                        }
                        
                    }];
                    
                }
                
                
            }
        
        }
        
    }

}

//隐藏进度圈,并将所有已经下载好图片数据的新闻进行本地数据持久化
-(void)hideProgressViewAndSaveNewsDataWithNewsArr:(NSMutableArray *)newsArr
{
    
    DataNum++;
    
    dispatch_async(dispatch_get_main_queue(), ^(void){  //在主线程执行
        
        [notification displayNotificationWithMessage:@"正在存储离线资源..." completion:nil];
        
    });
    
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    FMDatabase *db =app.db;
    
    //开始本地存储
    
    for (NewsSourceModel *newModel in newsArr) {   //遍历
        
        if ([newModel.contentType integerValue]==2) {   //说明是图片新闻
            
            for (int i=0; i<newModel.pictures.count; i++) {
                
                BOOL insertBaseData  = [db executeUpdate:@"insert into offlineNewsDataTable (title ,content ,imageSrc ,source ,publishTime ,views ,newsId ,commentNum ,contentType ,descriptions ,image ) values(?,?,?,?,?,?,?,?,?,?,?)",newModel.title,newModel.content,newModel.imageSrc,newModel.source,newModel.publishTime,[NSString stringWithFormat:@"%@",newModel.views],[NSString stringWithFormat:@"%@",newModel.newsId],newModel.commentNum,newModel.contentType,[newModel.pictures[i] objectForKey:@"descriptions"],[newModel.pictures[i] objectForKey:@"imgPath"]];
                
                if (insertBaseData) {
                    
//                    NSLog(@"插入图片新闻数据成功");
                    
                }
                
            }
            
        }else if([newModel.contentType integerValue]==1){   //普通资讯(包含图文混排)
            
            NSData *titleImgData;
            //图片转data存储
            if (UIImagePNGRepresentation(newModel.titleImg) == nil) {
                
                titleImgData = UIImageJPEGRepresentation(newModel.titleImg, 1);
                
            } else {
                
                titleImgData = UIImagePNGRepresentation(newModel.titleImg);
            }
            
            //对多图片的(即图文混排)资讯进行进一步处理
            if (newModel.pictures.count>0) {
                
//                NSLog(@"newModel.pictures.count:%ld",newModel.pictures.count);
                //数据写入到数据库
                for (int i=0; i<newModel.pictures.count; i++) {
                    
                    BOOL insertTxtPicData  = [db executeUpdate:@"insert into offlineNewsDataTable (title ,content ,imageSrc ,source ,publishTime ,views ,newsId ,commentNum ,contentType ,titleImg,image) values(?,?,?,?,?,?,?,?,?,?,?)",newModel.title,newModel.content,newModel.imageSrc,newModel.source,newModel.publishTime,[NSString stringWithFormat:@"%@",newModel.views],[NSString stringWithFormat:@"%@",newModel.newsId],newModel.commentNum,newModel.contentType,titleImgData,[newModel.pictures[i] objectForKey:@"image"]];
                    
                    if (insertTxtPicData) {
                        
//                        NSLog(@"插入图文数据成功");
                        
                    }
                    
                }
                
            }else{  //说明详细资讯中并没有图片,直接插入普通的
                
                
                BOOL insertBaseData  = [db executeUpdate:@"insert into offlineNewsDataTable (title ,content ,imageSrc ,source ,publishTime ,views ,newsId ,commentNum ,contentType ,titleImg) values(?,?,?,?,?,?,?,?,?,?)",newModel.title,newModel.content,newModel.imageSrc,newModel.source,newModel.publishTime,[NSString stringWithFormat:@"%@",newModel.views],[NSString stringWithFormat:@"%@",newModel.newsId],newModel.commentNum,newModel.contentType,titleImgData];
                
                if (insertBaseData) {
                    
                    //                NSLog(@"插入普通新闻数据成功");
                    
                }
            
            }
        
        }
        
    }
    
    NSLog(@"数据已全部保存完毕");
    
    dispatch_async(dispatch_get_main_queue(), ^(void){  //在主线程执行
        
        [notification dismissNotification]; //隐藏
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:offLineReadState];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.mytableView reloadData];
        
        DataNum=0;
        
    });
    
}

-(IBAction)touchToUnlockTheOfflineMode:(UISwitch *)sender  // 开启/关闭 离线阅读模式
{

    if (sender.isOn==YES) {     //开启离线阅读模式
        
        [self ShowStatueBarTextNoticeWithString:@"离线模式已开启"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:offLineReadState];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self jumpToFirstViewAndBeginRefreshing];   //跳回住页面并刷新
        
    }else{                      //关闭离线阅读模式
        
        [self ShowStatueBarTextNoticeWithString:@"离线模式已关闭"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:offLineReadState];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self jumpToFirstViewAndBeginRefreshing];   //跳回住页面并刷新
        
    }

}

-(void)jumpToFirstViewAndBeginRefreshing    //在开启或关闭离线模式时调用
{

    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //获取侧边栏的视图
    YRSideViewController *sideViewController=[delegate sideViewController];
    
    [sideViewController hideSideViewController:YES];
    
    //获取资讯页
    JTNavigationController *fv =[delegate rootViewController];
    
    FirstViewController *fv1 = fv.jt_viewControllers[0];
    
    //获取主页的tabbarController
    UITabBarController *tabbarVC = [delegate tabbarController];
    
    [tabbarVC setSelectedIndex:0];
    
    [fv1.mytableView.mj_header beginRefreshing];
    
}











@end
