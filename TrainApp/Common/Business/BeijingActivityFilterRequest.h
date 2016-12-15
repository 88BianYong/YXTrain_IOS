//
//  BeijingActivityFilterRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityFilterRequest.h"

@interface BeijingActivityFilterRequest : ActivityFilterRequest
@property (nonatomic, copy) NSString *segmentId;
@property (nonatomic, copy) NSString *pid;
@end
