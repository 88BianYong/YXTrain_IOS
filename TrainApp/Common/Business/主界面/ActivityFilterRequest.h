//
//  ActivityFilterRequest.h
//  TrainApp
//
//  Created by ZLL on 2016/11/9.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@class ActivityFilterModel;
@protocol ActivityFilterRequestItem_body_stage <NSObject>
@end
@interface ActivityFilterRequestItem_body_stage : JSONModel
@property (nonatomic, strong) NSString<Optional> *stageID;
@property (nonatomic, strong) NSString<Optional> *name;
@end

@protocol ActivityFilterRequestItem_body_study <NSObject>
@end
@interface ActivityFilterRequestItem_body_study : JSONModel
@property (nonatomic, strong) NSString<Optional> *studyID;
@property (nonatomic, strong) NSString<Optional> *name;
@end

@protocol ActivityFilterRequestItem_body_segment <NSObject>
@end
@interface ActivityFilterRequestItem_body_segment : JSONModel
@property (nonatomic, strong) NSString<Optional> *segmentID;
@property (nonatomic, strong) NSString<Optional> *name;
@end

@protocol ActivityFilterRequestItem_body <NSObject>
@end
@interface ActivityFilterRequestItem_body : JSONModel
@property (nonatomic, strong) NSArray<ActivityFilterRequestItem_body_stage,Optional> *stages;
@property (nonatomic, strong) NSArray<ActivityFilterRequestItem_body_segment,Optional> *segments;
@property (nonatomic, strong) NSArray<ActivityFilterRequestItem_body_study,Optional> *studys;
@end

@interface ActivityFilterRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ActivityFilterRequestItem_body<Optional> *body;
- (ActivityFilterModel *)filterModel;
@end

@interface ActivityFilterRequest : YXGetRequest
@property (nonatomic, strong) NSString *projectId;
@property (nonatomic, strong) NSString *w;
@end
