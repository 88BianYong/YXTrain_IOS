//
//  ShareResourcesViewController.h
//  TrainApp
//
//  Created by ZLL on 2016/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"
@class ActivityStepListRequestItem_Body_Active_Steps_Tools;
@interface ShareResourcesViewController : PagedListViewControllerBase
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, strong) ActivityStepListRequestItem_Body_Active_Steps_Tools *tool;
@end
