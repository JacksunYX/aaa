//
//  NewsTableViewCell.h
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/10.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.

///  用于展示新闻内容的自定义cell(旧,已经不再使用)




#import <UIKit/UIKit.h>
#import "TYAttributedLabel.h"
@interface NewsTableViewCell : UITableViewCell<TYAttributedLabelDelegate>
//图文混排
@property (nonatomic,strong) TYAttributedLabel *label;

//标题
@property(nonatomic,retain) UILabel *title;

//详细信息
@property(nonatomic,retain) UILabel *introduction;

//新闻配图
@property(nonatomic,retain) UIImageView *backImage;

//新闻发布的来源+当前发布时间
@property(nonatomic,retain) UILabel *issueTime;

//收藏数
@property(nonatomic,strong) UIButton *collect;

//点击量
@property(nonatomic,strong) UILabel *clickrate;

//转发量
@property(nonatomic,strong) UILabel *share;

@property(nonatomic,retain) UILabel *source;//来源

//新闻标签(根据后台得到的新闻标签，生成button数组)
@property(nonatomic,strong) NSMutableArray *tagsBtns;

@property (nonatomic,strong) UIView *backView;  //背景框

#pragma mark    ---    分享按钮
@property (nonatomic,strong) UIButton *qqshare; //qq分享

@property (nonatomic,strong) UIButton *friendshare; //微信朋友圈分享

@property (nonatomic,strong) UIButton *weiboshare; //微博分享

@property (nonatomic,strong) UIButton *moreshare; //更多分享

//给新闻赋值并且实现自动换行
-(void)setIntroductionText:(NSString*)text;


-(void)setLabelOfCellWith:(NSString *)content;

@end
