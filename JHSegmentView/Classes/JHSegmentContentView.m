//
//  JHSegmentContentView.m
//  SegmentView
//
//  Created by mshqiu on 2017/4/12.
//  Copyright © 2017年 jinhui. All rights reserved.
//

#import "JHSegmentContentView.h"

@interface JHSegmentContentView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;
@property (nonatomic, weak) UIViewController *parentViewController;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHSegmentContentView {
    CGFloat _startContentOffsetX;
    CGFloat _endContentOffsetX;
    BOOL _skipCallBack;
    NSUInteger _selectedIndex;
    CGSize _lastSize;
}

- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray<UIViewController *> *)viewControllers parentViewController:(UIViewController *)parentViewController {
    if (self = [super initWithFrame:frame]) {
        _lastSize = self.bounds.size;
        self.layoutMargins = UIEdgeInsetsZero;
        
        [self addSubview:self.collectionView];
        
        self.viewControllers = viewControllers;
        self.parentViewController = parentViewController;
        
        if (self.parentViewController) {
            for (UIViewController *viewController in self.viewControllers) {
                [self.parentViewController addChildViewController:viewController];
            }
        }
    }
    [self setNeedsLayout];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(_lastSize, self.bounds.size)) {
        _lastSize = self.bounds.size;
        
        self.collectionView.frame = self.bounds;
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        layout.itemSize = self.bounds.size;
        [layout invalidateLayout];
        
        [self selectViewControllerAtIndex:_selectedIndex animated:NO];
    }
}

- (void)selectViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < self.viewControllers.count) {
        _selectedIndex = index;
        // 外部主动设置滚动位置时设置标志位，避免多次回调
        _skipCallBack = YES;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    }
}

#pragma mark - JHSegmentHeaderViewDelegate
- (void)segmentHeaderViewDidSelectItemAtIndex:(NSUInteger)index {
    [self selectViewControllerAtIndex:index animated:NO];
}

#pragma mark - UIScrollViewDelegate
// 以下代理方法按顺序执行
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _startContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _endContentOffsetX = scrollView.contentOffset.x;
    
    int index = (int)(_endContentOffsetX/self.bounds.size.width);
    int toIndex;
    CGFloat progress = (_endContentOffsetX - index*self.bounds.size.width)/self.bounds.size.width;
    
    // 处理代理方法回调
    if (_endContentOffsetX > _startContentOffsetX) {
        // 向左滚动
        if (_endContentOffsetX == (index*self.bounds.size.width)) {
            // 滚动到临界值
            _selectedIndex = index;
            toIndex = index;
            index = index-1;
            progress = 1.0;
        } else {
            toIndex = index+1;
        }
    } else {
        // 向右滚动
        toIndex = index;
        index = index+1;
        progress = 1.0 - progress;
    }
    
    if (!_skipCallBack && [self.delegate respondsToSelector:@selector(segmentContentViewScrollingFromIndex:toIndex:progress:)]) {
        [self.delegate segmentContentViewScrollingFromIndex:index toIndex:toIndex progress:progress];
    }
    _skipCallBack = NO;
    _startContentOffsetX = scrollView.contentOffset.x;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kCellID" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIViewController *viewController;
    @try {
        viewController = self.viewControllers[indexPath.item];
    } @catch (NSException *exception) {
        
    } @finally {
        viewController.view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:viewController.view];
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.contentView.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.sectionInset = UIEdgeInsetsZero;
        _layout.itemSize = self.bounds.size;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
        _collectionView.contentInset = UIEdgeInsetsZero;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"kCellID"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
