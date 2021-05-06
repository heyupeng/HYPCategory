//
//  CGContext+YPConicGradient.m
//  YPDemo
//
//  Created by Peng on 2020/4/29.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import "CGContext+YPConicGradient.h"

#import <CoreGraphics/CoreGraphics.h>

#import "CGGeometry+YPExtension.h"

/// c= (1 - t ) * c1 + t * c2
CGColorRef yp_CGColorCreateInterpolationWithProcess(CGColorRef c1, CGColorRef c2, float t) {
    const CGFloat * cps1 = CGColorGetComponents(c1);
    const CGFloat * cps2 = CGColorGetComponents(c2);
    
    CGFloat r, g, b,a;
    r = (1-t) * cps1[0] + t * cps2[0];
    g = (1-t) * cps1[1] + t * cps2[1];
    b = (1-t) * cps1[2] + t * cps2[2];
    a = (1-t) * cps1[3] + t * cps2[3];
    
    CGFloat c[] = {r,g,b,a};
    return CGColorCreate(CGColorSpaceCreateDeviceRGB(), c);
}

CGFloat yp_CGColorGetDiffMaximumWithColor(CGColorRef color1, CGColorRef color2) {
    const CGFloat * c1 = CGColorGetComponents(color1);
    const CGFloat * c2 = CGColorGetComponents(color2);
    
    CGFloat r, g, b,a;
    r = ABS(c1[0] - c2[0]);
    g = ABS(c1[1] - c2[1]);
    b = ABS(c1[2] - c2[2]);
    a = c1[3] - c2[3];
    
    return MAX(MAX(r, g), MAX(b, a));
}

#pragma mark - yp prative
#define curWay 2
/** conic gradient 锥形渐变
 * way 1:
 * 取圆弧上的点与圆心相连的线段，以画线实现渐变效果（缺陷：当着色带有透明度时，靠近圆形一侧的画线收束会导致颜色加深效果。舍弃。）
 *
 * way 2:
 * 将锥形区域分成多个三角形，按色值变化进行填充渐变;
 *
 * way 3:(缺陷：存在一个色值重叠点域)
 * 将 angle 按 perAngle 大小分割为 n 个区域;
 * 一个标准区域内, 初始角记 minAngle，过弦作中垂线相交于弦中点M，点M到圆心O记作OM， L(OM) = cos(perAngle/2);
 * 通过三角形相似原理计算画线开始点，减少画线收束色彩叠加。
 */
CGPoint insertPoint(CGFloat startAngle, CGFloat angle, CGFloat t, CGFloat perAngle, CGFloat radius) {
    CGPoint sPoint = CGPointZero;
    
    CGFloat minAngle, midAngle;
    minAngle = floor(angle * t / perAngle) * perAngle;
    midAngle = minAngle + perAngle / 2;
    // 中垂线 OM 长
    CGFloat midLength = radius * ABS(cos(perAngle / 2));
    // 中点 M
    CGPoint midPoint = CGPointMake(midLength * cos(startAngle + midAngle), midLength * sin(startAngle + midAngle));

    CGFloat tm = ABS(t * angle - midAngle) / (perAngle/2); //[0, 0.5, 1] =>[1, 0 , 1]
//    tm = sin(M_PI*0.5 * tm);
#if 1
    // 两边向中垂线聚拢
    tm = 1-tm; tm /= 2;
    sPoint.x = midPoint.x * (tm);
    sPoint.y = midPoint.y * (tm);
#else
    // 中垂线向两边扩散
    if (t * angle - midAngle > 0) {
        sPoint = CGPointMake(cos(startAngle + minAngle + perAngle) * midLength, sin(startAngle + minAngle + perAngle) * midLength);
    } else {
        sPoint = CGPointMake(cos(startAngle + minAngle) * midLength, sin(startAngle + minAngle) * midLength);
    }
    tm = tm/4;
    sPoint.x = sPoint.x * (tm);
    sPoint.y = sPoint.y * (tm);
#endif
    return sPoint;
}

