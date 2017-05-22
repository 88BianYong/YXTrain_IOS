//
//  YXCourseDetailItem.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "HttpBaseRequest.h"

@protocol YXCourseDetailItem_chapter_fragment <NSObject>
@end
@interface YXCourseDetailItem_chapter_fragment : JSONModel
@property (nonatomic, copy) NSString<Optional> *fragment_name;
@property (nonatomic, copy) NSString<Optional> *surl;
@property (nonatomic, copy) NSString<Optional> *murl;
@property (nonatomic, copy) NSString<Optional> *lurl;
@property (nonatomic, copy) NSString<Optional> *url;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *record;
@property (nonatomic, copy) NSString<Optional> *duration;
@property (nonatomic, copy) NSString<Optional> *sgqz;
@end

@protocol YXCourseDetailItem_chapter <NSObject>
@end
@interface YXCourseDetailItem_chapter : JSONModel
@property (nonatomic, copy) NSString<Optional> *chapter_name;
@property (nonatomic, copy) NSArray<YXCourseDetailItem_chapter_fragment, Optional> *fragments;
@end

@interface YXCourseDetailItem : JSONModel
@property (nonatomic, copy) NSString<Optional> *module_name;
@property (nonatomic, copy) NSString<Optional> *course_title;
@property (nonatomic, copy) NSString<Optional> *course_id;
@property (nonatomic, copy) NSString<Optional> *forcequizcorrect;
@property (nonatomic, copy) NSString<Optional> *source;

@property (nonatomic, copy) NSString<Optional> *ac;
@property (nonatomic, copy) NSString<Optional> *tc;
@property (nonatomic, copy) NSString<Optional> *rc;
@property (nonatomic, copy) NSString<Optional> *t;
@property (nonatomic, copy) NSString<Optional> *c;
@property (nonatomic, copy) NSString<Optional> *p;
@property (nonatomic, copy) NSString<Optional> *i;
@property (nonatomic, copy) NSString<Optional> *md5;
@property (nonatomic, copy) NSString<Optional> *mxt;
@property (nonatomic, copy) NSArray<YXCourseDetailItem_chapter, Optional> *chapters;
@property (nonatomic, strong) NSIndexPath<Optional> *playIndexPath;
- (YXCourseDetailItem_chapter_fragment *)willPlayVideo;
@end
