//
//  YXDatumGlobalSingleton.h
//  YanXiuApp
//
//  Created by niuzhaowang on 15/9/6.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXFilterModel.h"

@interface YXDatumGlobalSingleton : NSObject

+ (YXDatumGlobalSingleton *)sharedInstance;

@property (nonatomic, strong) YXFilterModel *filterModel;

// 我的资源请求用的回传值
@property (nonatomic, copy) NSString *myOffset;
@property (nonatomic, copy) NSString *slOffset;
// end

// 获取资源筛选目录
//- (void)getDatumFilterData:(void(^)(NSError *error))completion;

@end
