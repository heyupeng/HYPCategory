//
//  Combinatorics.m
//  YPDemo
//
//  Created by MAC on 2020/5/6.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import "Combinatorics.h"
#import <math.h>

#pragma mark - 排列组合
/// A(n,m) =  n * (n-1) * ... * (n-m+1) = n!/(n-m)!
long arrangement(unsigned int n, unsigned int m) {
    if (n == 0 || m == 0) {
        return 1;
    }
    long a = 1;
    for (int i = 0; i < m; i ++) {
        a = a * (n - i);
    }
    return a;
}

/// C(n,m) = A(n,m)/m!
long combination(unsigned int n, unsigned int m) {
    if (n == 0 || m == 0 || n == m) {
        return 1;
    }
    if (m == 1 || m == n - 1) {
        return n;
    }
    if (m > n * 0.5) {
        m = n - m;
    }
    long c = 1;
    for (int i = 0; i < m; i++) {
        c = c * (n - i) / (i+1);
    }
    return c;
}

/*
 C(n,0) = 1;
 C(n,1) = C(n-1,0) + C(n-1,1)
        = C(n-1,0) + ... + C(1,0) + C(1,1)
        = (n-1)*1 + 1 = n;
 C(n,2) = C(n-1,1) + C(n-1,2)
        = C(n-1,1) + ... + C(2,1) + C(2,2)
        = 1/2 * (n-1-2+1) * (n-1+2) + 1= 1/2*(n-2)*(n+1) +1 = 1/2*(n-1)*n
 C(n,3) = C(n-1,2) + C(n-1,3) = C(n-1,2) + ... + C(3,2) + C(3,3)
        = 1/2*[(n-1)^2 - (n-1) + ... + (3)^2 -3] + 1
        = 1/2*[(n-1)^2 + (n-2)^2 + ... + (3)^2] - 1/2*[(n-1) + (n-2) + ... + 3] + 1
 */
/// 递归法： c(n,m) = c(n - 1, m - 1) + c(n - 1, m);
long combine_r(int n, int m) {
    if (n == 0 || m == 0 || n == m) {
        return 1;
    }
    if (m > n * 0.5) {
        m = n - m;
    }
    
    long c = 0;
    if (m == 1 || m == n - 1) {
        c = n;
    }
    else if (m == 2 || n - m == 2) {
        c = n * (n - 1) / 2;
    }
    else {
        c = combine_r(n - 1, m - 1) + combine_r(n - 1, m);
    }
    
    return c;
}

/// 杨辉三角前n项总个数
int yanghui_count(int column) {
    return 1/2*(column +1) * (column +2);
}

/// 杨辉三角前n项半数和
int yanghui_harfofcount(int column) {
    int harf = ceil( (column +1) / 2.0);
    int remainder = column % 2;
    return (harf +1) * harf - (remainder?0:1) * harf;
}

long c_combine[100 * 101] = {1, 1, 1};

/// 递归法： c(n,m) = c(n - 1, m - 1) + c(n - 1, m);
long combine_r_c(int n, int m) {
    if (n == 0 || m == 0 || n == m) {
        return 1;
    }
    if (m > n * 0.5) {
        m = n - m;
    }
    
    long ci = yanghui_harfofcount(n-1) + m;
    if (c_combine[ci] != '\0') {
        return c_combine[ci];
    }
    
    long c = 0;
    if (m == 1 || m == n - 1) {
        c = n;
    }
    else if (m == 2 || n - m == 2) {
        c = n * (n - 1) / 2;
    }
    else {
        long c1 = 0, c2 = 0;
        c1 = combine_r_c(n - 1, m - 1);
        c2 = combine_r_c(n - 1, m);
        c = c1 + c2;
    }
    
    if (ci <= yanghui_harfofcount(201)) {
        c_combine[ci] = c;
    }
    
    return c;
}
