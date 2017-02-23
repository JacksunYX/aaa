//
//  DetableTableViewController+Methods.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/12.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "DetableTableViewController.h"

@interface DetableTableViewController (Methods)<UIWebViewDelegate>
#pragma mark---视图创建方法
-(void)loadWebViewWithUrl:(NSURL *)url;//加载webView
-(void)loadLogImage;//加载log图片
-(void)loadHud;//加载hud指示器
-(void)addBtn;//添加一个悬浮点击按钮
-(void)addNavigationRightBtn;//添加导航栏右边的按钮
-(void)updataTheView;//修改显示模式效果
-(void)loadmyTableView;//加载tableView
-(void)addTableMJFoot;//添加上拉加载评论


#pragma mark ----交互方法

-(IBAction)changeSelectState:(UIButton *)sender;//点赞按钮事件
-(void)touchToSearch;//点击查看用户信息

-(void)UrlComment ;//请求评论列表

-(NSMutableString *)getTheCurrentDate;//取得当前时间字符串数据

-(void)issueCommentWithString:(NSString *)string;//发表评论

@end
