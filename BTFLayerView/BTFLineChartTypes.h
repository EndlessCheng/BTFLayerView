//
//  BTFLineChartTypes.h
//  BTFLineChartView
//
//  Created by chengyh on 15/9/24.
//  Copyright © 2015年 jianyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, BTFYScaleType) {
    BTFYScaleStartFromZero = 0,
    BTFYScaleStartAboutMinValue,
    BTFYScaleStartAboutMaxValue,
};

typedef NS_OPTIONS(NSUInteger, BTFMinMaxLineType) {
    BTFClearLineWithoutValue = 0,
    BTFClearLine,
    BTFNormalLine,
};