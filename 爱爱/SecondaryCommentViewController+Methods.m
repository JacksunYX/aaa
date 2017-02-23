//
//  SecondaryCommentViewController+Methods.m
//  爱爱
//
//  Created by 爱爱网 on 16/2/17.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "SecondaryCommentViewController+Methods.h"

#import "Reachability.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "WZLBadgeImport.h"      //按钮小红点库

#import "CommendSourceModel.h"
#import "NewsSourceModel.h"

#import "NewLoginViewController.h"  //登录页面

#import "DetailNewsViewController.h"    //普通新闻
#import "PureImageViewController.h"     //图片新闻


@implementation SecondaryCommentViewController (Methods)

#pragma mark ----- 统一视图加载方法

-(void)loadbaseView                 //加载基本视图
{
    
    commentsArr =[NSMutableArray new];
    cellHeightArr=[NSMutableArray new];
    

    [self changeNavigationBarState];
    
    [self creatTableView];
    
    if (self.comment.createTime) {    //说明不是从"我的评论跳转过来的"
        
        [self loadcommentViewWithCommentModel:self.comment];
        
    }else{                          //从"我的评论"跳转过来的,需要请求这条评论的相关信息
    
        [self getTheMainBodyComment];   //获取主体评论
    
    }
    
    [self getNewCommentData];   //获取子评论
    
}

#pragma mark ----- 视图创建方法

-(void)changeNavigationBarState     //修改导航栏
{
    
    //修改左侧按钮
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40,40)];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"back_icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
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
    
    //导航栏颜色
    self.navigationController.navigationBar.dk_barTintColorPicker =DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
    
    self.navigationController.toolbarHidden=YES;
    
    //打开手势侧滑功能
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    self.title =@"评论详情";
    SetNavigationBarTitle(18,RGBA(50, 50, 50, 1));
    
    //关闭侧边栏侧滑
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
    
}

-(void)creatTableView               //创建表视图
{

    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-64-44) style:UITableViewStylePlain];
    
    self.mytableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    self.mytableView.dataSource=self;
    self.mytableView.delegate=self;
    [self.view addSubview:self.mytableView];
    
    self.mytableView.tableFooterView=[[UIView alloc]init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mytableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.mytableView.dk_separatorColorPicker=DKColorWithColors([UIColor grayColor], FirstNightBackgroundColor);
    self.mytableView.separatorInset=UIEdgeInsetsMake(0, 10, 0, 10);
}

