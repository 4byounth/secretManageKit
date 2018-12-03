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


extern NSString *account;
extern BOOL isUsedFirstTime;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if([NSUserDefaults.standardUserDefaults valueForKey:@"account"]){
        account = [NSUserDefaults.standardUserDefaults valueForKey:@"account"];
        self.label_account.text = account;
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




@end
