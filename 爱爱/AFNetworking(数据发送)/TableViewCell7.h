//
//  TableViewCell7.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/19.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///  用于展示普通新闻的自定义cell



#import <UIKit/UIKit.h>


#import "NewsSourceModel.h"//新闻模型

@interface TableViewCell7 : UITableViewCell<UIGestureRecognizerDelegate>
//左边的图
@property (nonatomic,strong) UIImageView *imvL;//图片
@property (nonatomic,strong) UIView *backViewL;//背景框
@property (nonatomic,strong) UILabel *titleL;//标题
@property (nonatomic,strong) UIImageView *eyeL;//眼睛
@property (nonatomic,strong) UILabel *clickL;//点击量



//右边的图(和左边一样,但是内容不一样,)
@property (nonatomic,strong) UIImageView *imvR;
@property (nonatomic,strong) UIView *backViewR;//背景框
@property (nonatomic,strong) UILabel *titleR;
@property (nonatomic,strong) UIImageView *eyeR;
@property (nonatomic,strong) UILabel *clickR;

@property (nonatomic,strong) NewsSourceModel *newsModelL;
@property (nonatomic,strong) NewsSourceModel *newsModelR;



//处理传过来的数组
-(void)setViewWithNewsArr:(NSArray *)newsArr;

@end
