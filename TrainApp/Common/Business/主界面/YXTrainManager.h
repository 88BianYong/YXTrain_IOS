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
@property (nonatomic, assign) BOOL isBeijingProject;
@property (nonatomic, strong) LSTTrainHelper *trainHelper;
@property (nonatomic, copy) NSString *requireId;//北京项目专用
@property (nonatomic, copy) NSString *homeworkid;//北京项目专用

+ (instancetype)sharedInstance;
- (void)getProjectsWithCompleteBlock:(void(^)(NSArray *groups, NSError *error))completeBlock;
- (void)clear;

@end
