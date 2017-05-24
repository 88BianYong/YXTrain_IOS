//
//  VideoCourseChapterViewController.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXCourseListRequest.h"
typedef void (^VideoCourseChapterFragmentCompleteBlock)(NSError *error,YXFileItemBase *fileItem ,BOOL isHaveVideo);

@interface VideoCourseChapterViewController : YXBaseViewController
@property (nonatomic, strong) YXCourseListRequestItem_body_module_course *course;
@property (nonatomic, assign) BOOL isFromRecord;

/**
 准备下一个播放源

 @param isAgain YES重新播放 NO 不
 */
- (void)readyNextWillplayVideoAgain:(BOOL)isAgain;
- (void)setVideoCourseChapterFragmentCompleteBlock:(VideoCourseChapterFragmentCompleteBlock)block;
- (void)requestForCourseDetail;
@end
