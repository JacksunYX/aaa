//
//  NewsCell.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/21.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///新的自定义cell，用于展示资讯(能够容纳长篇幅的大图)


#define TopMargin  10 //图片距离上部的距离


#import <UIKit/UIKit.h>

@protocol NewCellImageDelegate <NSObject>   //代理方法
@optional

-(void)reloadCellAtIndexPathWithUrl:(NSString *)url;    //加载完图片后刷新界面

-(void)deleteCellAtIndexPathWithUrl:(NSString *)url;    //对于标题图片有误的新闻回调移除

-(void)reloadCellAtIndexPathAfterLoadAllFontWithUrl:(NSString *)url;    //加载完所有字体后刷新界面

@end

@interface NewsCell : UITableViewCell

@property (nonatomic,strong) NSMutableDictionary *model;   //数据模型

@property (nonatomic,strong) id<NewCellImageDelegate> delegate; //代理


@end
