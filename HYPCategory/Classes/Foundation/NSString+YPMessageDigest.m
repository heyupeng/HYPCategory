//
//  NSString+YPMessageDigest.m
//  YPDemo
//
//  Created by Peng on 2018/5/17.
//  Copyright © 2018年 heyupeng. All rights reserved.
//

#import "NSString+YPMessageDigest.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (yp_MD5)

+ (NSString *)y_md5: (NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

- (NSString *)yp_md5 {
    return [NSString md5:self];
}

@end


@implementation NSString (yp_MD_deprecate_1_0)

+ (NSString *)md5:(NSString *)string {
    return [self yp_md5: string];
}
- (NSString *)md5 {
    return [self yp_md5];
}

@end
