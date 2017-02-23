//
//  MineDataVC+Methods.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/1.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

//头像默认图标名
#define DefaultHeadPortraits @"DefaultHeadPortraits_icon"


#import "MineDataVC+Methods.h"

#import "UserSourceModel.h" //用户信息模型

#import "UIImageView+CornerRadius.h"




#import "ParallaxHeaderView.h"  //表头动态模糊库

#import "UIImageView+ProgressView.h"    //带进度圈的图片处理库


@implementation MineDataVC (Methods)

#pragma mark ----- 统一视图加载方法

-(void)loadBaseView //加载基本视图
{
    
    [self creatTableView];  //创建表视图
    
    [self changeUserDataShow];  //加载用户信息
    
}

#pragma mark ----- 视图加载方法

-(void)creatTableView       //创建用于展示"个人中心"列表的表视图
{

    UITableView *table =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-self.tabBarController.tabBar.frame.size.height)];
    self.mytableView=table;
    [self.view addSubview:self.mytableView];
    self.mytableView.dataSource=self;
    self.mytableView.delegate=self;
    self.mytableView.tableFooterView=[[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mytableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.mytableView.dk_backgroundColorPicker=DKColorWithColors([UIColor whiteColor], FirstNightBackgroundColor);
    
    
    ParallaxHeaderView *headerView =[ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"Userbackground.png"] forSize:CGSizeMake(Width, Width/2)];
    
    [self.mytableView setTableHeaderView:headerView];
    
    CGFloat imgvWidth = 75;
    userView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgvWidth, imgvWidth)];
    [headerView addSubview:userView];
    userView.userInteractionEnabled=YES;
    userView.backgroundColor = [UIColor whiteColor];
    userView.layer.cornerRadius = userView.frame.size.width/2;
    userView.layer.borderColor = [UIColor whiteColor].CGColor;
    userView.layer.borderWidth = 1;
    
    
    //布局
    userView.sd_layout
    .centerXEqualToView(headerView)
    .centerYEqualToView(headerView)
    ;

    //添加点击事件
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToJumpToDesignatedVC:)];
    singleTap.delegate=self;
    [userView addGestureRecognizer:singleTap];
    
}


-(void)changeUserDataShow   //修改用户头像显示
{

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
            
            //图片重绘切角处理
            UIImage *img =[self scaleToSize:userModel.userImg size:CGSizeMake(160, 160)];
            
            UIImage *im =[self cutImage:img WithRadius:img.size.width/2];
            
            [userView setImage:im];
            
        }
        
    }else{
    
        [userView setImage:[UIImage imageNamed:DefaultHeadPortraits]];
    
    }

}






#pragma mark ----- 辅助方法

/////通知部分
- (void)tongzhi:(NSNotification *)text  //成功接到登录通知后的回调方法
{

    NSLog(@"userImg:%@",text.userInfo[@"userImg"]);
    NSLog(@"nickname:%@",text.userInfo[@"nickname"]);
    
    if (!text.userInfo[@"userImg"]) {
        
        return;
        
    }
    
    NSString *imgurl =[MainUrl stringByAppendingString:text.userInfo[@"userImg"]];
    
    NSLog(@"imgurl:%@",imgurl);
    
    [userView sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:DefaultHeadPortraits] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UIImage *img =[self scaleToSize:image size:CGSizeMake(160, 160)];
        
        UIImage *im =[self cutImage:img WithRadius:img.size.width/2];
        
        [userView setImage:im];
        
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
            BOOL b = [db executeUpdate:@"update UserTable set userImg = ? where userId = ?",data,CurrentUserId];
            
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
    
    
}

-(void)logoutTongzhi:(NSNotification *)text  //成功接到注销通知后的回调方法
{
    
    [userView setImage:[UIImage imageNamed:DefaultHeadPortraits]];
    
}

-(void)UpdataUserImgTongZhi:(NSNotification *)text //成功接到更换图片的通知后的回调方法
{
    
    NSData *imgdata = text.userInfo[@"userImagedata"];
    UIImage *img =[UIImage imageWithData:imgdata];
    [userView setImage:img];
    
}
/////





//用户头像点击事件
-(void)touchToJumpToDesignatedVC:(UITapGestureRecognizer *)tapView
{
    self.hidesBottomBarWhenPushed=YES;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginRoNot"]isEqualToString:@"YES"]) {
        
        //如果用户登录了，点击跳转到用户信息设置界面
//        UserDataViewController *userVC =[UserDataViewController new];
//        
//        [self.navigationController pushViewController:userVC animated:YES];
        
    }else{  //用户没有登录,点击进入登录界面
        
        QuickLoginVC *loginVC =[QuickLoginVC new];
        
//        [self.navigationController pushViewController:loginVC animated:YES];
        
        loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;    // 设置动画效果
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }

    self.hidesBottomBarWhenPushed=NO;
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



#pragma mark ----- UISCrollViewDelegate
///必须要加上这个代理的方法才能显示动态模糊化的效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mytableView)
    {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)self.mytableView.tableHeaderView layoutHeaderViewForScrollViewOffset:self.mytableView.contentOffset];
    }
}




@end
