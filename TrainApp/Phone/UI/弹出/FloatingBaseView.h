//
//  FloatingBaseView.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/31.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^FloatingBaseRemoveCompleteBlock)(void);
@interface FloatingBaseView : UIView
- (void)setFloatingBaseRemoveCompleteBlock:(FloatingBaseRemoveCompleteBlock)block;
@end
