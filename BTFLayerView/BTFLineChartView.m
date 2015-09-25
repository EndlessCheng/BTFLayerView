//
// Created by chengyh on 15/8/7.
// Copyright (c) 2015 jianyan. All rights reserved.
//

#import "BTFLineChartView.h"
#import "BTFLineChartViewModel.h"

#import "Prefix.pch"

const int HORIZONTAL_LINE_NUMBER = 6;
const int VERTICAL_LINE_NUMBER = 9;

const float AXES_LINE_WIDTH = 1.0;
const float MIN_MAX_LINE_WIDTH = 2.0;
const float BOLD_LINES_WIDTH = 2.0;

const int SCALE_FONT_SIZE = 7;

const float X_SCALE_TOP_SPACE_TO_TABLE = 6.0;
const float Y_SCALE_RIGHT_SPACE_TO_TABLE = 6.0;

@implementation BTFLineChartView {
    CGPoint _originPoint;
    float _chartWidth;
    float _chartHeight;
    
    UIColor *_boldLinesColor;
    UIColor *_fillColor;
    
    BTFYScaleType _yScaleType;
    BTFMinMaxLineType _minMaxLineType;
}

- (id)initWithFrame:(CGRect)frame boldLinesColor:(UIColor *)boldLinesColor fillColor:(UIColor *)fillColor
         yScaleType:(BTFYScaleType)yScaleType minMaxLineType:(BTFMinMaxLineType)minMaxLineType {
    self = [super initWithFrame:frame];
    
    if (self) {
        _originPoint = CGPointMake(25, self.frame.size.height - 28);
        _chartWidth = self.frame.size.width - 50;
        _chartHeight = self.frame.size.height - 62;
        
        _boldLinesColor = boldLinesColor;
        _fillColor = fillColor;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        _yScaleType = yScaleType;
        _minMaxLineType = minMaxLineType;
    }

    return self;
}

- (CGPoint)changePointToLayerPoint:(CGPoint)point {
    float x = _originPoint.x + point.x * _chartWidth;
    float y = _originPoint.y - point.y * _chartHeight;
    return CGPointMake(x, y);
}

- (void)drawChart {
    if (_model) {
        [self drawXYLines];
        [self drawScales];
        [self drawArea];
        [self drawBoldLines];
        
        CGPoint minUnitPoint = [_model getUnitLineChartMinPointWithYScaleType:_yScaleType];
        CGPoint maxUnitPoint = [_model getUnitLineChartMaxPointWithYScaleType:_yScaleType];
        UIColor *minPointColor = [UIColor colorWithRed:3.0 / 255 green:169.0 / 255 blue:252.0 / 255 alpha:1.0];
        UIColor *maxPointColor = [UIColor colorWithRed:241.0 / 255 green:90.0 / 255 blue:36.0 / 255 alpha:1.0];
        if (_minMaxLineType == BTFNormalLine) {
            UIColor *minLineColor = [minPointColor colorWithAlphaComponent:0.5];
            UIColor *maxLineColor = [maxPointColor colorWithAlphaComponent:0.5];
            [self drawMinMaxLineWithUnitPoint:minUnitPoint pointColor:minPointColor lineColor:minLineColor];
            [self drawMinMaxLineWithUnitPoint:maxUnitPoint pointColor:maxPointColor lineColor:maxLineColor];
        }
        if (_minMaxLineType != BTFClearLineWithoutValue) {
            [self drawStringWithValue:_model.minY position:[self changePointToLayerPoint:minUnitPoint] backgroundColor:minPointColor];
            [self drawStringWithValue:_model.maxY position:[self changePointToLayerPoint:maxUnitPoint] backgroundColor:maxPointColor];
        }
    }
}

- (CAShapeLayer *)getShapeLayerWithLineWidth:(float)lineWidth color:(UIColor *)color {
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.strokeColor = color.CGColor;
    return shapeLayer;
}

