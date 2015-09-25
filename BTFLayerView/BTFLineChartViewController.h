//
//  BTFLineChartViewController.h
//  BTFLineChartView
//
//  Created by chengyh on 15/8/7.
//  Copyright (c) 2015 jianyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTFLineChartScrollView.h"

@interface BTFLineChartViewController : UIViewController

@property(weak, nonatomic) IBOutlet UIView *lineChartView;
@property(weak, nonatomic) IBOutlet BTFLineChartScrollView *lineChartScrollView;

@end
