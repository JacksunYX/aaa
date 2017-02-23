//
//  FirstCommentViewController.h
//  爱爱
//
//  Created by 爱爱网 on 16/2/18.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.

///一级评论




@class NewsSourceModel;
#import <UIKit/UIKit.h>

#import "YIPopupTextView.h"     //弹出框库

@interface FirstCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,YIPopupTextViewDelegate,UIAlertViewDelegate>

{

    NSMutableArray *hotCommentArr;      //用于保存热门评论的数组
    NSMutableArray *otherCommentArr;    //用于保存其它评论的数组
    
    YIPopupTextView *popupTextView;     //评论框
    
    MBProgressHUD   *hud;
    
    UIView *backView;   //下方评论控件的背景板
}

@property (nonatomic,strong) UITableView *mytableView;

@property (nonatomic,strong) NewsSourceModel    *newsModel;    //保存一级评论页传过来的新闻对象

@property (nonatomic,strong) NSString *baseDate;    //时间基点(如果按时间排序返回时间基点)
@property (nonatomic,strong) NSString *baseObjectId;        //评论的基点Id(只用于后台去重)

@property (nonatomic,assign) BOOL popKeyBoard;   //是否弹出评论键盘

@end
