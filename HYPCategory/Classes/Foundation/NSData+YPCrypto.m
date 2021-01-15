//
//  NSData+YPCrypto.m
//  YPDemo
//
//  Created by Mac on 2020/12/18.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import "NSData+YPCrypto.h"

@implementation NSData (yp_Crypto)

- (NSData *)yp_crypt:(CCOperation)cryptOp algorithm:(CCAlgorithm)algorithm key:(NSString *)key keySize:(size_t)keySize blockSize:(size_t)blockSize error:(NSError **)error {
    NSData * data = self;
    
    NSInteger length = blockSize + data.length;
    Byte * dataout = malloc(length);
    size_t moved = 0;
    
    CCCryptorStatus status = CCCrypt(cryptOp, algorithm, 0xff,
                                     key.UTF8String, keySize, nil,
                                     data.bytes, data.length,
                                     dataout, length,
                                     &moved);
    NSData * crypt;
    if (status == kCCSuccess) {
        crypt = [NSData dataWithBytes:(void*)dataout length:moved];
    } else {
        NSLog(@"Crypt Error (%d)", status);
        if (error) *error = [NSError errorWithDomain:@"Crypto" code:status userInfo:@{}];
    }
    
    free(dataout);
    return crypt;
}

- (NSData *)yp_encryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key keySize:(size_t)keySize blockSize:(size_t)blockSize error:(NSError **)error {
    return [self yp_crypt:kCCEncrypt algorithm:algorithm key:key keySize:keySize blockSize:blockSize  error:error];
}

- (NSData *)yp_decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key keySize:(size_t)keySize blockSize:(size_t)blockSize error:(NSError **)error {
    return [self yp_crypt:kCCDecrypt algorithm:algorithm key:key keySize:keySize blockSize:blockSize  error:error];
}

#pragma mark - AES Algorithm Encrypt
/// crypt
/// @param cryptOp crypt basic operation: kCCEncrypt/0 or kCCDecrypt/1.
/// @param AES  {0: AES128, 1: AES192, 2: AES256}
/// @param key encrypt / decrypt key
- (NSData *)yp_crypt:(CCOperation)cryptOp AES:(int)AES WithKey:(NSString *)key {
    /// Operation
    CCOperation op = cryptOp;
    /// Algorithm
    CCAlgorithm algorithm = kCCAlgorithmAES;
    /// KeySize
    size_t keySize = kCCKeySizeAES128;
    if (AES == 1) { keySize = kCCKeySizeAES192; }
    else if (AES == 2) { keySize = kCCKeySizeAES256;}
    
    NSData * crypt = [self yp_crypt:op algorithm:algorithm key:key keySize:keySize blockSize:kCCBlockSizeAES128 error:nil];
    return crypt;
}

/// Encrypt by AES algorithm
/// @param AES {0: AES128, 1: AES192, 2: AES256}
/// @param key encrypt key
- (NSData *)yp_encryptUsingAES:(int)AES WithKey:(NSString *)key {
    return [self yp_crypt:kCCEncrypt AES:AES WithKey:key];
}

/// Decrypt by AES algorithm
/// @param AES {0: AES128, 1: AES192, 2: AES256}
/// @param key encrypt key
- (NSData *)yp_decryptUsingAES:(int)AES Withkey:(NSString *)key {
    return [self yp_crypt:kCCDecrypt AES:AES WithKey:key];
}

/// Encrypt by AES128
- (NSData *)yp_encryptedDataUsingAES128WithKey:(NSString *)key {
    return [self yp_encryptUsingAES:0 WithKey:key];
}

/// Encrypt by AES192
- (NSData *)yp_encryptedDataUsingAES192WithKey:(NSString *)key {
    return [self yp_encryptUsingAES:1 WithKey:key];
}

/// Encrypt by AES256
- (NSData *)yp_encryptedDataUsingAES256WithKey:(NSString *)key {
    return [self yp_encryptUsingAES:2 WithKey:key];
}

#pragma mark - AES Algorithm Decrypt
/// Decrypt by AES128
- (NSData *)yp_decryptedDataUsingAES128WithKey:(NSString *)key {
    return [self yp_decryptUsingAES:0 Withkey:key];
}

/// Decrypt by AES192
- (NSData *)yp_decryptedDataUsingAES192WithKey:(NSString *)key {
    return [self yp_decryptUsingAES:1 Withkey:key];
}

/// Decrypt by AES256
- (NSData *)yp_decryptedDataUsingAES256WithKey:(NSString *)key {
    return [self yp_decryptUsingAES:2 Withkey:key];
}

