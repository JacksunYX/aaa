//
//  CommentTableViewCell.h
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/10.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.

///  用于展示一级评论的自定义cell

@class CommendSourceModel;


#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell


//评论者昵称
@property(nonatomic,retain) UILabel *name;

//用户评论内容
@property(nonatomic,retain) UILabel *introduction;

//用户头像
@property(nonatomic,retain) UIImageView *userImage;

//评论时间
@property(nonatomic,retain) UILabel *issueTime;

//点赞数
@property(nonatomic,strong) UIButton *support;

////用户头像上的按钮,用于查看用户信息
//@property(nonatomic,strong) UIButton *userbtn;

@property (nonatomic,strong) UIImageView *genderView;//用户性别图标


@property (nonatomic,strong) UIView *backView;      //背景框

@property (nonatomic,strong) UIButton *zanBtn;      // 点赞按钮

@property (nonatomic,strong) UILabel *zanNum;       //赞数

@property (nonatomic,strong) UIImageView *comment;  //评论图标

@property (nonatomic,strong) UILabel *comments;     //评论数









//通过传过来的数据模型填充评论内容
-(void)setContentWithCommentModle:(CommendSourceModel *)commentModel;

//初始化cell类
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;


@end
