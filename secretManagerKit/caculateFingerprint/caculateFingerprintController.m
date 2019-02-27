//
//  caculateFingerprintController.m
//  secretManagerKit
//
//  Created by mac  on 2018/11/27.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "caculateFingerprintController.h"
#import "sign_class.h"
#import <NSData+HexString.h>
#import "fileSelectController.h"

@interface caculateFingerprintController ()

@end


@implementation caculateFingerprintController

- (void)viewDidLoad {
    [super viewDidLoad];
    extern NSString *account;
    self.label_account.text = account;
    self.field_account.text = account;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)click_msg:(UIButton *)sender {
    self.btn_select.hidden = YES;
    if(sender.selected == NO){
        sender.selected = YES;
        _btn_file.selected = NO;
    }
}

- (IBAction)click_fiel:(UIButton *)sender {
    _btn_select.hidden = NO;
    if(sender.selected == NO){
        sender.selected = YES;
        _btn_msg.selected = NO;
    }
}

- (IBAction)click_caculate:(id)sender {
    if(![_field_msg.text isEqualToString:@""]){
        if(_btn_msg.selected){
            NSData *hash = [sign_class HashMessage:_field_msg.text];
            NSString *hexstring = [hash dataToHexString];
            _view_result.text = hexstring;
        }
        else{
            NSData *hash = [sign_class HashFile:_field_msg.text];
            NSString *hexstring = [hash dataToHexString];
            _view_result.text = hexstring;
        }
    }
    
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
        else{
            self.field_msg.text = vcSel.current_path;
        }
    }
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
