//
//  Complex.m
//  BezierCurve
//
//  Created by Mac on 2020/8/26.
//  Copyright © 2020 Peng. All rights reserved.
//

#import "Complex.h"

Complex ComplexZero = {0,0};

/// 是否为实数
bool complexIsRealNumber(Complex c) {
    if (c.b == 0) return 1;
    if (ABS(c.b) < 0.000001) return 1;
    return 0;
}

/// 是否为纯虚数
bool complexIsImaginaryNumber(Complex c) {
    if (complexIsRealNumber(c)) return 0;
    if (c.a == 0) return 1;
    if (ABS(c.a) < 0.000001) return 1;
    return 0;
}

Complex ComplexAddValue(Complex c1, float a, float b) {
    Complex c;
    c.a = c1.a + a;
    c.b = c1.b + b;
    return c;
}

Complex ComplexMultiplyValue(Complex c1, float v) {
    Complex c;
    c.a = c1.a * v;
    c.b = c1.b * v;
    return c;
}

#pragma mark - 基础运算：加减乘除
/// 复数相加 c = c1 + c2。
Complex ComplexAddComplex(Complex c1, Complex c2) {
    Complex c;
    c.a = c1.a + c2.a;
    c.b = c1.b + c2.b;
    return c;
}

/// 复数相加 c = c1 - c2。
Complex ComplexSubtractComplex(Complex c1, Complex c2) {
    Complex c;
    c.a = c1.a - c2.a;
    c.b = c1.b - c2.b;
    return c;
}

/// 复数相乘 c = c1 * c2。
Complex ComplexMultiplyComplex(Complex c1, Complex c2) {
    Complex c;
    c.a = c1.a * c2.a + c1.b * c2.b * (-1);
    c.b = c1.a * c2.b + c1.b * c2.a;
    return c;
}

/// 复数相除 c = c1 / c2。c2 != ComplexZero
Complex ComplexDevideComplex(Complex c1, Complex c2) {
    Complex c;
    c.a = (c1.a * c2.a + c1.b * c2.b) / (c2.a * c2.a + c2.b * c2.b);
    c.b = (c1.b * c2.a - c1.a * c2.b) / (c2.a * c2.a + c2.b * c2.b);
    return c;
}

#pragma mark - 开方
/// 负数开根号
Complex ComplexOpenRootForNumber(float num, int n) {
    Complex c = {0, 0};
    if (num >= 0) { // 非负数开方
        c.a = pow(num, 1.0 / n);
        return c;
    }
    if (n % 2 == 1) { // 负数开奇数方
        c.a = pow(ABS(num), 1.0 / n);
        if (num < 0) c.a *= -1;
        return c;
    }
    
    float r = ABS(num);
    float theta = acos(num / r);
    c.a = pow(r, 1.0 / n) * cos(theta / n);
    c.b = pow(r, 1.0 / n) * sin(theta / n);
    return c;
}

/// 负数开根号
/// @param negative 开方数值，支持负数。
/// @param n 开方次数，正整数。
Complex sqrt_negativenumber(float negative, int n) {
    return ComplexOpenRootForNumber(negative, n);
}

/// 复数开方
/// @param n 开方次数，正整数。
Complex ComplexOpenRoot(Complex c, int n) {
    float r_2 = pow(c.a, 2) + pow(c.b, 2);
    float r = sqrt(r_2);
    float theta = acos(c.a / r);
    
    if (c.b == 0) { // 实数
        Complex cc = ComplexZero;
        cc.a = pow(r, 1.0/n);
        if (c.a < 0 && n%2 == 1) cc.a *= -1;
        if (c.a < 0 && n%2 == 0) {cc.b = pow(r, 1.0/n); cc.a = 0;}
        return cc;
    }
    
    theta /= n;
    r = pow(r, 1.0/n);
    Complex cc = ComplexMake(r * cos(theta), r * sin(theta));
    return cc;
}

/// 复数开平方
Complex sqrt2_complex(Complex c) {
    float r2 = c.a * c.a + c.b * c.b;
    float r = sqrt(r2);
    
    int n = 2;
    Complex cc = ComplexMake(0, 0);
    if (c.b == 0) { // 实数
        if(c.a >= 0) cc.a = pow(r, 1.0/2.0);
        else cc.b = pow(r, 1.0/2.0);
        return cc;
    }
    
    float cos_A, sin_A, angle;
    cos_A = c.a / r;
    sin_A = c.b / r;
    angle = atan2(sin_A, cos_A);
    
    r = pow(r, 1.0/n);
    angle = angle / n;
    cc.a =  r * cos(angle);
    cc.b =  r * sin(angle);
    return cc;
}

/// 复数开立方
Complex sqrt3_complex(Complex c) {
    float r2 = c.a * c.a + c.b * c.b;
    float r = sqrt(r2);
    
    int n = 3;
    Complex cc = ComplexMake(0, 0);
    if (c.b == 0) { // 实数的算术立方根为实数。
        cc.a = pow(r, 1.0/3.0);
        if (c.a < 0) cc.a *= -1;
        return cc;
    }
    
    float cos_A, sin_A, angle;
    cos_A = c.a / r;
    sin_A = c.b / r;
    angle = atan2(sin_A, cos_A);
    
    r = pow(r, 1.0/n);
    angle = angle / n;
    cc.a =  r * cos(angle);
    cc.b =  r * sin(angle);
    return cc;
}

NSString * NSStringFromComplex(Complex complex) {
    if (complexIsRealNumber(complex)) {
        return [NSString stringWithFormat:@"%.3f", complex.a];
    }
    return [NSString stringWithFormat:@"{%.3f, %.3fi}", complex.a, complex.b];
}
