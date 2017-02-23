//
//  Utility.m
//  Themis
//
//  Created by Gao on 15/9/10.
//  Copyright (c) 2015年 Themis. All rights reserved.
//

#import "Utility.h"
#import "sys/utsname.h"


@interface Utility()

@property (nonatomic, copy) NSString *url;

@end


@implementation Utility



/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
