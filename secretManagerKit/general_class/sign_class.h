//
//  sign_class.h
//  secretManagerKit
//
//  Created by mac on 2018/12/4.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface sign_class : NSObject


/*
 哈希签名
 */
+(NSData *)SignHash:(NSData *)hash :(NSData *)prikey;
/*
 文件哈希
 */
+(NSData *)HashFile:(NSString *)path;
/*
 消息哈希
 */
+(NSData *)HashMessage:(NSString *)message;
/*
 文件签名
 */
+(NSData *)SignFile: (NSString *)path :(NSData *)prikey;
/*
 消息签名
 */
+(NSData *)SignMessage: (NSString *)message :(NSData *)prikey;

/*
 验证哈希
 */
+(NSString *)VerifyHash: (NSData *)hash :(NSData *)sign;

/*
 验证文件签名
 */
+(NSString *)VerifyFile: (NSString *)path :(NSData *)Sign;

/*
 验证消息签名
 */
+(NSString *)VerifyMessage: (NSString *)message :(NSData *)Sign;

@end

NS_ASSUME_NONNULL_END
