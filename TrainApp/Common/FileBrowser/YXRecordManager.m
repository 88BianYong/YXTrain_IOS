//
//  YXRecordManager.m
//  TrainApp
//
//  Created by niuzhaowang on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXRecordManager.h"
#import "YXRecordContent.h"
#import "YXSaveProcessRequest.h"

@interface YXRecordManager()
@property (nonatomic, strong) YXCourseDetailItem *courseDetailItem;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) YXSaveProcessRequest *request;
@end

@implementation YXRecordManager

+ (instancetype)sharedManager{
    static YXRecordManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXRecordManager alloc] init];
    });
    return manager;
}

- (void)setupWithCourseDetailItem:(YXCourseDetailItem *)item{
    self.courseDetailItem = item;
    self.isActive = YES;
}

- (void)clear{
    self.courseDetailItem = nil;
    self.isActive = NO;
}

- (void)updateFragmentWithDuration:(NSTimeInterval)duration record:(NSTimeInterval)record watchedTime:(NSTimeInterval)time{
    CGFloat rcValue = [self.courseDetailItem.rc floatValue];
    self.courseDetailItem.rc = [NSString stringWithFormat:@"%lld", (long long)(rcValue+time)];
    
    YXCourseDetailItem_chapter *chapter = self.courseDetailItem.chapters[self.chapterIndex];
    YXCourseDetailItem_chapter_fragment *fragment = chapter.fragments[self.fragmentIndex];
    fragment.duration = [NSString stringWithFormat:@"%lld", (long long)duration];
    fragment.record = [NSString stringWithFormat:@"%lld", (long long)record];
}

- (CGFloat)preProgress{
    YXCourseDetailItem_chapter *chapter = self.courseDetailItem.chapters[self.chapterIndex];
    YXCourseDetailItem_chapter_fragment *fragment = chapter.fragments[self.fragmentIndex];
    if (fragment.duration.floatValue > 0) {
        return fragment.record.floatValue / fragment.duration.floatValue;
    }
    return 0;
}

- (void)updateFragmentWithFileBrowseTime:(NSTimeInterval)time{
    CGFloat rcValue = [self.courseDetailItem.rc floatValue];
    self.courseDetailItem.rc = [NSString stringWithFormat:@"%lld", (long long)(rcValue+time)];
}

- (void)report{
    [self.request stopRequest];
    self.request = [[YXSaveProcessRequest alloc] init];
    self.request.cid = self.courseDetailItem.course_id;
    self.request.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
    self.request.w = [LSTSharedInstance sharedInstance].trainManager.currentProject.w;
    self.request.content = [[YXRecordContent contentFromCourseDetailItem:self.courseDetailItem]toJSONString];
    
    NSString *course_id = self.courseDetailItem.course_id;
    NSString *rc = self.courseDetailItem.rc;
    WEAK_SELF
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRecordReportSuccessNotification object:nil userInfo:@{course_id:rc}];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kRecordReportCompleteNotification object:nil];
    }];
}

@end
