//
//  JT3DScrollView.h
//  JT3DScrollView
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JT3DScrollViewEffect) {
    JT3DScrollViewEffectNone,
    JT3DScrollViewEffectTranslation,    //上下交错的渐入渐出
    JT3DScrollViewEffectDepth,          //从小到大的渐入渐出
    JT3DScrollViewEffectCarousel,       //浮动的渐入渐出
    JT3DScrollViewEffectCards           //卡片式的渐入渐出
};

@interface JT3DScrollView : UIScrollView

@property (nonatomic) JT3DScrollViewEffect effect;

@property (nonatomic) CGFloat angleRatio;

@property (nonatomic) CGFloat rotationX;
@property (nonatomic) CGFloat rotationY;
@property (nonatomic) CGFloat rotationZ;

@property (nonatomic) CGFloat translateX;   //scrollView里相邻2个view的间距
@property (nonatomic) CGFloat translateY;

- (NSUInteger)currentPage;

- (void)loadNextPage:(BOOL)animated;
- (void)loadPreviousPage:(BOOL)animated;
- (void)loadPageIndex:(NSUInteger)index animated:(BOOL)animated;

@end
