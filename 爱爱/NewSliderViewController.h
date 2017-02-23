//
//  NewSliderViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/29.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///侧边栏展示

#define CellHeight 66



#import <UIKit/UIKit.h>


#import "UserSourceModel.h"                 //用户模型类

#import "NewLoginViewController.h"          //新的登录界面
#import "NormalRegisterViewController.h"    //新的注册界面
#import "FirstViewController.h"             //新主页
#import "FirstViewTabBarVC.h"
#import "UserDataViewController.h"          //用户信息设置界面

#import "TableViewCell.h"                   //自定义单元格cell类

#import "UserCollectsViewController.h"      //我的收藏页面
#import "MyMessageViewController.h"         //我的消息页面
#import "BrowsingHistoryViewController.h"   //浏览历史页面

#import "NewSettingViewController.h"        //新的设置界面


#import "UIImageView+WebCache.h"
#import "UCZProgressView.h" //进度圈库




@interface NewSliderViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>

{
    UIAlertView *myAlert;//提示框
    UIAlertView *offlineData;   //离线提示框
    
    UCZProgressView *progressView;
    
    UISwitch    *offLineRead;   //是否为离线阅读状态
    UILabel     *username;
    UIImageView *userImg;
    
    UIButton    *loginBtn;
    UIButton    *registerBtn;
    
    NSTimer     *myTimer;   //定时器(用于模拟下载需要离线的文件)
    
    NSMutableData      *didReceiveData;   //用于保存离线阅读时已经接受到的后台数据
    NSUInteger  contentLength;  //用于保存离线资源反馈的总的长度
    
    BOOL haveOfflineData;   //是否已经离线完毕
    
    NSMutableArray *offlineDataArr; //用于保存离线新闻的数组
    
    BOOL titleImgFinishLoad;    //标题图片加载完毕
    BOOL otherImgFinishLoad;    //其他图片加载完毕
    BOOL contentImgFinishLoad;  //图文混排图片加载完毕
    
    BOOL offlineDataFinished;   //离线资源已存储完毕
    NSInteger DataNum;          //计算保存的数据(假设)
    
    CWStatusBarNotification *notification;  //状态栏提示
    
}
@property (strong, readwrite, nonatomic) UITableView *mytableView;





@end
