//
//  sign_class.m
//  secretManagerKit
//
//  Created by mac on 2018/12/4.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "sign_class.h"
#import <CBSecp256k1.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonRandom.h>
#import <CommonCrypto/CommonDigest.h>
#import <BCGenerator.h>
#import <BTCKey.h>
#import <NSData+HexString.h>
#import <BTCBase58.h>
#import <NS+BTCBase58.h>
#import <openssl/hmac.h>
#import <openssl/ripemd.h>
#import <openssl/sha.h>
#import <NSData+Hashing.h>
#import "createAccountController.h"

@implementation sign_class

/*
 哈希签名
 */
+(NSData *)SignHash:(NSData *)hash :(NSData *)prikey{
    NSData *sign2 = [CBSecp256k1 compactSignDataWithRecId:hash withPrivateKey:prikey];
    NSData *pubkey = [CBSecp256k1 recoverPubkey:hash :sign2];
    NSData *pubKey1 = [CBSecp256k1 generatePublicKeyWithPrivateKey:prikey compression:YES];
    return sign2;
}
/*
 文件哈希
 */
+(NSData *)HashFile:(NSString *)path{
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    SHA256_CTX ctx;
    SHA256_Init(&ctx);
    unsigned char sha256[32];
    SHA256_Update(&ctx, data.bytes, content.length);
    SHA256_Final(sha256, &ctx);
    Byte *hash = sha256;
    return [[NSData alloc]  initWithBytes:hash length:32];
}
/*
 消息哈希
 */
+(NSData *)HashMessage:(NSString *)message{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    SHA256_CTX ctx;
    SHA256_Init(&ctx);
    unsigned char sha256[32];
    SHA256_Update(&ctx, data.bytes, message.length);
    SHA256_Final(sha256, &ctx);
    Byte *hash = sha256;
    return [[NSData alloc]  initWithBytes:hash length:32];
//    return nil;
}
/*
 文件签名
 */
+(NSData *)SignFile: (NSString *)path :(NSData *)prikey{
    NSData *hash = [sign_class HashFile:path];
    return [sign_class SignHash:hash :prikey];
}
/*
 消息签名
 */
+(NSData *)SignMessage: (NSString *)message :(NSData *)prikey{
    NSData *hash = [sign_class HashMessage:message];
//    NSData *msg_data = [message dataUsingEncoding:NSUTF8StringEncoding];
    return [sign_class SignHash:hash :prikey];
}

/*
 验证哈希
 */
+(NSString *)VerifyHash: (NSData *)hash :(NSData *)sign{
    if(hash == nil || hash.length != 32){
        return nil;
    }
    NSData *pubkey = [CBSecp256k1 recoverPubkey:hash :sign];
    NSString *account = [createAccountController pubToAccount:pubkey];
    return account;

}

/*
 验证文件签名
 */
+(NSString *)VerifyFile: (NSString *)path :(NSData *)Sign{
    NSData *hash = [sign_class HashFile:path];
    return [sign_class VerifyHash:hash :Sign];
}

/*
 验证消息签名
 */
+(NSString *)VerifyMessage: (NSString *)message :(NSData *)Sign{
    NSData *hash = [sign_class HashMessage:message];
    return [sign_class VerifyHash:hash :Sign];
}

@end
