//
//  HistoryTableViewCell.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/16.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///浏览历史页使用的自定义cell




@class NewsSourceModel;

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *ImageView;    //标题图

@property (nonatomic,strong) UILabel *titleLabel;        //标题

@property (nonatomic,strong) UILabel *source;           //来源

@property (nonatomic,strong) UILabel *publishTime;        //发布时间

-(void)setViewWithNewsModel:(NewsSourceModel *)newsModel;   //根据传过来的新闻数据设置cell

@end
