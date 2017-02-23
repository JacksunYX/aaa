//
//  DetailNewsViewController+Method.h
//  爱爱
//
//  Created by 爱爱网 on 15/12/21.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.
//

#import "DetailNewsViewController.h"

#import "WyzAlbumViewController.h"  //多图展示库

@interface DetailNewsViewController (Method)

#pragma mark --- 创建视图及发送请求统一方法

-(void)creatViewandSendRequest;//创建视图及发送请求统一方法

-(void)addTapGesturesOnBackView; //给新闻上的图片视图添加点击事件



#pragma  mark----交互类方法
-(void)sendRequestToGetData;//下拉刷新请求

-(void)UrlComment ;         //请求评论的网络数据

-(void)UrlNews;             //请求对应新闻的网络数据

-(void)issueComentWithString:(NSString *)string WithuserId:(NSString *)userId;//发表评论

//-(void)Urlsqlite:(NSInteger)index ;//请求数据库数据

-(void)touchToSearch;   //点击查看用户信息

-(void)touchToSend;     //转发按钮点击事件

-(IBAction)changeSelectState:(UIButton *)sender;    //点赞按钮事件


-(void)touchToShareWithWeibo;   //分享到微博

-(void)touchToShareWithQQZone;  //分享到qq空间

-(void)touchToShareWithFriend;  //分享到朋友圈

#pragma mark---视图加载方法

-(void)loadLogImage;//加载log图片

-(void)initTableView;//加载表视图

-(void)addNavigationRightBtn;//添加导航栏右边的按钮

-(void)addBtn;//添加一个悬浮点击按钮

-(void)changeNavigationBarState;//修改导航栏

-(void)creatToolbarWithCommentNum:(NSInteger)commentNum; //新的下方评论控件


#pragma mark ----- 辅助方法
-(void)addBdageNumOnBtn:(UIButton *)btn AndNum:(NSInteger)value;    //根据数量改变小红点的显示数量


#pragma  mark ----- 图片处理方法

//图片重绘切圆
- (UIImage*)cutImage:(UIImage *)orImage WithRadius:(int)radius;

//重绘至期望大小(方法3)
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;


#pragma mark ---暂未使用的方法
-(void)changeImageformatWithImage:(UIImage *)image;//转化图片为NSData

-(void)saveImageDataIntoSql:(NSData *)data;//保存图片流

-(UIImage *)loadLocationImageData;//加载本地保存的图片

-(NSMutableString *)getTheCurrentDate;//取得当前时间字符串数据

@end
