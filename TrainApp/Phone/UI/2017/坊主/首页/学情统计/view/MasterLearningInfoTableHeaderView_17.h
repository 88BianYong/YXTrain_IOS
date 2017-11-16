//
//  MasterLearningInfoTableHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterLearningInfoTableHeaderView_17 : UIView
@property (nonatomic, copy) void(^masterLearningInfoButtonBlock)(BOOL isOpen);
- (void)reloadMasterLearningInfo:(NSString *)title withNumber:(NSString *)total;
@end
