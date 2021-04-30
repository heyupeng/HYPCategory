//
//  YPViewController.m
//  HYPCategory
//
//  Created by heyupeng on 11/24/2020.
//  Copyright (c) 2020 heyupeng. All rights reserved.
//

#import "YPViewController.h"
#import <HYPCategory-umbrella.h>
//#import <YPCategory.h>
#import "Math+Extension.h"

@interface NSString (Debug)

@end

@implementation NSString (Debug)

//- (NSString *)debugDescription {
//    return [self stringByAppendingFormat:@"(len=%zi)", self.length];
//}

@end

@interface YPViewController ()

@end

@implementation YPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self digestTests];
    
    [self hexStringTests];
    
    [self safeAreaTests];
    
    [self cryptTests];
    
    [self arrayTests];
    
    [self hexConversionTests];
    
    [self SINTest];
    
    if ([self canOpenAppWithScheme:@"sushi"]) {
        [self openAppWithScheme:@"sushi"];

    }
}

/// 返回布尔值表示是否能通过给定scheme打开目标App。可以检查是否安装某App。
- (BOOL)canOpenAppWithScheme:(NSString *)scheme {
    NSString * urlString = [scheme stringByAppendingString:@"://"];
    NSURL *url = [NSURL URLWithString:urlString];
    return [[UIApplication sharedApplication] canOpenURL:url];
}

/// 通过给定scheme打开目标App。
- (void)openAppWithScheme:(NSString *)scheme {
    NSString * urlString = [scheme stringByAppendingString:@"://"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:url];
#pragma clang diagnostic pop
    }
}

- (void)digestTests {
    NSString * str = @"我的世界";
    
    NSLog(@"md5: \n %@", [str yp_md5]);
    NSLog(@"sha224: \n %@", [str yp_sha224]);
    NSLog(@"sha256: \n %@", [str yp_sha256]);
    NSLog(@"sha384: \n %@", [str yp_sha384]);
    NSLog(@"sha512: \n %@", [str yp_sha512]);
}

- (void)safeAreaTests {
    UIEdgeInsets sets0 = UIApplication.sharedApplication.yp_safeAreaInsets;
    UIEdgeInsets sets1 = UIApplication.sharedApplication.yp_safeAreaInsets1;
    
    NSLog(@"window safeArea: %@", NSStringFromUIEdgeInsets(sets0));
    NSLog(@"custom safeArea: %@", NSStringFromUIEdgeInsets(sets1));
}

- (void)hexStringTests {
    NSString * hex = @"0x678593205512";
    NSData * data = [NSData yp_dataWithHexString:hex];
    
    NSInteger intger = [data yp_hexIntegerValue];
    long long longlong = [data yp_hexLongValue];
    int i = [data yp_hexIntValue];
    NSString * hex1 = [data yp_hexString];
    
    NSLog(@"\n hex: %@ \n data: %@ \
          \n longValue: %lld \n intValue %d",
          hex, data.debugDescription,
          longlong, i);
}

- (void)cryptTests {
    NSString * str = @"我的世界";
    NSString * key = @"123";
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData * encryptedData = [data yp_encryptedDataUsingCAST:6 withKey:key];
    NSString * encrypted_base64String = [encryptedData base64EncodedStringWithOptions:0];
    NSLog(@"\n Data: %@ \n encryptedData: %@ \n Base64String: %@ ",
          data.hexString, encryptedData.yp_hexString.debugDescription, encrypted_base64String.debugDescription);
    
    NSData * decryptedData = [encryptedData yp_decryptedDataUsingCAST:6 withKey:key];
    NSString * decrypted_string = [[NSString alloc] initWithData:decryptedData  encoding:NSUTF8StringEncoding];
    NSLog(@"\n Data: %@ \n decryptedData: %@ \n decryptedString: %@",
          encryptedData.hexString, decryptedData.yp_hexString, decrypted_string);
}

- (void)arrayTests {
    NSArray * array = @[@1,@2,@3,@4];
    
    NSNumber * obj1 = [array yp_objectAtIndexInLoop:-5];
    
    NSNumber * obj2 = [array yp_objectAtIndexSafely:5];
    
    NSLog(@"\n `yp_objectAtIndexInLoop:` index:-5, value: %@; \
            \n `yp_objectAtIndexSafely:` index:5, value: %@",
          obj1, obj2);
}

