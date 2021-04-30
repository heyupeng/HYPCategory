//
//  Math+Extension.m
//  HYPCategory_Example
//
//  Created by Mac on 2021/3/2.
//  Copyright © 2021 heyupeng. All rights reserved.
//

#import "Math+Extension.h"

/// 浮点型采用IEEE754标准，float的小数部分可能有差。忽略 float 小数点后6位的影响。
///@discussion
/// 如：令 f = 1.8，b = f == 1.8
/// printf("b = %d", b) => 输出结果： b = 0
/// 判断上 f 不等于 1.8。
/// printf("%.15f", f)  => 输出结果：1.799999952316284
///
int isequaltozerof(float v) {
    if (v == 0.0) return 1;
    if (ABS(v) < M_APPROX_ZEROF * 0.5) return 1;
    return 0;
}

int isequaltozero(double v) {
    if (v == 0.0) return 1;
    if (ABS(v) < M_APPROX_ZERO * 0.5) return 1;
    return 0;
}

/// float数值精确到小数点后p位。(四舍五入)
float correctf(float v, signed int p) {
    float f;
    float d;
    float ff = modff(v, &d);
    if (ff == 0) return v;
    
    ff = ff * pow(10, p);
    ff = ceilf(ff);
    ff *= pow(0.1, p);
    f = d + ff;
    return f;
}

/// 比较两个浮点型数值。
int fcomparef(float f1, float f2) {
    float d = f1 - f2;
    if (d == 0.0) return 0;
    if (d > M_APPROX_ZEROF) return 1;
    if (d < -M_APPROX_ZEROF) return -1;
    
    int signFlag = 1;
    if (d < 0) {
        signFlag = -1;
    }
    printf("float: %f - %f = %f", f1, f2, d);
    d *= signFlag;
    
    bool c = d < M_APPROX_ZEROF;
    int p = 0;
    while (c == 1) {
        if (d >= 1) { break;}
        d *= 10;
        p ++;
    }
    
    if (p > 0) {
        printf(" = %c%fE-%d", (signFlag == 1? 0: '-'), d, p);
        if (d > 5 && p <= 7) c = 0;
        printf(" ≈ 0? %d (精确到%f)", c, M_APPROX_ZEROF);
    }
    c = !c;
    printf("\n");
    return c * signFlag;
}

/// 精确到小数点后p位比较两个float数值。
int fcomparefn(float f1, float f2, int p) {
    float d = f1 - f2;
    int signFlag = 1;
    if (d == 0) return 0;
    if (d < 0) signFlag = -1;
    
    float correct = pow(10, -p);
    if (signFlag ==  1 && d > correct) return 1;
    if (signFlag == -1 && d < correct) return -1;
    
    int c = 0;
    c = ABS(d) < M_APPROX_ZEROF;
    printf("FLOAT: %f - %f = %f", f1, f2, d);
    printf(" == 0 ？%d => %d \n", f1 - f2 == 0.0, c);
    return c;
}

/*反三角函数 asin, acos 映射区域为原点所在周期。即 asin 返回值区间[-π/2, π/2]; acos 返回值区间[0, π]。
 atan2(s,c)
 */
float asincosf(float s, float c) {
    if (s == 1) return M_PI_2;
    if (s == -1) return -M_PI_2;
    if (c == 1) return 0;
    if (c == -1) return -M_PI;
    if (ABS(s) > 1 || ABS(c) >1) return 0;
    
    float angles = asin(s);
    float anglec = acos(c);
    float angle = 0;
    
    if (s > M_APPROX_ZEROF && c > M_APPROX_ZEROF) {
        angle = angles;
    }
    else if (s > 0 && c < 0) {
        angle = anglec;
    }
    else if (s < 0 && c < 0) {
        angle = - anglec;
    }
    else if (s < 0 && c > 0) {
        angle = angles;
    }
    
    if (angles > M_APPROX_ZEROF && anglec > M_PI_2) {
//        printf("第2象限 \n");
        angle = anglec;
    }
    else if (angles > M_APPROX_ZEROF && anglec > 0.0) {
//        printf("第1象限 \n");
        angle = angles;
        if (angles > M_PI_2 * (1.0 *5/6)) {
            // 区间(π/2 * 5/6, π/2)，acos精度高一点点
            angle = anglec;
        }
    }
    else if (angles < M_APPROX_ZEROF && anglec < M_PI_2) {
//        printf(" 第4象限 \n");
        angle = angles;
    }
    else {
//        printf("第3象限 \n");
        angle = - anglec;
    }
    return angle;
}
