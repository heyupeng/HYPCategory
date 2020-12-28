//
//  NSData+YPHexString.m
//  YPDemo
//
//  Created by Peng on 2019/3/11.
//  Copyright © 2019年 heyupeng. All rights reserved.
//

#import "NSData+YPHexString.h"

@implementation NSData (YPHexString)

+ (NSData *)yp_dataWithHexString:(NSString *)hexString {
    hexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([hexString hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    
    if (hexString.length % 2 == 1) {
        hexString = [@"0" stringByAppendingString:hexString];
    }
    
    NSMutableData * mdata = [NSMutableData new];
    // strtol() or 取字符ascii值计算
    for (int i = 0; i < hexString.length; i += 2) {
        NSRange range = NSMakeRange(i, 2);
        NSString * str1 = [hexString substringWithRange:range];
        const char * cstr = [str1 cStringUsingEncoding:NSUTF8StringEncoding];
        char ch = strtol(cstr, nil, 16);
        [mdata appendBytes:&ch length:1];
    }
    
    return mdata;
}

/**
 @Summary
 hexString
 @Discussion
 通过 `data.description` 去除修边字符"<>" 与间隔字符" " 获取 hexString。
 
 iOS 13 `data.description` 输出结果发生变化，不再适用。使用 `data.debugDescription` 代替。
 
 @code
 // iOS 13 data.description 输出结果发生变化:
 // - iOS 13 前: <7812548e c632ae85>
 // - iOS 13 后: {length = 8, bytes = 0x7812548ec632ae85}
 
 NSString * string;
 if (@available(iOS 13.0, *)) { string = self.debugDescription;}
 else { string = self.description;}
 /// 去除 <>
 string = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
 /// 去除 space
 string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
 return string;
 */
- (NSString *)yp_hexStringByDescription {
    NSString * string;
    if (@available(iOS 13.0, *)) {
        string = self.debugDescription;
    } else {
        string = self.description;
    }
    /// 去除 <>
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    /// 去除 space
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}

/**
 数据流转16进制字符串 <03000c00 04000643> => @"03000c0004000643"
 
 iOS 13 data.description 输出结果有变化，通过data.description 去除修边字符"<>" 与间隔字符" " 获取hexString 的方法不再适用。或可使用data.debugDescription 代替data.description。
 */
- (NSString *)yp_hexString {
    Byte * bytes = (Byte *)[self bytes];
    NSInteger length = [self length];
    
    NSMutableString * hexString = [[NSMutableString alloc] initWithCapacity:length * 2];
    
    for (int i = 0; i < length; i ++) {
        UInt8 byte = bytes[i];
        [hexString appendFormat:@"%02x", byte];
    }
    // 某些设备存在HexString携带大写字母的问题，这里统一转换为小写。
    return [hexString lowercaseString];
}

/**
 数据流转ascii字符串 <313233 343561 626364> => 12345abcd
 */
- (NSString *)yp_ASCIIString {
//    return [[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding];
    
    Byte * bytes = (Byte *)[self bytes];
    NSInteger length = [self length];
    
    NSMutableString * hexString = [[NSMutableString alloc] initWithCapacity:length];
    
    for (int i = 0; i < length; i ++) {
        UInt8 byte = bytes[i];
        [hexString appendFormat:@"%c", byte];
    }
    
    return hexString;
}

- (NSArray<NSNumber *> *)yp_bytes {
    Byte * bytes = (Byte *)[self bytes];
    NSInteger length = [self length];
    
    if (length < 1) {return @[];}
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:length];
    for (int i = 0; i < length; i ++) {
        UInt8 byte = bytes[i];
        [array addObject:[NSNumber numberWithUnsignedChar:byte]];
    }
    
    return array;
}

- (int)yp_hexIntValue {
    Byte * bytes = (Byte *)[self bytes];
    NSUInteger length = [self length];
    
    size_t l = 4 ;// sizeof(int);
    int start = (int)(length>l? length-l: 0);
    
    int value = 0;
    for (int i = start; i < length; i ++) {
        Byte byte = bytes[i];
        value = (value << 8) + byte;
    }
    
    return value;
}

- (NSInteger)yp_hexIntegerValue {
    Byte * bytes = (Byte *)[self bytes];
    NSUInteger length = [self length];
    
    size_t l = sizeof(NSInteger);
    int start = (int)(length>l? length-l: 0);
    
    NSInteger value = 0;
    for (int i = start; i < length; i ++) {
        Byte byte = bytes[i];
        value = (value << 8) + byte;
    }
    
    return value;
}

- (long long)yp_hexLongLongValue {
    Byte * bytes = (Byte *)[self bytes];
    NSInteger length = [self length];
    
    size_t l = sizeof(NSInteger);
    int start = (int)(length-l>0? length-l: 0);
    
    long long  value = 0;
    for (int i = start; i < length; i ++) {
        Byte byte = bytes[i];
        value = (value << 8) + byte;
    }
    
    return value;
}

@end


@implementation NSData (yp_hexString_deprecate_1_0)

+ (NSData *)dataWithHexString:(NSString *)hexString {
    return [self yp_dataWithHexString:hexString];
}

- (NSString *)hexString {
    return [self yp_hexString];
}

- (NSString *)ASCIIString {
    return [self yp_ASCIIString];
}

- (NSArray<NSNumber *> *)hexArray {
    return [self yp_bytes];
}

- (NSInteger)hexIntegerValue {
    return [self yp_hexIntegerValue];
}

- (long long)hexLongLongValue {
    return [self yp_hexLongLongValue];
}

@end
