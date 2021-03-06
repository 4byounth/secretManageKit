//
//  AESCipher.m
//  secretManagerKit
//
//  Created by mac  on 2018/12/3.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "AESCipher.h"

@implementation AESCipher

NSString const *kInitVector = @"A-16-Byte-String";
size_t const kKeySize = kCCKeySizeAES128;
NSString *CIPHER = @"AES/CBC/PKCS5Padding";

+(NSData *) cipherOperation:(NSData *)contentData :(NSData *)keyData :(CCOperation) operation :(NSData *)iv {
    NSUInteger dataLength = contentData.length;
    
    //    void const *initVectorBytes = [kInitVector dataUsingEncoding:NSUTF8StringEncoding].bytes;
    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    if (operationBytes == NULL) {
        return nil;
    }
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyBytes,
                                          kKeySize,
                                          iv.bytes,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
    }
    free(operationBytes);
    operationBytes = NULL;
    return nil;
}

+(NSString *) aesEncryptString:(NSString *)content :(NSString *)key :(NSString *)iv {
    NSCParameterAssert(content);
    NSCParameterAssert(key);
    
    NSData *iv_data = [iv dataUsingEncoding:NSUTF8StringEncoding].bytes;
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encrptedData = [AESCipher aesDecryptData:contentData :keyData :iv_data ];
//    NSData *encrptedData = aesEncryptData(contentData, keyData, iv_data);
    return [encrptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

+(NSString *) aesDecryptString:(NSString *)content : (NSString *)key :(NSString *)iv {
    NSCParameterAssert(content);
    NSCParameterAssert(key);
    
    NSData *iv_data = [iv dataUsingEncoding:NSUTF8StringEncoding].bytes;
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryptedData = [AESCipher aesDecryptData:contentData :keyData :iv_data];
//    NSData *decryptedData = aesDecryptData(contentData, keyData,iv_data);
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

+(NSData *) aesEncryptData:(NSData *)contentData : (NSData *)keyData :(NSData *)iv {
    NSCParameterAssert(contentData);
    NSCParameterAssert(keyData);
    
//    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize * 8, kKeySize];
//    NSCAssert(keyData.length == kKeySize, hint);
    return [AESCipher cipherOperation:contentData :keyData :kCCEncrypt :iv ];
//    return cipherOperation(contentData, keyData, kCCEncrypt,iv);
}

+(NSData *) aesDecryptData:(NSData *)contentData : (NSData *)keyData :(NSData *)iv {
    NSCParameterAssert(contentData);
    NSCParameterAssert(keyData);
    
    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize * 8, kKeySize];
    NSCAssert(keyData.length == kKeySize, hint);
    return [AESCipher cipherOperation:contentData :keyData :kCCEncrypt :iv ];
//    return cipherOperation(contentData, keyData, kCCDecrypt,iv);
}

@end
