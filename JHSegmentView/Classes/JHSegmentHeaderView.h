//
//  JHSegmentHeaderView.h
//  SegmentView
//
//  Created by mshqiu on 2017/4/12.
//  Copyright © 2017年 jinhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSegmentStyle.h"
#import "JHSegmentViewDelegate.h"

@interface JHSegmentHeaderView : UIScrollView <JHSegmentContentViewDelegate>

@property (nonatomic, weak) id<JHSegmentHeaderViewDelegate> segmentDelegate;

@property (nonatomic, assign) NSUInteger selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles style:(JHSegmentStyle *)style;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)animateFromTitleAtIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex progress:(CGFloat)progress;

@end
