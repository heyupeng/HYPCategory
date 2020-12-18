//
//  NSData+YPCrypt.m
//  YPDemo
//
//  Created by Mac on 2020/12/18.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import "NSData+YPCrypt.h"

@implementation NSData (yp_Crypt)

- (NSData *)yp_crypt:(CCOperation)cryptOp algorithm:(CCAlgorithm)algorithm keySize:(size_t)keySize blockSize:(size_t)blockSize WithKey:(NSString *)key {
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
    }
    
    free(dataout);
    return crypt;
}

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
    if (AES == 1) {
        keySize = kCCKeySizeAES192;
    } else if (AES == 2) {
        keySize = kCCKeySizeAES256;
    }
    
    NSData * crypt;
    crypt = [self yp_crypt:op algorithm:algorithm keySize:keySize blockSize:kCCBlockSizeAES128 WithKey:key];
    
    return crypt;
}

/// Encrypt by AES algorithm
/// @param AES {0: AES128, 1: AES192, 2: AES256}
/// @param key encrypt key
- (NSData *)yp_AESEncrypt:(int)AES WithKey:(NSString *)key {
    return [self yp_crypt:kCCEncrypt AES:AES WithKey:key];
}

/// Decrypt by AES algorithm
/// @param AES {0: AES128, 1: AES192, 2: AES256}
/// @param key encrypt key
- (NSData *)yp_AESDecrypt:(int)AES Withkey:(NSString *)key {
    return [self yp_crypt:kCCDecrypt AES:AES WithKey:key];
}

#pragma mark - AES Algorithm Encrypt
/// Encrypt by AES128
- (NSData *)yp_AES128EncryptedDataWithKey:(NSString *)key {
    return [self yp_AESEncrypt:0 WithKey:key];
}

/// Encrypt by AES192
- (NSData *)yp_AES192EncryptedDataWithKey:(NSString *)key {
    return [self yp_AESEncrypt:1 WithKey:key];
}

/// Encrypt by AES256
- (NSData *)yp_AES256EncryptedDataWithKey:(NSString *)key {
    return [self yp_AESEncrypt:2 WithKey:key];
}

#pragma mark - AES Algorithm Decrypt
/// Decrypt by AES128
- (NSData *)yp_AES128DecryptedDataWithKey:(NSString *)key {
    return [self yp_AESDecrypt:0 Withkey:key];
}

/// Decrypt by AES192
- (NSData *)yp_AES192DecryptedDataWithKey:(NSString *)key {
    return [self yp_AESDecrypt:1 Withkey:key];
}

/// Decrypt by AES256
- (NSData *)yp_AES256DecryptedDataWithKey:(NSString *)key {
    return [self yp_AESDecrypt:2 Withkey:key];
}

#pragma mark - DES Algorithm
/// DES
- (NSData *)yp_DESEncryptedDataWithKey:(NSString *)key {
    return [self yp_crypt:kCCEncrypt algorithm:kCCAlgorithmDES keySize:kCCKeySizeDES blockSize:kCCBlockSizeDES WithKey:key];
}

/// Triple-DES
- (NSData *)yp_3DESEncryptedDataWithKey:(NSString *)key {
    return [self yp_crypt:kCCEncrypt algorithm:kCCAlgorithm3DES keySize:kCCKeySize3DES blockSize:kCCBlockSize3DES WithKey:key];
}

/// DES Decrypt
- (NSData *)yp_DESDecryptedDataWithKey:(NSString *)key {
    return [self yp_crypt:kCCDecrypt algorithm:kCCAlgorithmDES keySize:kCCKeySizeDES blockSize:kCCBlockSizeDES WithKey:key];
}

/// Triple-DES Decrypt
- (NSData *)yp_3DESDecryptedDataWithKey:(NSString *)key {
    return [self yp_crypt:kCCDecrypt algorithm:kCCAlgorithm3DES keySize:kCCKeySize3DES blockSize:kCCBlockSize3DES WithKey:key];
}

@end
