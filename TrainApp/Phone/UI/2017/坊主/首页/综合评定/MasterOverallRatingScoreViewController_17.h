//
//  MasterOverallRatingScoreViewController_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "MasterOverallRatingListRequest_17.h"
@interface MasterOverallRatingScoreViewController_17 : YXBaseViewController
@property (nonatomic, strong) MasterOverallRatingListItem_Body_UserScore *userScore;
@property (nonatomic, copy) void(^masterOverallRatingScoreBlock)(void);
@end
