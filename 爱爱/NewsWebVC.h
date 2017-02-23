//
//  NewsWebVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/4/22.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsWebVC : UIViewController

@property (nonatomic,strong) NSString *webViewUrlStr;   //网页地址

@property (nonatomic,strong) NSString *newsId;          //新闻id

@property (nonatomic,strong) NSMutableDictionary *newsModel; //保存新闻数据

@end
