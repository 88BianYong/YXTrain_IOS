//
//  YXWorkshopMemberRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/7/6.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol YXWorkshopMemberRequestItem_memberList
@end
@interface YXWorkshopMemberRequestItem_memberList:JSONModel
@property (nonatomic, strong) NSString<Optional> *uid;
@property (nonatomic, strong) NSString<Optional> *head;
@property (nonatomic, strong) NSString<Optional> *nickName;
@end

@interface YXWorkshopMemberRequestItem:HttpBaseRequestItem
@property (nonatomic, strong) NSArray<Optional, YXWorkshopMemberRequestItem_memberList> *memberList;
@property (nonatomic, strong) NSString<Optional> *total;
@end

@interface YXWorkshopMemberRequest : YXGetRequest
@property (nonatomic, strong) NSString *barid;
@property (nonatomic, strong) NSString *pageindex;
@property (nonatomic, strong) NSString *pagesize;
@end
