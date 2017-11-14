//
//  MasterIndexRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "ExamineDetailRequest_17.h"
@protocol MasterIndexRequestItem_Body_MyExamine_Types_Detail @end
@interface MasterIndexRequestItem_Body_MyExamine_Types_Detail : JSONModel
@property (nonatomic, copy) NSString<Optional> *typecode;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *amount;
@property (nonatomic, copy) NSString<Optional> *score;
@property (nonatomic, copy) NSString<Optional> *descripe;
@property (nonatomic, copy) NSString<Optional> *userscore;
@property (nonatomic, copy) NSString<Optional> *userfinishnum;
@property (nonatomic, copy) NSString<Optional> *isfinish;


@end
@protocol MasterIndexRequestItem_Body_MyExamine_Types @end
@interface MasterIndexRequestItem_Body_MyExamine_Types : JSONModel
@property (nonatomic, copy) NSString<Optional> *power;
@property (nonatomic, copy) NSString<Optional> *score;
@property (nonatomic, strong) NSArray<MasterIndexRequestItem_Body_MyExamine_Types_Detail,Optional> *details;
@end

@interface MasterIndexRequestItem_Body_MyExamine : JSONModel
@property (nonatomic, copy) NSString<Optional> *egscore;
@property (nonatomic, copy) NSString<Optional> *totalscore;
@property (nonatomic, copy) NSString<Optional> *viewType;
@property (nonatomic, copy) NSString<Optional> *ifexam;
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *toolId;
@property (nonatomic, copy) NSString<Optional> *isPass;
@property (nonatomic, strong) NSArray<MasterIndexRequestItem_Body_MyExamine_Types,Optional> *types;
@end

@interface MasterIndexRequestItem_Body_Modules_Extend : JSONModel
@property (nonatomic, copy) NSString<Optional> *stageId;

@end
@protocol MasterIndexRequestItem_Body_Modules @end
@interface MasterIndexRequestItem_Body_Modules : JSONModel
@property (nonatomic, copy) NSString<Optional> *code;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *toolId;
@property (nonatomic, copy) NSString<Optional> *iconStatus;
@property (nonatomic, strong) MasterIndexRequestItem_Body_Modules_Extend<Optional> *extend;

@end
@protocol MasterIndexRequestItem_Body_CountBars @end
@interface MasterIndexRequestItem_Body_CountBars : JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *allCount;
@property (nonatomic, copy) NSString<Optional> *passCount;

@end

@interface MasterIndexRequestItem_Body : JSONModel
@property (nonatomic, strong) NSArray<MasterIndexRequestItem_Body_CountBars,Optional> *countBars;
@property (nonatomic, strong) NSMutableArray<MasterIndexRequestItem_Body_Modules,Optional> *modules;
@property (nonatomic, strong) MasterIndexRequestItem_Body_MyExamine<Optional> *myExamine;
@end

@interface MasterIndexRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterIndexRequestItem_Body<Optional> *body;
@end
@interface MasterIndexRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectID;
@end
