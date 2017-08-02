//
//  CourseSubmitUserQuizesRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/2.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol CourseSubmitUserQuizesRequest_17Item_Data
@end
@interface CourseSubmitUserQuizesRequest_17Item_Data : JSONModel

@end
@interface CourseSubmitUserQuizesRequest_17Item : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *correctNum;
@property (nonatomic, copy) NSString<Optional> *totalNum;
@property (nonatomic, copy) NSString<Optional> *passRate;
@property (nonatomic, copy) NSString<Optional> *isPass;
@property (nonatomic, strong) NSArray<CourseSubmitUserQuizesRequest_17Item_Data, Optional> *data;
@end
@interface CourseSubmitUserQuizesRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *aj;
@property (nonatomic, copy) NSString<Optional> *pid;
@property (nonatomic, copy) NSString<Optional> *cid;
@property (nonatomic, copy) NSString<Optional> *stageid;

@end
