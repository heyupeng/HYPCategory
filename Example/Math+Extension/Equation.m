//
//  Equation.m
//  BezierCurve
//
//  Created by Mac on 2020/8/26.
//  Copyright © 2020 Peng. All rights reserved.
//

#import "Equation.h"

#pragma mark - 求解一元二次方程 ax^2 + bx + c = 0。
/// 求解一元二次方程 ax^2 + bx + c = 0。
NSArray * quadraticEquation(float a, float b, float c) {
    printfifdebug("一元二次方程求根.\n");
    printfifdebug("a = %f, b = %f, c = %f \n", a, b, c);
    float x1, x2;

    float D = pow(b, 2) - 4 * a * c;
    printfifdebug(" D = b^2 - 4ac = %f \n", D);
    
    if (D > 0) {
        float sqrtD = sqrtf(D);
        x1 = (-b + sqrtD) / (2 * a);
        x2 = (-b - sqrtD) / (2 * a);
        printfifdebug(" D > 0, 有2个实根: \n");
        printfifdebug(" %.3f, %.3f \n", x1, x2);
        return @[@(x1), @(x2)];
    }
    else if (D == 0) {
        x1 = -b / (2 * a);
        printfifdebug(" D = 0, 有1个重实根: \n");
        printfifdebug(" %.3f \n", x1);
        return @[@(x1)];
    }
    else {
        float sqrtD = sqrtf(-D);
        x1 = -b / (2 * a);
        Complex cx1 = {x1, sqrtD};
        Complex cx2 = {x1, -sqrtD};
        printfifdebug(" D < 0, 无实根，有2个复根: \n");
        printfifdebug("  x1 = %s  \n", NSStringFromComplex(cx1).UTF8String);
        printfifdebug("  x2 = %s  \n", NSStringFromComplex(cx2).UTF8String);
    }
    return nil;
}

#pragma mark - 求解一元三次方程 ax^3 + bx^2 + cx + d = 0。
/// 求解一元三次方程 ax^3 + bx^2 + cx + d = 0。盛金公式法一元三次方程求根。
NSArray * cubicEquationByShengjin(float a, float b, float c, float d) {
    printfifdebug("一元三次方程求根（盛金公式）.\n");
    printfifdebug("a = %f, b = %f, c = %f, d = %f \n", a, b, c, d);
    float x1, x2, x3;
    
    float A, B, C;
    A = pow(b, 2) - 3 * a * c;
    B = b* c - 9 * a* d;
    C = pow(c, 2) - 3 * b * d;
    
    float D = pow(B, 2) - 4* A* C;
    printfifdebug(" A = b^2 - 3ac = %f \n B = b*c - 9ad = %f \n C = c^2 - 3bd = %f \n", A, B, C);
    printfifdebug(" D = B^2 - 4AC = %f \n",  D);
    
    if (D < 0) {
        float theta, T;
        T = (2 * A * b - 3 * a * B) / (2 * pow(A, 3/2.0));
        theta = acos(T);
        
        x1 = (-b - 2 * sqrt(A) * cos(theta/3.0)) / (3 * a);
        x2 = (-b + sqrt(A) * (cos(theta/3.0) + sqrt(3) * sin(theta/3.0))) / (3 * a);
        x3 = (-b + sqrt(A) * (cos(theta/3.0) - sqrt(3) * sin(theta/3.0))) / (3 * a);
        
        printfifdebug(" D < 0, 有3个实根: \n");
        printfifdebug(" %.3f, %.3f, %.3f \n", x1, x2, x3);
        return @[@(x1), @(x2), @(x3)];
    }
    else if (D == 0 && A != 0) {
        float K = B / A;
        x1 = -b / a + K;
        x2 = -K / 2;
        
        printfifdebug(" D = 0, 有3个实根，其中2个相等: \n");
        printfifdebug(" %.3f, %.3f, %.3f", x1, x2, x2);
        return @[@(x1), @(x2)];
    }
    else if (D > 0) {
        float Y1, Y2;
        Y1 = A * b  + 3 * a * (-B + sqrt(B*B - 4 * A * C)) / 2;
        Y2 = A * b  + 3 * a * (-B - sqrt(B*B - 4 * A * C)) / 2;
        x1 = (-b - (pow(Y1, 1/3.0) + pow(Y2, 1/3.0))) / (3 * a);
        
        float m = 0, n = 0;
        m = (-b + 1/2.0 * (pow(Y1, 1/3.0) + pow(Y2, 1/3.0))) / (3 * a);
        n = sqrt(3)/2.0 * (pow(Y1, 1/3.0) - pow(Y2, 1/3.0)) / (3 * a);
        /* x2, x3 为共轭复数, z = m ± n i，记(m, ±n) */
        Complex cx2 = {m, n};
        Complex cx3 = {m, -n};
        
        printfifdebug(" D > 0, 有1个实根，2个复根: \n");
        printfifdebug("  x1 = %.3f, \n", x1);
        printfifdebug("  x2 = %s, \n", NSStringFromComplex(cx2).UTF8String);
        printfifdebug("  x3 = %s  \n", NSStringFromComplex(cx3).UTF8String);
        return @[@(x1)];
    }
    return nil;
}

