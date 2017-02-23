//
//  MyMessageViewController+Methods.m
//  爱爱
//
//  Created by 爱爱网 on 16/1/18.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//


#define TextNightColor [UIColor colorWithRed:218.0f/255.0f green:218.0f/255.0f blue:218.0f/255.0f alpha:1.0f]

#define tableF self.tableView.mj_footer//刷新尾


#import "MyMessageViewController+Methods.h"

#import "CommendSourceModel.h"

@implementation MyMessageViewController (Methods)




#pragma  mrak ---视图创建及请求发送的统一方法

-(void)creatViewAndsendRequest      //视图创建及请求发送的统一方法
{
    
    MessageArr =[NSMutableArray new];
    
    if (MessageArr.count==0)//创建log
    {
        logImage =[[UIImageView alloc]initWithFrame:CGRectMake(Width*0.4, Height*0.3, 69, 24)];
        [logImage setImage:[UIImage imageNamed:@"log_small.png"]];
        [self.view addSubview:logImage];
    }
    
    [self creatNavigationView];
    
    [self creatTableView];//创建视图
    
    [self sendRequestToGetCommentList]; //获取评论列表
    
}


#pragma mark ---视图加载



-(void)creatNavigationView//添加导航栏按钮相关
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
    self.title=@"我的评论";
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
    
    self.view.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    //打开手势侧滑功能
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    // 关闭侧边栏效果
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableRESideMenu" object:self userInfo:nil];
}

-(void)creatTableView//创建表视图
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    self.tableView.separatorInset=UIEdgeInsetsMake(0, 20, 0, 20);
}

-(void)addMjfooter  //添加上拉加载
{
    
    if (tableF) {
        
        return;
        
    }else{
        
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(sendRequestToGetCommentList)];
        [footer setTitle:TableViewMJFooterUpLoadText forState:MJRefreshStateIdle];
        [footer setTitle:TableViewMJFooterRefreshingText forState:MJRefreshStateRefreshing];
        [footer setTitle:TableViewMJFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
        tableF=footer;
        
    }
    
}


#pragma mark---请求方法

-(void)sendRequestToGetCommentList  //获取用户评论的评论
{
    
    if (MessageArr.count<=0) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeIndeterminate;
        
    }
    
    NSMutableString *Urlstr = [[MainUrl stringByAppendingString:UserCommentUrl]mutableCopy];
    
    if (baseDate.length>0) {
        
        [Urlstr appendFormat:@"?baseDate=%@&num=%d&userId=%@",baseDate,5,CurrentUserId];
        
    }else{
    
        [Urlstr appendFormat:@"?baseDate=%@&num=%d&userId=%@",[self getTheCurrentDate],5,CurrentUserId];
    
    }
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:Urlstr] cachePolicy:0 timeoutInterval:25.0];
    
    NSLog(@"获取评论中...");
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(data){
            
            NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            NSLog(@"我的评论dict:%@",dict);
            
            if ([dict objectForKey:@"baseDate"]) {
                
                baseDate = [dict objectForKey:@"baseDate"];
                
            }else{
                
                [hud hide:YES];
                
                if (!MessageArr.count) {    //只有在第一次获取数据超时时会跳转到侧边栏
                    
                    [self showString:@"没有评论啦~"];
                    
                    [self delayTimeToExecute];  //延时跳转到侧边栏
                    
                }else{
                
                    [tableF endRefreshing];
                    
                    [tableF setState:MJRefreshStateNoMoreData];
                
                }
                
                return ;
            }
            
            NSArray *newsArr =[dict objectForKey:@"result"];
            
            for (NSDictionary *dict in newsArr) {
                
                
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
                
//                NSLog(@"commentModel.parentComment:%@",commentModel.parentComment);
                
                if ([commentModel.contentAbstruct allKeys].count>0) {
                    
                    //给模型的属性(是一个新闻模型)赋值
                    for (NSString *key in commentModel.contentAbstruct) {
                        
                        [commentModel.newsModel setValue:[commentModel.contentAbstruct objectForKey:key] forKey:key];
                        
                    }
                    
                }
                
//                NSLog(@"commentModel.newsModel:%@",commentModel.newsModel);
                //计算高度并保存
                NSString *cellHeight =[NSString stringWithFormat:@"%f",[self getTheCellHeightWithModelContent:commentModel.commentContent AndCreatTime:commentModel.createTime AndParentComment:commentModel.parentComment]];
                
                [commentModel setValue:cellHeight forKey:@"cellHeight"];
                
                [MessageArr addObject:commentModel];    //添加到全局评论数组中
            }
            
            [hud hide:YES];
            
            NSLog(@"------解析完成------");
            
            if (MessageArr.count) {
                
                NSLog(@"刷新评论列表~~~");
                [self.tableView reloadData];
                
                [self addMjfooter];
                
                [tableF endRefreshing];
                
            }else{
                
                [self showString:@"您还没有评论过任何东西哟~"];
                
                if (!MessageArr.count) {    //只有在第一次获取数据超时时会跳转到侧边栏
                    
                    [self delayTimeToExecute];  //延时跳转到侧边栏
                    
                }
                
            }
            
        }else{
            
            [hud hide:YES];
            [self showString:@"请求超时"];
            
            if (!MessageArr.count) {    //只有在第一次获取数据超时时会跳转到侧边栏
                
                [self delayTimeToExecute];  //延时跳转到侧边栏
                
            }
            
        }
    }];


}





