//
//  cell_file.h
//  secretManagerKit
//
//  Created by mac on 2018/12/6.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface cell_file : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_filetype;
@property (weak, nonatomic) IBOutlet UILabel *label_filename;
@property (weak, nonatomic) IBOutlet UILabel *label_filesize;
@property (weak, nonatomic) IBOutlet UILabel *label_date;

@end

NS_ASSUME_NONNULL_END
