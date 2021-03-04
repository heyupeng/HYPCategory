//
//  MathExtension.h
//  HYPCategory_Example
//
//  Created by Mac on 2021/3/2.
//  Copyright © 2021 heyupeng. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

/******************************************************************************
 *          Math Functions Extension
 ******************************************************************************/

#define M_PROXIM_ZEROF 0.000001
#define M_PROXIM_ZERO 0.000000000000001

/// 浮点型采用IEEE754标准，小数部分的精度可能有差别 。float 型6位绝对精度，double 型15位。
extern int isequaltozerof(float);
extern int isequaltozero(double);

/// float数值精确到小数点后n位。(四舍五入)
extern float correctf(float v, signed int dp);

/// 比较两个浮点型数值。
extern int compareff(float f1, float f2);
/// 精确到小数点后n位比较两个float数值。
extern int compareffn(float f1, float f2, int dp);

extern float asincosf(float s, float c);

NS_ASSUME_NONNULL_END
