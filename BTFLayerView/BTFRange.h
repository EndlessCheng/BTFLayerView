//
//  BTFRange.h
//  BTFLayerView
//
//  Created by chengyh on 15/9/23.
//  Copyright © 2015年 jianyan. All rights reserved.
//

#import <Foundation/NSValue.h>
#import <Foundation/NSObjCRuntime.h>

typedef struct BTFRange {
    NSInteger location;
    NSInteger length;
} BTFRange;

NS_INLINE BTFRange BTFMakeRange(NSInteger loc, NSInteger len) {
    BTFRange r;
    r.location = loc;
    r.length = len;
    return r;
}
