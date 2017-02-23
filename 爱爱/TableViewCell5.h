//
//  TableViewCell5.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/19.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///  用于展示图片新闻的自定义cell



#import <UIKit/UIKit.h>
#import "NewsSourceModel.h"//新闻模型




@interface TableViewCell5 : UITableViewCell

@property (nonatomic,strong) UIImageView *icon;//左上角多图标注
@property (nonatomic,strong) UILabel *title;//标题


@property (nonatomic,strong) UIImageView *imvL;//左边的图
@property (nonatomic,strong) UIImageView *imvC;//中间的图
@property (nonatomic,strong) UIImageView *imvR;//右边的图



@property (nonatomic,strong) UIImageView *eye;//浏览图标
@property (nonatomic,strong) UILabel *clicks;//观看点击量
@property (nonatomic,strong) UIView *backView;//背景框


//自定义设置界面方法
-(void)setViewWithModel:(NewsSourceModel *)newsModel;

@end
