//
//  SecondaryComentCell.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/17.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///  用于展示二级评论的自定义cell




#import <UIKit/UIKit.h>
#import "CommendSourceModel.h"

@interface SecondaryComentCell : UITableViewCell

@property (nonatomic,strong) UIView *backView;      //背景框

@property (nonatomic,strong) UIImageView *userImg;  //用户头像

@property (nonatomic,strong) UILabel *nickname;    //昵称

@property (nonatomic,strong) UILabel *creatTime;   //发布时间

@property (nonatomic,strong) UILabel *content;     //评论内容

@property (nonatomic,strong) UIButton *zanBtn;     // 点赞按钮

@property (nonatomic,strong) UIImageView *genderView;//用户性别图标

//给评论赋值并且实现自动换行
-(void)setIntroductionTextWithCommentModel:(CommendSourceModel *)commentModel;

@end
