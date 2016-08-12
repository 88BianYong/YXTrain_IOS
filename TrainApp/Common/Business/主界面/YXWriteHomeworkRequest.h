//
//  YXWriteHomeworkRequest.h
//  TrainApp
//
//  Created by 郑小龙 on 16/8/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXGetRequest.h"
@interface YXWriteHomeworkRequestItem_Body_Upload : JSONModel
@property (nonatomic, copy) NSString<Optional> *resId;
@property (nonatomic, copy) NSString<Optional>  *fileName;
@property (nonatomic, copy) NSString<Optional> *downloadUrl;
@property (nonatomic, copy) NSString<Optional>  *previewUrl;

@end

@interface YXWriteHomeworkRequestItem_Body : JSONModel

@property (nonatomic, copy) NSString<Optional>  *title;
@property (nonatomic, copy) NSString<Optional>  *meizi_segment;
@property (nonatomic, copy) NSString<Optional>  *meizi_study;
@property (nonatomic, copy) NSString<Optional>  *meizi_edition;
@property (nonatomic, copy) NSString<Optional>  *meizi_grade;
@property (nonatomic, copy) NSString<Optional>  *meizi_chapter;
@property (nonatomic, copy) NSString<Optional>  *meizi_firstCategoryChapter;
@property (nonatomic, copy) NSString<Optional>  *meizi_keyword;
@property (nonatomic, strong)YXWriteHomeworkRequestItem_Body_Upload<Optional> *upload;

@end



@interface YXWriteHomeworkRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) YXWriteHomeworkRequestItem_Body<Optional> *body;
@end
@interface YXWriteHomeworkRequest : YXGetRequest
@property (nonatomic, copy) NSString *projectid;
@property (nonatomic, copy) NSString *passport;
@property (nonatomic, copy) NSString *hwid;
@end
