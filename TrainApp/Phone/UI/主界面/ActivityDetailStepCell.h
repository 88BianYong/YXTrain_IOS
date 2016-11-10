//
//  ActivityDetailStepCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityStepListRequest.h"
@interface ActivityDetailStepCell : UITableViewCell
@property (nonatomic, strong) ActivityStepListRequestItem_Body_Steps *stepContent;
@end
