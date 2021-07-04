//
//  NSString+YPHexString.h
//  YPDemo
//
//  Created by Peng on 2017/11/3.
//  Copyright © 2017年 heyupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (yp_NSStringExtensionMethods)

/// 删除空格字符。
- (NSString *)yp_stringByRemovingSpace;

@end

@interface NSString (YPHexString)

/// 16进制字符串转数据流。 @"03000c0004000643" => <03000c00 04000643> 。
- (NSData *)yp_hexStringToData;

/// 16进制字符串转long型数字。
- (long)yp_hexStringToLongValue;

/// 16进制字符串转long型数字。
- (long)yp_hexLongValue;

/// 16进制字符串转ASCII字符串。
- (NSString *)hexStringToASCIIString;

/// ASCII字符串转16进制字符串。
- (NSString *)ASCIIStringToHexString;

/// 16进制字符串高低位互换。 @"ade23faa" => @"aa3fe2ad"。
- (NSString *)hexStringReverse;

@end
