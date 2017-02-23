//
//  TableViewCell8.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/1.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///带辅助视图和文字描述的自定义cell



@class UserSourceModel;

#import <UIKit/UIKit.h>


@interface TableViewCell8 : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;      //标题

@property (nonatomic,strong) UILabel *contentLabel;    //展示内容

@property (nonatomic,strong) UIImageView *assistView;   //辅助视图

-(void)settitleWithText:(NSString *)string;     //填充标题

-(void)setintrodictionWithText:(NSString *)string;     //填充内容

@end
