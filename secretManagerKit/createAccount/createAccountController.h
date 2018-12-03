//
//  createAccountController.h
//  secretManagerKit
//
//  Created by mac  on 2018/11/27.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "create_delegate.h"


NS_ASSUME_NONNULL_BEGIN

static int LEN_PRIKEY = 32;
static int LEN_PUBKEY = 33;
static int LEN_ACCOUNT = 25;


@interface createAccountController : UIViewController{
    NSString *pwd;
    NSString *checkPwd;
    id<create_delegate> _delegate;
}

@property id<create_delegate> _delegate;
@property (weak, nonatomic) IBOutlet UITextField *field_pwd;
@property (weak, nonatomic) IBOutlet UITextField *field_confire_pwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_create_account;
@property (weak, nonatomic) IBOutlet UIButton *btn_import_account;
- (IBAction)click_create_account:(id)sender;
- (IBAction)click_import_account:(id)sender;
- (IBAction)cancelSelect:(UIStoryboardSegue*) segue;
- (IBAction)selectFile:(UIStoryboardSegue*) segue;
@end

NS_ASSUME_NONNULL_END
