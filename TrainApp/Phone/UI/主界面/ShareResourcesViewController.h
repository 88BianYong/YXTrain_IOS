//
//  ShareResourcesViewController.h
//  TrainApp
//
//  Created by ZLL on 2016/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"
@class ActivityListRequestItem_Body_Activity_Steps_Tools;
@interface ShareResourcesViewController : PagedListViewControllerBase
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) ActivityListRequestItem_Body_Activity_Steps_Tools *tool;
@end
