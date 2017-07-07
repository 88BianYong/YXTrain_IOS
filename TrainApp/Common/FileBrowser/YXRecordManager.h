//
//  YXRecordManager.h
//  TrainApp
//
//  Created by niuzhaowang on 16/7/5.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXCourseDetailItem.h"

static NSString * const kRecordReportCompleteNotification = @"kRecordReportCompleteNotification";
static NSString * const kRecordReportSuccessNotification = @"kRecordReportSuccessNotification";
static NSString * const kRecordNeedUpdateNotification = @"kRecordNeedUpdateNotification";

@interface YXRecordManager : NSObject

- (void)setupWithCourseDetailItem:(YXCourseDetailItem *)item;
- (void)clear;

@property (nonatomic, assign, readonly) BOOL isActive; // 为NO时不做记录

// 每次预览文件时都要设置下面2个属性，以便准确记录对应文件
@property (nonatomic, assign) NSInteger chapterIndex;
@property (nonatomic, assign) NSInteger fragmentIndex;

// 视频、音频操作
- (void)updateFragmentWithDuration:(NSTimeInterval)duration record:(NSTimeInterval)record watchedTime:(NSTimeInterval)time;
- (CGFloat)preProgress;

// 文件、网页
- (void)updateFragmentWithFileBrowseTime:(NSTimeInterval)time;

- (void)report;

@end
