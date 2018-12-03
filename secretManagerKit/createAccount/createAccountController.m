//
//  createAccountController.m
//  secretManagerKit
//
//  Created by mac  on 2018/11/27.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "createAccountController.h"
#import <CBSecp256k1.h>
#import <NSData+HexString.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSData+Hashing.h"
#import <CBBase58/BTCBase58.h>
#import <CBBase58/NS+BTCBase58.h>

#import <openssl/hmac.h>
#import <openssl/ripemd.h>
#import <openssl/sha.h>
#import "intTobyte.h"

/*
 整数转字节
 */
Byte* intmax_tToBytes(intmax_t num){
    Byte* target = (Byte*)malloc(LEN_PRIKEY);
    for(int i = 0;i<LEN_PRIKEY;i++){
        int offset = (LEN_PRIKEY-1-i)*8;
        target[i] = (Byte)((num>>offset) & 0xFF);
    }
    return target;
}

@interface createAccountController ()

@end

extern NSString *account;
extern BOOL isUsedFirstTime;


@implementation createAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
            NSData *pubKey = [CBSecp256k1 generatePublicKeyWithPrivateKey:priData compression:YES];
            account = [self pubToAccount:pubKey];
            [self._delegate showAccount:account];
            
            
            
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
    
    [self dismissViewControllerAnimated:true completion:nil];
}

//获取私钥
-(Byte *) getPriKey{
    Byte *pri = (Byte *)malloc(LEN_PRIKEY);
    srand((unsigned int)NSTimeIntervalSince1970*100);
    long rand = random();
    pri = intmax_tToBytes(rand);
    return pri;
}

//通过公钥生成账号
-(NSString *)pubToAccount:(NSData *)pub{
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
