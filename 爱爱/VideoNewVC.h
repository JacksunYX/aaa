//
//  VideoNewVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/10.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///视频新闻

@class KrVideoPlayerController;

#import <UIKit/UIKit.h>


#import "NewsSourceModel.h" //新闻数据模型


@interface VideoNewVC : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

{
    BOOL  ToUpdataComend;               //加载评论开关

    UIImageView *logImage;              //log图片

}

@property (nonatomic,strong) NewsSourceModel *newsModel;    //新闻载体模型

@property (nonatomic, strong) KrVideoPlayerController  *videoController;



@end
