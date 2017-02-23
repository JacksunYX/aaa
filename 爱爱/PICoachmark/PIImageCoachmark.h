//
//  PICoachMark.h
//  NewPiki
//
//  Created by Pham Quy on 2/2/15.
//  Copyright (c) 2015 Pikicast Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PICoachMarkProtocols.h"



@interface PIImageCoachmark : NSObject <PICoachmarkProtocol>
- (instancetype) initWithDictionary:(NSDictionary*) dictionary;
@property (nonatomic) CGFloat duration;
@property (nonatomic) NSInteger repeatCount;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com