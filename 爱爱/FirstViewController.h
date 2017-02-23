//
//  FirstViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/19.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///首页新闻资讯展示


@class JFDrawTextView;
#import <UIKit/UIKit.h>

#import "DetailNewsViewController.h"    //普通新闻详情页面
#import "PureImageViewController.h"     //纯图片新闻载体
#import "VideoNewVC.h"                  //视频新闻载体

#import "NewsSourceModel.h"             //新闻模型(用于普通区和推荐区)

#import "RESideMenu.h"

#import "AMPopTip.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

///ImageView旋转状态枚举
typedef enum {
    RotateStateStop,
    RotateStateRunning,
}RotateState;


@interface FirstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RESideMenuDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>

{
    
    NSMutableArray *otherNews2;                             //推荐区新闻数组
    NSMutableArray *otherNews;                              //普通区新闻数组
    
    NSMutableArray *processArr;                             //普通区处理好后的数组
    NSMutableArray *recommendNews;                          //推荐区处理好后的数组
    
    NSMutableArray *normalnewsArr;                          //用于暂时保存普通新闻
    
    NSMutableArray *recomendNewsListArr;                    //推荐区索引数组
    NSMutableArray *normalNewsListArr;                      //普通区索引数组
    
    MBProgressHUD *hud;                                     //指示器
    
    BOOL downPull;                                          //是否是下拉刷新
    
    UIImageView *logImage;                                  //log图片
    
    NSTimer *autoScrollTimer;                               //自动滚动推荐区的定时器
    
    UIButton *rightButton;                                  //导航栏右按钮
    
    
    CGFloat imageviewAngle;         //旋转角度
    UIImageView *StaticrightBtnImageView; //不旋转的ImageView
    UIImageView *DynamicrightBtnImageView; //旋转ImageView
    RotateState rotateState;        //旋转状态
    
    NSInteger   refreshNewsNum;     //下拉刷新的新闻数量
    
    BOOL recommendNewsRefreshFinished;  //推荐区新闻是否加载完成
    BOOL otherNewsRefreshFinished;      //其他区新闻是否加载完成
    
    AMPopTip *ResidePopTip;     //侧边栏提示
    AMPopTip *LogoPopTip;       //log提示
    AMPopTip *RefreshPopTip;    //刷新按钮提示
    
}

@property (nonatomic,strong) UITableView    *mytableView;       //表视图

@property (nonatomic,strong) NSString       *myDatebase;        //时间基点

@property (nonatomic,strong) NSString       *baseObjectId;      //基点ID

@property (nonatomic,strong) UIScrollView   *myscrollView;      //滚动视图

@property (nonatomic,strong) UIPageControl  *mypageControl;     

@property (nonatomic,strong) UIView         *myRecommendView;   //推荐新闻背景

@property (nonatomic,strong) JFDrawTextView *drawTextView;      //新的刷新头



@end
