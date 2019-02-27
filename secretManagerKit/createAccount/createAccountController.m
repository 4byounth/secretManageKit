//
//  createAccountController.m
//  secretManagerKit
//
//  Created by mac  on 2018/11/27.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "createAccountController.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CBSecp256k1.h>
#import <NSData+HexString.h>
#import "NSData+Hashing.h"
#import <CBBase58/BTCBase58.h>
#import <CBBase58/NS+BTCBase58.h>
#import <BCGenerator.h>
#import <BTCKey.h>
#import <NSData+HexString.h>
#import <BTCBase58.h>
#import <NS+BTCBase58.h>

#import <openssl/hmac.h>
#import <openssl/ripemd.h>
#import <openssl/sha.h>
#import "intTobyte.h"
#import "Keysave.h"
#import "sign_class.h"
#import "fileSelect/fileSelectController.h"


/*
 整数转字节
 */
Byte* intmax_tToBytes(intmax_t num){
    Byte* target = (Byte*)malloc(LEN_PRIKEY);
    for(int i = 0;i<LEN_PRIKEY;i++){
        int offset = (LEN_PRIKEY-1-i)*8;
        target[i] = (Byte)((num>>offset) & 0xFF);
        NSLog(@"%hhu",target[i]);
    }
    return target;
}

@interface createAccountController ()

@end

//NSString *account;
//BOOL isUsedFirstTime;


@implementation createAccountController

@synthesize _delegate = delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)click_create_account:(id)sender {
    if(![_field_pwd.text  isEqual: @""] && ![_field_confire_pwd.text  isEqual: @""]){
        if([_field_confire_pwd.text isEqualToString:_field_pwd.text] == NO){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"两次输入的密码不一致" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
        else{
            //密码验证通过之后的处理代码
            //调用账号生成函数,生成账号
            NSData *priData = [[NSData alloc] initWithBytesNoCopy:[self getPriKey] length:32];
            BTCKey *btckey = [[BTCKey alloc] initWithPrivateKey:priData];
            btckey.publicKeyCompressed = YES;
            NSData *pubKey = [CBSecp256k1 generatePublicKeyWithPrivateKey:priData compression:YES];
            extern NSString *account;
            extern NSString *password;
            account = [createAccountController pubToAccount:pubKey];
            password = _field_pwd.text;
            [NSUserDefaults.standardUserDefaults setValue:account forKey:@"account"];
            [self._delegate showAccount:account];
            //保存信息
            
            [NSUserDefaults.standardUserDefaults setValue:account forKey:@"account"];//将账号信息存储到本地
            [NSUserDefaults.standardUserDefaults setValue:password forKey:@"password"];
            NSLog(@"开始保存信息");
            [Keysave SaveKey:priData :pubKey :account :_field_pwd.text];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"成功生成账号" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:true completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            
                  
        }
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"设置密码或确认密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:true completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
}
//点击导入文件按钮
- (IBAction)click_import_account:(id)sender {
    
}

- (IBAction)cancelSelect:(UIStoryboardSegue*) segue{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)selectFile:(UIStoryboardSegue*) segue{
    id ID = segue.sourceViewController;
    if ([ID isKindOfClass:fileSelectController.class]) {
        fileSelectController *vcSel = ID;
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL isDir = NO;
        [fm fileExistsAtPath:vcSel.current_path isDirectory:&isDir];
        if(isDir){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"你选择的是一个目录，请选择具体的文件" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:true completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }
    else{
        [self dismissViewControllerAnimated:true completion:nil];
    }
    
}

//获取私钥
-(Byte *) getPriKey{
    Byte *pri = (Byte *)malloc(LEN_PRIKEY);
    srandom((unsigned int)NSTimeIntervalSince1970*1000);
    long rand = arc4random();
//    long rand = 132032465123;
    pri = intmax_tToBytes(rand);
    return pri;
}

//通过公钥生成账号
+(NSString *)pubToAccount:(NSData *)pub{
    SHA_CTX ctx1;
    SHA256_CTX ctx256;
    SHA1_Init(&ctx1);
    SHA256_Init(&ctx256);
    unsigned char sha1[20];
    unsigned char sha256[32];
    Byte *out = (Byte *)malloc(25);
    if(pub != nil){
        SHA1_Update(&ctx1, pub.bytes,pub.length);
        SHA1_Final(sha1, &ctx1);
        out[0] = 0;
        for(int i = 1;i<=20;i++){
            out[i] = sha1[i-1];
            printf("%x",out[i]);
        }
        printf("\n");
        SHA256_Update(&ctx256,out, 21);
        SHA256_Final(sha256, &ctx256);
        for(int i = 0;i<4;i++){
            out[21+i] = sha256[i];
            printf("%x",out[21+i]);
        }
        printf("\n");
        for(int i=0;i<25;i++){
            printf("%x",out[i]);
        }
        printf("\n");
        NSData *data = [[NSData alloc] initWithBytes:out length:25];
        return [data base58String];
    }
    return nil;
}
@end
