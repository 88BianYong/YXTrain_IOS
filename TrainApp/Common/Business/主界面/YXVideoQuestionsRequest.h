//
//  YXVideoQuestionsRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol YXVideoQuestionsRequestItem_Result_Questions <NSObject>
@end
@protocol YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson <NSObject>
@end

@interface YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson : JSONModel
@property (nonatomic, copy) NSString<Optional> *content;
@property (nonatomic, copy) NSString<Optional> *no;
@property (nonatomic, copy) NSString<Optional> *isChoose;
@end

@interface YXVideoQuestionsRequestItem_Result_Questions_Question : JSONModel
@property (nonatomic, strong) NSArray<YXVideoQuestionsRequestItem_Result_Questions_Question_AnswerJson, Optional> *answerJson;
@property (nonatomic, copy) NSString<Optional> *title;
@property (nonatomic, copy) NSString<Optional> *qId;
@property (nonatomic, copy) NSString<Optional> *types;

@end

@interface YXVideoQuestionsRequestItem_Result_Questions : JSONModel
@property (nonatomic, copy) NSString<Optional> *quesAnswerCount;
@property (nonatomic, strong) YXVideoQuestionsRequestItem_Result_Questions_Question<Optional> *question;
@end

@interface YXVideoQuestionsRequestItem_Result : JSONModel
@property (nonatomic, strong) NSArray<YXVideoQuestionsRequestItem_Result_Questions, Optional> *questions;
@end

@interface YXVideoQuestionsRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXVideoQuestionsRequestItem_Result<Optional> *result;
@end

@interface YXVideoQuestionsRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *pID;
@property (nonatomic, strong) NSString<Optional> *cID;
@property (nonatomic, strong) NSString<Optional> *qID;
@end