-(void)loadcommentViewWithCommentModel:(CommendSourceModel *)commentModel    //根据传入数据模型加载上方评论的视图
{
    
    if (!commentBackView) {
        
        commentBackView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 0)];
        
        //头像
        UIImageView *userView =[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
        
        if (commentModel.userImg) {
            
            NSURL *userImgUrl =[NSURL URLWithString:[[MainUrl copy] stringByAppendingString:commentModel.userImg]];
            [userView sd_setImageWithURL:userImgUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                //先放大到需要的size
                UIImage *img =[self scaleToSize:image size:CGSizeMake(160, 160)];
                
                //再切圆
                UIImage *img2 =[self cutImage:img WithRadius:img.size.width/2];
                
                [userView setImage:img2];
                
            }];
            
        }
        
        
        //昵称
        UILabel *nickname =[[UILabel alloc]init];
        [nickname setFont:[UIFont systemFontOfSize:16]];
        nickname.dk_textColorPicker=DKColorWithColors(RGBA(100, 100, 100, 1), TitleTextColorNight);
        [nickname setText:commentModel.nickname];
        [nickname sizeToFit];
        nickname.frame=CGRectMake(userView.frame.origin.x+userView.frame.size.width+20, userView.frame.origin.y, nickname.frame.size.width, nickname.frame.size.height);
        
        //性别图标
        UIImageView *genderView =[[UIImageView alloc]init];
        //性别
        if (commentModel.gender.length>0) {
            
            if ([commentModel.gender isEqualToString:@"1"]) {
                
                [genderView setImage:[UIImage imageNamed:@"userGender_M"]];    //男
                
            }else{
                
                [genderView setImage:[UIImage imageNamed:@"userGender_W"]];    //女
                
            }
            
            [genderView sizeToFit];
            
            genderView.frame=CGRectMake(nickname.frame.origin.x+nickname.frame.size.width+5, nickname.frame.origin.y+nickname.frame.size.height/2-genderView.frame.size.height/2, genderView.frame.size.width, genderView.frame.size.height);
            
        }else{
            
            [genderView setImage:nil];
            
        }
        
        
        
        //评论发布时间
        UILabel *creatTime =[[UILabel alloc]init];
        [creatTime setFont:[UIFont systemFontOfSize:14]];
        creatTime.dk_textColorPicker=DKColorWithColors(RGBA(80, 80, 80, 1), UnimportantContentTextColorNight);
        [creatTime setText:commentModel.createTime];
        [creatTime sizeToFit];
        creatTime.frame=CGRectMake(nickname.frame.origin.x, nickname.frame.origin.y+nickname.frame.size.height+10, creatTime.frame.size.width, creatTime.frame.size.height);
        
        
        //发布内容
        UILabel *content =[[UILabel alloc]initWithFrame:CGRectMake(nickname.frame.origin.x, creatTime.frame.origin.y+creatTime.frame.size.height+10, Width-nickname.frame.origin.x-20, 0)];
        content.numberOfLines=0;
        [content setFont:[UIFont systemFontOfSize:18]];
        content.dk_textColorPicker=DKColorWithColors([UIColor blackColor], ContentTextColorNight);
        [content setText:commentModel.commentContent];
        [content sizeToFit];
        
        [commentBackView addSubview:userView];
        [commentBackView addSubview:nickname];
        [commentBackView addSubview:genderView];
        [commentBackView addSubview:creatTime];
        [commentBackView addSubview:content];
        
        
        
#pragma mark ----- 新闻区
        UIView *newsView =[[UIView alloc]initWithFrame:CGRectMake(content.frame.origin.x, content.frame.origin.y+content.frame.size.height+30, Width-nickname.frame.origin.x, 0)];
        
        //分割线
        UILabel *separaterLine =[[UILabel alloc]initWithFrame:CGRectMake(0, 0.2, newsView.frame.size.width-20, 0.2)];
        separaterLine.backgroundColor =RGBA(100, 100, 100, 1);
        [newsView addSubview:separaterLine];
        
        
        //新闻配图
        UIImageView *newsImg =[[UIImageView alloc]initWithFrame:CGRectMake(separaterLine.frame.origin.x, separaterLine.frame.origin.y+10, 75, 75)];
        
        if (self.newsModel.imageSrc) {
            
            NSURL *newsImgUrl =[NSURL URLWithString:[[MainUrl copy] stringByAppendingString:self.newsModel.imageSrc]];
            [newsImg sd_setImageWithURL:newsImgUrl];
            
        }
        [newsView addSubview:newsImg];
        
        
        //新闻标题
        UILabel *newsTitle =[[UILabel alloc]initWithFrame:CGRectMake(newsImg.frame.origin.x+newsImg.frame.size.width+10, newsImg.frame.origin.y, separaterLine.frame.size.width-(newsImg.frame.size.width+10*2), 0)];
        newsTitle.numberOfLines=0;
        newsTitle.dk_textColorPicker=DKColorWithColors(RGBA(80, 80, 80, 1), TitleTextColorNight);
        [newsTitle setFont:[UIFont boldSystemFontOfSize:18]];
        [newsTitle setText:self.newsModel.title];
        [newsTitle sizeToFit];
        [newsView addSubview:newsTitle];
        
        
        //新闻发布时间
        UILabel *publishTime =[[UILabel alloc]initWithFrame:CGRectMake(newsTitle.frame.origin.x, 0, newsTitle.frame.size.width, 0)];
        publishTime.dk_textColorPicker=DKColorWithColors(RGBA(80, 80, 80, 1), UnimportantContentTextColorNight);
        [publishTime setFont:[UIFont systemFontOfSize:16]];
        [publishTime setText:self.newsModel.publishTime];
        [publishTime sizeToFit];
        publishTime.frame=CGRectMake(publishTime.frame.origin.x, newsImg.frame.origin.y+newsImg.frame.size.height-publishTime.frame.size.height, publishTime.frame.size.width, publishTime.frame.size.height);
        [newsView addSubview:publishTime];
        
        newsView.frame=CGRectMake(newsView.frame.origin.x, newsView.frame.origin.y, newsView.frame.size.width, newsImg.frame.origin.y+newsImg.frame.size.height+10);
        
        //添加新闻的点击事件
        UITapGestureRecognizer *single =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToSearchNews:)];
        single.delegate =self;
        [newsView addGestureRecognizer:single];
        
        
        [commentBackView addSubview:newsView];
        
        commentBackView.frame=CGRectMake(0, 0, Width, newsView.frame.origin.y+newsView.frame.size.height);
        
        commentBackView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
        newsView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], SecondaryNightBackgroundColor);
        
    }

    
}

