//
//  YXMockRequest.h
//  StatisticDemo
//
//  Created by niuzhaowang on 16/5/31.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXPostRequest.h"
#import "YXRecordBase.h"
#import "InstantRecordEntity.h"

@interface YXStatisticRequest : YXPostRequest

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *version;

@end
