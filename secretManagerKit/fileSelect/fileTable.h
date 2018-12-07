//
//  fileTable.h
//  secretManagerKit
//
//  Created by mac on 2018/12/5.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface fileTable : UITableViewController{
    NSFileManager *_fileManager;
}

@property NSFileManager *fileManager;
-(void) setData:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
