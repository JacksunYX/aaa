//
//  UIImageView+ProgressView.m
//
//  Created by Kevin Renskers on 07-06-13.
//  Copyright (c) 2013 Kevin Renskers. All rights reserved.
//

#import "UIImageView+ProgressView.h"

#import "LFRoundProgressView.h" //进度圈库

#define TAG_PROGRESS_VIEW 149462

@implementation UIImageView (ProgressView)

- (void)addProgressView:(UIProgressView *)progressView {
    UIProgressView *existingProgressView = (UIProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (!existingProgressView) {
        if (!progressView) {
            progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        }

        progressView.tag = TAG_PROGRESS_VIEW;
        progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

        float width = progressView.frame.size.width;
        float height = progressView.frame.size.height;
        float x = (self.frame.size.width / 2.0) - width/2;
        float y = (self.frame.size.height / 2.0) - height/2;
        progressView.frame = CGRectMake(x, y, width, height);

        [self addSubview:progressView];
    }
}

- (void)updateProgress:(CGFloat)progress {
    UIProgressView *progressView = (UIProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        progressView.progress = progress;
    }
}

- (void)removeProgressView {
    UIProgressView *progressView = (UIProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        [progressView removeFromSuperview];
    }
}


- (void)sd_setImageWithURL:(NSURL *)url usingProgressView:(UIProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder usingProgressView:(UIProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options usingProgressView:(UIProgressView *)progressView{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock usingProgressView:(UIProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock usingProgressView:(UIProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock usingProgressView:(UIProgressView *)progressView {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock usingProgressView:progressView];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock usingProgressView:(UIProgressView *)progressView {
    [self addProgressView:progressView];
    
    __weak typeof(self) weakSelf = self;

    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf updateProgress:progress];
        });

        if (progressBlock) {
            progressBlock(receivedSize, expectedSize);
        }
    }
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf removeProgressView];
        if (completedBlock) {
            completedBlock(image, error, cacheType, imageURL);
        }
    }];
}


#pragma mark ----- 自定义进度圈

//加载图片,并设置进度圈的各项颜色属性及大小
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder AndProgressBackgroundColor:(UIColor *)progressBackgroundColor AndProgressTintColor:(UIColor *)progressTintColor AndSize:(CGSize)size
{
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil usingProgressView:nil AndProgressBackgroundColor:progressBackgroundColor AndProgressTintColor:progressTintColor AndSize:size];
    
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock usingProgressView:(UIProgressView *)progressView AndProgressBackgroundColor:(UIColor *)progressBackgroundColor AndProgressTintColor:(UIColor *)progressTintColor AndSize:(CGSize)size
{
    
    [self addLFRoundProgressView:nil AndProgressBackgroundColor:progressBackgroundColor AndProgressTintColor:progressTintColor AndSize:size];
    
    __weak typeof(self) weakSelf = self;
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = ((CGFloat)receivedSize / (CGFloat)expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateLFRoundProgressView:progress];
        });
        
        if (progressBlock) {
            progressBlock(receivedSize, expectedSize);
        }
    }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       [weakSelf removeLFRoundProgressView];
                       if (completedBlock) {
                           completedBlock(image, error, cacheType, imageURL);
                       }
                   }];
    
}

//添加引入的第三方进度圈
-(void)addLFRoundProgressView:(LFRoundProgressView *)progressView AndProgressBackgroundColor:(UIColor *)progressBackgroundColor AndProgressTintColor:(UIColor *)progressTintColor AndSize:(CGSize)size
{
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    LFRoundProgressView *existingProgressView = (LFRoundProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (!existingProgressView) {
        
        if (!progressView) {
            
            progressView = [[LFRoundProgressView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-width/2, self.frame.size.height/2-height/2, width, height)];
            
        }
        
        progressView.tag = TAG_PROGRESS_VIEW;
        progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        progressView.progressBackgroundColor = progressBackgroundColor;   //进度颜色
        progressView.progressTintColor=progressTintColor; //边框颜色
        progressView.percentShow=NO;
        progressView.annular=NO;
        
        
        [self addSubview:progressView];
        
    }
    
}

//更新进度圈
- (void)updateLFRoundProgressView:(CGFloat)progress
{
    
    LFRoundProgressView *progressView = (LFRoundProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        progressView.progress = progress;
    }
    
}

//移除进度圈
- (void)removeLFRoundProgressView
{
    
    LFRoundProgressView *progressView = (LFRoundProgressView *)[self viewWithTag:TAG_PROGRESS_VIEW];
    if (progressView) {
        [progressView removeFromSuperview];
    }
    
}


@end
