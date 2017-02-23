//
//  RoomDetailVC+Methods.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "RoomDetailVC.h"

#import "ThemeRoomModel.h"  //房间模型

@interface RoomDetailVC (Methods)

#pragma mark ----- 统一视图加载方法
-(void)loadBaseView; //加载基本视图





#pragma mark ----- 辅助方法

-(void)addtapgestureToViewsWithViewsArr:(NSArray *)viewsArr;    //给滚动视图上的view添加点击事件

-(void)addtapGestureToLocationLabel:(UIView *)mapLabel;         //给酒店地址添加点击事件

-(void)addtapGestureToRomanticViewWithViewsArr:(NSArray *)viewsArr; //给浪漫服务视图上的view添加点击事件

-(void)clearSingleExampleSelectedData;  //第一次进入清空浪漫服务的选取项


@end
