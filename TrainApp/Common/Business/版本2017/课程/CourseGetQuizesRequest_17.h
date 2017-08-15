//
//  CourseGetQuizesRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"


@protocol CourseGetQuizesRequest_17Item_Result_Questions_Questions_AnswerJson
@end
@interface CourseGetQuizesRequest_17Item_Result_Questions_Questions_AnswerJson : JSONModel
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *no;
@property (nonatomic, copy) NSString<Optional> *isChoose;
@end

@interface CourseGetQuizesRequest_17Item_Result_Questions_Question : JSONModel
//@property (nonatomic, copy) NSString<Optional> *correctAnswer;
@property (nonatomic, copy) NSString<Optional> *qID;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *types;
@property (nonatomic, copy) NSString<Optional> *userChoose;
@property (nonatomic, strong) NSArray<CourseGetQuizesRequest_17Item_Result_Questions_Questions_AnswerJson, Optional> *answerJson;
@end
@protocol CourseGetQuizesRequest_17Item_Result_Questions <NSObject>
@end
@interface CourseGetQuizesRequest_17Item_Result_Questions : JSONModel
@property (nonatomic, copy) NSString<Optional> *quesAnswerCount;
@property (nonatomic, strong) CourseGetQuizesRequest_17Item_Result_Questions_Question<Optional> *question;
@end
@protocol CourseGetQuizesRequest_17Item_Result
@end
@interface CourseGetQuizesRequest_17Item_Result : JSONModel
@property (nonatomic, copy) NSString<Optional> *lastTime;
@property (nonatomic, copy) NSString<Optional> *wrongNum;
@property (nonatomic, copy) NSString<Optional> *correctNum;
@property (nonatomic, copy) NSString<Optional> *status;
@property (nonatomic, strong) NSArray<CourseGetQuizesRequest_17Item_Result_Questions, Optional> *questions;
@end

@interface CourseGetQuizesRequest_17Item : HttpBaseRequestItem
@property (nonatomic, strong) CourseGetQuizesRequest_17Item_Result<Optional> *result;
@end
@interface CourseGetQuizesRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *pid;
@property (nonatomic, copy) NSString<Optional> *cid;
@property (nonatomic, copy) NSString<Optional> *stageid;
@end
