//
//  WKWebView+Motheds.m
//  爱爱
//
//  Created by 薇薇一笑 on 16/5/5.
//  Copyright © 2016年 黑色o.o表白. All rights reserved.
//

#import "WKWebView+Motheds.h"
#import <objc/runtime.h>

#import "KZImageViewer.h"
#import "KZImage.h"

#import "UIImageView+ProgressView.h"

@implementation WKWebView (Motheds)

static char imgUrlArrayKey;

- (void)setMethod:(NSArray *)imgUrlArray

{
   
    objc_setAssociatedObject(self, &imgUrlArrayKey, imgUrlArray, 1);
    
}



- (NSArray *)getImgUrlArray

{
    
    return objc_getAssociatedObject(self, &imgUrlArrayKey);
    
}


//显示大图
-(BOOL)showBigImage:(NSURLRequest *)request
{
    
    //将url转换为string
    
    NSString *requestString = [[request URL] absoluteString];
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    
    if ([requestString hasPrefix:@"myweb:imageClick:"])
        
    {
        
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        
        NSLog(@"image url------%@", imageUrl);
        
        
        
        NSArray *imgUrlArr=[self getImgUrlArray];
        
        NSInteger index=0;
        
        for (NSInteger i=0; i<[imgUrlArr count]; i++) {
            
            if([imageUrl isEqualToString:imgUrlArr[i]])
                
            {
                
                index=i;
                
                break;
                
            }
            
        }
        
//        NSMutableArray *ImageArray = [NSMutableArray new];
//        for (int j =0; j<[imgUrlArr count]; j++) {
//            
//            UIImageView *imageV = [UIImageView new];
//            
//            [imageV sd_setImageWithURL:[NSURL URLWithString:imgUrlArr[j]]];
//            
//            [ImageArray addObject:imageV];
//            
//        }
        
        
        NSMutableArray  *kzImageArray = [NSMutableArray array];
        for (int i = 0; i < [imgUrlArr count]; i++)
        {
//            UIImageView *imageView = [ImageArray objectAtIndex:i];
//            KZImage *kzImage = [[KZImage alloc] initWithImage:imageView.image];
            
//            kzImage.thumbnailImage = imageView.image;

//            kzImage.srcImageView = imageView;
            
            KZImage *kzImage = [[KZImage alloc]initWithURL:[NSURL URLWithString:imgUrlArr[i]]];
            
//            kzImage.imageURL = [NSURL URLWithString:imgUrlArr[i]];
            
            [kzImageArray addObject:kzImage];
        }
        KZImageViewer *imageViewer = [[KZImageViewer alloc] init];
        [imageViewer showImages:kzImageArray atIndex:index];
        
//        [WFImageUtilshowImgWithImageURLArray:[NSMutableArrayarrayWithArray:imgUrlArr] index:index myDelegate:nil];
        
        return NO;
        
    }
    
    return YES;
    
}












@end
