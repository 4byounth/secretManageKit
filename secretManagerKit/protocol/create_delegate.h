//
//  create_delegate.h
//  secretManagerKit
//
//  Created by mac  on 2018/11/30.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol create_delegate <NSObject>

//显示账号
-(void) showAccount:(NSString *)account;

@end

NS_ASSUME_NONNULL_END
