//
//  VideoCourseChapterViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXCourseListRequest.h"
typedef NS_ENUM(NSInteger, VideoCourseFromWhere) {
    VideoCourseFromWhere_Detail,
    VideoCourseFromWhere_Record,
    VideoCourseFromWhere_QRCode,
    VideoCourseFromWhere_NotFound
};
typedef void (^VideoCourseChapterFragmentCompleteBlock)(YXFileItemBase *fileItem ,BOOL isHaveVideo);

typedef void (^VideoCourseIntroductionCompleteBlock)(YXCourseDetailItem *courseItem);
@interface VideoCourseChapterViewController : YXBaseViewController
@property (nonatomic, strong) YXCourseListRequestItem_body_module_course *course;
@property (nonatomic, assign) VideoCourseFromWhere fromWhere;
@property (nonatomic, assign) NSInteger seekInteger;
@property (nonatomic, copy) void(^videoCourseSlideBlcok)(BOOL isTopBool);

/**
 准备下一个播放源

 @param isAgain YES重新播放 NO 不
 */
- (void)dealWithCourseItem:(YXCourseDetailItem *)courseItem;
- (void)readyNextWillplayVideoAgain:(BOOL)isAgain;
- (void)setVideoCourseChapterFragmentCompleteBlock:(VideoCourseChapterFragmentCompleteBlock)block;
- (void)setVideoCourseIntroductionCompleteBlock:(VideoCourseIntroductionCompleteBlock)block;
@end
