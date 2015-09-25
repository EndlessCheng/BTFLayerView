//
//  BTFLineChartScrollView.h
//  BTFLineChartView
//
//  Created by chengyh on 15/9/24.
//  Copyright © 2015年 jianyan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTFLineChartTypes.h"

@interface BTFLineChartScrollView : UIScrollView

- (void)addChartViewWithYArray:(NSArray *)array seconds:(int)seconds
                boldLinesColor:(UIColor *)boldLinesColor fillColor:(UIColor *)fillColor
                    yScaleType:(BTFYScaleType)yScaleType minMaxLineType:(BTFMinMaxLineType)minMaxLineType
                         image:(UIImage *)image labelTitle:(NSString *)labelTitle unitTitle:(NSString *)unitTitle;

- (void)AllChartViewDidAdd;

@end