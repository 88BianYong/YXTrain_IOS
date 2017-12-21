//
//  MasterHomeworkSetDetailViewController_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "MasterHomeworkSetDetailProtocol_17.h"
@interface MasterHomeworkSetDetailViewController_17 : YXBaseViewController<MasterHomeworkSetDetailProtocol_17>
@property (nonatomic, copy) NSString *homeworkSetId;
@property (nonatomic, copy) NSString *homeworkId;
@property (nonatomic, assign) NSInteger tagInteger;
@property (nonatomic, assign) BOOL isSupportBool;
@end
