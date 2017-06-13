//
//  MasterStatRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 17/2/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterStatRequestItem_Body_Type_Detail
@end
@interface MasterStatRequestItem_Body_Type_Detail : JSONModel
@property (nonatomic, copy) NSString<Optional> *typecode;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *amount;
@property (nonatomic, copy) NSString<Optional> *score;
@property (nonatomic, copy) NSString<Optional> *descripe;
@property (nonatomic, copy) NSString<Optional> *userscore;
@end

@protocol MasterStatRequestItem_Body_Type
@end
@interface MasterStatRequestItem_Body_Type : JSONModel
@property (nonatomic, copy) NSString<Optional> *power;//1: "研修组织力",2: "研修指导力",3: "学习力",4: "在线考试"
@property (nonatomic, copy) NSString<Optional> *score;
@property (nonatomic, strong) NSArray<MasterStatRequestItem_Body_Type_Detail,Optional> *details;
@end

@interface MasterStatRequestItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *egscore;
@property (nonatomic, copy) NSString<Optional> *totalscore;
@property (nonatomic, copy) NSString<Optional> *viewType;
@property (nonatomic, copy) NSString<Optional> *ifexam;
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, strong) NSArray<MasterStatRequestItem_Body_Type,Optional> *types;
@end
@interface MasterStatRequestItem : HttpBaseRequestItem
@property (nonatomic ,strong) MasterStatRequestItem_Body<Optional> *body;

@end

@interface MasterStatRequest : YXGetRequest
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *roleId;
@end
