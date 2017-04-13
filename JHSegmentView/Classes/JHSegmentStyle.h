//
//  JHSegmentStyle.h
//  SegmentView
//
//  Created by mshqiu on 2017/4/12.
//  Copyright © 2017年 jinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHSegmentStyle : NSObject

// 选项卡之间的最小间距，距两侧边缘间距为该最小间距的一半
@property (nonatomic, assign) CGFloat minimumSpacing;

// 选项卡文字样式
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
// 选中的放大百分比(0~1)
@property (nonatomic, assign) CGFloat selectedDeltaScale;

// 选项卡文字遮罩样式，暂未实现
@property (nonatomic, assign) BOOL showCoverView;
@property (nonatomic, strong) UIColor *coverViewColor;

// 选项卡底部线条样式
@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, strong) UIColor *bottomLineColor;
@property (nonatomic, assign) CGFloat bottomLineHeight;

@end
