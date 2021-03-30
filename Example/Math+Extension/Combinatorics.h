//
//  Combinatorics.h
//  YPDemo
//
//  Created by MAC on 2020/5/6.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#ifndef Combinatorics_h
#define Combinatorics_h

/* 排列组合
 */
extern long arrangement(unsigned int n, unsigned int m);
extern long combination(unsigned int n, unsigned int m);

#define M_A(n,m) arrangement(n, m)
#define M_C(n,m) combination(n, m)

#endif /* Combinatorics_h */