/// 求解一元三次方程 ax^3 + bx^2 + cx + d = 0。卡丹公式法一元三次方程求根。
NSArray * cubicEquationByCardano(float a, float b, float c, float d) {
    printfifdebug("一元三次方程求根（Cardano卡丹公式法）. \n");
    float x1, x2, x3;
    
    // 卡丹公式法的一般情况转化
    // x = y - b/(3a) => y^3 + py + q = 0
    float o = -b/ (3* a);
    float p, q;
    p = (3* a* c - pow(b, 2)) / (3.0* pow(a, 2));
    q = (27 * pow(a, 2) * d - 9 * a*b*c + 2 * pow(b, 3)) / (27.0* pow(a, 3));
    
    float D = pow((q/2.0), 2) + pow(p/3.0, 3);
    /**
     * 当 D > 0 时，有一个实根和两个复根；
     * D = 0 时，有三个实根，当 p=q=0 时，有一个三重零根，p,q≠0 时，三个实根中有两个相等；
     * D < 0 时，有三个不等实根。
     */
    
    Complex cw1 = {-1.0/2.0, sqrt(3)/2.0};
    Complex cw2 = {-1.0/2.0, - sqrt(3)/2.0}; // w2 = w1 ^2
    
    float y1 = 0, y2 = 0, y3 = 0;
    if (D < 0) {
        float r = sqrt(-pow(p/3.0, 3));
        float theta = 1/3.0 * acos(-q/2.0/r);
        y1 = 2 * pow(r, 1/3.0) * cos(theta);
        y2 = 2 * pow(r, 1/3.0) * cos(theta + 1/3.0 * 2 * M_PI);
        y3 = 2 * pow(r, 1/3.0) * cos(theta + 2/3.0 * 2 * M_PI);
    } else if (D == 0){
        float m = -q/2.0 + sqrt(D);
        float n = -q/2.0 - sqrt(D);
        
        y1 = pow(m, 1/3.0) + pow(n, 1/3.0);
        y2 = cw1.a * pow(m, 1/3.0) + cw2.a * pow(n, 1/3.0);
    } else {
        float m = -q/2.0 + sqrt(D);
        float n = -q/2.0 - sqrt(D);
        
        float m_3, n_3;
        m_3 = (m >= 0? 1: -1) * pow(ABS(m), 1.0/3.0);
        n_3 = (n >= 0? 1: -1) * pow(ABS(n), 1.0/3.0);
        
        y1 = m_3 + n_3;
        
        Complex cy2 = ComplexAddComplex(ComplexMultiplyValue(cw1, m_3), ComplexMultiplyValue(cw2, n_3));
        Complex cy3 = ComplexAddComplex(ComplexMultiplyValue(cw2, m_3), ComplexMultiplyValue(cw1, n_3));
        
        Complex cx2 = ComplexAddComplex(cy2, ComplexMake(o, 0));
        Complex cx3 = ComplexAddComplex(cy3, ComplexMake(o, 0));
        printfifdebug(" x1 = %s, \n", NSStringFromComplex(ComplexMake(y1+o, 0)).UTF8String);
        printfifdebug(" x2 = %s, \n", NSStringFromComplex(cx2).UTF8String);
        printfifdebug(" x3 = %s  \n", NSStringFromComplex(cx3).UTF8String);
    }
    
    x1 = y1 + o;
    x2 = y2 + o;
    x3 = y3 + o;
    if (D < 0) {
        printfifdebug("%.3f, %.3f, %.3f \n", x1, x2, x3);
        return @[@(x1), @(x2), @(x3)];
    } else if (D == 0) {
        printfifdebug("%.3f, %.3f, %.3f \n", x1, x2, x2);
        return @[@(x1), @(x2)];
    } else {
        printfifdebug("%.3f \n", x1);
        return @[@(x1)];
    }
}

