//
// Created by chengyh on 15/8/7.
// Copyright (c) 2015 jianyan. All rights reserved.
//

#import "BTFLayerView.h"
#import "BTFLayerViewModel.h"

const int HORIZONTAL_LINE_NUMBER = 6;
const int VERTICAL_LINE_NUMBER = 6;
const float AXES_LINE_WIDTH = 1.0f;
const float MIN_MAX_LINE_WIDTH = 2.0f;

const int Y_SCALE_RIGHT_MARGIN = 22;

@implementation BTFLayerView {

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        _originPoint = CGPointMake(30, self.frame.size.height - 20);
        _chartWidth = self.frame.size.width - 60;
        _chartHeight = self.frame.size.height - 50;

        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }

    return self;
}

- (void)drawChart {
    if (_model) {
        [self prepareForDraw];
        [self drawXYLines];
        [self drawScales];
        [self drawArea];

        CGPoint normalMinPoint = CGPointMake(_model.minPoint.x, _model.minPoint.y / _model.maxPoint.y);
        CGPoint normalMaxPoint = CGPointMake(_model.maxPoint.x, 1.0f);
        UIColor *softBlue = [UIColor colorWithRed:3.0f / 255 green:169.0f / 255 blue:252.0f / 255 alpha:1.0f];
        UIColor *softRed = [UIColor colorWithRed:241.0f / 255 green:90.0f / 255 blue:36.0f / 255 alpha:1.0f];
        UIColor *softLightBlue = [UIColor colorWithRed:3.0f / 255 green:169.0f / 255 blue:252.0f / 255 alpha:0.5f];
        UIColor *softLightRed = [UIColor colorWithRed:241.0f / 255 green:90.0f / 255 blue:36.0f / 255 alpha:0.5f];
        [self drawMinMaxLineWithPoint:normalMinPoint value:_model.minPoint.y pointColor:softBlue lineColor:softLightBlue];
        [self drawMinMaxLineWithPoint:normalMaxPoint value:_model.maxPoint.y pointColor:softRed lineColor:softLightRed];
    }
}

- (CGPoint)changePointToLayerPoint:(CGPoint)point {
    float x = _originPoint.x + point.x * _chartWidth;
    float y = _originPoint.y - point.y * _chartHeight;
    CGPoint layerPoint = (CGPoint) {x, y};
    return layerPoint;
}

- (CAShapeLayer *)getShapeLayerWithLineWidth:(float)lineWidth color:(UIColor *)color {
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = lineWidth;
    shapeLayer.strokeColor = color.CGColor;
    return shapeLayer;
}

- (void)prepareForDraw {
}

- (void)drawXYLines {
    UIColor *grayColor = [UIColor colorWithRed:153.0f / 255 green:153.0f / 255 blue:153.0f / 255 alpha:1.0f];
    UIColor *lightGrayColor = [UIColor colorWithRed:153.0f / 255 green:153.0f / 255 blue:153.0f / 255 alpha:0.3f];

    // 画X轴
    CAShapeLayer *shapeLayerX = [self getShapeLayerWithLineWidth:AXES_LINE_WIDTH color:grayColor];
    [self.layer addSublayer:shapeLayerX];
    UIBezierPath *pathX = [UIBezierPath bezierPath];
    [pathX moveToPoint:CGPointMake(_originPoint.x, _originPoint.y)];
    [pathX addLineToPoint:CGPointMake(_originPoint.x + _chartWidth, _originPoint.y)];
    shapeLayerX.path = pathX.CGPath;

    // 画横线
    CAShapeLayer *shapeLayer = [self getShapeLayerWithLineWidth:AXES_LINE_WIDTH color:lightGrayColor];
    [self.layer addSublayer:shapeLayer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    float yGap = _chartHeight / (HORIZONTAL_LINE_NUMBER - 1);
    for (int i = 1; i < HORIZONTAL_LINE_NUMBER; i++) {
        float posY = _originPoint.y - yGap * i;
        [path moveToPoint:CGPointMake(_originPoint.x, posY)];
        [path addLineToPoint:CGPointMake(_originPoint.x + _chartWidth, posY)];
    }
    shapeLayer.path = path.CGPath;

    // 画竖线
    CAShapeLayer *shapeLayerY = [self getShapeLayerWithLineWidth:AXES_LINE_WIDTH color:lightGrayColor];
    [shapeLayerY setLineDashPattern:@[@3, @2]]; // 虚线: 长度, 间距
    [self.layer addSublayer:shapeLayerY];
    UIBezierPath *pathY = [UIBezierPath bezierPath];
    float xGap = _chartWidth / (VERTICAL_LINE_NUMBER - 1);
    for (int i = 1; i < VERTICAL_LINE_NUMBER - 1; i++) { // 第一条和最后一条不画
        float posX = _originPoint.x + xGap * i;
        [pathY moveToPoint:CGPointMake(posX, _originPoint.y - _chartHeight)];
        [pathY addLineToPoint:CGPointMake(posX, _originPoint.y)];
    }
    shapeLayerY.path = pathY.CGPath;
}

- (void)drawScales {
    UIColor *xScaleColor = [UIColor colorWithRed:4.0f / 255 green:22.0f / 255 blue:53.0f / 255 alpha:1.0];
    UIColor *yScaleColor = [UIColor colorWithRed:85.0f / 255 green:119.0f / 255 blue:148.0f / 255 alpha:1.0f];
    UIFont *font = [UIFont systemFontOfSize:7];

    // 画x轴上的刻度
    float xGap = _model.runSeconds / (VERTICAL_LINE_NUMBER - 1);
    for (int i = 0; i < VERTICAL_LINE_NUMBER; i++) {
        NSString *xScaleString = [NSString stringWithFormat:@"%d", (int) (xGap * i)];
        float posX = _originPoint.x - 15 + i * _chartWidth / (VERTICAL_LINE_NUMBER - 1);
        [self drawStringWithStr:xScaleString textColor:xScaleColor font:font
                          frame:CGRectMake(posX, _originPoint.y, 30.0f, 11.0f)
                backgroundColor:[UIColor clearColor]];
    }

    // 画y轴上的刻度(包括最低点)
    float yGap = _model.maxPoint.y / (HORIZONTAL_LINE_NUMBER - 1);
    for (int i = 0; i < HORIZONTAL_LINE_NUMBER; i++) {
        NSString *yScaleString = [NSString stringWithFormat:@"%d", (int) (yGap * i)];
        float posY = _originPoint.y - 5 - i * _chartHeight / (HORIZONTAL_LINE_NUMBER - 1);
        [self drawStringWithStr:yScaleString textColor:yScaleColor font:font
                          frame:CGRectMake(_originPoint.x - Y_SCALE_RIGHT_MARGIN, posY, 30.0f, 10.0f)
                backgroundColor:[UIColor clearColor]];
    }
}

- (void)drawStringWithStr:(NSString *)string
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
    xTextLayer.cornerRadius = 3.0f;

    [self.layer addSublayer:xTextLayer];
}

