//
//  ActivityListCell.h
//  TrainApp
//
//  Created by ZLL on 2016/11/7.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListRequest.h"
@interface ActivityListCell : UITableViewCell
@property (nonatomic, strong) ActivityListRequestItem_body_activity *activity;
@end
