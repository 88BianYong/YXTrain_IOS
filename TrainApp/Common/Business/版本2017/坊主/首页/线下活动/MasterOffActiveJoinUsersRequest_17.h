//
//  MasterOffActiveJoinUsersRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterOffActiveJoinUsersItem_Body_JoinUser @end
@interface MasterOffActiveJoinUsersItem_Body_JoinUser : JSONModel
@property (nonatomic, copy) NSString<Optional> *schoolName;
@property (nonatomic, copy) NSString<Optional> *name;
@end
@interface MasterOffActiveJoinUsersItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, strong) NSArray<MasterOffActiveJoinUsersItem_Body_JoinUser, Optional> *joinUsers;
@end

@interface MasterOffActiveJoinUsersItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterOffActiveJoinUsersItem_Body<Optional> *body;
@end

@interface MasterOffActiveJoinUsersRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *aId;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *pageSize;
@end
