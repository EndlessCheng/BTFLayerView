//
// Created by chengyh on 15/8/7.
// Copyright (c) 2015 jianyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTFLineChartTypes.h"

@class BTFLineChartViewModel;

@interface BTFLineChartView : UIView

@property BTFLineChartViewModel* model;

- (id)initWithFrame:(CGRect)frame boldLinesColor:(UIColor *)boldLinesColor fillColor:(UIColor *)fillColor
         yScaleType:(BTFYScaleType)yScaleType minMaxLineType:(BTFMinMaxLineType)minMaxLineType;

- (void)drawChart;

@end