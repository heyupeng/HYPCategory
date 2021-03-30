//
//  Equation.h
//  BezierCurve
//
//  Created by Mac on 2020/8/26.
//  Copyright © 2020 Peng. All rights reserved.
//

#import "Complex.h"

/// 求解一元二次方程 ax^2 + bx + c = 0。
NSArray * quadraticEquation(float a, float b, float c);

/// 求解一元三次方程 ax^3 + bx^2 + cx + d = 0。盛金公式法一元三次方程求根。
NSArray * cubicEquationByShengjin(float a, float b, float c, float d);

/// 求解一元三次方程 ax^3 + bx^2 + cx + d = 0。卡丹公式法一元三次方程求根。
NSArray * cubicEquationByCardano(float a, float b, float c, float d);

NSArray * cubicEquationGeneral(float a, float b, float c,float d);

NSArray * cubicEquation(float a, float b, float c,float d);

#ifndef printfifdebug

#ifndef __DEBUG_ENVIR__
#ifdef DEBUG
#define __DEBUG_ENVIR__ 1
#else
#define __DEBUG_ENVIR__ 0
#endif
#endif

#ifdef __DEBUG_ENVIR__
#define printfifdebug(...) printf(__VA_ARGS__)
#else
#define printfifdebug(...)
#endif

#endif
