//
// Created by chengyh on 15/8/7.
// Copyright (c) 2015 jianyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "BTFLineChartTypes.h"

@interface BTFLineChartViewModel : NSObject

@property (nonatomic) float minY;
@property (nonatomic) float maxY;

- (id)initWithArray:(NSArray *)yArray seconds:(float)seconds;

- (NSArray *)getXScaleStringsWithPartNumber:(int)partNumber;
- (NSArray *)getYScaleStringsWithPartNumber:(int)partNumber yScaleType:(BTFYScaleType)yScaleType;

- (NSArray *)getUnitLineChartPointsWithYScaleType:(BTFYScaleType)yScaleType;
- (CGPoint)getUnitLineChartMinPointWithYScaleType:(BTFYScaleType)yScaleType;
- (CGPoint)getUnitLineChartMaxPointWithYScaleType:(BTFYScaleType)yScaleType;

@end