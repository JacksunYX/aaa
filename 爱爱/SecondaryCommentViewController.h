//
//  SecondaryCommentViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/17.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///二级评论

@class CommendSourceModel;
@class NewsSourceModel;

#import "YIPopupTextView.h"     //弹出框库

#import <UIKit/UIKit.h>

@interface SecondaryCommentViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,YIPopupTextViewDelegate,UIAlertViewDelegate>

{

    NSMutableArray  *commentsArr;       //用于保存评论对象的数组
    
    UIView          *commentBackView;   //上方评论的背景
    
    YIPopupTextView *popupTextView;     //评论框
    
    UIAlertView     *myAlert;           //提示框
    
    BOOL            loadCellOrNot;      //是否已加载了cell
    
    NSMutableArray  *cellHeightArr;      //用于保存cell高度的数组
    
    MBProgressHUD   *hud;
    
    UIView *backView;   //下方评论控件的背景板

}

@property (nonatomic,strong) CommendSourceModel *comment;   //用于保存一级评论页面传过来的评论对象

@property (nonatomic,strong) NewsSourceModel    *newsModel;    //保存一级评论页传过来的新闻对象

@property (nonatomic,strong) UITableView        *mytableView;

@property (nonatomic,strong) NSString *baseDate;    //时间基点(如果按时间排序返回时间基点)
@property (nonatomic,strong) NSString *baseObjectId;        //评论的基点Id(只用于后台去重)
@end
