//
//  MasterManageListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterManageListRequestItem_Body_Group
@end
@interface MasterManageListRequestItem_Body_Group : JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *barid;
@end

@interface MasterManageListRequestItem_Body : JSONModel
@property (nonatomic, strong) NSMutableArray<MasterManageListRequestItem_Body_Group, Optional> *groups;
@end

@interface MasterManageListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterManageListRequestItem_Body<Optional> *body;
@end

@interface MasterManageListRequest : YXGetRequest
@property (nonatomic, copy) NSString *projectId;
@end
