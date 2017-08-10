//
//  FilterMaskView.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/10.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "FilterMaskView_17.h"

@implementation FilterMaskView_17

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:self];
    DDLogDebug(@">>>>%@",NSStringFromCGPoint(location));
    //    if (CGRectContainsPoint(self.favorButton.frame, location) && self.favorButton.enabled == NO) {
    //        [(YXBaseViewController *)[self viewController] showToast:@"您已经赞过了哦"];
    //    }
}
@end
