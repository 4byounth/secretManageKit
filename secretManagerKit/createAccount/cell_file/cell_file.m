//
//  cell_file.m
//  secretManagerkit
//
//  Created by mac  on 2018/11/28.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "cell_file.h"

@implementation cell_file
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if(self){
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (IBAction)click_next:(id)sender {
}

-(void)fillData:(fileProperty *)property{
    self.label_file_name.text = property.fileName;
    self.label_size.text = property.fileSize;
    self.label_date.text = property.createDate;
    self.label_size.text = [property.fileSize stringByAppendingString:@" B"] ;
}
@end
