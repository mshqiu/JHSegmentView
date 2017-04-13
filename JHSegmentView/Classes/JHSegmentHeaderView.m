//
//  JHSegmentHeaderView.m
//  SegmentView
//
//  Created by mshqiu on 2017/4/12.
//  Copyright © 2017年 jinhui. All rights reserved.
//

#import "JHSegmentHeaderView.h"
#import "UIColor+Transition.h"

@interface JHSegmentHeaderView ()

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) JHSegmentStyle *style;

@end

@implementation JHSegmentHeaderView {
    NSMutableArray *_titleSizeArray;
    CGFloat _minimumSpacing;
    CGFloat _totalWidth;
    CGSize _lastSize;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles style:(JHSegmentStyle *)style {
    if (self = [super initWithFrame:frame]) {
        _minimumSpacing = style.minimumSpacing;
        _lastSize = self.bounds.size;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.titles = titles;
        self.style = style;
        
        [self setupUI];
        [self setupLayout];
        [self setupSelectedLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(_lastSize, self.bounds.size)) {
        _lastSize = self.bounds.size;
        // bounds发生变化(例如屏幕旋转)，需要重新布局
        [self setupLayout];
        [self setupSelectedLabel];
        
        // 代理方法
        if ([self.segmentDelegate respondsToSelector:@selector(segmentHeaderViewDidSelectItemAtIndex:)]) {
            [self.segmentDelegate segmentHeaderViewDidSelectItemAtIndex:_selectedIndex];
        }
    }
}

- (void)setupUI {
    if (!self.titles.count) {
        return;
    }
    
    if (self.style.showBottomLine) {
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = self.style.bottomLineColor;
        bottomLine.tag = 9999;
        [self addSubview:bottomLine];
    }
    
    _titleSizeArray = [NSMutableArray array];
    
    for (int i = 0; i < self.titles.count; i++) {
        NSString *title = self.titles[i];

        CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.style.titleFont} context:nil];
        _totalWidth += rect.size.width;
        [_titleSizeArray addObject:NSStringFromCGSize(rect.size)];
        
        UILabel *label = [[UILabel alloc] init];
        label.userInteractionEnabled = YES;
        label.textColor = self.style.normalColor;
        label.font = self.style.titleFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
        label.tag = 10000+i;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLabelTapped:)];
        [label addGestureRecognizer:recognizer];
        
        [self addSubview:label];
    }
}

- (void)setupSelectedLabel {
    for (int i = 0; i < self.titles.count; i++) {
        UILabel *label = [self viewWithTag:i+10000];
        label.textColor = i==_selectedIndex ? self.style.selectedColor : self.style.normalColor;
        label.transform = i==_selectedIndex ? CGAffineTransformScale(CGAffineTransformIdentity, 1+self.style.selectedDeltaScale, 1+self.style.selectedDeltaScale) : CGAffineTransformIdentity;
    }
    
    [self scrollLabelAtIndexToCenter:_selectedIndex animated:YES];
    [self layoutBottomLineToLabelAtIndex:_selectedIndex animated:YES];
}

- (void)setupLayout {
    // 计算contentSize
    [self setupContentSize];
    
    // 布局子控件
    CGRect frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    for (int i = 0; i < self.titles.count; i++) {
        frame.origin.x += _minimumSpacing*0.5;
        frame.size.width = CGSizeFromString(_titleSizeArray[i]).width;
        UILabel *label = [self viewWithTag:10000+i];
        label.transform = CGAffineTransformIdentity;
        label.frame = frame;
        frame.origin.x = CGRectGetMaxX(frame) + _minimumSpacing*0.5;
    }
}

- (void)setupContentSize {
    BOOL scrollable = (_totalWidth+self.style.minimumSpacing*self.titles.count) >= self.bounds.size.width;
    self.bounces = scrollable;
    
    if (!scrollable) {
        _minimumSpacing = (self.bounds.size.width - _totalWidth)/self.titles.count;
        self.contentSize = self.bounds.size;
    } else {
        self.contentSize = CGSizeMake(_totalWidth+self.style.minimumSpacing*self.titles.count, self.bounds.size.height);
    }
}

- (void)onLabelTapped:(UIGestureRecognizer *)gestureRecognizer {
    UILabel *targetLabel = (UILabel *)gestureRecognizer.view;
    
    if (_selectedIndex == targetLabel.tag - 10000) {
        return;
    }
    
    UILabel *selectedLabel = [self viewWithTag:_selectedIndex+10000];
    selectedLabel.textColor = self.style.normalColor;
    
    targetLabel.textColor = self.style.selectedColor;
    _selectedIndex = targetLabel.tag - 10000;
    
    // 缩放
    [UIView animateWithDuration:0.2 animations:^{
        selectedLabel.transform = CGAffineTransformIdentity;
        targetLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1+self.style.selectedDeltaScale, 1+self.style.selectedDeltaScale);
    }];
    
    // 将选中的label滚到中间
    [self scrollLabelAtIndexToCenter:_selectedIndex animated:YES];
    
    // 底部线条跟随
    [self layoutBottomLineToLabelAtIndex:_selectedIndex animated:YES];
    
    // 代理方法
    if ([self.segmentDelegate respondsToSelector:@selector(segmentHeaderViewDidSelectItemAtIndex:)]) {
        [self.segmentDelegate segmentHeaderViewDidSelectItemAtIndex:_selectedIndex];
    }
}

