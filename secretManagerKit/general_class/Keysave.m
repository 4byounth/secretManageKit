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
    
    
    NSData *iv1_data = [[NSData alloc] initWithBytes:iv1_byte length:16];
    NSData *iv0_data = [[NSData alloc] initWithBytes:iv0_byte length:16];
    NSLog(@"16位的iv:%lu",(unsigned long)iv1_data.length);
    NSLog(@"16位的iv:%lu",iv0_data.length);
    
    
    NSData *ps_data = [password dataUsingEncoding:NSUTF8StringEncoding];
    //aes128加密
    NSData *enc1 = [AESCipher aesEncryptData:priKey :ps_data :iv1_data];
//    NSData *enc1 = aesEncryptData(priKey, ps_data, iv1_data);
//    NSData *enc0 = aesEncryptData(priKey, [[NSData alloc] initWithBytes:[Keysave ZaichengPassword] length:32], iv0_data);
    
    //数据转json字符串
    NSMutableDictionary *json_dic = [[NSMutableDictionary alloc] init];
    [json_dic setValue:account forKey:@"account"];
    [json_dic setValue:pubKey forKey:@"publickey"];
    [json_dic setValue:enc1 forKey:@"privatekey1"];
    [json_dic setValue:iv1_data forKey:@"iv1"];
    [json_dic  setValue:priKey forKey:@"privatekey0"];
    [json_dic setValue:iv0_data forKey:@"iv0"];
    [json_dic setValue:[CIPHER dataUsingEncoding:NSUTF8StringEncoding] forKey:@"cipher"];
    for(NSString *key in json_dic){
        NSLog(@"%@",key);
    }
    NSData *json_data = [NSJSONSerialization dataWithJSONObject:json_dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json_str = [[NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding];
    
    //创建文件路径
    NSString *path = [@"Users/zaicheng.net/keysave/" stringByAppendingString:account];
    NSArray *pathArray = [path pathComponents];
    NSLog(@"%@",pathArray);
    //创建文件
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path]){
        NSLog(@"存在文件");
        //创建文件操作对象
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:path];
        [fileHandler writeData:[json_str dataUsingEncoding:NSUTF8StringEncoding]];
        return YES;
    }
    else{
        NSLog(@"文件不存在,为您创建文件");
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        [fm createFileAtPath:path contents:[json_str dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        //创建文件操作对象
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:path];
        [fileHandler writeData:[json_str dataUsingEncoding:NSUTF8StringEncoding]];
        return YES;
    }
    
    
    return false;
}


@end
