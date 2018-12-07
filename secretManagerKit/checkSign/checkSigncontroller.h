//
//  checkSigncontroller.h
//  secretManagerKit
//
//  Created by mac  on 2018/11/27.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface checkSigncontroller : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *field_account;
@property (weak, nonatomic) IBOutlet UIButton *btn_select;
@property (weak, nonatomic) IBOutlet UILabel *label_account;
@property (weak, nonatomic) IBOutlet UIButton *btn_msg;
@property (weak, nonatomic) IBOutlet UIButton *btn_file;
@property (weak, nonatomic) IBOutlet UITextField *field_msg;
@property (weak, nonatomic) IBOutlet UITextField *field_sign;
@property (weak, nonatomic) IBOutlet UIButton *btn_verify;
- (IBAction)click_msg:(UIButton *)sender;
- (IBAction)click_file:(UIButton *)sender;
- (IBAction)click_verify:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *view_result;


@end

NS_ASSUME_NONNULL_END
