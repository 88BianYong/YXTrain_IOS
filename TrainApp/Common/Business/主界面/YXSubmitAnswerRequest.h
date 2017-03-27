//
//  YXSubmitAnswerRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/3/27.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface YXSubmitAnswerRequestItem : HttpBaseRequestItem
@property (nonatomic, copy) NSString<Optional> * isCorrect;
@end

@interface YXSubmitAnswerRequest : YXGetRequest
@property (nonatomic, strong) NSString<Optional> *qID;
@property (nonatomic, strong) NSString<Optional> *cID;
@property (nonatomic, strong) NSString<Optional> *pID;
@property (nonatomic, strong) NSString<Optional> *src;
@property (nonatomic, strong) NSString<Optional> *sm;
@property (nonatomic, strong) NSString<Optional> *aj;
@end
