//
//  YXVideoRecordTopView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/8.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXVideoRecordTopView : UIView
@property (nonatomic, assign) NSInteger recordTime;
@property (nonatomic, strong) UIButton *canleButton;
@property (nonatomic,copy) void(^cancleHandler)(void);
- (void)startAnimatetion;
- (void)stopAnimatetion;
@end
