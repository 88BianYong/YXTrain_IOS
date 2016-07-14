//
//  YXTrainManager.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/1.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXTrainListRequest.h"

@interface YXTrainManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) YXTrainListRequestItem_body_train *currentProject;
@property (nonatomic, assign) NSInteger currentProjectIndex;

- (void)getProjectsWithCompleteBlock:(void(^)(NSArray *projects, NSError *error))completeBlock;

- (void)clear;

@end
