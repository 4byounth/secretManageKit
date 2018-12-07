//
//  caculateSignViewController.h
//  secretManagerKit
//
//  Created by mac  on 2018/11/26.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface caculateSignViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *field_account;
@property (weak, nonatomic) IBOutlet UILabel *flabel_account;
@property (weak, nonatomic) IBOutlet UIButton *btn_msg;
@property (weak, nonatomic) IBOutlet UIButton *btn_file;
@property (weak, nonatomic) IBOutlet UITextField *field_msg;
@property (weak, nonatomic) IBOutlet UITextField *field_pwd;
@property (weak, nonatomic) IBOutlet UIButton *btn_caculate;
@property (weak, nonatomic) IBOutlet UIButton *btn_select;
@property (weak, nonatomic) IBOutlet UITextView *view_sign_result;
- (IBAction)click_file:(UIButton *)sender;
- (IBAction)click_msg:(UIButton *)sender;
- (IBAction)click_caculate:(id)sender;

@end

NS_ASSUME_NONNULL_END
