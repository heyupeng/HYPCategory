//
//  NSString+YPDigest.m
//  YPDemo
//
//  Created by Peng on 2018/5/17.
//  Copyright © 2018年 heyupeng. All rights reserved.
//

#import "NSString+YPDigest.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (yp_MD5)

+ (NSString *)yp_md5: (NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

- (NSString *)yp_md5 {
    return [NSString yp_md5:self];
}

@end


@implementation NSString (yp_SHA1)

+ (NSString *)yp_sha1: (NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

- (NSString *)yp_sha1 {
    return [NSString yp_sha1:self];
}

@end


@implementation NSString (yp_SHA224)

+ (NSString *)yp_sha224: (NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

- (NSString *)yp_sha224 {
    return [NSString yp_sha224:self];
}

@end


@implementation NSString (yp_SHA256)

+ (NSString *)yp_sha256: (NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

- (NSString *)yp_sha256 {
    return [NSString yp_sha256:self];
}

@end


@implementation NSString (yp_SHA384)

+ (NSString *)yp_sha384: (NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

- (NSString *)yp_sha384 {
    return [NSString yp_sha384:self];
}

@end


@implementation NSString (yp_SHA512)

+ (NSString *)yp_sha512: (NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

- (NSString *)yp_sha512 {
    return [NSString yp_sha512:self];
}

@end
