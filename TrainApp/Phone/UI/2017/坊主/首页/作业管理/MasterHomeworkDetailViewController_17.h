//
//  MasterHomeworkDetailViewController_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"

@interface MasterHomeworkDetailViewController_17 : YXBaseViewController
@property (nonatomic, copy) NSString *homeworkId;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) void(^masterHomeworkRecommendBlock)(BOOL recommend);
@property (nonatomic, copy) void(^masterHomeworkCommendBlock)(void);
@property (nonatomic, copy) NSString *pid;//如果不传使用默认pid
@end
