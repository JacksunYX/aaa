//
//  AreaSelectView.h
//  AreaSelect
//
//  Created by xhw on 16/3/16.
//  Copyright © 2016年 xhw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaModel.h"
#import "DBUtil.h"

@interface AreaSelectView : UIView

@property (nonatomic, copy) void(^selectedCityBlock)(AreaModel *);

@property (nonatomic, strong) NSMutableDictionary *cities;//城市列表
@property (nonatomic, strong) NSMutableArray *keys;//城市首字母

@end
