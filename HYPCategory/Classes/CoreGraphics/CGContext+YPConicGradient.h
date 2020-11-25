//
//  CGContext+YPConicGradient.h
//  YPDemo
//
//  Created by Peng on 2020/4/29.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

CG_EXTERN void CGContextDrawConicGradient(CGPoint startPoint, CGPoint endPoint, NSArray * colors, CGFloat *locations, BOOL closed);

#pragma mark - yp_API
CG_EXTERN void yp_drawConicGradient(CGPoint startPoint, CGPoint endPoint, NSArray * colors, CGFloat *locations, BOOL closed, CGFloat ratio);

CG_EXTERN void yp_drawConicGradientWithTwoColors(CGPoint startPoint, CGPoint endPoint, CGFloat angle, CGColorRef startColor, CGColorRef endColor);

CG_EXTERN void yp_drawConicGradientWithPath(UIBezierPath *path, CGPoint startPoint, CGPoint endPoint, CGFloat angle, CGColorRef startColor, CGColorRef endColor);

NS_ASSUME_NONNULL_END
