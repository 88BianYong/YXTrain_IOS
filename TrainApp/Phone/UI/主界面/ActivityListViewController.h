//
//  ActivityListViewController.h
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"
typedef NS_ENUM(NSUInteger, ActivityFromStatus){
    ActivityFromStatus_Activity = 0,//任务-活动
    ActivityFromStatus_Stage = 1,//阶段-活动
};
@interface ActivityListViewController : PagedListViewControllerBase
@property (nonatomic, strong) NSString *stageID;// 从考核的阶段课程进入需要传阶段的id
@property (nonatomic, assign) ActivityFromStatus status; // 哪个入口进入
@end
