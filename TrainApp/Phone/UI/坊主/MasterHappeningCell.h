//
//  MasterHappeningCell.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterStatRequest.h"
@interface MasterHappeningCell : UITableViewCell
@property (nonatomic, strong) MasterStatRequestItem_Body_Type_Detail *detail;
@property (nonatomic, copy) void(^MasterHappeningCellButtonBlock) (UIButton *sender);
@end
