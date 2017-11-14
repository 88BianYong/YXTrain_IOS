//
//  YXHomeworkListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/3.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXHomeworkInfoRequest.h"
@protocol YXHomeworkListRequestItem_Body_Stages <NSObject>
@end
@interface YXHomeworkListRequestItem_Body_Stages : JSONModel
@property (nonatomic, copy) NSString<Optional> *stagesId;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *subject;
@property (nonatomic, strong) NSMutableArray<YXHomeworkInfoRequestItem_Body ,Optional> *homeworks;
@end


@interface YXHomeworkListRequestItem_Body : JSONModel
@property (nonatomic, copy) NSString<Optional> *endDate;
@property (nonatomic, strong) NSMutableArray<YXHomeworkListRequestItem_Body_Stages ,Optional> *stages;
@end

@interface YXHomeworkListRequestItem:HttpBaseRequestItem
@property (nonatomic, strong)YXHomeworkListRequestItem_Body<Optional> * body;
@end


@interface YXHomeworkListRequest : YXGetRequest
@property (nonatomic, copy) NSString *pid;
@end
