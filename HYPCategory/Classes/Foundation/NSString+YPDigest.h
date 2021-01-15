//
//  NSString+YPDigest.h
//  YPDemo
//
//  Created by Peng on 2018/5/17.
//  Copyright © 2018年 heyupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (yp_Digest)

/* MD5 */
- (NSString *)yp_md5;

/* SHA1 */
- (NSString *)yp_sha1;

/* SHA224 */
- (NSString *)yp_sha224;

/* SHA256 */
- (NSString *)yp_sha256;

/* SHA384 */
- (NSString *)yp_sha384;

/* SHA512 */
- (NSString *)yp_sha512;

@end
