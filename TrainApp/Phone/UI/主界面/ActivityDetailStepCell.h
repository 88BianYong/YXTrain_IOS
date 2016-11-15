//
//  ActivityDetailStepCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListRequest.h"
@interface ActivityDetailStepCell : UITableViewCell
@property (nonatomic, strong) ActivityListRequestItem_Body_Activity_Steps *steps;
@end
