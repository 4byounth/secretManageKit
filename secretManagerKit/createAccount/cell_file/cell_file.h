//
//  cell_file.h
//  secretManagerkit
//
//  Created by mac  on 2018/11/28.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface cell_file : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_type;
@property (weak, nonatomic) IBOutlet UILabel *label_file_name;
@property (weak, nonatomic) IBOutlet UILabel *label_size;
@property (weak, nonatomic) IBOutlet UILabel *label_date;
@property (weak, nonatomic) IBOutlet UIButton *btn_next;
- (IBAction)click_next:(id)sender;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
