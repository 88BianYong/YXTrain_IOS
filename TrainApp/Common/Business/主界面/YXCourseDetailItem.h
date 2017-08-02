//
//  YXCourseDetailItem.h
//  TrainApp
//
//  Created by niuzhaowang on 16/6/30.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "HttpBaseRequest.h"
@protocol YXCourseDetailItem_chapter_fragment_items <NSObject>
@end
@interface YXCourseDetailItem_chapter_fragment_items : JSONModel
@property (nonatomic, copy) NSString<Optional> *sgtnm;
@property (nonatomic, copy) NSString<Optional> *sgdes;
@end


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
@property (nonatomic, copy) NSArray<YXCourseDetailItem_chapter_fragment_items, Optional> *items;

@end

@protocol YXCourseDetailItem_chapter <NSObject>
@end
@interface YXCourseDetailItem_chapter : JSONModel
@property (nonatomic, copy) NSString<Optional> *chapter_name;
@property (nonatomic, copy) NSArray<YXCourseDetailItem_chapter_fragment, Optional> *fragments;
@end

@interface YXCourseDetailItem_score : JSONModel
@property (nonatomic, copy) NSString<Optional> *avr;
@property (nonatomic, copy) NSString<Optional> *ccount;
@property (nonatomic, copy) NSString<Optional> *sself;
@end
@protocol YXCourseDetailItem_mti <NSObject>

@end
@interface YXCourseDetailItem_mti : JSONModel
@property (nonatomic, copy) NSString<Optional> *ctn;
@property (nonatomic, copy) NSString<Optional> *cti;
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
@property (nonatomic, strong) YXCourseDetailItem_score<Optional> *score;
@property (nonatomic, strong) NSArray<YXCourseDetailItem_mti, Optional> *mti;
@property (nonatomic, strong) NSIndexPath<Optional> *playIndexPath;
@property (nonatomic, copy) NSString<Optional> *vhead;
@property (nonatomic, copy) NSString<Optional> *vheadUrl;


@property (nonatomic, copy) NSString<Optional> *courseSchemeMode;//课程的考核模式，0：按时长考核，1：按完成考核
@property (nonatomic, copy) NSString<Optional> *openQuizTime;//按完成考核时，开启测验的时间点
@property (nonatomic, copy) NSString<Optional> *userQuizStatus;//按完成考核时，用户参加测验的结果（0：未合格，1合格）
@property (nonatomic, copy) NSString<Optional> *quizNum;//该课程下随堂练的个数（按时长考核时固定为0）
- (YXCourseDetailItem_chapter_fragment *)willPlayVideoSeek:(NSInteger)integer;
@end
