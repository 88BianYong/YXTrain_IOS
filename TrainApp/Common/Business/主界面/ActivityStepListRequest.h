//
//  ActivityStepListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol ActivityStepListRequestItem_Body_Steps_Tools <NSObject>
@end
@protocol ActivityStepListRequestItem_Body_Steps <NSObject>
@end

@interface ActivityStepListRequestItem_Body_Steps_Tools : JSONModel
@property (nonatomic, strong) NSString<Optional> *toolid;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSString<Optional> *tooltype;
@end

@interface ActivityStepListRequestItem_Body_Steps : JSONModel
@property (nonatomic, strong) NSString<Optional> *stepid;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, strong) NSArray<ActivityStepListRequestItem_Body_Steps_Tools,Optional> *tools;
@end

@interface ActivityStepListRequestItem_Body : JSONModel
@property (nonatomic, strong) NSArray<ActivityStepListRequestItem_Body_Steps,Optional> *steps;
@end

@interface ActivityStepListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ActivityStepListRequestItem_Body<Optional> *body;
@end

@interface ActivityStepListRequest : YXGetRequest
@property (nonatomic, strong) NSString *aid;
@end
