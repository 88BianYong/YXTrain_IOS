//
//  TrainListProjectGroup.m
//  TrainApp
//
//  Created by ZLL on 2016/11/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "TrainListProjectGroup.h"

@implementation TrainListProjectGroup
+ (NSArray<TrainListProjectGroup *> *)projectGroupsWithRawData:(YXTrainListRequestItem_body *)data {
    NSMutableArray *trainGroupArray = [NSMutableArray array];
    
    TrainListProjectGroup *trainingGroup = [[TrainListProjectGroup alloc]init];
    if (data.training.count > 0) {
        trainingGroup.name = @"在培项目";
        trainingGroup.items = data.training;
        [trainGroupArray addObject:trainingGroup];
    }
    TrainListProjectGroup *trainedGroup = [[TrainListProjectGroup alloc]init];
    if (data.trained.count > 0) {
        trainedGroup.name = @"历史项目";
        trainedGroup.items = data.trained;
        [trainGroupArray addObject:trainedGroup];
    }
    return trainGroupArray.copy;
}
@end
