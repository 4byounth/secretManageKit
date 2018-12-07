//
//  ViewController.m
//  secretManagerKit
//
//  Created by mac  on 2018/11/26.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "ViewController.h"
#import "create_delegate.h"
#import "createAccountController.h"
#import "global.h"
#import "sign_class.h"
#import <NSData+HexString.h>
#import "Keysave.h"
#import "AESCipher.h"
#import <CBSecp256k1.h>



extern BOOL isUsedFirstTime;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //首先从本地读取数据
    if([NSUserDefaults.standardUserDefaults valueForKey:@"account"]){
        extern NSString *account;
        extern NSString *password;
        account = [NSUserDefaults.standardUserDefaults valueForKey:@"account"];
        password = [NSUserDefaults.standardUserDefaults valueForKey:@"password"];
        self.label_account.text = account;
        [self.btn_secret_manager setEnabled:YES];
//        NSString *homePath = NSHomeDirectory();
//        NSString *path = [homePath stringByAppendingString:@"/Documents/zaicheng.net/keysave/"];
//        NSString *path1 = [path stringByAppendingFormat:@"%@.text",account];
        NSString *path1 = (NSString*)[NSUserDefaults.standardUserDefaults valueForKey:@"path"];
        NSLog(@"%@",path1);
        if([[NSFileManager defaultManager] fileExistsAtPath:path1]){
            NSLog(@"从文件中读取数据");
            [self readUserDatafromfile:account];
            extern NSDictionary *userDic;
            for (NSString *key in userDic){
                NSLog(@"[%@:%@]",key,userDic[key]);
            }
        }
        else{
            NSLog(@"文件不存在");
        }
    }
    if([NSUserDefaults.standardUserDefaults valueForKey:@"userDic"]){
        extern NSDictionary *userDic;
        userDic = [NSUserDefaults.standardUserDefaults valueForKey:@"userDic"];
        for (NSString *key in userDic) {
            NSLog(@"%@:%@",key,userDic[key]);
        }
    }
}


- (void)showAccount:(NSString *)account {
    [self.label_account setText:account];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id vc = segue.destinationViewController;
    if([vc isKindOfClass:[createAccountController class]]){
        createAccountController* createView = vc;
        createView._delegate = self;
    }
}

-(void)readUserDatafromfile:(NSString *)account{
    NSString *homePath = NSHomeDirectory();
    NSString *path = [homePath stringByAppendingFormat:@"/%@%@",@"zaicheng.net/keysave/",account];
    NSString *path1 = [path stringByAppendingString:@"my.text"];
    NSString *str = [NSString stringWithContentsOfFile:path1 encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    extern NSDictionary *userDic;
    NSError *err;
    userDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err){
        NSLog(@"json解析失败");
    }
}




@end