/** 浮点型在内存中存在原理与表现；
 * float 长度 4 * 8 = 32(位) ，
 *  1. 第31位为符号码，
 *  2. 第30-23位为阶码（共8位，指数码，小数点位移数，默认127 (0x7f) ），
 *  3. 第22-0位为位移后的小数部分编码（共23位，不足位补0）。
 * doule 长度 8 * 8 = 64(位) ，
 *  1. 第63位为符号码，
 *  2. 第62-52位为阶码（共11位，指数码，小数点位移数，默认1023 (0x3ff)），
 *  3. 第51-0位为位移后的小数部分编码（共52位，不足位补0）。
 */

/// double型 符号码、指数码、尾数码
#define FLOAT_SIGN_SIZE 1
#define FLOAT_RANK_SIZE 8
#define FLOAT_MANTISSA_SIZE 23
#define FLOAT_RANK_BASIC_VALUE 0x7f
#define FLOAT_MANTISSA_MAX 0x7fffff

/// double型 符号码、指数码、尾数码
#define DOUBLE_SIGN_SIZE 1
#define DOUBLE_RANK_SIZE 11
#define DOUBLE_MANTISSA_SIZE 52
#define DOUBLE_RANK_BASIC_VALUE 0x3ff
#define DOUBLE_MANTISSA_MAX 0xfffffffffffff

/**
 (double)4294967293.000000 => 0x0000a0ffffffef41 (内存中表现) => 0x41efffffffa00000
  Bin: 0100000111101111111111111111111111111111101000000000000000000000
  SignedFlag: 0 => 0
  OffsetFlag: 10000011110 => 31
  DataFlag: 11111111111111111111111111111101000000000000000000000
   Bin: 11111111111111111111111111111101.0
   Hex: fffffffd.0
   Dec: 4294967296.000000
 
 (double)4294967295.000000 => 0x0000e0ffffffef41 (内存中表现) => 0x41ef ffff ffe0 0000
  Bin: 0100000111101111111111111111111111111111111000000000000000000000
  SignedFlag: 0 => 0
  OffsetFlag: 10000011110 => 31
  DataFlag: 11111111111111111111111111111111000000000000000000000
   Bin: 11111111111111111111111111111111.0
   Hex: ffffffff.0
   Dec: 4294967296.000000
 */

