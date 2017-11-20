//
//  MasterHomeworkListRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "MasterManagerSchemeItem.h"
@protocol MasterHomeworkListItem_Body_Bar @end
@interface MasterHomeworkListItem_Body_Bar : JSONModel
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, copy) NSString<Optional> *name;
@end
@protocol MasterHomeworkListItem_Body_Homework @end
@interface MasterHomeworkListItem_Body_Homework : JSONModel
@property (nonatomic, copy) NSString<Optional> *homeworkId;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *publishUser;
@property (nonatomic, copy) NSString<Optional> *score;
@property (nonatomic, copy) NSString<Optional> *isMasterComment;//坊主点评 1已点评
@property (nonatomic, copy) NSString<Optional> *isGrouperComment;//组长点评 1已点评
@property (nonatomic, copy) NSString<Optional> *isExpertComment;//专家点评 1已点评
@property (nonatomic, copy) NSString<Optional> *isMyRecommend;
@property (nonatomic, copy) NSString<Optional> *isMasterRecommend;//坊主推优 1已推优
@property (nonatomic, copy) NSString<Optional> *isGrouperRecommend; //组长推优 1已推优
@property (nonatomic, copy) NSString<Optional> *isExpertRecommend;//专家推优 1已推优
@property (nonatomic, copy) NSString<Optional> *ismyrec;
@property (nonatomic, copy) NSString<Optional> *finishDate;
@end

@interface MasterHomeworkListItem_Body : JSONModel
@property (nonatomic, strong) NSArray<MasterManagerSchemeItem, Optional> *schemes;
@property (nonatomic, strong) NSArray<MasterHomeworkListItem_Body_Bar, Optional> *bars;
@property (nonatomic, strong) NSArray<MasterHomeworkListItem_Body_Homework, Optional> *homeworks;
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *totalPage;
@end

@interface MasterHomeworkListItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterHomeworkListItem_Body<Optional> *body;
@end

@interface MasterHomeworkListRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, copy) NSString<Optional> *recommendStatus;
@property (nonatomic, copy) NSString<Optional> *readStatus;
@property (nonatomic, copy) NSString<Optional> *commendStatus;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *pageSize;
@end
