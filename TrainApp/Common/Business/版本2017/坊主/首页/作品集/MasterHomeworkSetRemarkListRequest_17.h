//
//  MasterHomeworkSetRemarkListRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/29.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterHomeworkSetRemarkListItem_Body_Remark @end
@interface MasterHomeworkSetRemarkListItem_Body_Remark : JSONModel
@property (nonatomic, copy) NSString<Optional> *rId;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *headUrl;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *publishDate;
@property (nonatomic, copy) NSString<Optional> *allowDel;
@end

@interface  MasterHomeworkSetRemarkListItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, strong) NSArray<MasterHomeworkSetRemarkListItem_Body_Remark,Optional> *remarks;
@end

@interface MasterHomeworkSetRemarkListItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterHomeworkSetRemarkListItem_Body<Optional> *body;
@end
@interface MasterHomeworkSetRemarkListRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *homeworkSetId;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *pageSize;
@end
