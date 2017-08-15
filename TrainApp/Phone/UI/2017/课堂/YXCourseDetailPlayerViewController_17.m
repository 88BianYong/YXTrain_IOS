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
@interface YXCourseDetailPlayerViewController_17 ()
@property (nonatomic ,strong) VideoClassworkManager *classworkManager;

@property (nonatomic, strong) VideoCourseChapterViewController *chapterVC;
@property (nonatomic, strong) VideoCourseIntroductionViewController *introductionVC;
@property (nonatomic, strong) VideoCourseCommentViewController *commentVC;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainPlayCourseStatus object:@(YXTrainCourseVideoPlay)];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kYXTrainPlayCourseStatus object:@(YXTrainCourseVideoPause)];
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
}
- (void)setDetailItem:(YXCourseDetailItem *)detailItem {
    _detailItem = detailItem;
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
