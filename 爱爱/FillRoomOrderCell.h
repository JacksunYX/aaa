//
//  FillRoomOrderCell.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/3/28.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///填写房间订单的自定义cell(已未使用)





#import <UIKit/UIKit.h>

@interface FillRoomOrderCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,strong) UIView      *selectDateView;    //日期选择相关

@property (nonatomic,strong) UITextField *contactName;       //联系人姓名

@property (nonatomic,strong) UITextField *fillPhoneNum;      //填写手机号码

//重置选择日期的视图
-(void)setDateWithDateString:(NSString *)string Anddays:(NSInteger)days;

//填充输入框
-(void)setTextFieldWith:(NSString *)string AndtextField:(UITextField *)textfield;

@end
