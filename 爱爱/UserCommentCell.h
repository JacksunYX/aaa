//
//  UserCommentCell.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/2/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//




@class NewsSourceModel;
@class CommendSourceModel;

#import <UIKit/UIKit.h>

@interface UserCommentCell : UITableViewCell

@property (nonatomic,strong) UILabel *createTime;       //发表时间

@property (nonatomic,strong) UILabel *commentContent;   //发表内容

@property (nonatomic,strong) UIImageView *childNumView; //子评论图标

@property (nonatomic,strong) UILabel *childNum;         //子评论数

@property (nonatomic,strong) UILabel *ups;              //点赞数

@property (nonatomic,strong) UIImageView *upsView;      //点赞图标


@property (nonatomic,strong) UIView *backView;          //下方新闻的背景



-(void)setCommentViewWithNewsCommentModel:(CommendSourceModel *)commentModel AndParentComment:(NSDictionary *)dict;   //设置评论内容

-(void)setNewsViewWithNewsModel:(NewsSourceModel *)newsModel;  //加载相关新闻的内容



@end