- (void)drawXYLines {
    UIColor *tableLineColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1.0];
    UIColor *tableSeparatorColor = [tableLineColor colorWithAlphaComponent:0.3];

    // 画X轴和刻度线
    CAShapeLayer *shapeLayerX = [self getShapeLayerWithLineWidth:AXES_LINE_WIDTH color:tableLineColor];
    [self.layer addSublayer:shapeLayerX];
    UIBezierPath *pathX = [UIBezierPath bezierPath];
    [pathX moveToPoint:CGPointMake(_originPoint.x, _originPoint.y)];
    [pathX addLineToPoint:CGPointMake(_originPoint.x + _chartWidth, _originPoint.y)];
    float xGap = _chartWidth / (VERTICAL_LINE_NUMBER - 1);
    for (int i = 0; i < VERTICAL_LINE_NUMBER; ++i) {
        float posX = _originPoint.x + xGap * i;
        [pathX moveToPoint:CGPointMake(posX, _originPoint.y)];
        float scaleLineLength = (i & 1 ? 2 : 3);
        [pathX addLineToPoint:CGPointMake(posX, _originPoint.y + scaleLineLength)];
    }
    shapeLayerX.path = pathX.CGPath;

    // 画横线
    CAShapeLayer *shapeLayer = [self getShapeLayerWithLineWidth:AXES_LINE_WIDTH color:tableSeparatorColor];
    [self.layer addSublayer:shapeLayer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    float yGap = _chartHeight / (HORIZONTAL_LINE_NUMBER - 1);
    for (int i = 1; i < HORIZONTAL_LINE_NUMBER; i++) {
        float posY = _originPoint.y - yGap * i;
        [path moveToPoint:CGPointMake(_originPoint.x, posY)];
        [path addLineToPoint:CGPointMake(_originPoint.x + _chartWidth, posY)];
    }
    shapeLayer.path = path.CGPath;

    // 画竖虚线
    CAShapeLayer *shapeLayerY = [self getShapeLayerWithLineWidth:AXES_LINE_WIDTH color:tableSeparatorColor];
    [shapeLayerY setLineDashPattern:@[@3, @2]]; // 虚线: 长度, 间距
    [self.layer addSublayer:shapeLayerY];
    UIBezierPath *pathY = [UIBezierPath bezierPath];
    for (int i = 1; i < VERTICAL_LINE_NUMBER - 1; i++) { // 第一条和最后一条不画
        float posX = _originPoint.x + xGap * i;
        [pathY moveToPoint:CGPointMake(posX, _originPoint.y - _chartHeight)];
        [pathY addLineToPoint:CGPointMake(posX, _originPoint.y)];
    }
    shapeLayerY.path = pathY.CGPath;
}

- (void)drawScales {
    UIColor *xScaleColor = [UIColor colorWithRed:4.0 / 255 green:22.0 / 255 blue:53.0 / 255 alpha:1.0];
    UIColor *yScaleColor = [UIColor colorWithRed:85.0 / 255 green:119.0 / 255 blue:148.0 / 255 alpha:1.0];
    UIFont *font = [UIFont systemFontOfSize:SCALE_FONT_SIZE];

    // 画x轴上的刻度
    NSArray *xScaleStrings = [_model getXScaleStringsWithPartNumber:VERTICAL_LINE_NUMBER / 2 + 1];
    for (int i = 0; i < xScaleStrings.count; i++) {
        CGSize xScaleStringSize = [xScaleStrings[i] sizeWithAttributes:@{NSFontAttributeName:font}];
        float posX = _originPoint.x + i * _chartWidth / (VERTICAL_LINE_NUMBER / 2) - xScaleStringSize.width / 2;
        [self drawStringWithString:xScaleStrings[i] textColor:xScaleColor font:font
                             frame:CGRectMake(posX, _originPoint.y + X_SCALE_TOP_SPACE_TO_TABLE, xScaleStringSize.width, xScaleStringSize.height)
                   backgroundColor:[UIColor clearColor]];
    }
    
    // 画y轴上的刻度(包括最低点)
    NSArray *yScaleStrings = [_model getYScaleStringsWithPartNumber:HORIZONTAL_LINE_NUMBER yScaleType:BTFYScaleStartFromZero];
    for (int i = 0; i < yScaleStrings.count; i++) {
        CGSize yScaleStringSize = [yScaleStrings[i] sizeWithAttributes:@{NSFontAttributeName:font}];
        float posY = _originPoint.y - i * _chartHeight / (HORIZONTAL_LINE_NUMBER - 1) - yScaleStringSize.width / 2;
        [self drawStringWithString:yScaleStrings[i] textColor:yScaleColor font:font
                             frame:CGRectMake(_originPoint.x - Y_SCALE_RIGHT_SPACE_TO_TABLE - yScaleStringSize.width, posY, yScaleStringSize.width, yScaleStringSize.height)
                   backgroundColor:[UIColor clearColor]];
    }
}

- (void)drawStringWithString:(NSString *)string
                   textColor:(UIColor *)color
                        font:(UIFont *)font
                       frame:(CGRect)frame
             backgroundColor:(UIColor *)backgroundColor {
    CATextLayer *xTextLayer = [CATextLayer layer];

    CFStringRef fontName = (__bridge CFStringRef) font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    xTextLayer.font = fontRef;
    CGFontRelease(fontRef);

    xTextLayer.frame = frame;
    xTextLayer.fontSize = font.pointSize;
    xTextLayer.foregroundColor = color.CGColor;
    xTextLayer.backgroundColor = backgroundColor.CGColor;
    xTextLayer.alignmentMode = kCAAlignmentCenter;
    xTextLayer.wrapped = YES;
    xTextLayer.string = string;
    xTextLayer.contentsScale = [UIScreen mainScreen].scale;
    xTextLayer.cornerRadius = 3.0;

    [self.layer addSublayer:xTextLayer];
}

