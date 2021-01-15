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

- (NSData *)yp_encryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key keySize:(size_t)keySize blockSize:(size_t)blockSize error:(NSError **)error;

- (NSData *)yp_decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm key:(NSString *)key keySize:(size_t)keySize blockSize:(size_t)blockSize error:(NSError **)error;

/* AES */
- (NSData *)yp_encryptedDataUsingAES128WithKey:(NSString *)key;
- (NSData *)yp_encryptedDataUsingAES192WithKey:(NSString *)key;
- (NSData *)yp_encryptedDataUsingAES256WithKey:(NSString *)key;

- (NSData *)yp_decryptedDataUsingAES128WithKey:(NSString *)key;
- (NSData *)yp_decryptedDataUsingAES192WithKey:(NSString *)key;
- (NSData *)yp_decryptedDataUsingAES256WithKey:(NSString *)key;

/* DES */
- (NSData *)yp_encryptedDataUsingDESWithKey:(NSString *)key;
- (NSData *)yp_decryptedDataUsingDESWithKey:(NSString *)key;

- (NSData *)yp_encryptedDataUsing3DESWithKey:(NSString *)key;
- (NSData *)yp_decryptedDataUsing3DESWithKey:(NSString *)key;

/* CAST */
- (NSData *)yp_encryptedDataUsingCAST:(size_t)keySize withKey:(NSString *)key;
- (NSData *)yp_decryptedDataUsingCAST:(size_t)keySize withKey:(NSString *)key;

/* RC4 */
- (NSData *)yp_encryptedDataUsingRC4:(size_t)keySize withKey:(NSString *)key;
- (NSData *)yp_decryptedDataUsingRC4:(size_t)keySize withKey:(NSString *)key;

/* RC2 */
- (NSData *)yp_encryptedDataUsingRC2:(size_t)keySize withKey:(NSString *)key;
- (NSData *)yp_decryptedDataUsingRC2:(size_t)keySize withKey:(NSString *)key;

/* Blowfish */
- (NSData *)yp_encryptedDataUsingBlowfish:(size_t)keySize withKey:(NSString *)key;
- (NSData *)yp_decryptedDataUsingBlowfish:(size_t)keySize withKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
