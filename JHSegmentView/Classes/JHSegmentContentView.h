//
//  JHSegmentContentView.h
//  SegmentView
//
//  Created by mshqiu on 2017/4/12.
//  Copyright © 2017年 jinhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSegmentViewDelegate.h"

@interface JHSegmentContentView : UIView <JHSegmentHeaderViewDelegate>

@property (nonatomic, weak) id<JHSegmentContentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray<UIViewController *> *)viewControllers parentViewController:(UIViewController *)parentViewController;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)selectViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end
