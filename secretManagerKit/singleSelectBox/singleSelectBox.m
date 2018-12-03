//
//  singleSelectBox.m
//  secretManagerKit
//
//  Created by mac  on 2018/11/26.
//  Copyright © 2018年 mac . All rights reserved.
//

#import "singleSelectBox.h"

@implementation singleSelectBox
-(void) init:(CGRect *)rect :(NSString *)str{
    [super init];
    self.title = str;
}

-(void) drawRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 1, rect.size.height-2, rect.size.height - 2)];
    path.lineWidth = 2;
    [path stroke];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.size.height/4-0.5, rect.size.height/4-0.5, rect.size.height/2-1, rect.size.height/2-1)];
    path1.lineWidth = 2;
    [path1 stroke];
    
    NSString *str = self.title;
    NSDictionary *Dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor grayColor],NSStrokeWidthAttributeName:@10
                          };
    [str drawInRect:CGRectMake(rect.size.height + 1, 1, rect.size.width-rect.size.height - 1, rect.size.height - 2) withAttributes:Dic];
    
    [path stroke];
    [path1 stroke];
}
@end
