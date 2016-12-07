//
//  ActivityStepListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/11/10.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "ActivityListRequest.h"
@interface ActivityStepListRequestItem_Body : JSONModel
@property (nonatomic, strong) ActivityListRequestItem_body_activity<Optional> *active;
@end
@interface ActivityStepListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) ActivityStepListRequestItem_Body<Optional> *body;
- (ActivityStepListRequestItem *)activityDetailFormatItem:(ActivityListRequestItem_body_activity *)activity;
@end

@interface ActivityStepListRequest : YXGetRequest
@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *source;
@end
