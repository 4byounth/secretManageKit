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
#import <NS+BTCBase58.h>
#import <CommonCrypto/CommonDigest.h>

#import <CBSecp256k1.h>

#import <openssl/hmac.h>
#import <openssl/ripemd.h>
#import <openssl/sha.h>

#import "AESCipher.h"
#import <NSData+HexString.h>
#import "createAccountController.h"

//#import "intTobyte.h"
static NSString* ZAICHENG_PASSWORD_SEED = @"zaicheng.net";

@implementation Keysave
+(Byte *)RandomIV{
    Byte *iv = (Byte *)malloc(16);
    //    srand((unsigned int)NSTimeIntervalSince1970*1000);
    //    long rand = random();
    CCRandomGenerateBytes(iv, 16);
    NSLog(@"16位的iv:%@",[[NSData alloc] initWithBytes:iv length:16]);
    return iv;
}

+(Byte *)ZaichengPassword{
    
    Byte const *bseed = [ZAICHENG_PASSWORD_SEED dataUsingEncoding:NSUTF8StringEncoding].bytes;
    SHA256_CTX ctx256;
    SHA256_Init(&ctx256);
    Byte *sha256 = (Byte *)malloc(32);
    SHA256_Update(&ctx256, bseed, ZAICHENG_PASSWORD_SEED.length);
    SHA256_Final(sha256, &ctx256);
    return sha256;
}


/*
 保存信息
 */
