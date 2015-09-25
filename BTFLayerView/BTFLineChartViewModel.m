//
// Created by chengyh on 15/8/7.
// Copyright (c) 2015 jianyan. All rights reserved.
//

#import "BTFLineChartViewModel.h"

@implementation BTFLineChartViewModel {
    NSArray *_yArray;
    float _seconds;
    float _minutes;
    
    int _minYIndex;
    int _maxYIndex;
}

- (id)initWithArray:(NSArray *)yArray seconds:(float)seconds {
    self = [super init];

    if (self) {
        if (!yArray) {
            _yArray = @[@0, @0];
        } else if (yArray.count == 1) {
            _yArray = @[yArray[0], yArray[0]];
        } else {
            _yArray = [[NSArray alloc] initWithArray:yArray];
        }
        _seconds = seconds;
        _minutes = seconds / 60;
        
        _minY = INFINITY;
        _maxY = -INFINITY;
        for (int i = 0; i < _yArray.count; ++i) {
            float y = [_yArray[i] floatValue];
            if (y < _minY) {
                _minYIndex = i;
                _minY = y;
            }
            if (y > _maxY) {
                _maxYIndex = i;
                _maxY = y;
            }
        }
    }

    return self;
}

- (NSArray *)getXScaleStringsWithPartNumber:(int)partNumber {
    assert(partNumber > 1);
    
    NSMutableArray *xScaleStrings = [[NSMutableArray alloc] init];
    BOOL isLongTime = _seconds >= 300; // formula?
    float xGap = (isLongTime ? _minutes : _seconds) / (partNumber - 1);
    for (int i = 0; i < partNumber; i++) {
        NSString *xScaleString;
        if (i < partNumber - 1) {
            xScaleString = [NSString stringWithFormat:@"%d", (int) (xGap * i + 0.5)];
        } else {
            if (isLongTime) {
                xScaleString = [NSString stringWithFormat:@"%d(分钟)", (int) (xGap * i + 0.5)];
            } else {
                xScaleString = [NSString stringWithFormat:@"%d(秒)", (int) (xGap * i + 0.5)];
            }
        }
        [xScaleStrings addObject:xScaleString];
    }
    return xScaleStrings;
}

- (NSArray *)getYScaleStringsWithPartNumber:(int)partNumber yScaleType:(BTFYScaleType)yScaleType {
    assert(partNumber > 1);
    
    NSMutableArray *yScaleStrings = [[NSMutableArray alloc] init];
    switch (yScaleType) {
        case BTFYScaleStartFromZero: {
            float yGap = _maxY / (partNumber - 1);
            for (int i = 0; i < partNumber; i++) {
                [yScaleStrings addObject:[NSString stringWithFormat:@"%d", (int) (yGap * i + 0.5)]];
            }
            break;
        } case BTFYScaleStartAboutMinValue: {
            float yGap = (_maxY - _minY) / (partNumber - 1);
            for (int i = 0; i < partNumber; i++) {
                [yScaleStrings addObject:[NSString stringWithFormat:@"%d", (int) (_minY + yGap * i + 0.5)]];
            }
            break;
        } default:
            break;
    }
    return yScaleStrings;
}

- (CGPoint)getPointWithValueIndex:(int)valueIndex yScaleType:(BTFYScaleType)yScaleType {
    float x = ((float) valueIndex) / (_yArray.count - 1);
    float y;
    switch (yScaleType) {
        case BTFYScaleStartFromZero:
            y = [_yArray[valueIndex] floatValue] / _maxY;
            break;
        case BTFYScaleStartAboutMinValue:
            y = ([_yArray[valueIndex] floatValue] - _minY) / (_maxY - _minY);
            break;
        default:
            break;
    }
    
    return CGPointMake(x, y);
}

- (NSArray *)getUnitLineChartPointsWithYScaleType:(BTFYScaleType)yScaleType {
    NSMutableArray *unitLineChartPoints = [[NSMutableArray alloc] init];
    for (int i = 0; i < _yArray.count; ++i) {
        [unitLineChartPoints addObject:[NSValue valueWithCGPoint:[self getPointWithValueIndex:i yScaleType:yScaleType]]];
    }
    return unitLineChartPoints;
}

- (CGPoint)getUnitLineChartMinPointWithYScaleType:(BTFYScaleType)yScaleType {
    return [self getPointWithValueIndex:_minYIndex yScaleType:yScaleType];
}

- (CGPoint)getUnitLineChartMaxPointWithYScaleType:(BTFYScaleType)yScaleType {
    return [self getPointWithValueIndex:_maxYIndex yScaleType:yScaleType];
}

@end