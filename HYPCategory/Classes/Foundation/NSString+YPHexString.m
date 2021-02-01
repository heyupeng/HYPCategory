//
//  NSString+YPHexString.m
//  YPDemo
//
//  Created by Peng on 2017/11/3.
//  Copyright © 2017年 heyupeng. All rights reserved.
//

#import "NSString+YPHexString.h"

@implementation NSString (YPHexString)

void decToBin(int num, char *buffer) {
    if(num>0) {
        decToBin(num/2,buffer+1);
        *buffer = (char)(num%2+48);
    }
}

// 16进制字符串转数据流
- (NSData *)yp_hexStringToData {
    NSString *hexString = self;
    if ([hexString hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    if ([hexString rangeOfString:@" "].location != NSNotFound) {
        hexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if ([hexString length]%2 != 0) {
        return nil;
    }
    
    NSMutableData* data = [NSMutableData data];
    Byte byte = 0;
    for(int i=0;i<[hexString length];i++) {
        unichar ch = [hexString characterAtIndex:i];
        int value;
        if (ch >= '0' && ch <='9')
            value = ch - 48;    // '0' == 48
        else if (ch >= 'A' && ch <='F')
            value = ch - 'A' + 10;    // 'A' == 65
        else if (ch >= 'a' && ch <= 'f')
            value = ch - 'a' + 10;  // 'a' == 97
        else
            break;;
        
        if (i%2 == 0) byte = 0;
        
        byte = byte * 16 + value;
        if (i%2 == 1) {
            [data appendBytes:&byte length:1];
        }
    }
    return data;
}

- (long)yp_hexStringToLongValue {
    NSString * hex = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    const char * cstr = [hex cStringUsingEncoding:NSUTF8StringEncoding];
    return strtol(cstr, nil, 16);
}

- (long)yp_hexLongValue {
    NSString * hexString = [self uppercaseString];
    if ([hexString rangeOfString:@" "].location != NSNotFound) {
        hexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    long b = 0;
    for(int i=0;i<[hexString length];i++) {
        unichar ch = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int value;
        if (ch >= '0' && ch <='9')
            value = ch - 48;    // '0' == 48
        else if (ch >= 'A' && ch <='F')
            value = ch - 'A' + 10;    // 'A' == 65
        else if (ch >= 'a' && ch <= 'f')
            value = ch - 'a' + 10;  // 'a' == 97
        else
            break;
        
        b = b * 16 + value;
    }
    return b;
}

// 16进制字符串转ASCII字符串
- (NSString *)hexStringToASCIIString {
    NSString * hexString = self;
    
    NSString * str = @"";
    for (int i = 0; i < hexString.length; i+=2) {
        NSString * s = [hexString substringWithRange:NSMakeRange(i, 2)];
        const char * cstr = [s cStringUsingEncoding:NSUTF8StringEncoding];
        unichar  ch = strtoll(cstr, nil, 16);
        
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%c",ch & 0xff]];
    }
    return str;
}

// ASCII字符串转16进制字符串
- (NSString *)ASCIIStringToHexString {
    NSString * string = self;
    
    NSString * hexString = @"";
    for (int i = 0; i < string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        NSString * s = [NSString stringWithFormat:@"%.2x",ch & 0xff];
        hexString = [hexString stringByAppendingString:s];
    }
    return [hexString lowercaseString];
}

@end


@implementation NSString(YPHexReverse)

/// 16进制字符串的倒序。
///
///  @"ade2" => @"e2ad" .
///
///  @"ade23faa" => @"aa3fe2ad" .
///
///  @"ade23faa55d3" => @"d355aa3fe2ad" .
- (NSString *)hexStringReverse {
    NSString * hexString = self;
    
    if ([hexString hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    if (hexString.length % 2 == 1) {
        return @"";
    }
    
    NSString * string = @"";
    for (int i = 0, unitLength = 2; i < hexString.length; i += unitLength) {
        NSString * str1 = [hexString substringWithRange:NSMakeRange(hexString.length - unitLength -i, unitLength)];
        string = [string stringByAppendingString: str1];
    }
    return string;
}

@end

