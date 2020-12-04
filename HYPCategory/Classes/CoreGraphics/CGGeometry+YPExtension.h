//
//  CGGeometryExtension.h
//  PhotosLibrary
//
//  Created by Peng on 2019/1/3.
//  Copyright © 2019年 heyupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

// CGPoint Add, subtract, multiply divide
/// p = p1 + p2.
CG_INLINE CGPoint yp_CGPointAddPoint(CGPoint point1, CGPoint point2);

/// p = p1 - p2 (P2 -> P1).
CG_INLINE CGPoint yp_CGPointSubtractPoint(CGPoint point1, CGPoint point2);

// CGPoint Get Angle
CG_EXTERN CGFloat yp_CGPointGetAngle(CGPoint point);

CG_EXTERN CGFloat yp_CGPointGetAngleWithCenterPoint(CGPoint point, CGPoint center);

// CGSize
CG_INLINE CGSize yp_CGSizeFromScale(CGSize size, CGFloat scale);

// CGRect
CG_INLINE CGPoint yp_CGRectGetInnerCenterPoint(CGRect rect);

CG_INLINE CGPoint yp_CGRectGetMinPoint(CGRect rect);

CG_INLINE CGPoint yp_CGRectGetMidPoint(CGRect rect);

CG_INLINE CGPoint yp_CGRectGetMaxPoint(CGRect rect);


// CGPoint
CG_INLINE CGFloat yp_CGPointGetDistance(CGPoint point) {
    return sqrt(pow(point.x, 2) + pow(point.y, 2));
}

CG_INLINE CGFloat yp_CGPointGetDistanceToPoint(CGPoint point1, CGPoint point2) {
    return yp_CGPointGetDistance(yp_CGPointSubtractPoint(point1, point2));
}

CG_INLINE CGPoint yp_CGPointAddPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

CG_INLINE CGPoint yp_CGPointSubtractPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

// CGSize
CG_INLINE CGSize yp_CGSizeFromScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

// CGRect
CG_INLINE CGPoint yp_CGRectGetInnerCenterPoint(CGRect rect) {
    //    return CGPointMake(CGRectGetWidth(rect) * 0.5, CGRectGetHeight(rect) * 0.5);
    return CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
}

CG_INLINE CGPoint yp_CGRectGetMinPoint(CGRect rect) {
    return CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
}

CG_INLINE CGPoint yp_CGRectGetMidPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CG_INLINE CGPoint yp_CGRectGetMaxPoint(CGRect rect) {
    return CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

