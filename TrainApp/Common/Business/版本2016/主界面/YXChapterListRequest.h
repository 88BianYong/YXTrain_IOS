//
//  YXChapterListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/16.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol YXChapterListRequestItem_sub  <NSObject>

@end

@interface YXChapterListRequestItem_sub : JSONModel

@property (nonatomic, copy) NSString<Optional> *chapterId;
@property (nonatomic, copy) NSString<Optional> *idx;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, strong) NSArray<YXChapterListRequestItem_sub ,Optional> *sub;

@end

@interface YXChapterListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<YXChapterListRequestItem_sub ,Optional> *data;
@end

@interface YXChapterListRequest : YXGetRequest
@property (nonatomic, copy) NSString *app_id;
@property (nonatomic, copy) NSString *stage_id;
@property (nonatomic, copy) NSString *subject_id;
@property (nonatomic, copy) NSString *version_id;
@property (nonatomic, copy) NSString *grade_id;
@end
