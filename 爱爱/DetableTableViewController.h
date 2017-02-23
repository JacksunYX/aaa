//
//  DetableTableViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/11.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///详细资讯页面(网页资讯)



#pragma mark-----------------------------------
//统一接口宏




#pragma mark-----------------------------------


#define HeightOfSection 74
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>


#import "Reachability.h"
#import "MJRefresh.h"
#import "YIPopupTextView.h"//弹出框库

#import "NewsSourceModel.h"
#import "CommendSourceModel.h"
#import "CommentTableViewCell.h"//自定义评论区cell

@interface DetableTableViewController : UIViewController<UIGestureRecognizerDelegate,UITextViewDelegate,UIAlertViewDelegate,YIPopupTextViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    BOOL  ToUpdataComend;//是否加载评论的开关
    NSMutableArray *tableData;//保存评论的数组
    YIPopupTextView* popupTextView;
    UIAlertView *myAlert;//提示框
}

@property (nonatomic ,strong) NSString *myUrl;  //用于接收传过来的url字符串
@property (nonatomic ,strong) UIImageView *logImage;//log图片
@property (nonatomic ,strong) MBProgressHUD *hud;   //等待指示器
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic,strong) NSString *baseDate;//时间基点(如果按时间排序返回时间基点)
@property (nonatomic,assign) NSInteger baseUps;//点赞数基点
@property (nonatomic,strong) NewsSourceModel *newsModel;
@property (nonatomic,strong) UITableView *mytableView;
@end
