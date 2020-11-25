//
//  CGGeometryExtension.m
//  PhotosLibrary
//
//  Created by Peng on 2019/1/3.
//  Copyright © 2019年 heyupeng. All rights reserved.
//

#import "CGGeometryExtension.h"

/// 点P以点(0, 0)为圆心的角度/弧度。[-M_PI_2, M_PI_2 * 3]
CGFloat CGPointGetAngle(CGPoint point) {
    CGFloat angle = 0;
    CGFloat dx, dy;
    dx = point.x; dy = point.y;
    
    if (dx == 0) {
     angle = dy > 0? M_PI_2 : -M_PI_2;
     return angle;
    }
    
    angle = atan(dy / dx);;
    if (dx < 0) {
     angle += M_PI;
    }
    return angle;
}

/// 点P以点C为圆心的角度/弧度。
/// @param point 圆弧上的点
/// @param center 圆心点
CGFloat CGPointGetAngleWithCenterPoint(CGPoint point, CGPoint center) {
    CGFloat dx = point.x - center.x;
    CGFloat dy = point.y - center.y;
    return CGPointGetAngle(CGPointMake(dx, dy));
}
