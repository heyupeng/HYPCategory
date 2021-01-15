//
//  NSString+YPDigest.h
//  YPDemo
//
//  Created by Peng on 2018/5/17.
//  Copyright © 2018年 heyupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (yp_MD5)

+ (NSString *)yp_md5:(NSString *)string;
- (NSString *)yp_md5;

@end


@interface NSString (yp_SHA1)

+ (NSString *)yp_sha1: (NSString *)string;

- (NSString *)yp_sha1;

@end


@interface NSString (yp_SHA224)

+ (NSString *)yp_sha224: (NSString *)string;

- (NSString *)yp_sha224;
@end


@interface NSString (yp_SHA256)

+ (NSString *)yp_sha256: (NSString *)string;

- (NSString *)yp_sha256;

@end


@interface NSString (yp_SHA384)

+ (NSString *)yp_sha384: (NSString *)string;

- (NSString *)yp_sha384;

@end


@interface NSString (yp_SHA512)

+ (NSString *)yp_sha512: (NSString *)string;

- (NSString *)yp_sha512;

@end
