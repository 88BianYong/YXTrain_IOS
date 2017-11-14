//
//  DownloadResourceViewController.h
//  TrainApp
//
//  Created by ZLL on 2016/11/18.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
@class ActivityStepListRequestItem_Body_Active_Steps_Tools;
@interface DownloadResourceViewController : YXBaseViewController
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, strong) ActivityStepListRequestItem_Body_Active_Steps_Tools *tool;
@end
