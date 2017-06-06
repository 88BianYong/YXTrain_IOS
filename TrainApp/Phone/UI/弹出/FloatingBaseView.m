//
//  FloatingBaseView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FloatingBaseView.h"
@interface FloatingBaseView ()
@property (nonatomic, copy) FloatingBaseRemoveCompleteBlock removeBlock;
@end
@implementation FloatingBaseView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self removeFromSuperview];
    BLOCK_EXEC(self.removeBlock);
}
- (void)setFloatingBaseRemoveCompleteBlock:(FloatingBaseRemoveCompleteBlock)block {
    self.removeBlock = block;
}
@end
