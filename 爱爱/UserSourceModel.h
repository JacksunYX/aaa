//
//  UserSourceModel.h
//  爱爱
//
//  Created by 爱爱网 on 15/12/21.
//  Copyright © 2015年 黑色o.o表白. All rights reserved.

///用户信息模型




#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserSourceModel : NSObject

@property (nonatomic,strong) NSString   *userId;      //唯一id

@property (nonatomic,strong) NSString   *nickname;    //昵称

@property (nonatomic,strong) NSString   *username;    //账号

@property (nonatomic,strong) UIImage    *userImg;     //头像

@property (nonatomic,strong) NSString   *gender;      //性别

@property (nonatomic,strong) NSString   *birthday;    //生日

@property (nonatomic,strong) NSString   *location;    //所在地

@property (nonatomic,strong) NSString   *email;       //邮箱

@property (nonatomic,strong) NSString   *phoneNum;    //手机号




@end
