//
//  singleSelectedBox.h
//  secretManagerKit
//
//  Created by mac  on 2018/11/27.
//  Copyright © 2018年 mac . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface singleSelectedBox : UIView
{
    NSArray *_btn;//按钮数组
    NSInteger _btn_count;//按钮数量
    NSInteger _btnIndex;//被选中的按钮的下标
}

@property(nonatomic) NSArray *btn;
@property(assign,nonatomic) NSInteger btn_count;
@property(assign,nonatomic) NSInteger btnIndex;

-(void) init:(NSInteger)count;
-(void) getBtn:(UIButton **)buffer range:(NSRange)inRange;
-(void) setBtnIndex:(NSInteger)btnIndex;
-(void) setBtn:(NSArray * _Nonnull)btn;
-(void) setBtn_count:(NSInteger)btn_count;
@end

NS_ASSUME_NONNULL_END
