//
//  LSTTrainHelper.m
//  TrainApp
//
//  Created by 郑小龙 on 16/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "LSTTrainHelper.h"
#import "LSTTrainHelper_Beijing.h"
#import "LSTTrainHelper_Default.h"
#import "LSTTrainHelper_DeYang.h"

@implementation LSTTrainHelper
+ (instancetype)alloc{
    if ([self class] == [LSTTrainHelper class]) {
        if ([[YXTrainManager sharedInstance].currentProject.pid isEqualToString:YXTrainBeijingProjectId]) {
            return [LSTTrainHelper_Beijing alloc];
        }
        NSArray *array = [YXTrainDeYangProjectId componentsSeparatedByString:@","];
        __block BOOL isDeYang = NO;
        [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:[YXTrainManager sharedInstance].currentProject.pid]) {
                isDeYang = YES;
                *stop = YES;
            }
        }];
        if (isDeYang) {
            return [LSTTrainHelper_DeYang alloc];
        }
        return [LSTTrainHelper_Default alloc];
    }
    return [super alloc];
}
#pragma mark - show project
- (UIViewController<YXTrackPageDataProtocol> *)showExamProject {
    return nil;
}

- (void)workshopInterfaceSkip:(UIViewController *)viewController {
    
}
- (void)activityInterfaceSkip:(UIViewController *)viewController {
    [YXDataStatisticsManger trackEvent:@"活动列表" label:@"任务跳转" parameters:nil];
}
- (void)courseInterfaceSkip:(UIViewController *)viewController {
    [YXDataStatisticsManger trackEvent:@"课程列表" label:@"任务跳转" parameters:nil];
}
@end
