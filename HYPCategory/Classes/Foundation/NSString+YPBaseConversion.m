//
//  NSString+YPBaseConversion.h
//  YPDemo
//
//  Created by Peng on 2017/11/3.
//  Copyright © 2017年 heyupeng. All rights reserved.
//

#import "NSString+YPBaseConversion.h"

@implementation NSString (YPNumberBaseConversion)

/**
 Convert hex string to decimal string 16进制字符串转十进制字符串
 */
- (NSString *)yp_hexToDec {
    NSString * hexString = self;
    hexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    const char * cstr = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    long value = strtol(cstr, nil, 16);
    return [NSString stringWithFormat:@"%ld",value];
}

/**
 Convert hex string to binary string 16进制字符串转二进制字符串
 */
- (NSString *)yp_hexToBin {
    NSString * hexString = self;
    hexString = [hexString lowercaseString];
    hexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([hexString hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    
    NSDictionary  *hex2BinDict = @{
        @"0": @"0000", @"1": @"0001", @"2": @"0010", @"3": @"0011",
        @"4": @"0100", @"5": @"0101", @"6": @"0110", @"7": @"0111",
        @"8": @"1000", @"9": @"1001", @"a": @"1010", @"b": @"1011",
        @"c": @"1100", @"d": @"1101", @"e": @"1110", @"f": @"1111",
    };
    
    NSMutableString *binaryString=[[NSMutableString alloc] init];
    NSRange range = NSMakeRange(0, 1);
    for (int i=0; i<[hexString length]; i++) {
        range.location = i;
        NSString *key = [hexString substringWithRange:range];
        [binaryString appendString:[hex2BinDict objectForKey:key]];
    }
    
    return binaryString;
}

/**
 Convert hex string to binary string 16进制字符串转二进制字符串（删除前缀0，首位必为1）。
 */
- (NSString *)yp_hexToBinWithoutPrefixZero {
    NSMutableString * binaryString = (NSMutableString *)[self yp_hexToBin];
    
    /// 去除前缀 0；
    NSRange range = [binaryString rangeOfString:@"1" options:NSNumericSearch];
    if (range.location != NSNotFound) {
        [binaryString deleteCharactersInRange:NSMakeRange(0, range.location)];
    }
    return binaryString;
}

/**
 Convert binary string to decimal string 二进制字符串转十进制字符串
 */
- (NSString *)yp_binToDec {
    NSString * binaryString = self;
    binaryString = [binaryString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    const char * cstr = [binaryString cStringUsingEncoding:NSUTF8StringEncoding];
    long value = strtol(cstr, nil, 2);
    return [NSString stringWithFormat:@"%ld",value];
}

/**
 Convert binary string to hex string 二进制字符串转十六进制字符串
 */
- (NSString *)yp_binToHex {
    NSString * binaryString = self;
    binaryString = [binaryString stringByReplacingOccurrencesOfString:@" " withString:@""];
    binaryString = [binaryString lowercaseString];

#if 0
    const char * cstr = [binaryString cStringUsingEncoding:NSUTF8StringEncoding];
    long value = strtol(cstr, nil, 2);
    return [NSString stringWithFormat:@"%lx",value];
#else
    int l = binaryString.length % 4;
    if (l != 0) {
        l = 4 - l;
        NSString *supply = @"0000"; supply = [supply substringToIndex:l];
        binaryString = [supply stringByAppendingString:binaryString];
    }
    
    NSDictionary  *bin2hexDict = @{
        @"0000": @"0", @"0001": @"1", @"0010": @"2", @"0011": @"3",
        @"0100": @"4", @"0101": @"5", @"0110": @"6", @"0111": @"7",
        @"1000": @"8", @"1001": @"9", @"1010": @"a", @"1011": @"b",
        @"1100": @"c", @"1101": @"d", @"1110": @"e", @"1111": @"f",
    };
    
    NSMutableString * hexString=[[NSMutableString alloc] init];
    NSRange range = NSMakeRange(0, 4);
    for (int i=0; i<[binaryString length]; i+=4) {
        range.location = i;
        NSString *key = [binaryString substringWithRange:range];
        [hexString appendString:[bin2hexDict valueForKey:key]];
    }
    return hexString;
#endif
}

/**
 Convert decimal string to binary string 十进制字符串转二进制字符串
 */
- (NSString *)yp_decToBin {
    NSString * decimalString = self;
    long long decimal = [decimalString longLongValue];
    NSString *bin = @"";

    while (decimal) {
        bin = [[NSString stringWithFormat:@"%lld",decimal%2] stringByAppendingString:bin];
        if (decimal/2 < 1) {
            break;
        }
        decimal = decimal/2 ;
    }
    
    return bin;
}

/**
 Convert decimal string to hex string 十进制字符串转十六进制字符串
 */
- (NSString *)yp_decToHex {
    NSString * decimalString = self;
    long long decimal = [decimalString longLongValue];
    NSString * hex =@"";
    
    // way 1
    hex = [NSString stringWithFormat:@"%llx", [decimalString longLongValue]];
    return hex;
    
    // way 2
    uint32_t quotient;
    NSString *qLetter;
    
    if (decimal < 0) {
        quotient = decimal % 16;
        decimal = quotient;
    }
    
    do {
        quotient = decimal % 16;
        decimal = decimal / 16;
        switch (quotient) {
            case 10: qLetter =@"a"; break;
            case 11: qLetter =@"b"; break;
            case 12: qLetter =@"c"; break;
            case 13: qLetter =@"d"; break;
            case 14: qLetter =@"e"; break;
            case 15: qLetter =@"f"; break;
            default: qLetter = [NSString stringWithFormat:@"%u",quotient];
                
        }
        hex = [qLetter stringByAppendingString:hex];
    } while (decimal != 0);
    
    return hex;
}

@end

@implementation NSString (yp_NumberBaseConversion_Deprecate)

- (NSString *)hexToDecimal {
    return [self yp_hexToDec];
}

- (NSString *)hexToBinary {
    return [self yp_hexToBin];
}

- (NSString *)decimalToHex {
    return [self yp_decToHex];
}

- (NSString *)decimalToBinary {
    return [self yp_decToBin];
}

- (NSString *)binaryToHex {
    return [self yp_binToHex];
}

- (NSString *)binaryToDecimal {
    return [self yp_binToDec];
}

@end