- (void)drawArea {
    // 创建CGContextRef
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();

    // 创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _originPoint.x, _originPoint.y);
    for (unsigned int i = 0; i < _model.points.count; i++) {
        CGPoint point = [self changePointToLayerPoint:[_model.points[i] CGPointValue]];
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
    }
    CGPathAddLineToPoint(path, NULL, _originPoint.x + _chartWidth, _originPoint.y);
    UIColor *startColor = [UIColor colorWithRed:1.0f green:210.0f / 255 blue:20.0f / 255 alpha:0.5f];
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
    CGFloat locations[] = {0.0f, 1.0f};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0); // *

    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

- (void)drawMinMaxLineWithPoint:(CGPoint)point value:(float)value pointColor:(UIColor *)pointColor lineColor:(UIColor *)lineColor {
    // 画点
    CGPoint layerPoint = [self changePointToLayerPoint:point];

    CAShapeLayer *pointShapeLayer = [CAShapeLayer new];
    pointShapeLayer.lineCap = kCALineCapRound;
    pointShapeLayer.lineWidth = 1.0f;
    pointShapeLayer.fillColor = pointColor.CGColor;
    [self.layer addSublayer:pointShapeLayer];

    UIBezierPath *pointPath = [UIBezierPath bezierPath];
    [pointPath addArcWithCenter:layerPoint radius:2.0f startAngle:0.0f endAngle:180.0f clockwise:YES];
    pointShapeLayer.path = pointPath.CGPath; // 关联layer和贝塞尔路径

    // 画线
    CAShapeLayer *lineShapeLayer = [self getShapeLayerWithLineWidth:MIN_MAX_LINE_WIDTH color:lineColor];
    [self.layer addSublayer:lineShapeLayer];

    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:layerPoint];
    [linePath addLineToPoint:[self changePointToLayerPoint:(CGPoint) {point.x, 0.0f}]];
    lineShapeLayer.path = linePath.CGPath;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(0.0);
    animation.toValue = @(0.0);
    animation.duration = 0.0f;
    [pointShapeLayer addAnimation:animation forKey:nil];
    pointShapeLayer.strokeEnd = 1;
    [lineShapeLayer addAnimation:animation forKey:nil];
    lineShapeLayer.strokeEnd = 1;

    // 画文字
    NSString *valueString = [NSString stringWithFormat:@"%d", (int) value];
    float textWidth = valueString.length * 7.0f;
    float textHeight = 13.0f;
    float deltaX;
    if (point.x == 0.0f) {
        deltaX = 0.0f;
    }
    else if (point.x == 1.0f) {
        deltaX = textWidth;
    }
    else {
        deltaX = textWidth / 2;
    }
    CGRect minFrame = CGRectMake(layerPoint.x - deltaX, layerPoint.y - 15, textWidth, textHeight);
    UIColor *textColor = [UIColor whiteColor];
    UIFont *font = [UIFont systemFontOfSize:13];
    [self drawStringWithStr:valueString textColor:textColor font:font frame:minFrame backgroundColor:pointColor];
}

@end