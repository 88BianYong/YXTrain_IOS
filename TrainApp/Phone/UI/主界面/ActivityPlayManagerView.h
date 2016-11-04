//
//  ActivityPlayManagerView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityPlayBottomView;
typedef void (^BackActionBlock)(void);
typedef void (^RotateScreenBlock)(BOOL isVertical);
@interface ActivityPlayManagerView : UIView
@property (nonatomic, strong) ActivityPlayBottomView *bottomView;
- (void)setBackActionBlock:(BackActionBlock)block;
- (void)setRotateScreenBlock:(RotateScreenBlock)block;
@end
