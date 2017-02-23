//
//  ChangeToolBar.h
//  ThemisSurvey
//
//  Created by Gao on 15/10/6.
//  Copyright (c) 2015年 Themis Credit Mangement. All rights reserved.
//  水平切换菜单

#import <UIKit/UIKit.h>




@protocol HorizontalMenuDelegate <NSObject>
/**
 *  点击的按钮
 *
 *  @param button tag值
 */
- (void)clickButton:(UIButton *)button;

@end




@interface HorizontalMenu : UIView


@property (nonatomic, assign) id<HorizontalMenuDelegate> delegate;


@property (nonatomic, strong) UIButton *button;

/**
 *  初始化toolbar
 *
 *  @param frame  设置frame
 *  @param titles 设置标题数组
 *
 *  @return 返回一个toolbar
 */
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles;

@end
