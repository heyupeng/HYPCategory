//
//  NSString+YPBaseConversion.h
//  YPDemo
//
//  Created by Peng on 2017/11/3.
//  Copyright © 2017年 heyupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (yp_BaseConversion)

/**
 Convert hex to decimal 16进制字符串转十进制字符串
 */
- (NSString *)yp_hexToDec;

/**
 Convert hex to binary 16进制字符串转二进制字符串
 */
- (NSString *)yp_hexToBin;
- (NSString *)yp_hexToBinWithoutPrefixZero;

/**
 Convert binary string to hex string 二进制字符串转十六进制字符串
 */
- (NSString *)yp_binToHex;

/**
 Convert binary string to decimal string 二进制字符串转十进制字符串
 */
- (NSString *)yp_binToDec;

/**
 Convert decimal string to hex string 十进制字符串转十六进制字符串
 */
- (NSString *)yp_decToHex;

/**
 Convert decimal string to hex string 十进制字符串转二进制字符串
 */
- (NSString *)yp_decToBin;

@end


@interface NSString (yp_BaseConversion_Deprecate)

- (NSString *)hexToDecimal;

- (NSString *)hexToBinary;

- (NSString *)decimalToHex;

- (NSString *)decimalToBinary;

- (NSString *)binaryToHex;

- (NSString *)binaryToDecimal;

@end

NS_ASSUME_NONNULL_END
