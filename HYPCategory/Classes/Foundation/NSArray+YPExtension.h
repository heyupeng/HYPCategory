//
//  NSArray+YPExtension.h
//  YPDemo
//
//  Created by MAC on 2020/3/31.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (YPExtension)

- (ObjectType)yp_objectAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
