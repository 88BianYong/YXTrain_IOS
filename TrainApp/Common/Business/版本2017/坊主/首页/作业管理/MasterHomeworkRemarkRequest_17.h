//
//  MasterHomeworkRemarkRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/11/21.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterHomeworkRemarkItem_Body_Remark @end
@interface MasterHomeworkRemarkItem_Body_Remark : JSONModel
@property (nonatomic, copy) NSString<Optional> *rId;
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *headUrl;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *publishDate;
@end

@interface  MasterHomeworkRemarkItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *total;
@property (nonatomic, strong) NSArray<MasterHomeworkRemarkItem_Body_Remark,Optional> *remarks;
@end

@interface MasterHomeworkRemarkItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterHomeworkRemarkItem_Body<Optional> *body;
@end
@interface MasterHomeworkRemarkRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *homeworkId;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *pageSize;
@end
