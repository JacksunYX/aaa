//
//  FirstViewController+Methods.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/19.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "FirstViewController.h"
#import "MyTableView.h"     //自定义tableview




@interface FirstViewController (Methods)

#pragma mark --- 统一加载方法

-(void)loadMainView; //加载主界面



#pragma mark --- 视图创建方法

-(void)creatTableView;//创建表视图

-(void)updataTheNavigation;//修改导航栏显示

-(void)loadScrollViewWithArr:(NSArray *)arr;//加载滚动视图

//根据不同的新闻类型选择不同的载体来承载新闻(其他区(除图片资讯外))
-(void)chooseContainerWithNewsId:(NSInteger)newsId;



#pragma  mark --- 请求方法

-(void)upData;//下拉刷新








#pragma mark --- 辅助方法

-(void)jumpToDetailViewWithNewsId:(NSInteger)newsId; //根据传过来的新闻id进行界面跳转

-(void)jumpToPureImagesViewWithNewsId:(NSInteger)newsId;     //根据传过来的新闻id跳转到图片新闻


-(void)addMjfooter; //添加上拉加载

-(void)closeTheTimer;   //关闭定时器

-(void)openTheTimer;    //打开定时器





@end
