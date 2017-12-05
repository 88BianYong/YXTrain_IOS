//
//  MasterOverallRatingScoreRequet_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@interface MasterOverallRatingScoreRequet_17 : YXGetRequest
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *score;
@end
