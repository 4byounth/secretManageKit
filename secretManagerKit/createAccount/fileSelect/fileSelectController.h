//
//  fileSelectController.h
//  secretManagerkit
//
//  Created by mac  on 2018/11/28.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface fileSelectController : UITableViewController

@property(copy,nonatomic)NSString *path;

-(void) getFilePath;
-(void) showFile;
@end

NS_ASSUME_NONNULL_END
