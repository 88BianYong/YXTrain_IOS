//
//  YXDatumDelSourseRequest.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface YXDatumDelSourseRequest : YXGetRequest

@property (nonatomic, strong) NSString *resid;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *uid;

@end
