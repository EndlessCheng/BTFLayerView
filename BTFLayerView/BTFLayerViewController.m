//
//  BTFLayerViewController.m
//  BTFLayerView
//
//  Created by chengyh on 15/8/7.
//  Copyright (c) 2015 jianyan. All rights reserved.
//

#import "BTFLayerViewController.h"
#import "Prefix.pch"
#import "BTFLayerView.h"
#import "BTFLayerViewModel.h"

@interface BTFLayerViewController ()

@end

@implementation BTFLayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setChartView {
    UIColor *lightGrayColor = [UIColor colorWithRed:134.0f / 255
                                              green:145.0f / 255
                                               blue:155.0f / 255
                                              alpha:0.3f];
    int layerCount = 0;

    NSArray *array = @[@80.0f, @90.0f, @90.0f, @80.0f, @90.0f, @90.0f, @80.0f, @90.0f, @90.0f, @80.0f, @90.0f, @90.0f, @80.0f, @90.0f, @90.0f,];

    BTFLayerView *layerView = [[BTFLayerView alloc] initWithFrame:CGRectMake(54, 15, SCREEN_WIDTH - 64, 139)];
    BTFLayerViewModel *layerViewModel = [[BTFLayerViewModel alloc] initWithArray:array
                                                                      runSeconds:1320];
    layerView.model = layerViewModel;
    [layerView drawChart];
    [_chartScrollView addSubview:layerView];

    UIView *labelView = [self getLeftLabelViewWithFrame:CGRectMake(15, 55, 36, 60)
                                                  image:[UIImage imageNamed:@"chart_speed.png"]
                                             labelTitle:@"速度"
                                              unitTitle:@"km/h"];
    [_chartScrollView addSubview:labelView];


    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 15 + 139 + 4, SCREEN_WIDTH, 1)];
    [lineView setBackgroundColor:lightGrayColor];
    [_chartScrollView addSubview:lineView];

    layerCount++;

}

- (UIView *)getLeftLabelViewWithFrame:(CGRect)frame image:(UIImage *)image labelTitle:(NSString *)labelTitle unitTitle:(NSString *)unitTitle {
    CGSize size = frame.size;
    UIColor *titleColor = [UIColor colorWithRed:65.0f / 255 green:76.0f / 255 blue:89.0f / 255 alpha:1.0f];
    UIView *labelView = [[UIView alloc] initWithFrame:frame];

    UIImageView *labelImg = [[UIImageView alloc] initWithImage:image];
    [labelImg setFrame:CGRectMake((size.width - 26) / 2, 0, 26, 26)];

    UILabel *labelTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, size.width, 15)];
    [labelTitleLbl setText:labelTitle];
    [labelTitleLbl setFont:[UIFont systemFontOfSize:15]];
    [labelTitleLbl setTextColor:titleColor];
    [labelTitleLbl setTextAlignment:NSTextAlignmentCenter];

    UILabel *unitLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, size.width, 10)];
    [unitLbl setText:unitTitle];
    [unitLbl setFont:[UIFont systemFontOfSize:10]];
    [unitLbl setTextColor:titleColor];
    [unitLbl setTextAlignment:NSTextAlignmentCenter];

    [labelView addSubview:labelImg];
    [labelView addSubview:labelTitleLbl];
    [labelView addSubview:unitLbl];

    return labelView;
}

@end