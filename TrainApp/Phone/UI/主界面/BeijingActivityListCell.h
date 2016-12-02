//
//  BeijingActivityListCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListRequest.h"
@interface BeijingActivityListCell : UITableViewCell
@property (nonatomic, strong) ActivityListRequestItem_body_activity *activity;
@property (nonatomic, assign) BOOL isShowWorkshop;
@end
