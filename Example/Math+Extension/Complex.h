//
//  Complex.h
//  BezierCurve
//
//  Created by Mac on 2020/8/26.
//  Copyright © 2020 Peng. All rights reserved.
//

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#else
#ifndef FOUNDATION_EXTERN
#if defined(__cplusplus)
#define FOUNDATION_EXTERN extern "C"
#else
#define FOUNDATION_EXTERN extern
#endif
#endif
#if !defined(FOUNDATION_STATIC_INLINE)
#define FOUNDATION_STATIC_INLINE static __inline__
#endif
#endif

/*! 复数结构体。A structure that contains a complex number, */
struct Complex {
    // c = a + bi .
    /// 实数部
    float a;
    /// 虚数部
    float b;
};
typedef struct Complex Complex;

FOUNDATION_EXTERN Complex ComplexZero;

FOUNDATION_STATIC_INLINE Complex ComplexMake(float a, float b) {
    Complex c = {a, b};
    return c;
}

/// 是否为实数
FOUNDATION_EXTERN bool complexIsRealNumber(Complex c);
/// 是否为纯虚数
FOUNDATION_EXTERN bool complexIsImaginaryNumber(Complex c);

FOUNDATION_EXTERN Complex ComplexAddValue(Complex c1, float a, float b);
FOUNDATION_EXTERN Complex ComplexMultiplyValue(Complex c1, float v);

/// 复数相加 c = c1 + c2。
FOUNDATION_EXTERN Complex ComplexAddComplex(Complex c1, Complex c2);
/// 复数相加 c = c1 - c2。
FOUNDATION_EXTERN Complex ComplexSubtractComplex(Complex c1, Complex c2);
/// 复数相乘 c = c1 * c2。
FOUNDATION_EXTERN Complex ComplexMultiplyComplex(Complex c1, Complex c2);
/// 复数相除 c = c1 / c2。
FOUNDATION_EXTERN Complex ComplexDevideComplex(Complex c1, Complex c2);

/// 负数开根号
FOUNDATION_EXTERN Complex ComplexOpenRootForNumber(float num, int n);
/// 负数开根号
FOUNDATION_EXTERN Complex sqrt_negativenumber(float negative, int n);

/// 复数开方
FOUNDATION_EXTERN Complex ComplexOpenRoot(Complex c, int n);
/// 复数开平方
FOUNDATION_EXTERN Complex sqrt2_complex(Complex c);
/// 复数开立方
FOUNDATION_EXTERN Complex sqrt3_complex(Complex c);

FOUNDATION_EXTERN NSString * NSStringFromComplex(Complex complex);