-(void)loadcomentView2             //加载下方评论控件
{
    
    if (!backView) {
        
        //背景板
        backView =[[UIView alloc]initWithFrame:CGRectMake(0, Height-44, Width, 44)];
        backView.dk_backgroundColorPicker=DKColorWithColors(RGBA(250, 250, 250, 1), SecondaryNightBackgroundColor);
        
        UIButton *commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, Width-20*2, 34)];
        [commentBtn.layer setCornerRadius:commentBtn.frame.size.height/2];
        [commentBtn.layer setBorderWidth:TextFieldBorderWidth];
        commentBtn.layer.borderColor=MainThemeColor.CGColor;
        
        [commentBtn addTarget:self action:@selector(touchToSuspend) forControlEvents:UIControlEventTouchUpInside];
        [commentBtn setTitle:@"我也说两句~~" forState:UIControlStateNormal];
        commentBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        
        if ([DKNightVersionManager currentThemeVersion]==DKThemeVersionNormal) {
            [commentBtn setTitleColor:RGBA(100.0f,100.0f,100.0f,1.0) forState:UIControlStateNormal];
        }else{
            [commentBtn setTitleColor:UnimportantContentTextColorNight forState:UIControlStateNormal];
        }
        
        //修改按钮上内容做对齐,并做优化处理
        commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        
        [backView addSubview:commentBtn];
        [self.view addSubview:backView];
        
    }
    
}

-(void)creatMjfooter    //添加刷新尾
{
    //添加上拉加载功能
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNewCommentData)];
    [footer setTitle:TableViewMJFooterUpLoadText forState:MJRefreshStateIdle];
    [footer setTitle:TableViewMJFooterRefreshingText forState:MJRefreshStateRefreshing];
    [footer setTitle:TableViewMJFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
    self.mytableView.mj_footer=footer;
}

-(void)addBdageNumOnBtn:(UIButton *)btn AndNum:(NSInteger)value    //根据数量改变小红点的显示数量
{
    
    [btn showBadgeWithStyle:WBadgeStyleNumber value:value animationType:WBadgeAnimTypeBreathe];
    if (value>0) {
        
        btn.aniType = WBadgeAnimTypeBreathe;    //抖动效果
        
    }else{
        
        btn.aniType = WBadgeAnimTypeNone;       //无效果
        
    }
    btn.badgeBgColor = [UIColor purpleColor];      //底色
    btn.badgeCenterOffset = CGPointMake(0, 5);    //偏移量
    btn.badgeTextColor = [UIColor whiteColor];     //字体颜色
    
}

-(CAAnimation *)creatAnimation  //创建动画
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    return k;
}

-(BOOL)isEmpty:(NSString *) str     //判断传入的字符串是否全为空格组成
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






#pragma mark ----- 交互方法

