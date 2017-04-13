//
//  UIColor+Transition.h
//  SegmentView
//
//  Created by minshun on 2017/4/13.
//  Copyright © 2017年 jinhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Transition)

+ (UIColor *)transitionColorFromColor:(UIColor *)color toColor:(UIColor *)toColor progress:(CGFloat)progress;

@end
