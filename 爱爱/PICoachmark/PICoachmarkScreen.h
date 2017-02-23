//
//  PICoachmarkScreen.h
//  NewPiki
//
//  Created by Pham Quy on 2/2/15.
//  Copyright (c) 2015 Pikicast Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PICoachmarkScreen : NSObject
@property (nonatomic, strong) NSArray* coachmarks;
- (instancetype) initWithCoachMarks:(NSArray*) coachMarks;
@end


@interface PICoachmarkScreen (ImageCoachmark)
- (instancetype) initWithDictionary:(NSDictionary*) screenDict;
@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com