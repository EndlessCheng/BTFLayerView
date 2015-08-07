//
// Created by chengyh on 15/8/7.
// Copyright (c) 2015 jianyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTFLayerViewModel;

@interface BTFLayerView : UIView {
    CGPoint _originPoint;
    float _chartWidth;
    float _chartHeight;
}

@property BTFLayerViewModel* model;

- (void)drawChart;

@end