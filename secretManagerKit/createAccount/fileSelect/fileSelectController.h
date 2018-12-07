//
//  fileSelectController.h
//  secretManagerkit
//
//  Created by mac  on 2018/11/28.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fileProperty.h"



NS_ASSUME_NONNULL_BEGIN

@interface fileSelectController : UITableViewController{
    NSFileManager *_fileManager;
    NSArray<fileProperty *> *_fileArray;
}

@property(copy,nonatomic)NSString *current_path;
@property(copy,nonatomic)NSArray *fileArray;
@property(strong,nonatomic)NSFileManager *fileManager;


-(void)setData:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
