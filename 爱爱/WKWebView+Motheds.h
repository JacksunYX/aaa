//
//  WKWebView+Motheds.h
//  爱爱
//
//  Created by 薇薇一笑 on 16/5/5.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//
///单独写的一个WKWebView 分类



#import <WebKit/WebKit.h>


@interface WKWebView (Motheds)


- (void)setMethod:(NSArray *)imgUrlArray;

- (NSArray *)getImgUrlArray;

-(BOOL)showBigImage:(NSURLRequest *)request;

//-(NSArray *)getImageUrlByJS:(WKWebView *)wkWebView;  //通过js获取页面中的所有图片地址

@end
