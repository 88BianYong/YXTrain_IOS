//
//  BeijingCourseFilterRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/27.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol BeijingCourseFilterRequestItem_Filter <NSObject>
@end
@interface BeijingCourseFilterRequestItem_Filter : JSONModel
@property (nonatomic, copy) NSString<Optional> *filterID;
@property (nonatomic, copy) NSString<Optional> *name;
@end
@protocol BeijingCourseFilterRequestItem_Body_Segment <NSObject>
@end
@interface BeijingCourseFilterRequestItem_Body_Segment : JSONModel
@property (nonatomic, strong) NSArray<BeijingCourseFilterRequestItem_Filter, Optional> *study;
@property (nonatomic, copy) NSString<Optional> *segmentID;
@property (nonatomic, copy) NSString<Optional> *name;
@end

@interface BeijingCourseFilterRequestItem_Body : JSONModel
@property (nonatomic, strong) NSArray <BeijingCourseFilterRequestItem_Body_Segment, Optional> *segment;
@property (nonatomic, strong) NSArray <BeijingCourseFilterRequestItem_Filter, Optional> *stage;
@end


@interface BeijingCourseFilterRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) BeijingCourseFilterRequestItem_Body<Optional> *body;
@end
@interface BeijingCourseFilterRequest : YXGetRequest
@property (nonatomic, strong) NSString *pid;
@end
