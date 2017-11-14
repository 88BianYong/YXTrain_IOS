//
//  ActivityStepViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "ActivityStepListRequest.h"
@interface ActivityStepViewController : YXBaseViewController
@property (nonatomic, strong) ActivityStepListRequestItem_Body_Active_Steps *activityStep;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *stageId;
@end
