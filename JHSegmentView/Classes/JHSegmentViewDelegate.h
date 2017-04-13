//
//  JHSegmentViewDelegate.h
//  SegmentView
//
//  Created by mshqiu on 2017/4/12.
//  Copyright © 2017年 jinhui. All rights reserved.
//

#ifndef JHSegmentViewDelegate_h
#define JHSegmentViewDelegate_h

@protocol JHSegmentHeaderViewDelegate <NSObject>

- (void)segmentHeaderViewDidSelectItemAtIndex:(NSUInteger)index;

@end

@protocol JHSegmentContentViewDelegate <NSObject>

- (void)segmentContentViewScrollingFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex progress:(CGFloat)progress;

@end

#endif /* JHSegmentViewDelegate_h */
