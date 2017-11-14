//
//  BeijingActivityFilterRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/15.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityFilterRequest.h"
@protocol BeijingActivityFilterRequestItem_Filter <NSObject>
@end
@interface BeijingActivityFilterRequestItem_Filter : JSONModel
@property (nonatomic, copy) NSString<Optional> *filterID;
@property (nonatomic, copy) NSString<Optional> *name;
@end
@protocol BeijingActivityFilterRequestItem_Body_Segment <NSObject>
@end
@interface BeijingActivityFilterRequestItem_Body_Segment : JSONModel
@property (nonatomic, strong) NSArray<BeijingActivityFilterRequestItem_Filter, Optional> *study;
@property (nonatomic, copy) NSString<Optional> *segmentID;
@property (nonatomic, copy) NSString<Optional> *name;
@end

@interface BeijingActivityFilterRequestItem_Body : JSONModel
@property (nonatomic, strong) NSArray <BeijingActivityFilterRequestItem_Body_Segment, Optional> *segment;
@property (nonatomic, strong) NSArray <BeijingActivityFilterRequestItem_Filter, Optional> *stage;
@end


@interface BeijingActivityFilterRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) BeijingActivityFilterRequestItem_Body<Optional> *body;
@end

@interface BeijingActivityFilterRequest : ActivityFilterRequest
@property (nonatomic, copy) NSString<Optional> *pid;
@end
