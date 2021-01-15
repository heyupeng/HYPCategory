//
//  NSData+YPCrypto.h
//  YPDemo
//
//  Created by Mac on 2020/12/18.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonCrypto.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (yp_Crypto)

- (NSData *)yp_crypt:(CCOperation)cryptOp algorithm:(CCAlgorithm)algorithm keySize:(size_t)keySize blockSize:(size_t)blockSize WithKey:(NSString *)key;

/* AES */
- (NSData *)yp_AES128EncryptedDataWithKey:(NSString *)key;
- (NSData *)yp_AES192EncryptedDataWithKey:(NSString *)key;
- (NSData *)yp_AES256EncryptedDataWithKey:(NSString *)key;

- (NSData *)yp_AES128DecryptedDataWithKey:(NSString *)key;
- (NSData *)yp_AES192DecryptedDataWithKey:(NSString *)key;
- (NSData *)yp_AES256DecryptedDataWithKey:(NSString *)key;

/* DES */
- (NSData *)yp_DESEncryptedDataWithKey:(NSString *)key;
- (NSData *)yp_3DESEncryptedDataWithKey:(NSString *)key;

- (NSData *)yp_DESDecryptedDataWithKey:(NSString *)key;
- (NSData *)yp_3DESDecryptedDataWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
