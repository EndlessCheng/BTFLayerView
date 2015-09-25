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
    
    NSArray *imageNames = @[@"chart_heartrate.png", @"chart_speed.png", @"chart_cadence.png", @"chart_altitude.png"];
    NSArray *labelTitles = @[@"心率", @"速度", @"踏频", @"海拔"];
    NSArray *unitTitles = @[@"(次/分钟)", @"(公里/小时)", @"(转/分钟)", @"(米)"];
    
    assert(imageNames.count == labelTitles.count && imageNames.count == unitTitles.count);
    
    for (int i = 0; i < imageNames.count; ++i) {
        [_lineChartScrollView addChartViewWithYArray:[self generateRamdomArrayWithRange:BTFMakeRange(10, 15)] seconds:7200
                                          yScaleType:BTFYScaleStartFromZero minMaxLineType:BTFClearLineWithoutValue
                                               image:[UIImage imageNamed:imageNames[i]] labelTitle:labelTitles[i] unitTitle:unitTitles[i]];
    }
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