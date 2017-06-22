//
//  YXTrainManager.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/1.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXTrainListRequest.h"
#import "TrainListProjectGroup.h"
#import "YXTrackPageDataProtocol.h"
#import "LSTTrainHelper.h"
@interface YXTrainManager : NSObject
@property (nonatomic, strong) YXTrainListRequestItem_body_train *currentProject;
@property (nonatomic, strong) NSIndexPath *currentProjectIndexPath;
@property (nonatomic, strong) YXTrainListRequestItem *trainlistItem;
@property (nonatomic, strong) LSTTrainHelper *trainHelper;

+ (instancetype)sharedInstance;
- (void)getProjectsWithCompleteBlock:(void(^)(NSArray *groups, NSError *error))completeBlock;
- (void)saveToCache;
- (void)clear;
- (BOOL)setupProjectId:(NSString *)projectId;
@end
