//
//  UserCollectsViewController+Methods.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/8.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "UserCollectsViewController.h"





@interface UserCollectsViewController (Methods)

#pragma  mrak ---视图创建及请求发送的统一方法

-(void)creatViewAndsendRequest;//视图创建及请求发送的统一方法



#pragma mark ---视图加载
-(void)creatNavigationView;//添加导航栏按钮相关
-(void)creatTableView;//创建表视图



#pragma mark---请求方法
-(void)sendRequestToGetCollectList;//获取用户收藏列表

-(void)deleteSingleCollectWithNewId:(NSNumber *)newsId;  //滑动删除单个新闻

#pragma mark ---辅助方法

-(void)showString:(NSString *)str;//提示框










@end
