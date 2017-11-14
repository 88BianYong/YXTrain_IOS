//
//  ActivityDetailViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "ActivityListRequest.h"
@interface ActivityDetailViewController : YXBaseViewController
@property (nonatomic, strong) ActivityListRequestItem_body_activity *activity;
@end
