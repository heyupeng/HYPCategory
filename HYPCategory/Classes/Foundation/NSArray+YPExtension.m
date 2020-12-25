//
//  NSArray+YPExtension.m
//  YPDemo
//
//  Created by MAC on 2020/3/31.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import "NSArray+YPExtension.h"

@implementation NSArray (YPExtension)


/// 返回数组闭环内索引处的对象。Object at index in closed-loop
///
/// 索引超出数组起始(索引小于0时)，index = index + n * count。
///
/// 索引超出数组末尾(索引大于或等于count返回值)，index = index - n * count。
///
/// @param index 数组索引(当 index 为 -1，返回数组最后一个对象；当index 为 count，返回数组第一个对象)。
- (id)yp_objectAtIndexInLoop:(NSInteger)index {
    if (self.count == 0) return nil;
    
    if (index >= 0 && index < self.count) {
        return [self objectAtIndex:index];
    }
    
    index = index % self.count;
    
    if (index < 0) {
        index = index + self.count;
    }
    else if (index >= self.count) {
        index = index - self.count;
    }
    return [self yp_objectAtIndexInLoop:index];
}

/// 返回安全范围内索引处的对象。Object at index in safe bound.
/// @Discussion 防越界处理(索引大于或等于count返回值，或小于0，返回nil)。
/// @param index 数组边界内的索引。
- (id)yp_objectAtIndexSafely:(NSInteger)index {
    if (index < 0) {
        return nil;
    }
    else if (index >= self.count) {
        return nil;;
    }
    return [self objectAtIndex:index];
}

@end