/// 求解一元三次方程 ax^3 + bx^2 + cx + d = 0。一元三次方程通用求根法。
NSArray * cubicEquationGeneral(float a, float b, float c,float d) {
    printfifdebug("一元三次方程求根（通用求根法）. \n");
    float x1, x2, x3;
    
    float u, v;
    u = (9 * a*b*c -27 * pow(a, 2) * d - 2 * pow(b, 3)) / (54 * pow(a, 3));
    
    float v_1 = 4* a* pow(c, 3) - pow(b, 2)* pow(c, 2) - 18* a* b* c* d + 27* pow(a, 2)* pow(d, 2) + 4* pow(b, 3)* d;
    v = sqrt(3 * ABS(v_1)) / (18* pow(a, 2));
    
    float m, n = 0;
    if (ABS(u+v) >= ABS(u-v)) {
        m = (u+v >= 0? 1: -1) * pow(ABS(u+v), 1/3.0);
    } else {
        m = (u-v >= 0? 1: -1) * pow(ABS(u-v), 1/3.0);
    }
    
    float mn;
    if (m != 0) {
        mn = (pow(b, 2) - 3* a* c) / (9.0 * a);
        n = mn / m;
    }
    
//    CGFloat x1, x2, x3;
    x1 = m + n - b / (3.0* a);
    
    Complex c_v = {0, 0};
    if (v_1 >= 0) {
        c_v.a = sqrt(3 * (v_1)) / (18* pow(a, 2));
    } else {
        c_v.b = sqrt(3 * (-v_1)) / (18* pow(a, 2));
    }
    
    Complex c_m = ComplexZero, c_n = ComplexZero;
    Complex c_M = ComplexZero;
    if (pow(u + c_v.a, 2) + pow(c_v.b, 2) >= pow(u - c_v.a, 2) + pow(c_v.b, 2)) {
        c_M.a = u + c_v.a;
        c_M.b = c_v.b;
    } else {
        c_M.a = u - c_v.a;
        c_M.b =  - c_v.b;
    }
    c_m = sqrt3_complex(c_M);
    
    if (c_m.a != 0 || c_m.b != 0) {
        float mn = (pow(b, 2) - 3* a* c) / (9.0 * a);
        c_n = ComplexDevideComplex(ComplexMake(mn, 0), c_m);
    }
    
    Complex cx1, cx2, cx3;
    Complex cw1 = {-1.0/2.0, sqrt(3)/2.0};
    Complex cw2 = {-1.0/2.0, - sqrt(3)/2.0}; // w2 = w1 ^2
    
    cx1 = ComplexAddComplex(c_m, c_n);
    cx2 = ComplexAddComplex(ComplexMultiplyComplex(cw1, c_m), ComplexMultiplyComplex(cw2, c_n));
    cx3 = ComplexAddComplex(ComplexMultiplyComplex(cw2, c_m), ComplexMultiplyComplex(cw1, c_n));
    cx1 = ComplexAddComplex(cx1, ComplexMake(- b / (3.0* a), 0));
    cx2 = ComplexAddComplex(cx2, ComplexMake(- b / (3.0* a), 0));
    cx3 = ComplexAddComplex(cx3, ComplexMake(- b / (3.0* a), 0));
    
    printfifdebug(" x1 = %s, \n", NSStringFromComplex(cx1).UTF8String);
    printfifdebug(" x2 = %s, \n", NSStringFromComplex(cx2).UTF8String);
    printfifdebug(" x3 = %s  \n", NSStringFromComplex(cx3).UTF8String);
    
    if (m != n) {
        return @[@(x1)];
    }
    
    return nil;
}

NSArray * cubicEquation(float a, float b, float c,float d) {
    ComplexOpenRootForNumber(-8, 2);
#if 1
    return cubicEquationByShengjin(a, b, c, d);
#else
    return cubicEquationByCardano(a, b, c, d);
#endif
}
