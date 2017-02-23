//
//  NewsSourceModel.h
//  爱爱
//
//  Created by 黑色o.o表白 on 15/12/10.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.

///新闻信息模型




#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NewsSourceModel : NSObject




//新闻配图(地址)
@property(nonatomic,copy) NSString *backImagePath;

//新闻配图(已处理好)
@property (nonatomic,strong) UIImage *backImage;


//新闻来源+发布时间
@property(nonatomic,copy) NSString *issueTime;

//tags标签
@property(nonatomic,copy) NSString *tagsArr;

//收藏数
@property(nonatomic,strong) NSNumber *collect;

//点击量
@property(nonatomic,strong) NSNumber *clickrate;

//转发量
@property(nonatomic,strong) NSNumber *share;

//新闻的id(每条新闻有唯一的id)
@property(nonatomic,strong) NSNumber *onlyID;

#pragma mark------目前设定的新闻属性
@property (nonatomic,strong)UIImage *titleImg;                  //标题图片的本地缓存

@property (nonatomic,copy) NSString *browsTime;                 //新闻的最新浏览时间


@property (nonatomic,copy) NSString *title;                     //标题

@property (nonatomic,strong) NSNumber *newsId;                  //新闻id

@property (nonatomic,copy) NSString *imageSrc;                  //标题图片源地址字符串

@property (nonatomic,copy) NSString *content;                   //详细信息

@property (nonatomic,strong) NSNumber *views;                   //浏览数

@property (nonatomic,copy) NSString *publishTime;               //发布时间

@property (nonatomic,copy) NSString *source;                    //来源

@property (nonatomic,strong) NSNumber *commentNum;              //评论数

@property (nonatomic,strong) NSString *shareUrl;                //分享网址


@property (nonatomic,strong) NSNumber *ups;     //顶
@property (nonatomic,strong) NSNumber *downs;   //踩
@property (nonatomic,strong) NSNumber *han;     //汗

@property (nonatomic,assign) bool  isStore;                     //是否收藏

@property (nonatomic,copy) NSString *shares;                    //分享数量

@property (nonatomic,copy) NSString *contentDescription;        //新闻描述

@property (nonatomic,strong) NSNumber *contentType;             //新闻类型(多图、普通或视频类)

@property (nonatomic,strong) NSMutableArray *pictures;          //图片地址数组(全部保存图片的地址)

@property (nonatomic,strong) NSMutableArray *contentPictures;   //图片新闻数组



@end
