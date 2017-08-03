//
//  CourseCenterConditionRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol CourseCenterConditionRequest_17Item_CourseTypes

@end
@interface CourseCenterConditionRequest_17Item_CourseTypes : JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *typeID;
@end


@interface CourseCenterConditionRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectID;
@property (nonatomic, copy) NSString<Optional> *themeID;
@property (nonatomic, copy) NSString<Optional> *layerID;
@end