#pragma mark - DES Algorithm
/// DES
- (NSData *)yp_encryptedDataUsingDESWithKey:(NSString *)key {
    CCAlgorithm algorithm = kCCAlgorithmDES;
    size_t keySize = kCCKeySizeDES;
    size_t blockSize = kCCBlockSizeDES;
    return [self yp_encryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

/// DES Decrypt
- (NSData *)yp_decryptedDataUsingDESWithKey:(NSString *)key {
    CCAlgorithm algorithm = kCCAlgorithmDES;
    size_t keySize = kCCKeySizeDES;
    size_t blockSize = kCCBlockSizeDES;
    return [self yp_decryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

/// Triple-DES
- (NSData *)yp_encryptedDataUsing3DESWithKey:(NSString *)key {
    CCAlgorithm algorithm = kCCAlgorithm3DES;
    size_t keySize = kCCKeySize3DES;
    size_t blockSize = kCCBlockSize3DES;
    return [self yp_encryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

/// Triple-DES Decrypt
- (NSData *)yp_decryptedDataUsing3DESWithKey:(NSString *)key {
    CCAlgorithm algorithm = kCCAlgorithm3DES;
    size_t keySize = kCCKeySize3DES;
    size_t blockSize = kCCBlockSize3DES;
    return [self yp_decryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

#pragma mark - CAST Algorithm
/// Encrypt using CAST.
/// @param keySize 取值范围 [kCCKeySizeMinCAST , kCCKeySizeMaxCAST]。
/// @param key 加密密匙
- (NSData *)yp_encryptedDataUsingCAST:(size_t)keySize withKey:(NSString *)key {
    if (keySize < kCCKeySizeMinCAST) keySize = kCCKeySizeMinCAST;
    if (keySize > kCCKeySizeMaxCAST) keySize = kCCKeySizeMaxCAST;
    
    CCAlgorithm algorithm = kCCAlgorithmCAST;
    size_t blockSize = kCCContextSizeCAST;
    return [self yp_encryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

/// decrypt using CAST.
/// @param keySize 取值范围 [kCCKeySizeMinCAST , kCCKeySizeMaxCAST]。
/// @param key 加密密匙
- (NSData *)yp_decryptedDataUsingCAST:(size_t)keySize withKey:(NSString *)key {
    if (keySize < kCCKeySizeMinCAST) keySize = kCCKeySizeMinCAST;
    if (keySize > kCCKeySizeMaxCAST) keySize = kCCKeySizeMaxCAST;
    
    CCAlgorithm algorithm = kCCAlgorithmCAST;
    size_t blockSize = kCCContextSizeRC4;
    return [self yp_decryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

#pragma mark - RC4 Algorithm
/// Encrypt using RC4.
/// @param keySize 取值范围 [kCCKeySizeMinRC4, kCCKeySizeMaxRC4]。
/// @param key 加密密匙
- (NSData *)yp_encryptedDataUsingRC4:(size_t)keySize withKey:(NSString *)key {
    int interval[] = {kCCKeySizeMinRC4, kCCKeySizeMaxRC4};
    if (keySize < interval[0]) keySize = interval[0];
    if (keySize > interval[1]) keySize = interval[1];
    
    CCAlgorithm algorithm = kCCAlgorithmRC4;    
    size_t blockSize = kCCContextSizeRC4;
    return [self yp_encryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

/// decrypt using RC4.
/// @param keySize 取值范围 [kCCKeySizeMinRC4, kCCKeySizeMaxRC4]。
/// @param key 加密密匙
- (NSData *)yp_decryptedDataUsingRC4:(size_t)keySize withKey:(NSString *)key {
    int interval[] = {kCCKeySizeMinRC4, kCCKeySizeMaxRC4};
    if (keySize < interval[0]) keySize = interval[0];
    if (keySize > interval[1]) keySize = interval[1];
    
    CCAlgorithm algorithm = kCCAlgorithmRC4;
    size_t blockSize = kCCContextSizeRC4;
    return [self yp_decryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

#pragma mark - RC2 Algorithm
/// Encrypt using RC2.
/// @param keySize 取值范围 [kCCAlgorithmBlowfish, kCCKeySizeMaxRC2]。
/// @param key 加密密匙
- (NSData *)yp_encryptedDataUsingRC2:(size_t)keySize withKey:(NSString *)key {
    int interval[] = {kCCKeySizeMinRC2, kCCKeySizeMaxRC2};
    if (keySize < interval[0]) keySize = interval[0];
    if (keySize > interval[1]) keySize = interval[1];
    
    CCAlgorithm algorithm = kCCAlgorithmRC2;
    size_t blockSize = kCCBlockSizeRC2;
    return [self yp_encryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

/// decrypt using RC2.
/// @param keySize 取值范围 [kCCKeySizeMinRC2, kCCKeySizeMaxRC2]。
/// @param key 加密密匙
- (NSData *)yp_decryptedDataUsingRC2:(size_t)keySize withKey:(NSString *)key {
    int interval[] = {kCCKeySizeMinRC2, kCCKeySizeMaxRC2};
    if (keySize < interval[0]) keySize = interval[0];
    if (keySize > interval[1]) keySize = interval[1];
    
    CCAlgorithm algorithm = kCCAlgorithmRC2;
    size_t blockSize = kCCBlockSizeRC2;
    return [self yp_decryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

#pragma mark - Blowfish Algorithm
/// Encrypt using Blowfish.
/// @param keySize 取值范围 [kCCAlgorithmBlowfish, kCCKeySizeMaxBlowfish]。
/// @param key 加密密匙
- (NSData *)yp_encryptedDataUsingBlowfish:(size_t)keySize withKey:(NSString *)key {
    int interval[] = {kCCKeySizeMinBlowfish, kCCKeySizeMaxBlowfish};
    if (keySize < interval[0]) keySize = interval[0];
    if (keySize > interval[1]) keySize = interval[1];
    
    CCAlgorithm algorithm = kCCAlgorithmBlowfish;
    size_t blockSize = kCCBlockSizeBlowfish;
    return [self yp_encryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

/// decrypt using Blowfish.
/// @param keySize 取值范围 [kCCAlgorithmBlowfish, kCCKeySizeMaxBlowfish]。
/// @param key 加密密匙
- (NSData *)yp_decryptedDataUsingBlowfish:(size_t)keySize withKey:(NSString *)key {
    int interval[] = {kCCKeySizeMinBlowfish, kCCKeySizeMaxBlowfish};
    if (keySize < interval[0]) keySize = interval[0];
    if (keySize > interval[1]) keySize = interval[1];
    
    CCAlgorithm algorithm = kCCAlgorithmBlowfish;
    size_t blockSize = kCCBlockSizeBlowfish;
    return [self yp_decryptedDataUsingAlgorithm:algorithm key:key keySize:keySize blockSize:blockSize error:nil];
}

@end
