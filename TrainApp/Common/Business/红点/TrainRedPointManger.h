//
//  TrainRedPointManger.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainRedPointManger : NSObject
@property (nonatomic, assign) NSInteger showRedPointInteger;

@property (nonatomic, assign) NSInteger hotspotInteger;
@property (nonatomic, assign) NSInteger dynamicInteger;

+ (instancetype)sharedInstance;
@end
