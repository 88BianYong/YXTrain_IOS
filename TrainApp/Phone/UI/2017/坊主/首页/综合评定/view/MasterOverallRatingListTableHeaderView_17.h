//
//  MasterOverallRatingListTableHeaderView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterOverallRatingListRequest_17.h"
@interface MasterOverallRatingListTableHeaderView_17 : UIView
@property (nonatomic, strong) UIButton *explainButton;
@property (nonatomic, strong) MasterOverallRatingListItem_Body_CountUser *countUser;
@property (nonatomic, copy) void(^masterOverallRatingButtonBlock)(UIButton *sender);

@end
