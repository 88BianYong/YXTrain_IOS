//
//  YXGetRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "GetRequest.h"

@interface YXGetRequest : GetRequest

@property (nonatomic, strong) NSString<Optional> *token;
@property (nonatomic, strong) NSString<Optional> *ver;
@property (nonatomic, strong) NSString<Optional> *os;
@property (nonatomic, strong) NSString<Optional> *osType; //设备类型，1:iPhone，2:iPad

@end
