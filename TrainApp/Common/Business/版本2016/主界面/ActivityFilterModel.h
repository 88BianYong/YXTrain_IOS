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
@property (nonatomic, copy) NSString *filterID;
@property (nonatomic, copy) NSString *name;
@end

@interface ActivityFilterGroup : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *filterArray;
@end

@interface ActivityFilterModel : NSObject
@property (nonatomic, strong) NSArray *groupArray;
@property (nonatomic, strong) NSMutableArray<Optional> *selectedMutableArray;//数组@[学段,学科]
+ (ActivityFilterModel *)modelFromRawData:(ActivityFilterRequestItem *)item;
@end
