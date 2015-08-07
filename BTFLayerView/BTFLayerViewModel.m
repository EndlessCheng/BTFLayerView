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
        _maxY = -INFINITY;
        for (NSNumber *y in yArray) {
            _maxY = MAX(_maxY, [y floatValue]);
        }

        _points = [[NSMutableArray alloc] init];
        [_points addObject:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)]];
        for (unsigned int i = 0U; i < yArray.count; ++i) {
            float x = ((float) (i + 1)) / yArray.count;
            float y = [yArray[i] floatValue] / _maxY;
            NSValue *point = [NSValue valueWithCGPoint:CGPointMake(x, y)];
            if (![point isEqual:[NSNull null]]) {
                [_points addObject:point];
            }
        }

        _runSeconds = runSeconds;
    }

    return self;
}

@end