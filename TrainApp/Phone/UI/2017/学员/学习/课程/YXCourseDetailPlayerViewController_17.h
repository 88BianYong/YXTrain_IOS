//
//  YXCourseDetailPlayerViewController_17.h
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXCourseDetailRequest.h"
#import "YXModuleDetailRequest.h"
#import "YXCourseListRequest.h"
#import "VideoCourseChapterViewController.h"
#import "YXPlayerManagerView.h"
#import "CourseDetailContainerView_17.h"
#import "VideoClassworkManager.h"
@interface YXCourseDetailPlayerViewController_17 : YXBaseViewController
@property (nonatomic, strong) YXModuleDetailRequest *moduleDetailRequest;
@property (nonatomic, strong) YXCourseDetailRequest *courseDetailRequest;


@property (nonatomic, strong) YXCourseDetailItem *detailItem;
@property (nonatomic, strong) YXCourseListRequestItem_body_module_course *course;
@property (nonatomic, copy) NSString *stageString;


@property (nonatomic, assign) VideoCourseFromWhere fromWhere;
@property (nonatomic, assign) NSInteger seekInteger;
@property (nonatomic, assign) BOOL isFullscreen;
@property (nonatomic, assign) BOOL isHiddenTestBool;
@property (nonatomic, weak) id<YXPlayProgressDelegate> delegate;//返回,推入后台,播放完成,切换
@property (nonatomic, weak) id<YXBrowserExitDelegate> exitDelegate;


@property (nonatomic, strong) YXPlayerManagerView *playMangerView;
@property (nonatomic, strong) CourseDetailContainerView_17 *containerView;
@property (nonatomic, strong) VideoClassworkManager *classworkManager;


- (void)recordPlayerDuration;


@end
