//
//  main.m
//  secretManagerKit
//
//  Created by mac  on 2018/11/26.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NSString *account = @"";
BOOL isUsedFirstTime = NO;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        if(![NSUserDefaults.standardUserDefaults valueForKey:@"account"]){
            account = [NSUserDefaults.standardUserDefaults valueForKey:@"account"];
        }
        NSLog(@"%@",account);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
