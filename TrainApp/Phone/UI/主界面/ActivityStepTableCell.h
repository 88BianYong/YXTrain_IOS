//
//  ActivityStepTableCell.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityStepListRequest.h"
typedef void(^ActivityStepTableCellBlock) (ActivityStepListRequestItem_Body_Active_Steps_Tools *tool);
@interface ActivityStepTableCell : UITableViewCell
@property (nonatomic, strong) ActivityStepListRequestItem_Body_Active_Steps_Tools *firstTool;
@property (nonatomic, strong) ActivityStepListRequestItem_Body_Active_Steps_Tools *secondTool;
@property (nonatomic, strong) ActivityStepListRequestItem_Body_Active_Steps_Tools *thirdTool;
@property (nonatomic, strong) ActivityStepListRequestItem_Body_Active_Steps_Tools *fourthTool;

- (void)setActivityStepTableCellBlock:(ActivityStepTableCellBlock)block;
@end