- (void)animateFromTitleAtIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex progress:(CGFloat)progress {
    if (toIndex >= self.titles.count || index >= self.titles.count) {
        return;
    }
    if (progress < 0 || progress > 1) {
        progress = 1;
    }
    
    UILabel *sourceLabel = [self viewWithTag:index+10000];
    UILabel *targetLabel = [self viewWithTag:toIndex+10000];
    
    // 缩放渐变
    CGFloat delta = self.style.selectedDeltaScale;
    sourceLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1+(1-progress)*delta, 1+(1-progress)*delta);
    targetLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1+progress*delta, 1+progress*delta);
    
    // 将选中的label滚到中间
    [self scrollLabelAtIndexToCenter:toIndex fromLabelAtIndex:index progress:progress];
    
    // 底部线条跟随
    [self layoutBottomLineFromLabelAtIndex:index toLabelAtIndex:toIndex progress:progress];
    
    // 颜色渐变
    UIColor *sourceLabelSourceColor = self.style.selectedColor;
    UIColor *sourceLabelTargetColor = self.style.normalColor;
    
    UIColor *targetLabelSourceColor = self.style.normalColor;
    UIColor *targetLabelTargetColor = self.style.selectedColor;
   
    sourceLabel.textColor = [UIColor transitionColorFromColor:sourceLabelSourceColor toColor:sourceLabelTargetColor progress:progress];
    targetLabel.textColor = [UIColor transitionColorFromColor:targetLabelSourceColor toColor:targetLabelTargetColor progress:progress];
    
    if (progress == 1) {
        _selectedIndex = toIndex;
    }
}

- (void)scrollLabelAtIndexToCenter:(NSUInteger)toIndex fromLabelAtIndex:(NSUInteger)index progress:(CGFloat)progress {
    if (progress < 0 || progress > 1) {
        progress = 1;
    }
    
    CGPoint sourceOffset = [self contentOffsetWhenScrollLabelAtIndexToCenter:index];
    CGPoint targetOffset = [self contentOffsetWhenScrollLabelAtIndexToCenter:toIndex];
    
    CGFloat x = sourceOffset.x + (targetOffset.x-sourceOffset.x)*progress;
    
    [self setContentOffset:CGPointMake(x, 0) animated:NO];
}

- (void)scrollLabelAtIndexToCenter:(NSUInteger)toIndex animated:(BOOL)animated {
    CGPoint targetOffset = [self contentOffsetWhenScrollLabelAtIndexToCenter:toIndex];
    [self setContentOffset:targetOffset animated:animated];
}

// 将指定索引的label滚动到中心所需的contentOffset
- (CGPoint)contentOffsetWhenScrollLabelAtIndexToCenter:(NSUInteger)index {
    if (index >= self.titles.count) {
        return CGPointZero;
    }
    
    UILabel *targetLabel = [self viewWithTag:index+10000];
    
    CGPoint offset = CGPointZero;
    if (targetLabel.center.x <= self.bounds.size.width*0.5) {
        offset = CGPointZero;
    } else if (targetLabel.center.x >= self.contentSize.width - self.bounds.size.width*0.5) {
        offset = CGPointMake(self.contentSize.width - self.bounds.size.width, 0);
    } else {
        offset = CGPointMake(targetLabel.center.x - self.bounds.size.width*0.5, 0);
    }
    
    return offset;
}

- (void)layoutBottomLineToLabelAtIndexIfNeeded:(NSUInteger)index {
    if (!self.style.showBottomLine) {
        return;
    }
    
    UILabel *targetLabel = [self viewWithTag:index+10000];
    UIView *bottomLine = [self viewWithTag:9999];
    
    CGRect frame = CGRectMake(targetLabel.frame.origin.x, CGRectGetMaxY(self.bounds)-self.style.bottomLineHeight, targetLabel.frame.size.width, self.style.bottomLineHeight);
    if (!CGRectEqualToRect(frame, bottomLine.frame)) {
        bottomLine.frame = frame;
    }
}

- (void)layoutBottomLineToLabelAtIndex:(NSUInteger)index animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutBottomLineFromLabelAtIndex:_selectedIndex toLabelAtIndex:index progress:1];
        }];
    } else {
        [self layoutBottomLineFromLabelAtIndex:_selectedIndex toLabelAtIndex:index progress:1];
    }
}

- (void)layoutBottomLineFromLabelAtIndex:(NSUInteger)index toLabelAtIndex:(NSUInteger)toIndex progress:(CGFloat)progress {
    if (!self.style.showBottomLine) {
        return;
    }
    
    if (toIndex >= self.titles.count || index >= self.titles.count) {
        return;
    }
    if (progress < 0 || progress > 1) {
        progress = 1;
    }
//    NSLog(@"%s  %d --> %d  %f", __func__, index, toIndex, progress);
    UILabel *sourceLabel = [self viewWithTag:index+10000];
    UILabel *targetLabel = [self viewWithTag:toIndex+10000];
    UIView *bottomLine = [self viewWithTag:9999];

    CGFloat startX = sourceLabel.frame.origin.x;
    CGFloat endX = targetLabel.frame.origin.x;
    CGFloat startWidth = sourceLabel.frame.size.width;
    CGFloat endWidth = targetLabel.frame.size.width;
    
    CGFloat x = startX + (endX-startX)*progress;
    CGFloat width = startWidth + (endWidth-startWidth)*progress;
    
    bottomLine.frame = CGRectMake(x, CGRectGetMaxY(self.bounds)-self.style.bottomLineHeight, width, self.style.bottomLineHeight);
}

#pragma mark - JHSegmentContentViewDelegate
- (void)segmentContentViewScrollingFromIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex progress:(CGFloat)progress {
    [self animateFromTitleAtIndex:index toIndex:toIndex progress:progress];
}

@end
