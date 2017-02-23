//
//  UIImageView+Animation.m
//  ImageViewAnimation
//
//  Created by Pierre on 04/12/2014.
//  Copyright (c) 2014 Felginep. All rights reserved.
//

#import "UIImageView+Animation.h"
#import "UIImageView+WebCache.h"

#define AN_LOADER_SIZE 40.0f
#define AN_LOADER_LINE_WIDTH 2.0f
#define AN_ANIMATION_DURATION 0.4f
#define AN_ANIMATION_DELAY 0.2f

@implementation UIImageView (Animation)

- (void)animateImageWithURL:(NSURL *)url {
    __block CAShapeLayer * shapeLayer;
    UIColor * lastColor = self.backgroundColor;

    if (!self.layer.mask) {
        shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.contentsScale = self.layer.contentsScale;
        shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:[self _centerRectWithSize:AN_LOADER_SIZE]].CGPath;
        shapeLayer.lineWidth = AN_LOADER_LINE_WIDTH;
        shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeEnd = 0;
        self.layer.mask = shapeLayer;
        self.backgroundColor = [UIColor darkGrayColor];
    }

    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat percentage = (CGFloat)receivedSize / (CGFloat)expectedSize;
        if (percentage > 0) {
            shapeLayer.strokeEnd = percentage;
        }

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image;

        void(^completionBlock)() = ^{
            self.layer.mask = nil;
            shapeLayer = nil;
            self.backgroundColor = lastColor;
        };

        if (cacheType == SDImageCacheTypeDisk || cacheType == SDImageCacheTypeMemory) { // NO animation
            completionBlock();
            return ;
        }

        shapeLayer.strokeEnd = 0;
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        shapeLayer.fillColor = [UIColor blackColor].CGColor;

        UIBezierPath * fromPath = [UIBezierPath bezierPathWithOvalInRect:[self _centerRectWithSize:AN_LOADER_SIZE]];
        [fromPath appendPath:[UIBezierPath bezierPathWithOvalInRect:[self _centerRectWithSize:AN_LOADER_SIZE - AN_LOADER_LINE_WIDTH]]];
        shapeLayer.path = fromPath.CGPath;
        shapeLayer.fillRule = kCAFillRuleEvenOdd;

        CGFloat maxSize = MAX(self.bounds.size.width, self.bounds.size.height);
        CGFloat maxRadius = sqrtf(maxSize * maxSize / 2);
        UIBezierPath * toPath = [UIBezierPath bezierPathWithOvalInRect:[self _centerRectWithSize:2 * maxRadius]];
        [toPath appendPath:[UIBezierPath bezierPathWithOvalInRect:[self _centerRectWithSize:0]]];

        [CATransaction begin]; {
            [CATransaction setAnimationDuration:AN_ANIMATION_DURATION];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            [CATransaction setCompletionBlock:^{
                completionBlock();
            }];

            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"path"];
            animation.beginTime = CACurrentMediaTime() + AN_ANIMATION_DELAY;
            animation.fromValue = (__bridge id)fromPath.CGPath;
            animation.toValue = (__bridge id)toPath.CGPath;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            [shapeLayer addAnimation:animation forKey:@"pathAnimation"];
        } [CATransaction commit];
    }];
}

#pragma mark - Private

- (CGRect)_centerRectWithSize:(CGFloat)size {
    return CGRectMake(0.5f * (self.bounds.size.width - size),
                      0.5f * (self.bounds.size.height - size),
                      size,
                      size);
}

@end
