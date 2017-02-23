//
//  PureImageViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/1/13.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///详细资讯页面(图片资讯)



#import <UIKit/UIKit.h>

#import "NewsSourceModel.h"     //新闻模型类

#import "YIPopupTextView.h"     //弹出框库

@interface PureImageViewController : UIViewController<UIGestureRecognizerDelegate,UIScrollViewDelegate,UIAlertViewDelegate,YIPopupTextViewDelegate,UIActionSheetDelegate>

{

    BOOL creatOrNot;    //是否已创建过下方的评论栏
    
    BOOL hideControl;   //受否隐藏控件

    YIPopupTextView* popupTextView;//评论框
    
    CGFloat ScrollViewHeight;       //用来保存滚动视图的最终高度
    CGFloat DescriptionViewHeight;  //用来保存描述视图的最终高度
    
    NSMutableArray *ImgArr;     //用来存储已经保存好图片的数组
    NSMutableArray *scrollArr;  //用来保存承载图片的滚动视图的数组
    
    UIActivityIndicatorView *_indicatorView;
    
    CGFloat lastScale;
}
@property (nonatomic,strong) NewsSourceModel *newsModel;    //新闻载体模型

@property (nonatomic,strong) UIScrollView *myScrollView;    //贴图片的滚动视图

@property (nonatomic,strong) UIView *descriptionView;       //用于展示描述文字

@property (nonatomic,strong) UIView *toolbar;               //下方评论等控件的载体框

@property (nonatomic,strong) UIView *statusView;            //状态栏颜色


@end
