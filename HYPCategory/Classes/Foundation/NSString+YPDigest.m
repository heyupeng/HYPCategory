//
//  NSString+YPDigest.m
//  YPDemo
//
//  Created by Peng on 2018/5/17.
//  Copyright © 2018年 heyupeng. All rights reserved.
//

#import "NSString+YPDigest.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (yp_Digest)

#pragma mark - MD5
- (NSString *)yp_md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

#pragma mark - SHA1
- (NSString *)yp_sha1 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

#pragma mark - SHA224
- (NSString *)yp_sha224 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA224_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA224_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

#pragma mark - SHA256
- (NSString *)yp_sha256 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

#pragma mark - SHA384
- (NSString *)yp_sha384 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

#pragma mark - SHA512
- (NSString *)yp_sha512 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return [output lowercaseString];
}

@end