- (void)floatTest {
    float value = 2.2;
    printf("%f (double) \n", value);
    
    size_t size = sizeof(typeof(value));
    UInt8 bytes[size];
    memcpy(bytes, &value, size);
    
    printf(" => 0x");
    for (int i = 0; i < size; i ++) {
        UInt8 v = bytes[i];
        printf("%02x", v);
    }
    printf(" (内存中表现) \n");
    
    NSData * hexData = [NSData dataWithBytes:bytes length:size];
    // 小端高位字节在高位地址
    NSString *  hexString = [hexData yp_hexString];
    hexString = [hexString hexStringReverse];
    long memValue = 4614256656552045841;// (*(long *)hexData.bytes);
    printf(" => 0x%s => %ld \n", hexString.UTF8String, memValue);
    
    long signedFlag = 0, offsetFlag = 0, valueFlag = 0;
    
    // 8 * 4 => 1 + 8 + 23
    signedFlag = (memValue >> FLOAT_MANTISSA_SIZE) >> FLOAT_RANK_SIZE;
    offsetFlag = (memValue >> FLOAT_MANTISSA_SIZE) & (FLOAT_RANK_BASIC_VALUE * 2 + 1);
    offsetFlag -= FLOAT_RANK_BASIC_VALUE;
    valueFlag = (memValue & FLOAT_MANTISSA_MAX);
    valueFlag += (1 << FLOAT_MANTISSA_SIZE);
    
    NSString * binString = [hexString yp_hexToBin];
    NSString * flagBin = [binString substringWithRange:NSMakeRange(0, 1)];
    NSString * offsetBin = [binString substringWithRange:NSMakeRange(1, 8)];
    NSString * dataBin = [binString substringFromIndex:9];
    
    signedFlag = [[flagBin yp_binToDec] intValue];
    offsetFlag = [[offsetBin yp_binToDec] intValue] - FLOAT_RANK_BASIC_VALUE;
    
    printf(" Bin: %s \n", binString.debugDescription.UTF8String);
    printf(" => %s,%s,%s \n", flagBin.UTF8String, offsetBin.UTF8String, dataBin.UTF8String);
    printf(" SignFlag: %s => %ld \n", flagBin.UTF8String, signedFlag);
    printf(" ExpFlag: %s => %ld \n", offsetBin.debugDescription.UTF8String, offsetFlag);
    printf(" DataFlag(1.M): 1.%s \n", dataBin.debugDescription.UTF8String);
    
    dataBin = [@"1" stringByAppendingString: dataBin];

    NSString * intBin = @"0";
    NSString * decimalBin = @"";
    if (offsetFlag > (int)(dataBin.length - 1)) {
        // 尾部补充缺失0
        NSString * fillStr = @"";
        for (int i = 0; i < offsetFlag - (dataBin.length-1); i++) {
            fillStr = [fillStr stringByAppendingString:@"0"];
        }
        dataBin = [dataBin stringByAppendingString:fillStr];
    } else if (offsetFlag < -1) {
        // 当指数小于-1时，首部补充0
        NSString * fillStr = @"";
        for (int i = 0; i < (- offsetFlag - 1); i++) {
            fillStr = [fillStr stringByAppendingString:@"0"];
        }
        dataBin = [fillStr stringByAppendingString:dataBin];
    }
    
    if (offsetFlag >= 0) {
        intBin = [dataBin substringToIndex:offsetFlag + 1];
        decimalBin = [dataBin substringFromIndex:offsetFlag + 1];
    } else {
        decimalBin = dataBin;
    }
    
    // 小数部分去除尾部补位0
    NSRange range = [decimalBin rangeOfString:@"1" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        decimalBin = [decimalBin substringToIndex:range.location + range.length];
    } else {
        decimalBin = @"0";
    }
    
    printf("  Bin: %s.%s \n", intBin.UTF8String, decimalBin.UTF8String);
    printf("  Hex: %s.%s \n", [intBin yp_binToHex].UTF8String, [decimalBin yp_binToHex].UTF8String);
    
    long intDec = [[intBin yp_binToDec] longLongValue];
    
    double decimal = 0;
    int flag = 0;
    for (int i = 0; i < decimalBin.length; i ++) {
        NSString * s = [decimalBin substringWithRange:NSMakeRange(i, 1)];
        flag += 1;
        if ([s intValue] == 0) {
            continue;
        }
        double v = pow(0.5, (i + 1));
        if (v < pow(0.1, 20)) break;
        decimal += v;
        flag = 0;
    }
    
    typeof(value) decode = ((typeof(value))intDec + decimal) * (signedFlag == 0 ? 1 : -1);
    printf("  Dec: %.7f \n", decode);
}

