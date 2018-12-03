//
//  AESCipher.h
//  secretManagerKit
//
//  Created by mac  on 2018/12/3.
//  Copyright © 2018年 mac . All rights reserved.
//

#ifndef AESCipher_h
#define AESCipher_h


#endif /* AESCipher_h */
#import <Foundation/Foundation.h>

NSString * aesEncryptString(NSString *content, NSString *key,NSString *iv);
NSString * aesDecryptString(NSString *content, NSString *key,NSString *iv);

NSData * aesEncryptData(NSData *data, NSData *key,NSData *iv);
NSData * aesDecryptData(NSData *data, NSData *key,NSData *iv);

NSString *CIPHER = @"AES/CBC/PKCS5Padding";
