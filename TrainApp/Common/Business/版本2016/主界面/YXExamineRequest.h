//
//  YXExamineRequest.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol YXExamineRequestItem_body_toolExamineVo <NSObject>

@end
@interface YXExamineRequestItem_body_toolExamineVo : JSONModel
@property (nonatomic, strong) NSString<Optional> *toolid;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *finishnum;
@property (nonatomic, strong) NSString<Optional> *totalnum;
@property (nonatomic, strong) NSString<Optional> *userscore;
@property (nonatomic, strong) NSString<Optional> *totalscore;
@property (nonatomic, strong) NSString<Optional> *isneedmark;
@end

@protocol YXExamineRequestItem_body_leadingVo <NSObject>

@end
@interface YXExamineRequestItem_body_leadingVo : JSONModel
@property (nonatomic, strong) NSString<Optional> *voID;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *isfinish;
@property (nonatomic, strong) NSString<Optional> *enddate;
@property (nonatomic, strong) NSString<Optional> *userscore;
@property (nonatomic, strong) NSString<Optional> *totalscore;
@property (nonatomic, strong) NSArray<YXExamineRequestItem_body_toolExamineVo,Optional> *toolExamineVoList;
@end

@protocol YXExamineRequestItem_body_bounsVoData <NSObject>

@end
@interface YXExamineRequestItem_body_bounsVoData : JSONModel
@property (nonatomic, strong) NSString<Optional> *voID;
@property (nonatomic, strong) NSString<Optional> *toolid;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *isfinish;
@property (nonatomic, strong) NSString<Optional> *finishnum;
@property (nonatomic, strong) NSString<Optional> *totalnum;
@property (nonatomic, strong) NSString<Optional> *userscore;
@property (nonatomic, strong) NSString<Optional> *totalscore;
@property (nonatomic, strong) NSString<Optional> *isneedmark;
@property (nonatomic, strong) NSString<Optional> *enddate;
@end

@interface YXExamineRequestItem_body_bounsVo : JSONModel
@property (nonatomic, strong) NSString<Optional> *publishBlog;
@property (nonatomic, strong) NSString<Optional> *publishHomework;
@property (nonatomic, strong) NSString<Optional> *uploadRes;
@property (nonatomic, strong) NSString<Optional> *publishWenda;
@property (nonatomic, strong) NSString<Optional> *timeCourse;
@property (nonatomic, strong) NSString<Optional> *mark;
@property (nonatomic, strong) NSString<Optional> *comment;
@property (nonatomic, strong) NSString<Optional> *followUser;
@property (nonatomic, strong) NSString<Optional> *joinAnswering;
@property (nonatomic, strong) NSString<Optional> *joinActive;
@property (nonatomic, strong) NSString<Optional> *commentEd;
@property (nonatomic, strong) NSString<Optional> *tuiyouEdHomework;
@property (nonatomic, strong) NSString<Optional> *tuiyouEdResource;
@property (nonatomic, strong) NSString<Optional> *downloadEdRes;
@property (nonatomic, strong) NSString<Optional> *bouns1;
@property (nonatomic, strong) NSString<Optional> *bouns2;
@property (nonatomic, strong) NSString<Optional> *bouns3;
@property (nonatomic, strong) NSString<Optional> *bounstotal;
@property (nonatomic, strong) NSString<Optional> *bounsscore;
@end

@interface YXExamineRequestItem_body : JSONModel
@property (nonatomic, strong) NSString<Optional> *totalfficial;
@property (nonatomic, strong) NSString<Optional> *totalscore;
@property (nonatomic, strong) NSString<Optional> *bounstotal;
@property (nonatomic, strong) NSString<Optional> *pofficial;
@property (nonatomic, strong) NSString<Optional> *punofficial;
@property (nonatomic, strong) NSString<Optional> *userGetScore;
@property (nonatomic, strong) NSString<Optional> *bounsscore;
@property (nonatomic, strong) NSString<Optional> *bounsdailylimit;
@property (nonatomic, strong) NSString<Optional> *isContainsTeacher;
@property (nonatomic, strong) NSString<Optional> *level;
@property (nonatomic, strong) NSString<Optional> *w;
@property (nonatomic, strong) NSString<Optional> *checkway;
@property (nonatomic, strong) NSString<Optional> *uRank;
@property (nonatomic, strong) NSString<Optional> *bounsdaily;
@property (nonatomic, strong) NSString<Optional> *userName;
@property (nonatomic, strong) NSString<Optional> *ptotalscore;
@property (nonatomic, strong) NSString<Optional> *isPass;
@property (nonatomic, strong) YXExamineRequestItem_body_bounsVo<Optional> *bounsVo;
@property (nonatomic, strong) NSArray<YXExamineRequestItem_body_leadingVo,Optional> *leadingVoList;
@property (nonatomic, strong) NSArray<YXExamineRequestItem_body_bounsVoData,Optional> *bounsVoList;
@end

@interface YXExamineRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXExamineRequestItem_body<Optional> *body;
@end

@interface YXExamineRequest : YXGetRequest
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *w;
@property (nonatomic, strong) NSString *userId;
@end


