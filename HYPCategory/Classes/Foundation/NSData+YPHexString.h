//
//  NSData+YPHexString.h
//  YPDemo
//
//  Created by Peng on 2019/3/11.
//  Copyright © 2019年 heyupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (yp_NSDataExtensionMethods)

/**
 数据流反序。 <313233 616263> => <636261 333231>
 */
- (NSData *)yp_reverseData;

/**
 数据流转码字符串。
 */
- (NSString *)yp_stringUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)yp_ASCIIString;

- (NSString *)yp_UTF8String;

@end

@interface NSData (yp_HexString)

/**
 16进制字符串转数据流 @"03000c0004000643" => <03000c00 04000643>
 0.57 sec / 100,000
 */
+ (NSData *)yp_dataWithHexString:(NSString *)hexString;

/**
 数据流转16进制字符串 <03000c00 04000643> => @"03000c0004000643"
 */
- (NSString *)yp_hexString;

/**
 数据流转数组 <0643> => @[0x06, 0x43]
 */
- (NSArray<NSNumber *> *)yp_bytes;

/**
 数据流转数字 <0643> => 1603
 */
- (int)yp_hexIntValue;

- (NSInteger)yp_hexIntegerValue;

- (long long)yp_hexLongLongValue;

@end

@interface NSData (yp_hexString_deprecate_1_0)

+ (NSData *)dataWithHexString:(NSString *)hexString;

- (NSString *)hexString;

- (NSString *)ASCIIString;

- (NSArray<NSNumber *> *)hexArray;

- (NSInteger)hexIntegerValue;

- (long long)hexLongLongValue;

@end

NS_ASSUME_NONNULL_END
