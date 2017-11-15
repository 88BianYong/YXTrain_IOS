//
//  MasterHomeModuleCell.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterIndexRequest_17.h"
@interface MasterHomeModuleCell_17 : UITableViewCell
@property (nonatomic, strong) NSArray<__kindof MasterIndexRequestItem_Body_Modules *> *modules;
@property (nonatomic, copy) void(^masterHomeModuleCompleteBlock)(MasterIndexRequestItem_Body_Modules *tool);
@end
