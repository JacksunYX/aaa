//
//  RomanticVC.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/5/25.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///浪漫服务详情
#import "RomanticSingleExample.h"   //引入单例


#import <UIKit/UIKit.h>

@interface RomanticVC : UIViewController
{

    DGActivityIndicatorView *activityIndicatorView; //加载指示器

}

@property (nonatomic,strong) NSMutableDictionary *romanticDic;  //浪漫服务的数据字典


@end
