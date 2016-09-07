//
//  YXCMSManager.h
//  TrainApp
//
//  Created by 郑小龙 on 16/9/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXRotateListRequest.h"

@interface YXCMSManager : NSObject

+ (instancetype)sharedManager;

///type:1启动图 2轮播图
- (void)requestWithType:(NSString *)type
             completion:(void(^)(NSArray *rotates, NSError *error))completion;
@end
