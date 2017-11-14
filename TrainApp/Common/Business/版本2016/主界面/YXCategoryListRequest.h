//
//  YXCategoryListRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"

@protocol YXCategoryListRequestItem_Data <NSObject>

@end

@interface YXCategoryListRequestItem_Data : JSONModel

@property (nonatomic, copy) NSString<Optional> *categoryId;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *code;
@property (nonatomic, strong) NSArray<YXCategoryListRequestItem_Data,Optional> *sub;
@end

@interface YXCategoryListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<YXCategoryListRequestItem_Data, Optional> *data;
@end

@interface YXCategoryListRequest : YXGetRequest
@property (nonatomic, copy) NSString *flag;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *app_id;
@property (nonatomic, copy) NSString *stage_id;
@property (nonatomic, copy) NSString *subject_id;
@property (nonatomic, copy) NSString *filter;
@end
