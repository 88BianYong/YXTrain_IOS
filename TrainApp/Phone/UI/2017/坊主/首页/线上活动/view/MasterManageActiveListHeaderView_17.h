//
//  MasterManageActiveListHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTCollectionFilterDefaultModel.h"
@interface MasterManageActiveListHeaderView_17 : UITableViewHeaderFooterView
@property (nonatomic, strong) NSArray<LSTCollectionFilterDefaultModel *> *filterModel;
@property (nonatomic, copy) void(^masterHomeworkFilterButtonBlock)(void);
@end
