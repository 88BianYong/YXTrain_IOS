//
//  ActivityFilterModel.h
//  TrainApp
//
//  Created by ZLL on 2016/11/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ActivityFilterRequestItem;
@interface ActivityFilter : NSObject
@property (nonatomic, strong) NSString *filterID;
@property (nonatomic, strong) NSString *name;
@end

@interface ActivityFilterGroup : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *filterArray;
@end

@interface ActivityFilterModel : NSObject
@property (nonatomic, strong) NSArray *groupArray;
+ (ActivityFilterModel *)modelFromRawData:(ActivityFilterRequestItem *)item;
@end