- (void)drawBoldLines {
    CAShapeLayer *lineShapeLayer = [self getShapeLayerWithLineWidth:BOLD_LINES_WIDTH color:_boldLinesColor];
    [self.layer addSublayer:lineShapeLayer];
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    NSArray *unitLineChartPoints = [_model getUnitLineChartPointsWithYScaleType:_yScaleType];
    
    for (int i = 0; i < unitLineChartPoints.count - 1; ++i) {
        [linePath moveToPoint:[self changePointToLayerPoint:((NSValue *)unitLineChartPoints[i]).CGPointValue]];
        [linePath addLineToPoint:[self changePointToLayerPoint:((NSValue *)unitLineChartPoints[i + 1]).CGPointValue]];
        
    }
    lineShapeLayer.path = linePath.CGPath;
}

- (void)drawArea {
    // 创建CGContextRef
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    // 创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _originPoint.x, _originPoint.y);
    NSArray *unitLineChartPoints = [_model getUnitLineChartPointsWithYScaleType:_yScaleType];
    for (NSValue *unitPointValue in unitLineChartPoints) {
        CGPoint unitPoint = [self changePointToLayerPoint:unitPointValue.CGPointValue];
        CGPathAddLineToPoint(path, NULL, unitPoint.x, unitPoint.y);
    }
    CGPathAddLineToPoint(path, NULL, _originPoint.x + _chartWidth, _originPoint.y);
    UIColor *startColor = _fillColor;
    [self drawLinearGradient:gc path:path startColor:startColor.CGColor endColor:startColor.CGColor];
    CGPathRelease(path); // 注意释放CGMutablePathRef

    // 从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    CAShapeLayer *slayer = [CAShapeLayer layer];
    slayer.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    slayer.contents = (id) img.CGImage;
    [self.layer addSublayer:slayer];

    UIGraphicsEndImageContext();
}

// 渐变色辅助函数
- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);

    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    CGFloat locations[] = {0.0, 1.0};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0); // *

    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)drawMinMaxLineWithUnitPoint:(CGPoint)unitPoint pointColor:(UIColor *)pointColor lineColor:(UIColor *)lineColor {
    // 画点
    CGPoint layerPoint = [self changePointToLayerPoint:unitPoint];

    CAShapeLayer *pointShapeLayer = [CAShapeLayer new];
    pointShapeLayer.lineCap = kCALineCapRound;
    pointShapeLayer.lineWidth = 1.0;
    pointShapeLayer.fillColor = pointColor.CGColor;
    [self.layer addSublayer:pointShapeLayer];

    UIBezierPath *pointPath = [UIBezierPath bezierPath];
    [pointPath addArcWithCenter:layerPoint radius:2.0 startAngle:0.0 endAngle:180.0 clockwise:YES];
    pointShapeLayer.path = pointPath.CGPath; // 关联layer和贝塞尔路径

    // 画线
    CAShapeLayer *lineShapeLayer = [self getShapeLayerWithLineWidth:MIN_MAX_LINE_WIDTH color:lineColor];
    [self.layer addSublayer:lineShapeLayer];

    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:layerPoint];
    [linePath addLineToPoint:[self changePointToLayerPoint:CGPointMake(unitPoint.x, 0.0)]];
    lineShapeLayer.path = linePath.CGPath;

    // draw
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(0.0);
    animation.toValue = @(0.0);
    animation.duration = 0.0;
    [pointShapeLayer addAnimation:animation forKey:nil];
    pointShapeLayer.strokeEnd = 1;
    [lineShapeLayer addAnimation:animation forKey:nil];
    lineShapeLayer.strokeEnd = 1;
}

- (void)drawStringWithValue:(int)value position:(CGPoint)position backgroundColor:(UIColor *)backgroundColor {
    NSString *valueString = [NSString stringWithFormat:@"%d", (int) value];
    float textWidth = valueString.length * 8.0f;
    float textHeight = 13.0f;
    CGRect minFrame = CGRectMake(position.x - textWidth / 2, position.y - 15, textWidth, textHeight);
    UIColor *textColor = [UIColor whiteColor];
    UIFont *font = [UIFont systemFontOfSize:13];
    [self drawStringWithString:valueString textColor:textColor font:font frame:minFrame backgroundColor:backgroundColor];
}

@end