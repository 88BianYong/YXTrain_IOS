//
//  CourseDetailMangerViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/25.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseDetailViewController_17.h"
#import "VideoPlayManagerView.h"
#import "CourseDetailContainerView_17.h"
#import "VideoCourseIntroductionViewController.h"
#import "VideoClassworkManager.h"
#import "VideoCourseCommentViewController.h"
#import "AppDelegate.h"
#import "CourseTestViewController_17.h"
#import "YXCourseDetailRequest.h"
#import "YXModuleDetailRequest.h"
@interface VideoCourseDetailViewController_17 ()
@property (nonatomic, strong) VideoPlayManagerView *playMangerView;
@property (nonatomic, strong) CourseDetailContainerView_17 *containerView;
@property (nonatomic ,strong) VideoClassworkManager *classworkManager;
@property (nonatomic, strong) VideoCourseChapterViewController *chapterVC;
@property (nonatomic, strong) VideoCourseIntroductionViewController *introductionVC;
@property (nonatomic, strong) VideoCourseCommentViewController *commentVC;

@property (nonatomic, strong) YXModuleDetailRequest *moduleDetailRequest;
@property (nonatomic, strong) YXCourseDetailRequest *courseDetailRequest;

@property (nonatomic, strong) YXCourseDetailItem *detailItem;
@property (nonatomic, strong) RACDisposable *disposable;

@property (nonatomic, assign) BOOL isFullscreen;
@property (nonatomic, assign) BOOL isShowClossworkViewBool;//是否正在显示随堂练界面

@end

@implementation VideoCourseDetailViewController_17

- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.disposable) {
        [self.disposable dispose];        
    }
}
- (BOOL)isShowClossworkViewBool {
    return !self.classworkManager.hidden;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = self.course.course_title;
    if (self.fromWhere == VideoCourseFromWhere_NotFound){
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self setupUI];
    [self setupLayout];
    [self startLoading];
    [self requestForCourseDetail];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    [self.playMangerView viewWillAppear];
    self.classworkManager.clossworkView.alpha = 1.0f;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playMangerView viewWillDisappear];
    self.classworkManager.clossworkView.alpha = 0.0f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma makr - set 
- (void)setDetailItem:(YXCourseDetailItem *)detailItem {
    if (detailItem == nil) {
        return;
    }
    _detailItem = detailItem;
    [self.chapterVC dealWithCourseItem:_detailItem];
    self.introductionVC.courseItem = _detailItem;
    if (_detailItem.quizNum.integerValue == 0 || _detailItem.courseSchemeMode.integerValue == 0 || _detailItem.userQuizStatus.integerValue == 1) {
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playMangerView.mas_bottom).offset(-71.0f);
        }];
    }else {
        self.containerView.startTimeInteger = _detailItem.openQuizTime.integerValue;
        self.containerView.playTimeInteger = _detailItem.rc.integerValue;
        self.containerView.isStartBool = self.containerView.playTimeInteger >= self.containerView.startTimeInteger;
        WEAK_SELF
        self.disposable = [RACObserve(self.playMangerView, playTotalTime) subscribeNext:^(id x) {
            STRONG_SELF
            if (self.playMangerView.playTotalTime > 0 ) {
                self.containerView.playTimeInteger += self.playMangerView.playTotalTime;
                if (floor((float)self.containerView.playTimeInteger/60.0f) >= ceil((float)self.containerView.startTimeInteger/60.0f) && !self.containerView.isStartBool) {
                    [self.playMangerView playReport:^(BOOL isSuccess) {
                        self.containerView.isStartBool = isSuccess;
                    }];
                }
            }
        }];
    }
}

