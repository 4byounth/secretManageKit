//
//  AESUtil.m
//  secretManagerKit
//
//  Created by mac  on 2018/12/1.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "AESUtil.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonRandom.h>
#import <CommonCrypto/CommonDigest.h>

static NSString* CIPHER = @"AES/CBC/PKCS5Padding";
NSString *const kInitVector = @"16-Bytes--String";
size_t const kKeySize = kCCKeySizeAES128;
@implementation AESUtil

+(Byte *) encrpyt:(Byte *)src :(Byte *) iv :(NSString *) password{
    Byte *ps = (Byte *)malloc(password.length);
    ps = [password dataUsingEncoding:NSUTF8StringEncoding].bytes;
    
    Byte *dst = nil;
    
    long epslen = (password.length + 15)/16*16;
    Byte *eps = (Byte *)malloc(epslen);
    for(int i = 0;i<password.length;i++){
        eps[i] = ps[i];
    }
    for(int i = (int)password.length;i<epslen;i++){
        eps[i] = 0;
    }
    
    return ps;
    
}

//加密函数
//CCCrypt(CCOperation op,
//        CCAlgorithm alg,
//        CCOptions options,
//        const void *key,
//        size_t keyLength,
//        const void *iv,
//        const void *dataIn,
//        size_t dataInLength,
//        void *dataOut,
//        size_t dataOutAvailable,
//        size_t *dataOutMoved)


+(NSString *)encryptAES:(NSString *)src :(NSString *)password{
    NSData *srcData = [src dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger dataLength = srcData.length;
    
    //为结束字符串'\0'+1
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [password getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    //密文长度<=明文长度 + blockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding, keyPtr, kKeySize, initVector.bytes, srcData.bytes, srcData.length, encryptedBytes, encryptSize, &actualOutSize);
    if(cryptStatus == kCCSuccess){
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    return nil;
}

//+(Byte *) encrypt: (Byte *)src :(Byte *)iv :(Byte*)ps{
//    long epslen = ( + 15)/16*16;
//    Byte* eps = (Byte *)malloc(epslen);
//
//}
@end
