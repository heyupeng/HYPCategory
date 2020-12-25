//
//  NSArray+YPExtension.h
//  YPDemo
//
//  Created by MAC on 2020/3/31.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 数组边界内对象
@interface NSArray<ObjectType> (YPExtension)

/// 返回数组闭环内索引处的对象。
/// Object at index in closed-loop
- (ObjectType)yp_objectAtIndexInLoop:(NSInteger)index;

/// 防越界处理。
/// Object at index in safe bound.
- (ObjectType)yp_objectAtIndexSafely:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
