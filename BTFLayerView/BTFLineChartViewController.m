//
//  BTFLineChartViewController.m
//  BTFLineChartView
//
//  Created by chengyh on 15/8/7.
//  Copyright (c) 2015 jianyan. All rights reserved.
//

#import "BTFLineChartViewController.h"

#import "BTFRange.h"

@implementation BTFLineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    srand48(arc4random());
    
    [_lineChartScrollView addChartViewWithYArray:[self generateRamdomArrayWithRange:BTFMakeRange(10, 15)] seconds:1320
                                      yScaleType:BTFYScaleStartFromZero minMaxLineType:BTFClearLine
                                           image:[UIImage imageNamed:@"chart_speed.png"] labelTitle:@"速度" unitTitle:@"km/h"];
    [_lineChartScrollView AllChartViewDidAdd];
}

- (NSArray *)generateRamdomArrayWithRange:(BTFRange)range {
    NSMutableArray *randomArray = [[NSMutableArray alloc] init];
    int randomTimes = 30;
    for (int i = 0; i < randomTimes; ++i) {
        [randomArray addObject:@(range.location + drand48() * range.length)];
    }
    return randomArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end