-(void)getNewCommentData    //上拉加载
{
    //判断是否有网络
    Reachability *re =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status =[re currentReachabilityStatus];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:offLineReadState]isEqualToString:@"YES"])     //离线阅读的模式下(取本地数据)
    {
        
        
        
    }else if(status==0){            //无网络
        
        
        [self showString:@"请检查网络环境~"];
        
    }else//有网络
    {
        
        //        NSLog(@"加载二级评论中...");
        [self getCommentsWithCurrentCommentId]; //获取当前子评论列表
    }
    
}

-(void)getTheMainBodyComment    //加载当前页面的评论主体
{

//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *mainCommentUrl = [[MainUrl stringByAppendingString:GetSingleCommentUrl]mutableCopy];
    
    [mainCommentUrl appendFormat:@"?commentId=%@&deviceId=%@",self.comment.commentId,deviceId];
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:mainCommentUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(data){
        
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"二级评论主体评论返回dict:%@",dict);
            
            //解析主体评论
            NSArray *keyArr =[dict allKeys];
            
            for (NSString *key in keyArr) {
                
                [self.comment setValue:[dict objectForKey:key] forKey:key];
                
            }
            
            NSLog(@"填充好的主体评论self.comment:%@",self.comment);
//            [hud hide:YES];
            //创建上方评论主体
            [self loadcommentViewWithCommentModel:self.comment];
            
            [self.mytableView reloadData];
        
        }else{
        
//            [hud hide:YES];
            
            [self.mytableView setHidden:YES];
            
            [self showString:@"评论加载超时"];
            
            [self delayTimeToExecute];      //延时退回
            
        }
        
    }];

}

-(void)getCommentsWithCurrentCommentId  //根据当前评论主体对象的commentId获取对应的评论列表
{
    
    if (!hud) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud show:YES];
        
    }

    if (self.baseDate.length<=0) {
        self.baseDate=@"";
        [commentsArr removeAllObjects];
    }
    NSMutableString *commentUrl = [[MainUrl stringByAppendingString:commentCheckUrl]mutableCopy];
    
    NSString *userId;//如果存在就附上，不存在就给个没有的值
    if (CurrentUserId) {
        userId=CurrentUserId;
    }else{
        userId=@"";
    }
    
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    if (self.baseObjectId.length==0) {
        
        [commentUrl appendFormat:@"?objectId=%@&baseDate=%@&num=%d&sortBy=%d&userId=%@&objectType=%d&deviceId=%@",self.comment.commentId,self.baseDate,5,0,userId,2,deviceId];
        
    }else{
    
        [commentUrl appendFormat:@"?objectId=%@&baseDate=%@&num=%d&sortBy=%d&userId=%@&objectType=%d&baseObjectId=%@&deviceId=%@",self.comment.commentId,self.baseDate,5,0,userId,2,self.baseObjectId,deviceId];
    
    }
    