+(Boolean) SaveKey:(NSData *)priKey :(NSData *)pubKey :(NSString *)account :(NSString *)password{
    Byte *iv1_byte = [Keysave RandomIV];
    Byte *iv0_byte = [Keysave RandomIV];
    //    Byte *iv1_byte = [@"A-16-Byte-String" dataUsingEncoding:NSUTF8StringEncoding].bytes;
    //    Byte *iv0_byte = [@"A-16-Byte-String" dataUsingEncoding:NSUTF8StringEncoding].bytes;
    
    
    NSData *iv1_data = [[NSData alloc] initWithBytes:iv1_byte length:16];
    NSData *iv0_data = [[NSData alloc] initWithBytes:iv0_byte length:16];
    
    
    NSData *ps_data = [password dataUsingEncoding:NSUTF8StringEncoding];
    //aes128加密
    NSData *enc1 = [AESCipher aesEncryptData:priKey :ps_data :iv1_data];
    //    NSData *enc1 = aesEncryptData(priKey, ps_data, iv1_data);
    //    NSData *enc0 = aesEncryptData(priKey, [[NSData alloc] initWithBytes:[Keysave ZaichengPassword] length:32], iv0_data);
    
    //数据转json字符串
    NSMutableDictionary *json_dic = [[NSMutableDictionary alloc] init];
    [json_dic setValue:account forKey:@"account"];
    [json_dic setValue:[pubKey dataToHexString] forKey:@"publickey"];
    [json_dic setValue:[enc1 dataToHexString] forKey:@"privatekey1"];
    [json_dic setValue:[iv1_data dataToHexString] forKey:@"iv1"];
    [json_dic  setValue:[priKey dataToHexString] forKey:@"privatekey0"];
    [json_dic setValue:[iv0_data dataToHexString] forKey:@"iv0"];
    [json_dic setValue:CIPHER forKey:@"cipher"];
    extern NSDictionary *userDic;
    userDic = json_dic;
    [NSUserDefaults.standardUserDefaults setObject:userDic forKey:@"userDic"];
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:json_dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json_str = [[NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",json_str);
    
    //创建文件路径
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *homePath = NSHomeDirectory();
    NSString *path = [homePath stringByAppendingString:@"/Documents/zaicheng.net/keysave/"];
    if([fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]){
        NSLog(@"目录创建成功");
    }
    else{
        NSLog(@"目录创建失败");
    }
    
    BOOL isDir = NO;
    BOOL existed = [fm fileExistsAtPath:path isDirectory:&isDir];
    if(isDir && existed){
        NSString *path1 = [path stringByAppendingFormat:@"%@.txt",account];
        if(![json_str writeToFile:path1 atomically:YES encoding:NSUTF8StringEncoding error:nil]){
            NSLog(@"写入失败");
        }
        [NSUserDefaults.standardUserDefaults setValue:path1 forKey:@"path"];
    }
    else{
        NSLog(@"文件不存在,为您创建文件");
        NSError *error;
        if(![fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]){
            NSLog(@"目录创建失败");
            NSLog(@"%@",error.debugDescription);
        }
        NSString *path1 = [path stringByAppendingFormat:@"%@.txt",account];
        if(![json_str writeToFile:path1 atomically:YES encoding:NSUTF8StringEncoding error:nil]){
            NSLog(@"写入失败");
        }
        [NSUserDefaults.standardUserDefaults setValue:path1 forKey:@"path"];
        return YES;
    }
    return false;
}

/*
 验证消息私钥
 */
+(NSData *)VerifyKey:(NSString *)account :(NSString *)password{
    extern NSDictionary *userDic;
    NSString *account1 = [userDic valueForKey:@"account"];
    if(![account isEqualToString:account1]){
        return nil;
    }
    NSString *encpriHex = [userDic valueForKey:@"privatekey1"];
    NSString *ivHex = [userDic valueForKey:@"iv1"];
    NSData *iv = [NSData hexStringToData:ivHex];
    NSData *envprikey = [NSData hexStringToData:encpriHex];
    NSData *ps_data = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSData *prikey = [AESCipher aesDecryptData:envprikey :ps_data :iv];
    if(prikey == nil){
        return nil;
    }
    NSData *pubkey = [CBSecp256k1 generatePublicKeyWithPrivateKey:prikey compression:YES];
    NSString *account2 = [createAccountController pubToAccount:pubkey];
    if(![account1 isEqualToString:account2]){
        return nil;
    }
    NSLog(@"私钥：%@",prikey);
    return prikey;
}



@end

@implementation AESCipher

//NSString const *kInitVector = @"A-16-Byte-String";
//size_t const kKeySize = kCCKeySizeAES128;
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
                                          16,
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
    
    NSData *iv_data = [iv dataUsingEncoding:NSUTF8StringEncoding];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encrptedData = [AESCipher aesEncryptData:contentData :keyData :iv_data ];
    //    NSData *encrptedData = aesEncryptData(contentData, keyData, iv_data);
    return [encrptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

+(NSString *) aesDecryptString:(NSString *)content : (NSString *)key :(NSString *)iv {
    NSCParameterAssert(content);
    NSCParameterAssert(key);
    
    NSData *iv_data = [iv dataUsingEncoding:NSUTF8StringEncoding];
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryptedData = [AESCipher aesDecryptData:contentData :keyData :iv_data];
    //    NSData *decryptedData = aesDecryptData(contentData, keyData,iv_data);
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

+(NSData *) aesEncryptData:(NSData *)contentData : (NSData *)keyData :(NSData *)iv {
    NSCParameterAssert(contentData);
    NSCParameterAssert(keyData);
    Byte *key_byte = keyData.bytes;
    Byte *data = (Byte *)malloc(16);
    if(keyData.length < 16){
        for(int i = keyData.length;i<16;i++){
            data[i] = 0;
        }
        for (int i = 0;i<keyData.length;i++) {
            data[i] = key_byte[i];
        }
    }
    NSLog(@"%@",[[NSData alloc] initWithBytes:data length:16]);
    //    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize * 8, kKeySize];
    //    NSCAssert(keyData.length == kKeySize, hint);
    return [AESCipher cipherOperation:contentData : [[NSData alloc] initWithBytes:data length:16]:kCCEncrypt :iv ];
    //    return cipherOperation(contentData, keyData, kCCEncrypt,iv);
}

+(NSData *) aesDecryptData:(NSData *)contentData : (NSData *)keyData :(NSData *)iv {
    NSCParameterAssert(contentData);
    NSCParameterAssert(keyData);
    
    Byte *key_byte = keyData.bytes;
    Byte *data = (Byte *)malloc(16);
    if(keyData.length < 16){
        for(int i = keyData.length;i<16;i++){
            data[i] = 0;
        }
        for (int i = 0;i<keyData.length;i++) {
            data[i] = key_byte[i];
        }
    }
    NSLog(@"%@",[[NSData alloc] initWithBytes:data length:16]);
    //    NSString *hint = [NSString stringWithFormat:@"The key size of AES-%lu should be %lu bytes!", kKeySize * 8, kKeySize];
    //    NSCAssert(keyData.length == kKeySize, hint);
    return [AESCipher cipherOperation:contentData :[[NSData alloc] initWithBytes:data length:16] :kCCDecrypt :iv];
    //    return cipherOperation(contentData, keyData, kCCDecrypt,iv);
}

@end

