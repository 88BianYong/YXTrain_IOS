//
//  BeijingCourseFilterManager.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeijingCourseFilterRequest.h"
@protocol BeijingCourseFilter <NSObject>
@end
@interface BeijingCourseFilter : NSObject
@property (nonatomic, copy) NSString *filterID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<__kindof BeijingCourseFilter *> *filterArray;
@end

@interface BeijingCourseFilterModel : NSObject
@property (nonatomic, strong) NSArray<__kindof BeijingCourseFilter *> *segment;
@property (nonatomic, strong) NSArray<__kindof BeijingCourseFilter *> *stage;
@property (nonatomic, strong) NSArray<__kindof BeijingCourseFilter *> *study;
@property (nonatomic, copy) NSString *segmentName;
@property (nonatomic, copy) NSString *stageName;
@property (nonatomic, copy) NSString *studyName;
@property (nonatomic, assign) NSInteger chooseInteger;
+ (BeijingCourseFilterModel *)modelFromRawData:(BeijingCourseFilterRequestItem *)item;

@end

@interface BeijingCourseFilterManager : NSObject
- (void)startRequestCourseFilterItemWithBlock:(void (^)(BeijingCourseFilterModel *, NSError *))aCompleteBlock;
@end