- (void)donbleTest:(double)value {
    
    size_t size = sizeof(typeof(value));
    UInt8 bytes[size];
    memcpy(bytes, &value, size);
    
    printf(" => 0x");
    for (int i = 0; i < size; i ++) {
        UInt8 v = bytes[i];
        printf("%02x", v);
    }
    printf(" (内存中表现) \n");
    
    NSData * hexData = [NSData dataWithBytes:bytes length:size];
    // 小端高位字节在高位地址
    NSString *  hexString = [hexData yp_hexString];
    hexString = [hexString hexStringReverse];
    unsigned long memValue = (*(unsigned long *)hexData.bytes);
    printf(" => 0x%s => %ld \n", hexString.UTF8String, memValue);
    
    long signedFlag = 0, offsetFlag = 0, valueFlag = 0;
    // 8 * 8 => 1 + 11 + 52
    signedFlag = (memValue >> DOUBLE_MANTISSA_SIZE) >> DOUBLE_RANK_SIZE;
    offsetFlag = (memValue >> DOUBLE_MANTISSA_SIZE) & (DOUBLE_RANK_BASIC_VALUE * 2 + 1);
    offsetFlag -= DOUBLE_RANK_BASIC_VALUE;
    valueFlag = (memValue & DOUBLE_MANTISSA_MAX);
    valueFlag += ((long)1 << DOUBLE_MANTISSA_SIZE);
    
    NSString * binString = [hexString yp_hexToBin];
    NSString * flagBin;
    NSString * offsetBin;
    NSString * dataBin;
    
    flagBin = [binString substringWithRange:NSMakeRange(0, DOUBLE_SIGN_SIZE)];
    offsetBin = [binString substringWithRange:NSMakeRange(DOUBLE_SIGN_SIZE, DOUBLE_RANK_SIZE)];
    dataBin = [binString substringFromIndex:DOUBLE_SIGN_SIZE + DOUBLE_RANK_SIZE];
    
    printf(" Bin: %s \n", binString.debugDescription.UTF8String);
    printf(" => %s,%s,%s \n", flagBin.UTF8String, offsetBin.UTF8String, dataBin.UTF8String);
    
    signedFlag = [[flagBin yp_binToDec] intValue];
    offsetFlag = [[offsetBin yp_binToDec] intValue] - DOUBLE_RANK_BASIC_VALUE;
    
    printf(" SignFlag: %s => %ld \n", flagBin.UTF8String, signedFlag);
    printf(" ExpFlag: %s => %ld \n", offsetBin.debugDescription.UTF8String, offsetFlag);
    printf(" DataFlag(1.M): 1.%s \n", dataBin.debugDescription.UTF8String);
    
    dataBin = [@"1" stringByAppendingString: dataBin];

    NSString * intBin = @"0";
    NSString * decimalBin = @"";
    if (offsetFlag > (int)(dataBin.length - 1)) {
        // 尾部补充缺失0
        NSString * fillStr = @"";
        for (int i = 0; i < offsetFlag - (dataBin.length-1); i++) {
            fillStr = [fillStr stringByAppendingString:@"0"];
        }
        dataBin = [dataBin stringByAppendingString:fillStr];
    } else if (offsetFlag < -1) {
        // 当指数小于-1时，首部补充0
        NSString * fillStr = @"";
        for (int i = 0; i < (- offsetFlag - 1); i++) {
            fillStr = [fillStr stringByAppendingString:@"0"];
        }
        dataBin = [fillStr stringByAppendingString:dataBin];
    }
    
    if (offsetFlag >= 0) {
        intBin = [dataBin substringToIndex:offsetFlag + 1];
        decimalBin = [dataBin substringFromIndex:offsetFlag + 1];
    } else {
        decimalBin = dataBin;
    }
    
    // 小数部分去除尾部补位0
    NSRange range = [decimalBin rangeOfString:@"1" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        decimalBin = [decimalBin substringToIndex:range.location + range.length];
    } else {
        decimalBin = @"0";
    }
    
    printf("  Bin: %s.%s \n", intBin.UTF8String, decimalBin.UTF8String);
    printf("  Hex: %s.%s \n", [intBin yp_binToHex].UTF8String, [decimalBin yp_binToHex].UTF8String);
    
    long intDec = [[intBin yp_binToDec] longLongValue];
    
    double decimal = 0;
    int flag = 0;
    for (int i = 0; i < decimalBin.length; i ++) {
        NSString * s = [decimalBin substringWithRange:NSMakeRange(i, 1)];
        flag += 1;
        if ([s intValue] == 0) {
            continue;
        }
        double v = pow(0.5, (i + 1));
        if (v < pow(0.1, 20)) break;
        decimal += v;
        flag = 0;
    }
    
    typeof(value) decode = ((typeof(value))intDec + decimal) * (signedFlag == 0 ? 1 : -1);
    printf("  Dec: %.18f \n", decode);
}

- (void)hexConversionTests {
    double value = 0.725625;
    printf("%.27f (double) \n", value);
    [self donbleTest:value];
    
    NSString * s = @"5f3a7d9c";
    NSString * bin = [s yp_hexToBin];
    NSString * dec = [s yp_hexToDec];
}

- (void)SINTest {
    for (float i = -M_PI; i <= M_PI; i += 0.05) {
        CGFloat aa = asincosf(sin(i), cos(i));
        NSLog(@"%f => %f  %d", i, aa, isequaltozerof(i-aa));
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets insets = self.view.safeAreaInsets;
    NSLog(@"viewSafeAreaInsets: %@", NSStringFromUIEdgeInsets(insets));
}
@end
