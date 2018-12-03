//
//  singleSelectBox.h
//  secretManagerKit
//
//  Created by mac  on 2018/11/26.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE

@interface singleSelectBox : UIView
{
    NSString *title;
}
@property(copy,atomic) IBInspectable NSString *title;

-(void)init:(CGRect *)rect :(NSString *)str;
@end

NS_ASSUME_NONNULL_END
