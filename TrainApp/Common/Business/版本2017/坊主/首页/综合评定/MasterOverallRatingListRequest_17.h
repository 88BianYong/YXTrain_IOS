//
//  MasterOverallRatingListRequest_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/12/5.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@protocol MasterOverallRatingListItem_Body_Bar @end
@interface MasterOverallRatingListItem_Body_Bar : JSONModel
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *barId;
@end
@protocol MasterOverallRatingListItem_Body_UserScore @end
@interface MasterOverallRatingListItem_Body_UserScore : JSONModel
@property (nonatomic, copy) NSString<Optional> *userId;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Ignore> *sortName;
@property (nonatomic, copy) NSString<Optional> *schoolName;
@property (nonatomic, copy) NSString<Optional> *studyName;
@property (nonatomic, copy) NSString<Optional> *segmentName;
@property (nonatomic, copy) NSString<Optional> *score;
@end

@interface MasterOverallRatingListItem_Body_CountUser : JSONModel
@property (nonatomic, copy) NSString<Optional> *scoreCount;
@property (nonatomic, copy) NSString<Optional> *allCount;
@end

@interface MasterOverallRatingListItem_Body : JSONModel
@property (nonatomic, strong) MasterOverallRatingListItem_Body_CountUser<Optional> *countUser;
@property (nonatomic, strong) NSArray<MasterOverallRatingListItem_Body_UserScore,Optional> *userScores;
@property (nonatomic, strong) NSArray<MasterOverallRatingListItem_Body_Bar,Optional> *bars;
@property (nonatomic, copy) NSString<Optional> *exmineDesc;

@end

@interface MasterOverallRatingListItem : HttpBaseRequestItem
@property (nonatomic, strong) MasterOverallRatingListItem_Body<Optional> *body;
@end

@interface MasterOverallRatingListRequest_17 : YXGetRequest
@property (nonatomic, copy) NSString<Optional> *projectId;
@property (nonatomic, copy) NSString<Optional> *barId;
@property (nonatomic, copy) NSString<Optional> *userName;
@property (nonatomic, copy) NSString<Optional> *isScore;
@property (nonatomic, copy) NSString<Optional> *page;
@property (nonatomic, copy) NSString<Optional> *pageSize;
@end
