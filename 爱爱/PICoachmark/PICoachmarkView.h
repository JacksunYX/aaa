//
//  PICoachmarkView.h
//  NewPiki
//
//  Created by Pham Quy on 2/2/15.
//  Copyright (c) 2015 Pikicast Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PICoachmarkViewDelegate;
@class PICoachmarkScreen;
@interface PICoachmarkView : UIView
@property (nonatomic, weak) id<PICoachmarkViewDelegate> delegate;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic, strong) NSArray* screens;


- (void) addScreen:(PICoachmarkScreen*) screen;
- (void) start;
- (void) skipCoaching;
@end


@interface PICoachmarkView (ImageCoachmark)
- (instancetype) initWithFrame:(CGRect) frame coachMarks:(NSDictionary*) coachMarks;
@end

//------------------------------------------------------------------------------
@protocol PICoachmarkViewDelegate <NSObject>
@optional
- (void)coachMarksView:(PICoachmarkView*)coachMarksView willNavigateToIndex:(NSUInteger)index;
- (void)coachMarksView:(PICoachmarkView*)coachMarksView didNavigateToIndex:(NSUInteger)index;
- (void)coachMarksViewWillFinish:(PICoachmarkView*)coachMarksView;
- (void)coachMarksViewDidFinish:(PICoachmarkView*)coachMarksView;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com