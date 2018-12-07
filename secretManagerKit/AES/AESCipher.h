//
//  AESCipher.h
//  secretManagerKit
//
//  Created by mac  on 2018/12/3.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN
extern NSString *CIPHER;

@interface AESCipher:NSObject{
    
}
+(NSData *) cipherOperation:(NSData *)contentData :(NSData *)keyData :(CCOperation) operation :(NSData *)iv;
+(NSString *) aesEncryptString:(NSString *)content :(NSString *)key :(NSString *)iv;

+(NSString *) aesDecryptString:(NSString *)content : (NSString *)key :(NSString *)iv;
+(NSData *) aesEncryptData:(NSData *)contentData : (NSData *)keyData :(NSData *)iv;
+(NSData *) aesDecryptData:(NSData *)contentData : (NSData *)keyData :(NSData *)iv;

@end

NS_ASSUME_NONNULL_END
