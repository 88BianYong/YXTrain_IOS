//
//  MasterHomeworkSetListDetailViewController_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"

@interface MasterHomeworkSetListDetailViewController_17 : YXBaseViewController
@property (nonatomic, copy) NSString *homeworkSetId;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) void(^masterHomeworkSetRecommendBlock)(BOOL recommend);
@property (nonatomic, copy) void(^masterHomeworkSetCommendBlock)(void);

@property (nonatomic, copy) NSString *pid;//如果不传使用默认pid

@end
