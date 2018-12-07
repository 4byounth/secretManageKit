//
//  caculateSignViewController.m
//  secretManagerKit
//
//  Created by mac  on 2018/11/26.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "caculateSignViewController.h"
#import "sign_class.h"
#import "Keysave.h"
#import <NSData+HexString.h>
#import "fileSelectController.h"

@interface caculateSignViewController ()

@end

@implementation caculateSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    extern NSString *account;
    extern NSDictionary *userDic;
    _flabel_account.text = [userDic valueForKey:@"account"];
    _field_account.text = [userDic valueForKey:@"account"];
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

- (IBAction)click_caculate:(id)sender {
    NSData *prikey = [Keysave VerifyKey:self.flabel_account.text :_field_pwd.text];
    NSData *sign = [[NSData alloc] init];
    if(prikey == nil){
        return ;
    }
    if(_btn_msg.selected){
        NSLog(@"%@",prikey);
        sign =[sign_class SignMessage:_field_msg.text :prikey];
    }
    else{
        sign = [sign_class SignFile:_field_msg.text :prikey];
    }
    NSLog(@"%@",sign);
    self.view_sign_result.text = [sign dataToHexString];
//    self.view_sign_result.text = [[NSString alloc] initWithData:sign encoding:NSUTF8StringEncoding];
}

- (IBAction)click_file:(UIButton *)sender {
    _btn_select.hidden = NO;
    if(sender.isSelected == NO){
        sender.selected = YES;
        _btn_msg.selected = NO;
    }
}

- (IBAction)click_msg:(UIButton *)sender {
    self.btn_select.hidden = YES;
    if(sender.isSelected == NO){
        sender.selected = YES;
        _btn_file.selected = NO;
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
