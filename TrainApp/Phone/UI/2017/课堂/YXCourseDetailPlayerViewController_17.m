//
//  YXCourseDetailPlayerViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/8/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXCourseDetailPlayerViewController_17.h"
#import "YXCourseDetailPlayerViewController_17+Rotate.h"
#import "YXCourseDetailPlayerViewController_17+Request.h"

#import "VideoCourseIntroductionViewController.h"
#import "VideoCourseCommentViewController.h"
#import "CourseTestViewController_17.h"
#import "VideoClassworkManager.h"
#import "YXPlayerBeginningView.h"
@interface YXCourseDetailPlayerViewController_17 ()
@property (nonatomic, strong) VideoClassworkManager *classworkManager;
@property (nonatomic, strong) YXPlayerBeginningView *beginningView;

@property (nonatomic, strong) VideoCourseChapterViewController *chapterVC;
@property (nonatomic, strong) VideoCourseIntroductionViewController *introductionVC;
@property (nonatomic, strong) VideoCourseCommentViewController *commentVC;

@property (nonatomic, assign) BOOL isBeginPlayEnd;

@end

@implementation YXCourseDetailPlayerViewController_17
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = self.course.course_title;
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForCourseDetail];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainPlayCourseNext object:@(YXTrainCourseVideoPlay)];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainPlayCourseNext object:@(YXTrainCourseVideoPause)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - set
- (void)setIsFullscreen:(BOOL)isFullscreen {
    _isFullscreen = isFullscreen;
    self.classworkManager.clossworkView.isFullscreen = _isFullscreen;
    self.playMangerView.isFullscreen = _isFullscreen;
    self.beginningView.isFullscreen = _isFullscreen;
}
- (void)setDetailItem:(YXCourseDetailItem *)detailItem {
    if (detailItem == nil) {
        return;
    }
    _detailItem = detailItem;
    [self.chapterVC dealWithCourseItem:_detailItem];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playMangerView.mas_bottom).offset(-71.0f);
    }];
    self.introductionVC.courseItem = _detailItem;
//    if (_detailItem.quizNum.integerValue == 0 || _detailItem.courseSchemeMode.integerValue == 0 || _detailItem.userQuizStatus.integerValue == 1) {
//        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.playMangerView.mas_bottom).offset(-71.0f);
//        }];
//    }else {//新随堂练
//        self.containerView.startTimeInteger = _detailItem.openQuizTime.integerValue;
//        self.containerView.playTimeInteger = _detailItem.rc.integerValue;
//        self.playMangerView.playTotalTime = _detailItem.rc.integerValue;
//        self.containerView.isStartBool =floor((float)self.containerView.playTimeInteger/60.0f) >= ceil((float)self.containerView.startTimeInteger/60.0f);
//        WEAK_SELF
//        self.disposable = [RACObserve(self.playMangerView, playTotalTime) subscribeNext:^(id x) {
//            STRONG_SELF
//            if (self.playMangerView.playTotalTime > 0 ) {
//                self.containerView.playTimeInteger = self.playMangerView.playTotalTime;
//                if (floor((float)self.containerView.playTimeInteger/60.0f) >= ceil((float)self.containerView.startTimeInteger/60.0f) && !self.containerView.isStartBool) {
//                    [self.playMangerView playReport:^(BOOL isSuccess) {
//                        self.containerView.isStartBool = isSuccess;
//                    }];
//                }
//            }
//        }];
//    }
}

#pragma makr - setupUI
- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.errorView = [[YXErrorView alloc]init];
    WEAK_SELF
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForCourseDetail];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self requestForCourseDetail];
    };
    
    self.containerView = [[CourseDetailContainerView_17 alloc] init];
