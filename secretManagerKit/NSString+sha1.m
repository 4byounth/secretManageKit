//
//  NSString+sha1.m
//  secretManagerkit
//
//  Created by mac  on 2018/11/29.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(sha1)

-(NSString *)sha1{
    const char *cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2];
    for(int i = 0;i<CC_SHA1_DIGEST_LENGTH;i++ ){
        [output appendFormat:@"%02x",digest[i]];
    }
    return output;
}

-(NSString *)sha256{
    const char *cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0;i<CC_SHA256_DIGEST_LENGTH;i++ ){
        [output appendFormat:@"%02x",digest[i]];
    }
    return output;
}

@end
