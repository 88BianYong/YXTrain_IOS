//
//  MasterOverallRatingSearchContentView_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterOverallRatingListRequest_17.h"
@interface MasterOverallRatingSearchContentView_17 : UIView
@property (nonatomic, strong) NSMutableArray *searchMutableArray;
@property (nonatomic, copy) void(^masterOverallRatingSearchBlock)(MasterOverallRatingListItem_Body_UserScore *userScore);
@end
