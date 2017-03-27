//
//  BeijingActivityFilterModel.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/26.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeijingActivityFilterRequest.h"
@protocol BeijingActivityFilter <NSObject>
@end
@interface BeijingActivityFilter : NSObject
@property (nonatomic, copy) NSString *filterID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<__kindof BeijingActivityFilter *> *filterArray;
@end

@interface BeijingActivityFilterModel : NSObject
@property (nonatomic, strong) NSArray<__kindof BeijingActivityFilter *> *segment;
@property (nonatomic, strong) NSArray<__kindof BeijingActivityFilter *> *stage;
@property (nonatomic, strong) NSArray<__kindof BeijingActivityFilter *> *study;
@property (nonatomic, copy) NSString *segmentName;
@property (nonatomic, copy) NSString *stageName;
@property (nonatomic, copy) NSString *studyName;
@property (nonatomic, assign) NSInteger chooseInteger;
+ (BeijingActivityFilterModel *)modelFromRawData:(BeijingActivityFilterRequestItem *)item;

@end

@interface BeijingActivityFilterManager : NSObject
- (void)startRequestActivityFilterItemWithBlock:(void (^)(BeijingActivityFilterModel *, NSError *))aCompleteBlock;
@end
