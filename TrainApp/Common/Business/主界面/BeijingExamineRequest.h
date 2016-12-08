//
//  BeijingExamineRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/12/1.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList <NSObject>
@end

@protocol BeijingExamineRequestItem_ExamineVoList <NSObject>
@end

@interface BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList : JSONModel
@property (nonatomic, copy) NSString<Optional> *toolid;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *finishnum;
@property (nonatomic, copy) NSString<Optional> *totalnum;
@property (nonatomic, copy) NSString<Optional> *userscore;
@property (nonatomic, copy) NSString<Optional> *totalscore;
@property (nonatomic, copy) NSString<Optional> *totalCredit;//已选学时
@property (nonatomic, copy) NSString<Optional> *totalHasCredit;//已学学时
@property (nonatomic, copy) NSString<Optional> *requireid;
@property (nonatomic, copy) NSString<Optional> *homeworkid;//已学学时
@end

@interface BeijingExamineRequestItem_ExamineVoList : JSONModel
@property (nonatomic, copy) NSString<Optional> *examineVoID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *isfinish;
@property (nonatomic, copy) NSString<Optional> *userscore;
@property (nonatomic, copy) NSString<Optional> *totalscore;
@property (nonatomic, strong) NSMutableArray<BeijingExamineRequestItem_ExamineVoList_ToolExamineVoList,Optional> *toolExamineVoList;
@end

@interface BeijingExamineRequestItem_BounsVo : JSONModel
@end

@interface BeijingExamineRequestItem: HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> *pofficial;
@property (nonatomic, copy) NSString<Optional> *w;
@property (nonatomic, copy) NSString<Optional> *userGetScore;
@property (nonatomic, copy) NSString<Optional> *bounsdailylimit;
@property (nonatomic, copy) NSString<Optional> *level;
@property (nonatomic, copy) NSString<Optional> *isContainsTeacher;
@property (nonatomic, copy) NSString<Optional> *uRank;
@property (nonatomic, copy) NSString<Optional> *bounsdaily;
@property (nonatomic, copy) NSString<Optional> *punofficial;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *ptotalscore;
@property (nonatomic, copy) NSString<Optional> *isNewPlatform;
@property (nonatomic, copy) NSString<Optional> *applystatus;
@property (nonatomic, strong) NSArray<BeijingExamineRequestItem_ExamineVoList,Optional> *examineVoList;
@end

@interface BeijingExamineRequest : YXGetRequest
@property (nonatomic, strong) NSString *projectid;
@property (nonatomic, strong) NSString *w;
@end
