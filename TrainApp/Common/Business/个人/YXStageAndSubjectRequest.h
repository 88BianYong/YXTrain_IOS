//
//  YXStageAndSubjectRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

// 学科，如数学
@interface YXStageAndSubjectItem_Stage_Subject : JSONModel

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *name;

@end

// 学段，如小学
@protocol YXStageAndSubjectItem_Stage_Subject @end
@interface YXStageAndSubjectItem_Stage : JSONModel

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray<YXStageAndSubjectItem_Stage_Subject, Optional> *subjects;

@end

@protocol YXStageAndSubjectItem_Stage @end
@interface YXStageAndSubjectItem : HttpBaseRequestItem

@property (nonatomic, strong) NSArray<YXStageAndSubjectItem_Stage, Optional> *stages;
@property (nonatomic, copy) NSString *version;

@end

@interface YXStageAndSubjectRequest : YXGetRequest

@end
