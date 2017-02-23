//
//  RoomDeviceScrollView.h
//  情趣设施自定义测试
//
//  Created by 薇薇一笑 on 16/3/31.
//  Copyright © 2016年 爱爱网. All rights reserved.
//
///房间情趣设施自定义View



#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectedStatus) {

    NotBeSelected,  //默认没有被选择
    HaveBeSelected, //被选择的状态
    
};

@interface RomanticServieView : UIView

@property (nonatomic,strong) NSMutableArray *viewsArr;  //用于保存视图的数组

@property (nonatomic)        SelectedStatus selectedMode;   //选择的模式

//初始化方法
-(instancetype)initWithWidth:(CGFloat)width;

//根据传入的数据加载视图
-(void)setUpViewWithDeviceArr:(NSArray *)modelArr;

@end
