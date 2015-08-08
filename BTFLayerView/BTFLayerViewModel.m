//
// Created by chengyh on 15/8/7.
// Copyright (c) 2015 jianyan. All rights reserved.
//

#import "BTFLayerViewModel.h"

@implementation BTFLayerViewModel {

}

- (id)initWithArray:(NSArray *)yArray
         runSeconds:(int)runSeconds {
    self = [super init];

    if (self) {
        _minPoint = CGPointMake(0, INFINITY);
        _maxPoint = CGPointMake(0, -INFINITY);
        for (unsigned int i = 0U; i < yArray.count; ++i) {
            float y = [yArray[i] floatValue];
            if (y < _minPoint.y) {
                _minPoint.x = i;
                _minPoint.y = y;
            }
            if (y > _maxPoint.y) {
                _maxPoint.x = i;
                _maxPoint.y = y;
            }
        }

        _points = [[NSMutableArray alloc] init];
        if (yArray.count == 1) {
            _minPoint.x = 0.0f;
            _maxPoint.x = 1.0f;
            [_points addObject:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]];
            [_points addObject:[NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)]];
        }
        else {
            _minPoint.x /= yArray.count - 1;
            _maxPoint.x /= yArray.count - 1;
            for (unsigned int i = 0U; i < yArray.count; ++i) {
                float x = ((float) i) / (yArray.count - 1);
                float y = [yArray[i] floatValue] / _maxPoint.y;
                NSValue *point = [NSValue valueWithCGPoint:CGPointMake(x, y)];
                if (![point isEqual:[NSNull null]]) {
                    [_points addObject:point];
                }
            }
        }
        _runSeconds = runSeconds;
    }

    return self;
}

@end