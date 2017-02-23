//
//  DetailNewsViewController.h
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/10.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.

///详细资讯页面(普通资讯)



#pragma mark-----------------------------------




#import "AppDelegate.h"
#import <UIKit/UIKit.h>


#import "NewsSourceModel.h"



#import <ShareSDK/ShareSDK.h>


#import "AFNetworking.h"
#import "YIPopupTextView.h"     //弹出框库
#import "UIImageView+WebCache.h"//图片处理库
#import "NewsBackView.h"        //用于新闻展示的自定义view


@interface DetailNewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UIAlertViewDelegate,YIPopupTextViewDelegate>
{
    NSMutableArray *tableNews;          //新闻区数据存放数组
    NSMutableArray *tableHotComment;    //热评区数据存放数组
    NSMutableArray *tableData;          //一般评论区数据存放数组
    BOOL  ToUpdataComend;               //加载评论开关
    UIImageView *logImage;              //log图片
    
    UIAlertView *myAlert;               //提示框
    YIPopupTextView* popupTextView;     //评论框
    
    NSInteger offset;                   //记录新闻区高度,作为直接看评论时的偏移量
    
    BOOL creatOrNot;                    //是否已创建过下方的评论栏
    
    
    //(以下三个已弃用)
    UIButton *rightbtn1;                //收藏按钮
    UIButton *rightbtn2;                //分享按钮
    UIButton *suspendBtn;               //悬浮评论按钮
    
    NewsBackView   *backView;           //保存新闻界面
    
}

@property (nonatomic,retain) UITableView *tableView;
//@property (nonatomic,strong) UITextView *textView;  //评论输入框

@property (nonatomic,strong) NewsSourceModel *newsModel;    //新闻载体模型
@property (nonatomic,strong) NSString *baseDate;            //时间基点(如果按时间排序返回时间基点)
@property (nonatomic,strong) NSString *baseObjectId;        //评论的基点Id(只用于后台去重)

@property (nonatomic,assign) NSInteger baseUps;             //点赞数基点

@property (nonatomic) BOOL news;    //方位标记


@end