//    NSLog(@"commentUrl:%@",commentUrl);
    
    //    NSLog(@"----构建完成----");
    NSLog(@"---开始刷新二级评论子评论列表---");
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:commentUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(data){
            NSLog(@"---开始解析子评论数据---");
            
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *result =[dic objectForKey:@"result"];
            
            if (result.count<=0) {
                
                [hud hide:YES];
                
                [self.mytableView.mj_footer endRefreshing];
                
                [(MJRefreshAutoStateFooter *)self.mytableView.mj_footer setTitle:TableViewMJFooterNoMoreDataText forState:MJRefreshStateIdle];
                
                [self loadcomentView2];     //加载下方评论控件
                
            }
            
            if ([dic objectForKey:@"baseDate"]) {
                self.baseDate=[dic objectForKey:@"baseDate"];
            }else{
                
                [hud hide:YES];
                
                [self.mytableView.mj_footer endRefreshing];
                
                [self.mytableView.mj_footer setState:MJRefreshStateNoMoreData];
                
            }
            
            if ([dic objectForKey:@"baseObjectId"]) {
                
                NSNumber *number=[dic objectForKey:@"baseObjectId"];
                
                self.baseObjectId =[NSString stringWithFormat:@"%@",number];
            }
            
            
            for (NSDictionary *dict in result) {
                
                
                NSArray *keyArr=[dict allKeys];//获取所有键
                CommendSourceModel *commentModel =[[CommendSourceModel alloc]init];
                //        遍历键数组
                for (NSString *str in keyArr) {
                    //给模型赋值
                    
                    if ([str isEqualToString:@"isUps"]) {           //是否被点赞
                        
                        commentModel.isUps = [[dict objectForKey:str] boolValue];
                        
                    }else if([str isEqualToString:@"isComment"]){   //是否评论过
                        
                        commentModel.isComment = [[dict objectForKey:str] boolValue];
                        
                    }else{
                        
                        [commentModel setValue:[dict objectForKey:str] forKey:str];
                    }
                    
                }
                
                NSString *cellHeight =[NSString stringWithFormat:@"%f",[self getTheCellHeightWithModelContent:commentModel.commentContent]];
                
                [commentModel setValue:cellHeight forKey:@"cellHeight"];
                
                [commentsArr addObject:commentModel];//添加到全局评论数组中
            }
            
            
            NSLog(@"------解析完成------");
            
            if (commentsArr.count) {
                
                if (!self.mytableView.mj_footer) {
                    
                    [self creatMjfooter];
                    
                }
                
                [self loadcomentView2];     //加载下方评论控件
                
                NSLog(@"刷新评论列表~~~");
                [self.mytableView reloadData];
                
                [self.mytableView.mj_footer endRefreshing];
                
//                NSLog(@"commentsArr:%@",commentsArr);
                
            }else{
                
                [self showString:@"暂无评论"];
                [self.mytableView.mj_footer endRefreshing];
            }
            
            [hud hide:YES];
            
        }else{
            
            [self.mytableView.mj_footer endRefreshing];
            
            [hud hide:YES];
            
            [self showString:@"评论加载超时"];
            
        }
    }];

}

-(IBAction)changeSelectState:(UIButton *)sender //点赞按钮事件
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
        
        if (!sender.isSelected) {//非赞状态下
            
            
            for (int i=0; i<commentsArr.count; i++) {     //遍历评论数组,获取当前点赞的评论的对象
                
                CommendSourceModel *comentModel =commentsArr[i];
                
                if ([comentModel.commentId integerValue]==sender.tag) {
                    
                    NSLog(@"%@",comentModel.commentId);
                    NSLog(@"%ld",(long)sender.tag);
                    
                    [comentModel setValue:@1 forKey:@"isUps"];  //修改是否点赞
                    
                    NSNumber *ups =[NSNumber numberWithInteger:[comentModel.ups integerValue]+1];
                    
                    
                    [comentModel setValue:ups forKey:@"ups"];
                    
                    [self addBdageNumOnBtn:sender AndNum:[comentModel.ups integerValue]];
                    
                }
                
            }
            
            [self sendRequestToGetDataWithDiffentCommand:2 AndcontentType:2 AndobjectId:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
            
            sender.selected=!sender.selected;
            [sender.layer addAnimation:[self creatAnimation] forKey:@"SHOW"];
        }else{
            
            [self showString:@"您已经赞过啦!"];
            
        }
        
    }else{//非登录状态下,提示登录
        
        myAlert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用啦" otherButtonTitles:@"登录", nil];
        [myAlert show];
    }
    
}


-(void)sendRequestToGetDataWithDiffentCommand:(NSInteger)command AndcontentType:(NSInteger)contentType AndobjectId:(NSString *)objectId     //根据不同指令发送点赞或收藏请求
{
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    NSMutableString *Urlstr = [[MainUrl stringByAppendingString:commandUrl]mutableCopy];
    //拼接完整url
    [Urlstr appendFormat:@"?objectId=%@&userId=%@&command=%ld&contentType=%lD&deviceId=%@",objectId,CurrentUserId,(long)command,(long)contentType,deviceId];
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:Urlstr]cachePolicy:0 timeoutInterval:5.f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"resultCode:%@",[dict objectForKey:@"resultCode"]);
            
        }else{
            
            [self showString:@"请求超时"];
            
        }
        
    }];
}