//    self.containerView.courseDetailContainerButtonBlock = ^{
//        STRONG_SELF
//        CourseTestViewController_17 *VC = [[CourseTestViewController_17 alloc] init];
//        VC.cID = self.course.courses_id;
//        VC.stageString = self.stageString;
//        VC.courseTestQuestionBlock = ^(BOOL isFullBool) {
//            STRONG_SELF
//            if (isFullBool) {
//                self.detailItem.userQuizStatus = @"1";
//                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(self.playMangerView.mas_bottom).offset(-71.0f);
//                }];
//            }
//        };
//        [self.navigationController pushViewController:VC animated:YES];
//    };
    self.containerView.hidden = YES;
    [self.view addSubview:self.containerView];
    self.playMangerView = [[YXPlayerManagerView alloc] init];
    self.playMangerView.hidden = YES;
    [self.playMangerView.thumbImageView sd_setImageWithURL:[NSURL URLWithString:self.course.course_img]];
    self.playMangerView.playerManagerRotateActionBlock = ^{
        STRONG_SELF
        [self rotateScreenAction];
    };
    self.playMangerView.playerManagerBackActionBlock = ^{
        STRONG_SELF
         [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    };
    self.playMangerView.playerManagerFinishActionBlock = ^{
        STRONG_SELF
        [self recordPlayerDuration];
        SAFE_CALL(self.exitDelegate, browserExit);
        [self.chapterVC readyNextWillplayVideoAgain:NO];
    };
    self.playMangerView.playerManagerPlayerActionBlock = ^(YXPlayerManagerAbnormalStatus status) {
        STRONG_SELF
        if (status == YXPlayerManagerAbnormal_Finish) {
            [self.chapterVC readyNextWillplayVideoAgain:YES];
        }else {
            [self requestForCourseDetail];
        }
    };
    [self.view addSubview:self.playMangerView];
    
    self.chapterVC = [[VideoCourseChapterViewController alloc]init];
    self.chapterVC.course = self.course;
    self.chapterVC.seekInteger = self.seekInteger;
    self.chapterVC.fromWhere = self.fromWhere;
    [self.chapterVC setVideoCourseChapterFragmentCompleteBlock:^(YXFileItemBase *fileItem, BOOL isHaveVideo) {
        STRONG_SELF
        [self recordPlayerDuration];
        SAFE_CALL(self.exitDelegate, browserExit);
        self.playMangerView.hidden = NO;
        self.containerView.hidden = NO;
        if (fileItem) {
            self.playMangerView.fileItem = fileItem;
            self.delegate = fileItem;
            self.exitDelegate = fileItem;
            if ([self isPlayBeginningVideo:[fileItem.vhead boolValue]] && fileItem.vheadUrl.length > 0 || 0) {
                self.playMangerView.pauseStatus = YXPlayerManagerPause_Manual;
                [self showBeginningView];
            }
            //[self setupClassworkManager:fileItem];
        }else {
            if (isHaveVideo) {
                self.playMangerView.playerStatus = YXPlayerManagerAbnormal_Finish;
            }
        }
    }];
    [self.chapterVC setVideoCourseIntroductionCompleteBlock:^(YXCourseDetailItem *courseItem) {
        STRONG_SELF
        self.title = courseItem.course_title;
    }];
    self.chapterVC.videoCourseSlideDistanceBlock = ^(CGFloat distance) {
        STRONG_SELF
        //[self refreshContainerView:distance];
    };
    self.introductionVC = [[VideoCourseIntroductionViewController alloc] init];
    self.introductionVC.title = self.title;
    self.commentVC = [[VideoCourseCommentViewController alloc] init];
    self.commentVC.courseId = self.course.courses_id;
//    self.commentVC.videoCourseSlideDistanceBlock = ^(CGFloat distance) {
//        STRONG_SELF
//        [self refreshContainerView:distance];
//    };
    [self addChildViewController:self.chapterVC];
    [self addChildViewController:self.introductionVC];
    [self addChildViewController:self.commentVC];
    self.containerView.viewControllers = @[self.chapterVC,self.introductionVC,self.commentVC];
    [self setupRightWithTitle:@" "];//TBD: 标题右移
}
- (void)setupLayout {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.width.mas_offset(kScreenWidth);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.playMangerView.mas_bottom);
    }];
    [self remakeForHalfSize];
}
- (void)showBeginningView {
    [self.beginningView playVideoClear];
    self.beginningView = nil;
    self.beginningView = [[YXPlayerBeginningView alloc] init];
    WEAK_SELF
    self.beginningView.playerBeginningRotateActionBlock = ^{
        STRONG_SELF
        [self rotateScreenAction];
    };
    self.beginningView.playerBeginningFinishActionBlock = ^(BOOL isSave) {
        STRONG_SELF
        if (isSave) {
            NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kYXTrainPlayBeginningCourse]];
            mutableDictionary[self.playMangerView.fileItem.cid] = [NSDate date];
            [[NSUserDefaults standardUserDefaults] setObject:mutableDictionary forKey:kYXTrainPlayBeginningCourse];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.isBeginPlayEnd = YES;
        }
        self.beginningView = nil;
        self.playMangerView.pauseStatus = YXPlayerManagerPause_Not;        
    };
    self.beginningView.playerBeginningBackActionBlock = ^{
        STRONG_SELF
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    };
    [self.playMangerView addSubview:self.beginningView];
    self.beginningView.videoUrl = [NSURL URLWithString:@"http://upload.ugc.yanxiu.com/video/4620490456e684328d4fcf5a920f54a1.mp4"];
    //[NSURL URLWithString:self.playMangerView.fileItem.vheadUrl];
    [self.beginningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playMangerView);
    }];
}
- (BOOL)isPlayBeginningVideo:(BOOL)vHead {
    NSMutableDictionary *mutableDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kYXTrainPlayBeginningCourse];
    NSDate *oldDate = mutableDictionary[self.playMangerView.fileItem.cid];
    BOOL playBool = NO;
    if (oldDate == nil) {
        playBool = YES;
    }else {
        NSTimeInterval  value = [[NSDate date] timeIntervalSinceDate:oldDate];
        playBool = (value > 12 * 60 * 60) ? YES : NO;
    }
    return playBool && vHead && !self.isBeginPlayEnd;
}
#pragma mark - Notification
- (void)setupNotification {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kRecordNeedUpdateNotification object:nil] subscribeNext:^(id x) {
        STRONG_SELF
        [self recordPlayerDuration];
    }];
}
#pragma mark - report
- (void)recordPlayerDuration {
    if (self.playMangerView.player.duration) {
        if (self.playMangerView.startTime) {
            self.playMangerView.playTime += [[NSDate date]timeIntervalSinceDate:self.playMangerView.startTime];
        }
        [self.delegate playerProgress:self.playMangerView.slideProgressView.playProgress totalDuration:self.playMangerView.player.duration stayTime:self.playMangerView.playTime];
        self.playMangerView.playTime = 0;
        self.playMangerView.startTime = nil;
    }
}
@end
