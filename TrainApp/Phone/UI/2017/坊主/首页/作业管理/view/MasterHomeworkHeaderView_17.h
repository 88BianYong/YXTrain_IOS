//
//  MasterHomeworkHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTCollectionFilterDefaultModel.h"
@interface MasterHomeworkHeaderView_17 : UITableViewHeaderFooterView
@property (nonatomic, strong) NSArray<LSTCollectionFilterDefaultModel *> *filterModel;
@property (nonatomic, copy) void(^masterHomeworkFilterButtonBlock)(void);
@end