-(void)issueComentWithString:(NSString *)string AnduserId:(NSString *)userId AndcommentId:(NSString *)commentId       //通过当前登录的用户userId和评论的commentId进行评论
{
    
    //    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.mode = MBProgressHUDModeIndeterminate;
    //    [hud show:YES];
    NSString *deviceId = [self getDeviceId]; //获取设备标识
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain",@"text/html", nil];
    manager.securityPolicy.allowInvalidCertificates = YES;
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    string = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef) string,NULL,(CFStringRef) @"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8)); //对内容进行编码
    
    NSDictionary *params = @{
                             
                             @"newsId":self.newsModel.newsId,
                             @"userId":userId,
                             @"commentContent":string,
                             @"commentId":commentId,
                             @"deviceId":deviceId
                             
                             };
    
    
    [manager POST:[MainUrl stringByAppendingString:issuecomentUrl] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        //        NSLog(@"responseObject:%@",responseObject);
        
        if (!responseObject) {
            
            //            [hud hide:YES];
            [self showString:@"服务器出错"];
            return ;
            
        }
        
        NSArray *keyArr=[responseObject allKeys];//获取所有键
        CommendSourceModel *commentModel =[[CommendSourceModel alloc]init];
        //        遍历键数组
        for (NSString *str in keyArr) {
            
            //给模型赋值
            if ([str isEqualToString:@"isUps"]) {
                
                commentModel.isUps = [[responseObject objectForKey:str] boolValue];
                
            }else{
                
                [commentModel setValue:[responseObject objectForKey:str] forKey:str];
            }
            
        }
        
        NSString *cellHeight =[NSString stringWithFormat:@"%f",[self getTheCellHeightWithModelContent:commentModel.commentContent]];
        
        [commentModel setValue:cellHeight forKey:@"cellHeight"];
        
        [hud hide:YES];
        
        commentModel.childNum=@"0";
        
        [commentsArr insertObject:commentModel atIndex:0];
        
        //        [cellHeightArr removeAllObjects];
        
        [self.mytableView reloadData];
        
        [self showString:@"评论成功"];
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"error:%@",error);
        
        //        [hud hide:YES];
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

-(void)touchToPop           //返回上一页
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchToPoprootView   //返回主页
{
    
    

    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)showString:(NSString *)str   //提示框
{
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    hud2.mode = MBProgressHUDModeText;
    hud2.labelText = str;
    hud.margin = 10.f;
//    hud2.cornerRadius = 10;
    hud2.removeFromSuperViewOnHide = YES;
    [hud2 sizeToFit];
    [hud2 hide:YES afterDelay:1];
}

-(NSMutableString *)getTheCurrentDate   //取得当前时间字符串数据
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *date=[nsdf2 stringFromDate:[NSDate date]];//取得当前时间的字符串
    
    NSMutableString *str =[date mutableCopy];//copy为可变的
    
    //对时间字符串进行加工
    [str deleteCharactersInRange:NSMakeRange(16, 1)];
    [str deleteCharactersInRange:NSMakeRange(13, 1)];
    [str deleteCharactersInRange:NSMakeRange(10, 1)];
    [str deleteCharactersInRange:NSMakeRange(7, 1)];
    [str deleteCharactersInRange:NSMakeRange(4, 1)];
    //    NSLog(@"%@  %lu",str,str.length);
    return str;
}

