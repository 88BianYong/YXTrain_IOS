//
//  MasterHappeningCell_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/17.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterIndexRequest_17.h"
@interface MasterHappeningCell_17 : UITableViewCell
@property (nonatomic, strong) MasterIndexRequestItem_Body_MyExamine_Types_Detail *detail;
@property (nonatomic, copy) void(^MasterHappeningCellButtonBlock) (UIButton *sender);
@end
