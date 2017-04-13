//
//  UIColor+Transition.m
//  SegmentView
//
//  Created by minshun on 2017/4/13.
//  Copyright © 2017年 jinhui. All rights reserved.
//

#import "UIColor+Transition.h"

@implementation UIColor (Transition)

+ (UIColor *)transitionColorFromColor:(UIColor *)color toColor:(UIColor *)toColor progress:(CGFloat)progress {
    if (progress < 0 || progress > 1) {
        progress = 1;
    }
    
    CGFloat r, g, b;
    CGFloat toR, toG, toB;
    
    [color getRed:&r green:&g blue:&b alpha:nil];
    [toColor getRed:&toR green:&toG blue:&toB alpha:nil];
    
    r = r + (toR-r)*progress;
    g = g + (toG-g)*progress;
    b = b + (toB-b)*progress;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end
