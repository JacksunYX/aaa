//
//  TableViewCell4.h
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/14.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.

///目前用于展示我的收藏页的自定义cell



#import <UIKit/UIKit.h>

@interface TableViewCell4 : UITableViewCell

@property (nonatomic,strong) UIImageView *ImageView;    //标题图

@property (nonatomic,strong) UILabel *TextLabel;        //标题

@property (nonatomic,strong) UILabel *source;           //来源

@property (nonatomic,strong) UIButton *comments;     //评论量

@property (nonatomic,strong) UILabel *issueTime;        //发布时间



-(void)creatViewWithCommentNum:(NSInteger)commentNum AndPublishTime:(NSString *)publishTime; //创建下方控件


@end
