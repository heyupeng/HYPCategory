//
//  NSString+YPHexString.m
//  YPDemo
//
//  Created by Peng on 2017/11/3.
//  Copyright © 2017年 heyupeng. All rights reserved.
//

#import "NSString+YPHexString.h"

@implementation NSString (yp_NSStringExtensionMethods)

/// 删除空格字符。
- (NSString *)yp_stringByRemovingSpace {
    if ([self rangeOfString:@" "].location != NSNotFound) {
        return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return self;
}

@end

@implementation NSString (YPHexString)

char __base16EncodeLookup__(int value) {
    char * base16 = "0123456789abcdef";
    if (value >= 0 && value < 16) { return base16[value]; }
    return 0;
}

int __base16DecodeLookup__(unichar ch) {
    int value = 17;
    if (ch >= '0' && ch <='9') value = ch - 48;    // '0' == 48
    else if (ch >= 'A' && ch <='F') value = ch - 'A' + 10;    // 'A' == 65
    else if (ch >= 'a' && ch <= 'f') value = ch - 'a' + 10;  // 'a' == 97
    return value;
}

/// 删除16进制字符串多余字符。
- (NSString *)yp_stringByStandardizingHexDigit {
    NSString * hex = self;
    if ([hex hasPrefix:@"0x"]) {
        hex = [hex substringFromIndex:2];
    }
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    if ([hex rangeOfString:@" "].location != NSNotFound) {
        hex = [hex yp_stringByRemovingSpace];
    }
    NSRange range = [hex rangeOfString:@"[0-9A-Fa-f]{1,}" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound && range.length != hex.length) {
        hex = [hex substringWithRange:range];
    }
    if ([hex length] % 2 == 1) {
        hex = [@"0" stringByAppendingString:hex];
    }
    return hex;
}

// 16进制字符串转数据流
- (NSData *)yp_hexStringToData {
    NSString *hexString = [self yp_stringByStandardizingHexDigit];
    
    NSMutableData* data = [NSMutableData data];
    Byte byte = 0;
    for(int i=0;i<[hexString length];i++) {
        unichar ch = [hexString characterAtIndex:i];
        int value = __base16DecodeLookup__(ch);
        if (value > 16) { break; }
        
        if (i%2 == 0) byte = 0;
        
        byte = byte * 16 + value;
        if (i%2 == 1) {
            [data appendBytes:&byte length:1];
        }
    }
    return data;
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

- (long)yp_hexStringToLongValue {
    NSString * hex = [self yp_stringByStandardizingHexDigit];
    const char * cstr = [hex cStringUsingEncoding:NSUTF8StringEncoding];
    return strtol(cstr, nil, 16);
}

- (long)yp_hexLongValue {
    NSString * hexString = [self yp_stringByStandardizingHexDigit];
    
    long b = 0;
    for(int i=0;i<[hexString length];i++) {
        unichar ch = [hexString characterAtIndex:i];
        int value = __base16DecodeLookup__(ch);
        if (value > 16) { break; }
        b = b * 16 + value;
    }
    return b;
}

/// 16进制字符串的倒序。
///  @discussion "ade2" => @"e2ad" .
///  @discussion "ade23faa" => @"aa3fe2ad" .
///  @discussion "ade23faa55d3" => @"d355aa3fe2ad" .
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

