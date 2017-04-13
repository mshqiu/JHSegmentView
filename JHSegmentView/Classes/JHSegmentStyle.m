//
//  JHSegmentStyle.m
//  SegmentView
//
//  Created by mshqiu on 2017/4/12.
//  Copyright © 2017年 jinhui. All rights reserved.
//

#import "JHSegmentStyle.h"

@implementation JHSegmentStyle

- (CGFloat)minimumSpacing {
    if (_minimumSpacing < 15) {
        _minimumSpacing = 15;
    }
    return _minimumSpacing;
}

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:14];
    }
    return _titleFont;
}

- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [UIColor darkGrayColor];
    }
    return _normalColor;
}

- (UIColor *)selectedColor {
    if (!_selectedColor) {
        _selectedColor = [UIColor orangeColor];
    }
    return _selectedColor;
}

- (UIColor *)bottomLineColor {
    if (!_bottomLineColor) {
        _bottomLineColor = [UIColor orangeColor];
    }
    return _bottomLineColor;
}

- (CGFloat)bottomLineHeight {
    if (_bottomLineHeight < 2) {
        _bottomLineHeight = 2;
    }
    return _bottomLineHeight;
}

- (CGFloat)selectedDeltaScale {
    if (_selectedDeltaScale < 0 || _selectedDeltaScale > 1) {
        _selectedDeltaScale = 0.16;
    }
    return _selectedDeltaScale;
}

@end
