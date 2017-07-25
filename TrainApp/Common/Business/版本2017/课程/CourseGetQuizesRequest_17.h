//
//  CourseGetQuizesRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"


@protocol CourseGetQuizesRequest_17Item_Result_Questions_AnswerJson
@end
@interface CourseGetQuizesRequest_17Item_Result_Questions_AnswerJson : JSONModel
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *no;
@property (nonatomic, copy) NSString<Optional> *isChoose;
@end

@interface CourseGetQuizesRequest_17Item_Result_Questions_Question : JSONModel
@property (nonatomic, strong) NSArray<Optional> *correctAnswer;
@end
@protocol CourseGetQuizesRequest_17Item_Result_Questions <NSObject>
@end
@interface CourseGetQuizesRequest_17Item_Result_Questions : JSONModel
@property (nonatomic, copy) NSString<Optional> *quesAnswerCount;
@property (nonatomic, copy) NSString<Optional> *qID;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *types;
@property (nonatomic, strong) NSArray<CourseGetQuizesRequest_17Item_Result_Questions_AnswerJson, Optional> *answerJson;
@end
@protocol CourseGetQuizesRequest_17Item_Result
@end
@interface CourseGetQuizesRequest_17Item_Result : JSONModel
@property (nonatomic, strong) NSArray<CourseGetQuizesRequest_17Item_Result_Questions, Optional> *questions;
@end

@interface CourseGetQuizesRequest_17Item : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<CourseGetQuizesRequest_17Item_Result,Optional> *result;
@end
@interface CourseGetQuizesRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectID;
@property (nonatomic, copy) NSString<Optional> *thame;//主题 id，有主题时必填，默认为0
@property (nonatomic, copy) NSString<Optional> *page;//页数
@property (nonatomic, copy) NSString<Optional> *limit;//每页数量
@end
