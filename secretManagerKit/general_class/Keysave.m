//
//  Keysave.m
//  secretManagerKit
//
//  Created by mac  on 2018/12/1.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "Keysave.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonRandom.h>
#import <CommonCrypto/CommonDigest.h>

#import <openssl/hmac.h>
#import <openssl/ripemd.h>
#import <openssl/sha.h>
#import "AESCipher.h"
//#import "intTobyte.h"
static NSString* ZAICHENG_PASSWORD_SEED = @"zaicheng.net";

@implementation Keysave
+(Byte *)RandomIV{
    Byte *iv = (Byte *)malloc(16);
//    srand((unsigned int)NSTimeIntervalSince1970*1000);
//    long rand = random();
    CCRandomGenerateBytes(iv, 16);
    return iv;
}

+(Byte *)ZaichengPassword{
    
    Byte *bseed = [ZAICHENG_PASSWORD_SEED dataUsingEncoding:NSUTF8StringEncoding].bytes;
    SHA256_CTX ctx256;
    SHA256_Init(&ctx256);
    Byte *sha256 = (Byte *)malloc(32);
    SHA256_Update(&ctx256, bseed, ZAICHENG_PASSWORD_SEED.length);
    SHA256_Final(sha256, &ctx256);
    return sha256;
}

+(Boolean)  SaveKey:(NSData *)priKey: (NSData *)pubKey: (NSString *)account: (NSString *)password{
    Byte *iv1_byte = [Keysave RandomIV];
    Byte *iv0_byte = [Keysave RandomIV];
    
    
    NSData *iv1_data = [[NSData alloc] initWithBytes:iv1_byte length:16];
    NSData *iv0_data = [[NSData alloc] initWithBytes:iv0_byte length:16];
    
    NSData *ps_data = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *enc1 = aesEncryptData(priKey, ps_data, iv1_data);
    NSData *enc0 = aesEncryptData(priKey, [[NSData alloc] initWithBytes:[Keysave ZaichengPassword] length:32], iv0_data);
    
    return false;
}


@end
