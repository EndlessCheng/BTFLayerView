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

    int i = 0; // 记录图表个数

//    _heartRates = _recordFile.heartRates;
//    _runTime =self.recordPackage.recordPackageDuration.intValue;
//    if (!_heartRates) {
    NSArray *array = @[@80.0f, @90.0f, @90.0f, @80.0f, @90.0f, @90.0f, @80.0f, @90.0f, @90.0f, @80.0f, @90.0f, @90.0f, @80.0f, @90.0f, @90.0f,];
//    }
//    NSLog(@"_heartRates==nil: %d", _heartRates==nil);
//    if (_heartRates /*&& _heartRates.count > 1*/) {

    BTFLayerView *layerView = [[BTFLayerView alloc] initWithFrame:CGRectMake(54, 15, SCREEN_WIDTH - 64, 139)];
    BTFLayerViewModel *layerViewModel = [[BTFLayerViewModel alloc] initWithArray:array
                                                                      runSeconds:1320];
    layerView.model = layerViewModel;
    [layerView drawChart];

    [_chartScrollView addSubview:layerView];

//    UIView *signView = [self getLeftSignViewWithFrame:CGRectMake(15, 55, 36, 60)
//                                                image:[UIImage imageNamed:@"chart_heartrate.png"]
//                                            signTitle:@"心率"
//                                            unitTitle:@"bpm"];
//    [_chartScrollView addSubview:signView];


    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 15 + 139 + 4, SCREEN_WIDTH, 1)];
    [lineView setBackgroundColor:lightGrayColor];
    [_chartScrollView addSubview:lineView];

    i++;
//    }

}

@end