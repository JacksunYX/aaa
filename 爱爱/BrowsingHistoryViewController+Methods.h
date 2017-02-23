//
//  BrowsingHistoryViewController+Methods.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/3.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "BrowsingHistoryViewController.h"

#import "NewsSourceModel.h" //模型
#import "NewsWebVC.h"


@interface BrowsingHistoryViewController (Methods)


#pragma  mrak ---视图创建及请求发送的统一方法
-(void)creatView;                               //视图创建

-(void)getDataFromLocation;                     //从本地读取历史纪录表


#pragma mark ---视图加载

-(void)creatNavigationView;                     //添加导航栏按钮相关

-(void)creatTableView;                          //创建表视图

#pragma mark ----- 辅助方法

-(void)showString:(NSString *)str;   //提示框

-(NSMutableString *)getTheCurrentDate;          //取得当前时间字符串数据

-(NSMutableString *)getTheYesterDate;        //取得前一天的时间字符串数据

@end