void yp_drawConicGradient(CGPoint startPoint, CGPoint endPoint, NSArray * colors, CGFloat *locations, BOOL closed, CGFloat ratio) {
    int colorsLen = (int)colors.count;
    float angle = M_PI * 2, startAngle = M_PI * (-1);
    float radius = startPoint.x;
    float l = radius * angle;
    bool isClosed = false; // 形成一个闭环渐变
//    float ratio = 0.6; // 色彩保留占比值(色彩不渐变区与渐变区比值，[0, 1], 1则不存在渐变区域, 两色彩渐变区域大小为1-ratio
    
    startAngle = yp_CGPointGetAngleWithCenterPoint(endPoint, startPoint);
    radius = sqrtf(powf(startPoint.x - endPoint.x, 2) + powf(startPoint.y - endPoint.y, 2));;
    l = radius * angle;
    isClosed  = closed;
    
#if (curWay == 3)
    float perAngle = M_PI * (1.0/6);
    float n = angle / perAngle;
#endif
    UIBezierPath * path;
    UIColor * color1, * color2;
    float ct = 0;
    int minimumIndex = 0, maximumIndex = 0;
    
    minimumIndex = isClosed? colorsLen - 1: 0;
    color1 = colors[minimumIndex];
    color2 = colors[maximumIndex];
    
    float unitT = 1/l*2;
    CGPoint sPoint = CGPointZero, ePoint = CGPointZero;
    for (float t = 0; t < 1; t += unitT) {
        CGFloat curAngle  = startAngle + angle * t;
        CGFloat dx, dy;
        dx = radius * cos(curAngle);
        dy = radius * sin(curAngle);
        
        ePoint = CGPointMake(radius * cos(curAngle + angle * unitT), radius * sin(curAngle + angle * unitT));
        
        // 计算 t 对应的色彩区间
        for (int i = 0; i < colorsLen; i++) {
            float location = locations[i];
            if (t > location) {
                minimumIndex = i;
                color1 = colors[minimumIndex];
            } else {
                maximumIndex = i;
                color2 = colors[maximumIndex];
                break;
            }
        }
        
        // t 在色彩区间的占比 ct
        if ((locations[maximumIndex] - locations[minimumIndex]) != 0) {
            ct = (t - locations[minimumIndex]) / (locations[maximumIndex] - locations[minimumIndex]);
        } else {
            ct = 0;
        }
        
        // 色彩组构成闭环，重置首尾 ct
        if (isClosed && angle == (float)(M_PI * 2) && maximumIndex == 0 && t < locations[minimumIndex]) {
            ct = (t - (locations[minimumIndex] - 1)) / (locations[maximumIndex] - (locations[minimumIndex] - 1));
        }
        else if (isClosed && angle == (float)(M_PI * 2) && minimumIndex == colorsLen - 1) {
            maximumIndex = 0;
            color2 = colors[maximumIndex];
            ct = (t - locations[minimumIndex]) / (locations[maximumIndex] + 1 - locations[minimumIndex]);
        }
        
        // 色彩保留稳定区 ct 重算
        if (ct > 0 && ct < ratio * 0.5) {
            ct = 0;
        }
        else if (ct > 1- ratio * 0.5 && ct < 1) {
            ct = 1;
        } else {
            ct = (ct - ratio * 0.5)/(1 - ratio);
        }
        
#if (curWay == 3)
        // way3
        sPoint = insertPoint(startAngle, angle, t, perAngle, n, radius);
#endif
        
        if ([color1 isKindOfClass:[UIColor class]]) {
            CGColorRef colorRef = yp_CGColorCreateInterpolationWithProcess(color1.CGColor, color2.CGColor, ct);
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), colorRef);
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), colorRef);
        } else {
            CGColorRef colorRef = yp_CGColorCreateInterpolationWithProcess((__bridge CGColorRef)color1, (__bridge CGColorRef)color2, ct);
            CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), colorRef);
            CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), colorRef);
        }
        
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(startPoint.x + sPoint.x, startPoint.y + sPoint.y)];
        [path addLineToPoint:CGPointMake(startPoint.x + dx, startPoint.y + dy)];
#if (curWay != 2)
        path.lineWidth = 2;
        [path stroke];
#else
        [path addLineToPoint:CGPointMake(startPoint.x + ePoint.x, startPoint.y + ePoint.y)];
//        [path stroke];
        [path fill];
#endif
        
    }
}

void yp_drawConicGradientWithTwoColors(CGPoint startPoint, CGPoint endPoint, CGFloat angle, CGColorRef startColor, CGColorRef endColor) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint dpoint = CGPointMake(endPoint.x - startPoint.x, endPoint.y - startPoint.y);
    float startAngle = yp_CGPointGetAngle(dpoint);
    float radius = sqrtf(powf(dpoint.x, 2) + powf(dpoint.y, 2));
    
    float l = radius * (angle);
    float unit = 1;
    if (l != 0) {
        unit = 1/l * 1.5;
    }
    
    for (float t = 0; t <= 1; t += unit) {
        CGFloat dAngle = t * angle;
        CGPoint point = CGPointMake(startPoint.x + radius * cos(startAngle + dAngle), startPoint.y + radius * sin(startAngle + dAngle));
        
        CGColorRef colorRef = yp_CGColorCreateInterpolationWithProcess(startColor, endColor, t);
     
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, point.x, point.y);
#if 0
        CGContextSetStrokeColorWithColor(context, colorRef);
        CGContextSetLineWidth(context, 0.8);
        CGContextStrokePath(context);
#else
        CGContextAddLineToPoint(context, startPoint.x + radius * cos(startAngle + dAngle + unit * angle), startPoint.y + radius * sin(startAngle + dAngle + unit * angle));
        CGContextAddLineToPoint(context, startPoint.x, startPoint.y);
        
        CGContextSetStrokeColorWithColor(context, colorRef);
        CGContextSetFillColorWithColor(context, CGColorCreateCopy(colorRef));
        CGContextSetLineWidth(context, 1);
        CGContextStrokePath(context);
        CGContextFillPath(context);
#endif
    }
}

void yp_drawConicGradientWithPath(UIBezierPath *path, CGPoint startPoint, CGPoint endPoint, CGFloat angle, CGColorRef startColor, CGColorRef endColor) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
            
    yp_drawConicGradientWithTwoColors(startPoint, endPoint, angle, startColor, endColor);
    
    CGContextRestoreGState(context);
}

#pragma mark - public
void CGContextDrawConicGradient(CGPoint startPoint, CGPoint endPoint, NSArray * colors, CGFloat *locations, BOOL closed) {
    yp_drawConicGradient(startPoint, endPoint, colors, locations, colors, 0);
}