#pragma mark ---辅助方法

-(void)touchToPop       //返回上一页
{
    
    [self.navigationController popViewControllerAnimated:YES];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //获取侧边栏的视图
    YRSideViewController *sideViewController=[delegate sideViewController];
    
    [sideViewController  showLeftViewController:YES];
}


-(void)showString:(NSString *)str//提示框
{
    MBProgressHUD *huds = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    huds.mode = MBProgressHUDModeText;
    huds.labelText = str;
    huds.margin = 10.f;
    //    hud.cornerRadius=20;
    huds.removeFromSuperViewOnHide = YES;
    
    [huds hide:YES afterDelay:2];
}


-(NSMutableString *)getTheCurrentDate       //取得当前时间字符串数据
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
    
    return str;
}


-(void)delayTimeToExecute   //延时执行
{
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self touchToPop];
        
    });
    
}


-(CGFloat)getTheCellHeightWithModelContent:(NSString *)content AndCreatTime:(NSString *)createTime  AndParentComment:(NSDictionary *)dict   //根据传入的内容事先计算出cell的高度并保存
{
    
    CGFloat cellHeight = 50;    //基础高度
    
    //发布时间
    UILabel *createTimeLabel = [[UILabel alloc]init];
    [createTimeLabel setText:createTime];
    [createTimeLabel setFont:[UIFont systemFontOfSize:12]];
    [createTimeLabel sizeToFit];
    createTimeLabel.frame = CGRectMake(0, 10, createTimeLabel.frame.size.width, createTimeLabel.frame.size.height);
    
    //评论内容
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, createTimeLabel.frame.origin.y+createTimeLabel.frame.size.height+10, Width-25*2, 0)];
    contentLabel.numberOfLines =0;
    [contentLabel setFont:[UIFont systemFontOfSize:16]];
    
    NSString *commentContent = content;
    
    if ([dict allKeys].count>0) {   //说明有父类评论
        
        commentContent = [commentContent stringByAppendingString:[NSString stringWithFormat:@" || @ %@ : %@",[dict objectForKey:@"nickname"],[dict objectForKey:@"commentContent"]]];
        
    }
    
    contentLabel.text = commentContent;
    
    //设置label的最大行数
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行距
    [paragraphStyle setLineSpacing:5];
    //需要添加行距的范围(添加范围为整个文本长度)
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentLabel.text length])];
    
    [contentLabel setAttributedText:attributedString];
    [contentLabel sizeToFit];      //自适应高度
    
    cellHeight=contentLabel.frame.origin.y+contentLabel.frame.size.height+10+cellHeight+10;
    
//    NSLog(@"计算后得到的cellHeight:%f",cellHeight);
    
    return cellHeight;
}








@end
