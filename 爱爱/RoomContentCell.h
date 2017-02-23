//
//  RoomContentCell.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/26.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///用于展示房间详情的自定义cell


@class ThemeRoomModel;
@class JT3DScrollView;

#import "RomanticServieView.h"  //情趣浪漫服务视图

#import <UIKit/UIKit.h>

@interface RoomContentCell : UITableViewCell<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UILabel *location;  //酒店方位

@property (nonatomic,strong) ThemeRoomModel *model; //房间模型

@property (nonatomic,strong)JT3DScrollView  *scrollView;    //第三方库滚动视图(用于展示类似房间)

@property (nonatomic,strong) NSMutableArray *viewsArr;  //保存推荐栏滚动视图的数组

@property (nonatomic,strong) RomanticServieView *serviceView;    //浪漫服务视图


@end
