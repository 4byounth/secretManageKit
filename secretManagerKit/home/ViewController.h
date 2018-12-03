//
//  ViewController.h
//  secretManagerKit
//
//  Created by mac  on 2018/11/26.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "create_delegate.h"

@interface ViewController : UIViewController <create_delegate>

@property (weak, nonatomic) IBOutlet UILabel *label_account;
@property (weak, nonatomic) IBOutlet UIButton *btn_secret_manager;
@property (weak, nonatomic) IBOutlet UIButton *btn_caculate_sign;
@property (weak, nonatomic) IBOutlet UIButton *btn_check_sign;
@property (weak, nonatomic) IBOutlet UIButton *btn_caculate_fignerprint;
@property (weak, nonatomic) IBOutlet UIButton *btn_versionInfo;

@end

