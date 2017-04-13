//
//  JHViewController.m
//  JHSegmentView
//
//  Created by mshqiu on 04/13/2017.
//  Copyright (c) 2017 mshqiu. All rights reserved.
//

#import "JHViewController.h"
#import "JHSegmentView.h"

@interface JHViewController ()

@end

@implementation JHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:[UIColor redColor]];
    [colors addObject:[UIColor yellowColor]];
    [colors addObject:[UIColor greenColor]];
    [colors addObject:[UIColor blueColor]];
    [colors addObject:[UIColor grayColor]];
    
    JHSegmentStyle *style = [[JHSegmentStyle alloc] init];
    style.selectedDeltaScale = 0.16;
    style.showBottomLine = YES;
    
    NSArray *titles = @[@"全部", @"资产支持计划", @"银杏系列", @"资管计划", @"信托计划", @"收益凭证", @"高端理财", @"优选理财", @"定期理财"];
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = colors[i%colors.count];
        [viewControllers addObject:viewController];
    }
    
    CGRect frame = CGRectMake(0, 64, self.view.bounds.size.width, 30);
    JHSegmentHeaderView *headerView = [[JHSegmentHeaderView alloc] initWithFrame:frame titles:titles style:style];
    headerView.tag = 111;
    headerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:headerView];
    
    frame.origin.y = 64 + 30;
    frame.size.height = self.view.bounds.size.height - 64 - 30;
    
    JHSegmentContentView *contentView = [[JHSegmentContentView alloc] initWithFrame:frame viewControllers:viewControllers parentViewController:self];
    contentView.tag = 222;
    [self.view addSubview:contentView];
    
    headerView.segmentDelegate = contentView;
    contentView.delegate = headerView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UIView *headerView = [self.view viewWithTag:111];
    UIView *contentView = [self.view viewWithTag:222];
    
    CGRect frame = CGRectZero;
    frame.origin.y = 64;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = 30;
    headerView.frame = frame;
    
    frame.origin.y = CGRectGetMaxY(frame);
    frame.size.height = self.view.bounds.size.height - frame.origin.y;
    contentView.frame = frame;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
