//
//  CommendSourceModel.h
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/10.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.

///评论信息模型




@class NewsSourceModel;
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CommendSourceModel : NSObject

//头像(已处理)
@property (nonatomic,strong) UIImage *userImage;


#pragma mark----目前定下来的字段

@property (nonatomic,strong)    NSNumber *commentId;

@property (nonatomic,copy)      NSString *commentContent;       //用户评论内容

@property (nonatomic,copy)      NSString *createTime;           //发表时间

@property (nonatomic,assign)    bool isUps;                     //是否点赞

@property (nonatomic,strong)    NSNumber *ups;                  //点赞数

@property (nonatomic,copy)      NSString *userImg;              //头像地址

@property (nonatomic,copy)      NSString *nickname;             //评论者名字

@property (nonatomic,copy)      NSString *ipAddress;            //位置

@property (nonatomic,strong)    NSString *childNum;             //评论量

@property (nonatomic,assign)    bool isComment;                 //是否被评论

@property (nonatomic,strong)    NSDictionary *parentComment;    //评论了哪条评论

@property (nonatomic,strong)    NSString *gender;               //性别

@property (nonatomic,strong)    NSString *location;             //位置





@property (nonatomic,strong)    NSString *cellHeight;  //保存cell的高度

@property (nonatomic,strong)    NSDictionary *contentAbstruct; //用于保存所属的新闻的相关内容

@property (nonatomic,strong)    NewsSourceModel *newsModel;    //保存所属的新闻


@end
