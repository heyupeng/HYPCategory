//
//  NSData+YPHexString.m
//  YPDemo
//
//  Created by Peng on 2019/3/11.
//  Copyright © 2019年 heyupeng. All rights reserved.
//

#import "NSData+YPHexString.h"

@implementation NSData (yp_NSDataExtendedMethods)

/**
 数据流反序。
 @discussion <313233 616263> => <636261 333231>
 */
- (NSData *)yp_reverseData {
    Byte * bytes = (Byte *)[self bytes];
    NSInteger length = [self length];
    NSMutableData * newData = [[NSMutableData alloc] initWithLength:length];
    for (NSInteger i = length - 1; i > 0; i --) {
        Byte byte = bytes[i];
        [newData appendBytes:&byte length:1];
    }
    return newData;
}

/**
 转码字符串。使用给定编码方式编码数据流 Data 。
 @param encoding 给定编码方式
 */
- (NSString *)yp_stringUsingEncoding:(NSStringEncoding)encoding {
    return [[NSString alloc] initWithData:self encoding:encoding];
}

/**
 转码UTF8字符串。使用 NSUTF8StringEncoding 编码数据流 Data 。
 @discussion <313233 616263> => "123abc"
 */
- (NSString *)yp_UTF8String {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

/**
 转码ASCII字符串。
 @discussion <313233 616263> => "123abc"
 */
- (NSString *)yp_ASCIIString {
    return [[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding];
}

@end

@implementation NSData (yp_HexString)

/// 删除16进制字符串非法字符。
NSString * yp_NSStringStandardizingHexDigit(NSString * hexString) {
    NSString * hex = hexString;
    if ([hex hasPrefix:@"0x"]) {
        hex = [hex substringFromIndex:2];
    }
    else if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    
    if ([hex rangeOfString:@" "].location != NSNotFound) {
        hex = [hex stringByReplacingOccurrencesOfString:@" " withString:@""];
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

/**
 16进制字符串转数据流。 @"03000c0004000643" => <03000c00 04000643>
 0.57 sec / 100,000
 */
+ (NSData *)yp_dataWithHexString:(NSString *)hexString {
    hexString = yp_NSStringStandardizingHexDigit(hexString);
    
    NSMutableData * mdata = [NSMutableData new];
    // strtol() or 取字符ascii值计算
    for (int i = 0; i < hexString.length; i += 2) {
        NSRange range = NSMakeRange(i, 2);
        NSString * substr = [hexString substringWithRange:range];
        const char * cstr = [substr cStringUsingEncoding:NSUTF8StringEncoding];
        char ch = strtol(cstr, nil, 16);
        [mdata appendBytes:&ch length:1];
    }
    
    return mdata;
}

/**
 数据流转16进制字符串。
 @Discussion 通过 `data.description` 去除修边字符"<>" 与间隔字符" " 获取 hexString。
 @Discussion iOS 13 `data.description` 输出结果发生变化，需使用 data.debugDescription 代替。
 
 @code
 // iOS 13 data.description 输出结果发生变化，需使用 data.debugDescription 代替:
 // - iOS 13 前: <7812548e c632ae85>
 // - iOS 13 后: {length = 8, bytes = 0x7812548ec632ae85}
 
 NSString * string;
 if (@available(iOS 13.0, *)) { string = self.debugDescription;}
 else { string = self.description;}
 
 string = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
 string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
 return string;
 @endcode
 */
- (NSString *)yp_hexStringByTrimmingAndSpaceCharacter {
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
 数据流转16进制字符串。 <03000c00 04000643> => @"03000c0004000643"
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
 NSNumber类型集合。
 */
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
    
    int value = 0;
    size_t l = 4 ;// sizeof(int);
    int start = (int)(length>l? length-l: 0);
    
    for (int i = start; i < length; i ++) {
        Byte byte = bytes[i];
        value = (value << 8) + byte;
    }
    
    return value;
}

- (long)yp_hexLongValue {
    Byte * bytes = (Byte *)[self bytes];
    NSUInteger length = [self length];
    
    long  value = 0;
    size_t l = sizeof(long);
    int start = (int)(length>l? length-l: 0);
    
    for (int i = start; i < length; i ++) {
        Byte byte = bytes[i];
        value = (value << 8) + byte;
    }
    
    return value;
}

- (long long)yp_hexLongLongValue {
    Byte * bytes = (Byte *)[self bytes];
    NSUInteger length = [self length];
    
    long long  value = 0;
    size_t l = sizeof(value);
    int start = (int)(length>l? length-l: 0);
    
    for (int i = start; i < length; i ++) {
        Byte byte = bytes[i];
        value = (value << 8) + byte;
    }
    
    return value;
}

- (NSInteger)yp_hexIntegerValue {
    Byte * bytes = (Byte *)[self bytes];
    NSUInteger length = [self length];
    
    NSInteger value = 0;
    size_t l = sizeof(NSInteger);
    int start = (int)(length>l? length-l: 0);
    
    for (int i = start; i < length; i ++) {
        Byte byte = bytes[i];
        value = (value << 8) + byte;
    }
    
    return value;
}

@end


@implementation NSData (yp_hexString_deprecate_1_0)

- (NSString *)ASCIIString {
    return [self yp_ASCIIString];
}

+ (NSData *)dataWithHexString:(NSString *)hexString {
    return [self yp_dataWithHexString:hexString];
}

- (NSString *)hexString {
    return [self yp_hexString];
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
