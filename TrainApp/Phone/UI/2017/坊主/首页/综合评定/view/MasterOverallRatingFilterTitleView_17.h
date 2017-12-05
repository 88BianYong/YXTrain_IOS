//
//  MasterOverallRatingFilterTitleView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTCollectionFilterDefaultModel.h"
@interface MasterOverallRatingFilterTitleView_17 : UIView
@property (nonatomic, strong) NSArray<LSTCollectionFilterDefaultModel *> *filterModel;
@property (nonatomic, copy) void(^masterOverallRatingFilterButtonBlock)(void);
@end
