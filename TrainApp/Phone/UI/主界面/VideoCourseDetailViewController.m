//
//  VideoCourseDetailViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/5/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "VideoCourseDetailViewController.h"
#import "VideoPlayManagerView.h"
#import "CourseDetailContainerView.h"
#import "VideoCourseIntroductionViewController.h"
#import "VideoClassworkManager.h"
#import "VideoCourseCommentViewController.h"
#import "AppDelegate.h"
@interface VideoCourseDetailViewController ()
@property (nonatomic, strong) VideoPlayManagerView *playMangerView;
@property (nonatomic, strong) CourseDetailContainerView *containerView;
@property (nonatomic ,strong) VideoClassworkManager *classworkManager;
@property (nonatomic, strong) VideoCourseChapterViewController *chapterVC;
@property (nonatomic, strong) VideoCourseIntroductionViewController *introductionVC;
@property (nonatomic, strong) VideoCourseCommentViewController *commentVC;
@property (nonatomic, assign) BOOL isFullscreen;
@property (nonatomic, assign) BOOL isShowClossworkViewBool;//是否正在显示随堂练界面
@end

@implementation VideoCourseDetailViewController

- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
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

#pragma mark - setupUI
- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"dfe2e6"];
    self.errorView = [[YXErrorView alloc]init];
    WEAK_SELF
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self.chapterVC requestForCourseDetail];
    };
    self.dataErrorView = [[DataErrorView alloc] init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self startLoading];
        [self.chapterVC requestForCourseDetail];
    };
    
    self.containerView = [[CourseDetailContainerView alloc] init];
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
            [self.chapterVC requestForCourseDetail];
        }
    }];
    [self.view addSubview:self.playMangerView];

    self.chapterVC = [[VideoCourseChapterViewController alloc]init];
    self.chapterVC.course = self.course;
    self.chapterVC.seekInteger = self.seekInteger;
    self.chapterVC.fromWhere = self.fromWhere;
    [self.chapterVC setVideoCourseChapterFragmentCompleteBlock:^(NSError *error, YXFileItemBase *fileItem, BOOL isHaveVideo) {
        STRONG_SELF
        [self stopLoading];
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            return;
        }
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
        self.introductionVC.courseItem = courseItem;
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



@end