-(void)touchToSuspend   //发表评论的跳转页面(使用第三方库YIPopupTextView)
{
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
        myAlert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有登录哟~" delegate:self cancelButtonTitle:@"不用啦" otherButtonTitles:@"登录", nil];
        [myAlert show];
        
    }else{
        
        popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"写点什么呗..." maxCount:150 buttonStyle:YIPopupTextViewButtonStyleLeftCancelRightDone doneButtonColor:[UIColor colorWithRed:230.0f/255.0f green:23.0f/255.0f blue:115.0f/255.0f alpha:1.0]];
        
        popupTextView.delegate = self;//代理
        popupTextView.caretShiftGestureEnabled = YES;   // default = NO
        popupTextView.outerBackgroundColor=[UIColor clearColor];//弹出输入框后的背景色
        popupTextView.layer.borderColor=[[UIColor colorWithRed:230.0f/255.0f green:23.0f/255.0f blue:115.0f/255.0f alpha:1.0]CGColor];//边框线颜色
        popupTextView.layer.borderWidth=0.5;//边框线粗细
        popupTextView.topUIBarMargin=self.view.frame.size.height/2.5;//上间距
        popupTextView.bottomUIBarMargin=self.view.frame.size.height/2.5;//下间距
        popupTextView.keyboardType=UIKeyboardTypeDefault;
        [popupTextView showInView:self.view];//显示
        
    }
}

-(CGFloat)getTheCellHeightWithModelContent:(NSString *)content      //根据传入的内容事先计算出cell的高度并保存
{
    
    CGFloat cellHeight = 56;    //基础高度
    
    //评论内容
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Width-40-45-20*2, 0)];
    
    contentLabel.text = content;
    
    //设置label的最大行数
    if (Width==414&&Height==736) {
        contentLabel.font =[UIFont systemFontOfSize:16];
    }else{
        contentLabel.font =[UIFont systemFontOfSize:14];
    }
    
    contentLabel.numberOfLines =0;
    
    //
    contentLabel.frame = CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, Width-40-45-20*2, 0);
    
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行距
    [paragraphStyle setLineSpacing:5];
    //需要添加行距的范围(添加范围为整个文本长度)
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentLabel.text length])];
    
    [contentLabel setAttributedText:attributedString];
    [contentLabel sizeToFit];      //自适应高度
    
    cellHeight=20+cellHeight+contentLabel.frame.size.height+10;
    
//    NSLog(@"计算后得到的cellHeight:%f",cellHeight);
    
    return cellHeight;
}


//新闻图片的点击事件
-(void)touchToSearchNews:(UITapGestureRecognizer *)tapGesture
{
    
    switch ([self.newsModel.contentType integerValue]) {
        case 1:
        {
            
            NSLog(@"跳转到普通新闻");
            
            DetailNewsViewController *dv=[[DetailNewsViewController alloc]init];
            dv.newsModel=self.newsModel;
            [self.navigationController pushViewController:dv animated:YES];
            
        }
            break;
        case 2:
        {
            
            NSLog(@"跳转到图片新闻");
            PureImageViewController *pv =[[PureImageViewController alloc]init];
            pv.newsModel=self.newsModel;
            [self.navigationController pushViewController:pv animated:YES];
            
        }
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



#pragma mark ----- YIPopupTextViewdelegate
- (void)popupTextView:(YIPopupTextView*)textView didDismissWithText:(NSString*)text cancelled:(BOOL)cancelled   //YIPopupTextViewDelegate代理方法
{
    if (cancelled) {
        NSLog(@"取消");
        
    }else{
        
        if ([text isEqual:@""]||[self isEmpty:text]) {
            
            [self showString:@"评论内容不能为空哟~"];
            
        }else{
        
            [self issueComentWithString:text AnduserId:CurrentUserId AndcommentId:[NSString stringWithFormat:@"%@", self.comment.commentId]];
        
        }
        
        
    }
}

#pragma mark ----- UIAlertViewdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1) {
        
        NewLoginViewController *lv =[[NewLoginViewController alloc]init];
        
        [self.navigationController pushViewController:lv animated:YES];
        
    }
    
}

//图片重绘切圆
- (UIImage*)cutImage:(UIImage *)orImage WithRadius:(int)radius
{
    UIGraphicsBeginImageContext(orImage.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.f;
    float y1 = 0.f;
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
    
    CGContextTranslateCTM(gc, 0.f, orImage.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0.f, 0.f, orImage.size.width, orImage.size.height), orImage.CGImage);
    
    
    
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


@end
