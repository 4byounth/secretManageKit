//
//  fileProperty.h
//  secretManagerKit
//
//  Created by mac on 2018/12/6.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface fileProperty : NSObject{
    NSString *_fileType;
    NSString *_fileName;
    NSString *_fileSize;
    NSString *_createDate;
    
}
@property(copy,nonatomic) NSString *fileName;
@property(copy,nonatomic) NSString *fileType;
@property(copy,nonatomic) NSString *fileSize;
@property(copy,nonatomic) NSString *createDate;

@end

NS_ASSUME_NONNULL_END
