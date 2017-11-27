//
//  MasterManageActiveListTableHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterManagerSchemeItem.h"
@interface MasterManageActiveListTableHeaderView_17 : UIView
@property (nonatomic, strong) MasterManagerSchemeItem *scheme;
@property (nonatomic, copy) void(^masterActiveButtonBlock)(UIButton *sender);
@end
