//
//  BTFLineChartTypes.h
//  BTFLineChartView
//
//  Created by chengyh on 15/9/24.
//  Copyright © 2015年 jianyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, BTFYScaleType) {
    BTFYScaleStartFromZero = 0, // Y轴从0开始
    BTFYScaleStartAboutMinValue, // Y轴从（最小值再减小一点）开始
    BTFYScaleStartAboutMaxValue, // Y轴从最大值往上减小
};

typedef NS_OPTIONS(NSUInteger, BTFMinMaxLineType) {
    BTFClearLineWithoutValue = 0, // 不显示最值标记线及最值
    BTFClearLine, // 不显示最值标记线，显示最值
    BTFNormalLine, // 显示最值标记线及最值
};