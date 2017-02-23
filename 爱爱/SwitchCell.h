//
//  SwitchCell.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/2/24.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///带开关按钮的自定义cell




#import <UIKit/UIKit.h>

@interface SwitchCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;       //标题

@property (nonatomic,strong) UILabel *detailContent;    //详细功能描述

@property (nonatomic,strong) UISwitch *Switch;          //开关功能


-(void)settitleWithText:(NSString *)string AndOnOrNot:(BOOL)onOrNot;             //填充标题


@end
