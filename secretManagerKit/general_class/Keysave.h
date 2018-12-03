//
//  Keysave.h
//  secretManagerKit
//
//  Created by mac  on 2018/12/1.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Keysave : NSObject

+(Byte *)RandomIV;
+(Boolean) SaveKey:(NSData *)priKey :(NSData *)pubKey :(NSString *)account :(NSString *)password;
@end

NS_ASSUME_NONNULL_END
