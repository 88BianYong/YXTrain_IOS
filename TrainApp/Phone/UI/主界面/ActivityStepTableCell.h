//
//  ActivityStepTableCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListRequest.h"
typedef void(^ActivityStepTableCellBlock) (ActivityListRequestItem_Body_Activity_Steps_Tools *tool);
@interface ActivityStepTableCell : UITableViewCell
@property (nonatomic, strong) ActivityListRequestItem_Body_Activity_Steps_Tools *firstTool;
@property (nonatomic, strong) ActivityListRequestItem_Body_Activity_Steps_Tools *secondTool;
@property (nonatomic, strong) ActivityListRequestItem_Body_Activity_Steps_Tools *thirdTool;
@property (nonatomic, strong) ActivityListRequestItem_Body_Activity_Steps_Tools *fourthTool;
- (void)setActivityStepTableCellBlock:(ActivityStepTableCellBlock)block;
@end
