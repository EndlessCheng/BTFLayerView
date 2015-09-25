//
//  BTFLineChartScrollView.m
//  BTFLineChartView
//
//  Created by chengyh on 15/9/24.
//  Copyright © 2015年 jianyan. All rights reserved.
//

#import "BTFLineChartScrollView.h"

#import "Prefix.pch"
#import "BTFLineChartView.h"
#import "BTFLineChartTypes.h"
#import "BTFLineChartViewModel.h"

const int CHART_VIEW_HEIGHT = 147;
const int LEFT_LABEL_VIEW_WIDTH = 66;
const int LINE_HEIGHT = 1;

const float TOP_SPACE_TO_SUPERVIEW = 11;

@implementation BTFLineChartScrollView

- (void)addChartViewWithYArray:(NSArray *)array seconds:(int)seconds
                    yScaleType:(BTFYScaleType)yScaleType minMaxLineType:(BTFMinMaxLineType)minMaxLineType
                         image:(UIImage *)image labelTitle:(NSString *)labelTitle unitTitle:(NSString *)unitTitle {
    assert([[self subviews] count] >= 2); // 初始就有2个subview
    int chartScrollSubViewsCount = [[self subviews] count] - 2;
    UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_SPACE_TO_SUPERVIEW + chartScrollSubViewsCount * CHART_VIEW_HEIGHT, SCREEN_WIDTH, CHART_VIEW_HEIGHT)];
    
    UIView *labelView = [self getLeftLabelViewWithFrame:CGRectMake(0, 0, LEFT_LABEL_VIEW_WIDTH, CHART_VIEW_HEIGHT) image:image labelTitle:labelTitle unitTitle:unitTitle];
    [frameView addSubview:labelView];
    
    BTFLineChartView *lineChartView = [[BTFLineChartView alloc] initWithFrame:CGRectMake(51, 0, SCREEN_WIDTH - 51, CHART_VIEW_HEIGHT) yScaleType:yScaleType minMaxLineType:minMaxLineType];
    lineChartView.model = [[BTFLineChartViewModel alloc] initWithArray:array seconds:seconds];
    [lineChartView drawChart];
    [frameView addSubview:lineChartView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CHART_VIEW_HEIGHT - LINE_HEIGHT, SCREEN_WIDTH, LINE_HEIGHT)];
    UIColor *separatorColor = [UIColor colorWithRed:134.0 / 255 green:145.0 / 255 blue:155.0 / 255 alpha:0.3];
    [lineView setBackgroundColor:separatorColor];
    [frameView addSubview:lineView];
    
    [self addSubview:frameView];
}

- (UIView *)getLeftLabelViewWithFrame:(CGRect)frame image:(UIImage *)image labelTitle:(NSString *)labelTitle unitTitle:(NSString *)unitTitle {
    UIColor *titleColor = [UIColor colorWithRed:65.0 / 255 green:76.0 / 255 blue:89.0 / 255 alpha:1.0];
    
    UIImageView *labelImg = [[UIImageView alloc] initWithImage:image];
    labelImg.center = CGPointMake(frame.size.width / 2, image.size.height / 2);
    
    int labelTitleFontSize = 12;
    UILabel *labelTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, labelImg.frame.origin.y + labelImg.frame.size.height + 5, frame.size.width, labelTitleFontSize)];
    [labelTitleLbl setText:labelTitle];
    [labelTitleLbl setFont:[UIFont systemFontOfSize:labelTitleFontSize]];
    [labelTitleLbl setTextColor:titleColor];
    [labelTitleLbl setTextAlignment:NSTextAlignmentCenter];
    
    int unitTitleFontSize = 9;
    UILabel *unitLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, labelTitleLbl.frame.origin.y + labelTitleLbl.frame.size.height + 4, frame.size.width, unitTitleFontSize)];
    [unitLbl setText:unitTitle];
    [unitLbl setFont:[UIFont systemFontOfSize:unitTitleFontSize]];
    [unitLbl setTextColor:[titleColor colorWithAlphaComponent:0.7]];
    [unitLbl setTextAlignment:NSTextAlignmentCenter];
    
    float contentViewHeight = unitLbl.frame.origin.y + unitLbl.frame.size.height;
    UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, (frame.size.height - contentViewHeight) / 2, frame.size.width, contentViewHeight)];
    [frameView addSubview:labelImg];
    [frameView addSubview:labelTitleLbl];
    [frameView addSubview:unitLbl];
    
    return frameView;
}

- (void)AllChartViewDidAdd {
    assert([[self subviews] count] >= 2);
    int chartScrollSubViewsCount = [[self subviews] count] - 2;
    [self setContentSize:CGSizeMake(SCREEN_WIDTH, TOP_SPACE_TO_SUPERVIEW + chartScrollSubViewsCount * CHART_VIEW_HEIGHT)];
}

@end