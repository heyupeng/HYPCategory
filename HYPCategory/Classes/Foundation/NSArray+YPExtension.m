//
//  NSArray+YPExtension.m
//  YPDemo
//
//  Created by MAC on 2020/3/31.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import "NSArray+YPExtension.h"

@implementation NSArray (YPExtension)

- (id)yp_objectAtIndex:(NSInteger)index {
    if (index < 0) {
        index = index + self.count;
    }
    else if (index >= self.count) {
        index = index % self.count;
    }
    return [self objectAtIndex:index];
}
@end
