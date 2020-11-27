//
//  NSString+YPMessageDigest.h
//  YPDemo
//
//  Created by Peng on 2018/5/17.
//  Copyright © 2018年 heyupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (yp_MD5)

+ (NSString *)yp_md5:(NSString *)string;
- (NSString *)yp_md5;

@end

@interface NSString (yp_MD_deprecate_1_0)

+ (NSString *)md5:(NSString *)string;
- (NSString *)md5;

@end