#pragma mark - setupUI
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
    self.containerView.courseDetailContainerButtonBlock = ^{
        STRONG_SELF
        CourseTestViewController_17 *VC = [[CourseTestViewController_17 alloc] init];
        VC.cID = self.course.courses_id;
        VC.stageString = self.stageString;
        VC.courseTestQuestionBlock = ^(BOOL isFullBool) {
            if (isFullBool) {
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.playMangerView.mas_bottom).offset(-71.0f);
                }];
            }
        };
        [self.navigationController pushViewController:VC animated:YES];
    };
    self.containerView.hidden = YES;
    [self.view addSubview:self.containerView];
    self.playMangerView = [[VideoPlayManagerView alloc] init];
    self.playMangerView.hidden = YES;
    [self.playMangerView.thumbImageView sd_setImageWithURL:[NSURL URLWithString:self.course.course_img]];
    [self.playMangerView setVideoPlayManagerViewRotateScreenBlock:^(BOOL isVertical) {
        STRONG_SELF
        [self rotateScreenAction];
    }];
    [self.playMangerView setVideoPlayManagerViewBackActionBlock:^{
        STRONG_SELF
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }];
    [self.playMangerView setVideoPlayManagerViewFinishBlock:^{
        STRONG_SELF
        [self.chapterVC readyNextWillplayVideoAgain:NO];
    }];
    [self.playMangerView setVideoPlayManagerViewPlayVideoBlock:^(VideoPlayManagerStatus status) {
        STRONG_SELF
        if (self.playMangerView.playStatus == VideoPlayManagerStatus_Finish) {
            [self.chapterVC readyNextWillplayVideoAgain:YES];
        }else {
            [self requestForCourseDetail];
        }
    }];
    [self.view addSubview:self.playMangerView];
    
    self.chapterVC = [[VideoCourseChapterViewController alloc]init];
    self.chapterVC.course = self.course;
    self.chapterVC.seekInteger = self.seekInteger;
    self.chapterVC.fromWhere = self.fromWhere;
    [self.chapterVC setVideoCourseChapterFragmentCompleteBlock:^(YXFileItemBase *fileItem, BOOL isHaveVideo) {
        STRONG_SELF
        self.playMangerView.hidden = NO;
        self.containerView.hidden = NO;
        if (fileItem) {
            self.playMangerView.fileItem = fileItem;
            [self setupClassworkManager:fileItem];
        }else {
            if (isHaveVideo) {
                self.playMangerView.playStatus = VideoPlayManagerStatus_Finish;
            }
        }
    }];
    [self.chapterVC setVideoCourseIntroductionCompleteBlock:^(YXCourseDetailItem *courseItem) {
        STRONG_SELF
        self.title = courseItem.course_title;
    }];
    self.introductionVC = [[VideoCourseIntroductionViewController alloc] init];
    self.introductionVC.title = self.title;
    self.commentVC = [[VideoCourseCommentViewController alloc] init];
    self.commentVC.courseId = self.course.courses_id;
    [self addChildViewController:self.chapterVC];
    [self addChildViewController:self.introductionVC];
    [self addChildViewController:self.commentVC];
    self.containerView.viewControllers = @[self.chapterVC,self.introductionVC,self.commentVC];
    
    [self setupRightWithTitle:@" "];//TBD: 标题右移
}
- (void)setupClassworkManager:(YXFileItemBase *)fileItem {
    //随堂练
    [self.classworkManager clear];
    self.classworkManager = nil;
    self.classworkManager = [[VideoClassworkManager alloc] initClassworkRootViewController:self.navigationController];
    self.classworkManager.classworkMutableArray = [self quizeesExercisesFormatSgqz:fileItem.sgqz];
    self.classworkManager.cid = fileItem.cid;
    self.classworkManager.source = fileItem.source;
    self.classworkManager.forcequizcorrect = fileItem.forcequizcorrect.boolValue;
    [self.classworkManager startBatchRequestForVideoQuestions];
    WEAK_SELF
    [self.classworkManager setVideoClassworkManagerBlock:^(BOOL isPlay, NSInteger playTime) {
        STRONG_SELF
        self.playMangerView.topView.alpha = isPlay ? 1.0f : 0.0f;
        self.playMangerView.bottomView.alpha = isPlay ? 1.0f : 0.0f;
        if (isPlay) {
            if (playTime >= 0) {
                [self.playMangerView.player seekTo:playTime];
            }
            self.playMangerView.isShowTop = YES;
            [self checkNetworkDoPlay];
        }else {
            self.playMangerView.bottomView.slideProgressControl.bSliding = NO;
            [self.playMangerView.player pause];
            self.playMangerView.isShowTop = NO;
        }
    }];
    self.playMangerView.classworkManager = self.classworkManager;
    self.classworkManager.clossworkView.isFullscreen = self.isFullscreen;
}
- (void)checkNetworkDoPlay {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]) {
        [self showToast:@"网络不可用,请检查网络"];
        return;
    }
    if ([r isReachableViaWiFi]) {
        [self.playMangerView.player play];
        return;
    }
    if ([r isReachableViaWiFi]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络连接提示" message:@"当前处于非Wi-Fi环境，仍要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
        WEAK_SELF
        UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF
            [self naviLeftAction];
            return;
        }];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF
            [self.playMangerView.player play];
        }];
        [alertVC addAction:backAction];
        [alertVC addAction:goAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
-(NSMutableArray<YXFileVideoClassworkItem *> *)quizeesExercisesFormatSgqz:(NSString *)sgqz {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSArray *quizees = [sgqz componentsSeparatedByString:@","];
    [quizees enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *temp = [obj componentsSeparatedByString:@"_"];
        if (temp.count == 2) {
            YXFileVideoClassworkItem *item = [[YXFileVideoClassworkItem alloc] init];
            item.quizzesID = temp[0];
            item.timeString = temp[1];
            item.isTrue = NO;
            [mutableArray addObject:item];
        }
    }];
    return mutableArray;
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
- (void)remakeForFullSize {
    self.playMangerView.isFullscreen = YES;
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.playMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.classworkManager.clossworkView.isFullscreen = YES;
    self.isFullscreen = YES;
    [self.view layoutIfNeeded];
}
- (void)remakeForHalfSize {
    self.playMangerView.isFullscreen = NO;
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.playMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.playMangerView.mas_width).multipliedBy(9.0 / 16.0).priority(999);
    }];
    self.isFullscreen = NO;
    self.classworkManager.clossworkView.isFullscreen = self.isFullscreen;
    [self.view layoutIfNeeded];
}
#pragma mark - action
- (void)rotateScreenAction {
    UIInterfaceOrientation screenDirection = [UIApplication sharedApplication].statusBarOrientation;
    if(screenDirection == UIInterfaceOrientationLandscapeLeft || screenDirection ==UIInterfaceOrientationLandscapeRight){
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }else{
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    }
}
- (void)naviLeftAction{
    UIInterfaceOrientation screenDirection = [UIApplication sharedApplication].statusBarOrientation;
    if(screenDirection == UIInterfaceOrientationLandscapeLeft || screenDirection ==UIInterfaceOrientationLandscapeRight){
        [self rotateScreenAction];
    }else{
        [self.playMangerView playVideoClear];
        if (self.fromWhere == VideoCourseFromWhere_QRCode) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.appDelegateHelper.courseId = nil;
            appDelegate.appDelegateHelper.projectId = nil;
            appDelegate.appDelegateHelper.seg = nil;
            [LSTSharedInstance sharedInstance].floatingViewManager.loginStatus = PopUpFloatingLoginStatus_Default;
            [[LSTSharedInstance sharedInstance].floatingViewManager startPopUpFloatingView];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if (size.width > size.height) {
        [self remakeForFullSize];
    }else{
        [self remakeForHalfSize];
    }
}
#pragma mark - request
- (void)requestForCourseDetail{
    if (self.course.is_selected.integerValue == 0 && self.fromWhere == VideoCourseFromWhere_Detail) {
        [self.courseDetailRequest stopRequest];
        self.courseDetailRequest = [[YXCourseDetailRequest alloc]init];
        self.courseDetailRequest.cid = self.course.courses_id;
        self.courseDetailRequest.stageid = self.course.module_id;
        self.courseDetailRequest.courseType = self.course.courseType;
        self.courseDetailRequest.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
        WEAK_SELF
        [self.courseDetailRequest startRequestWithRetClass:[YXCourseDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            YXCourseDetailRequestItem *item = (YXCourseDetailRequestItem *)retItem;
            UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
            data.requestDataExist = item.body.chapters.count != 0;
            data.localDataExist = NO;
            data.error = error;
            if ([self handleRequestData:data]) {
                return;
            }
            self.detailItem = item.body;
        }];
    }else{
        [self.moduleDetailRequest stopRequest];
        self.moduleDetailRequest = [[YXModuleDetailRequest alloc]init];
        self.moduleDetailRequest.cid = self.course.courses_id;
        self.moduleDetailRequest.w = [LSTSharedInstance sharedInstance].trainManager.currentProject.w;
        self.moduleDetailRequest.pid = [LSTSharedInstance sharedInstance].trainManager.currentProject.pid;
        self.moduleDetailRequest.courseType = self.course.courseType;
        
        WEAK_SELF
        [self.moduleDetailRequest startRequestWithRetClass:[YXModuleDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            [self stopLoading];
            YXModuleDetailRequestItem *item = (YXModuleDetailRequestItem *)retItem;
            UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
            data.requestDataExist = item.body.chapters.count != 0;
            data.localDataExist = NO;
            data.error = error;
            if ([self handleRequestData:data]) {
                return;
            }
            self.detailItem = item.body;
        }];
    }
}

@end
