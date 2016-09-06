//
//  YXCMSCustomView.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCMSManager.h"
@interface YXCMSCustomView : UIView
@property (nonatomic, copy) void (^clickedBlock)(YXCMSModel *model);
- (void)reloadWithModel:(YXCMSModel *)model;

@end
