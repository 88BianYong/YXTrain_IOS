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
#import "VideoCourseChapterViewController.h"
@interface VideoCourseDetailViewController ()
@property (nonatomic, strong) VideoPlayManagerView *playMangerView;
@property (nonatomic, strong) CourseDetailContainerView *containerView;
@end

@implementation VideoCourseDetailViewController

- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = self.course.course_title;

    [self setupUI];
    [self setupLayout];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.playMangerView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playMangerView viewWillDisappear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI{
    self.playMangerView = [[VideoPlayManagerView alloc] init];
    //self.playMangerView.delegate = self;
    WEAK_SELF
    [self.playMangerView setVideoPlayManagerViewRotateScreenBlock:^(BOOL isVertical) {
        STRONG_SELF
        [self rotateScreenAction];
    }];
    [self.playMangerView setVideoPlayManagerViewPlayVideoBlock:^(VideoPlayManagerStatus status) {
        STRONG_SELF
//        if (status == VideoPlayManagerViewStatus_Unknown) {
//            YXWebViewController *VC = [[YXWebViewController alloc] init];
//            VC.urlString = [self.toolVideoItem.body formatToolVideo].external_url;
//            VC.isUpdatTitle = YES;
//            [self.navigationController pushViewController:VC animated:YES];
//        }else {
//            [self requestForActivityToolVideo];
//        }
    }];
    [self.playMangerView setVideoPlayManagerViewBackActionBlock:^{
        STRONG_SELF
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }];
    [self.view addSubview:self.playMangerView];
    self.containerView = [[CourseDetailContainerView alloc] init];
    [self.view addSubview:self.containerView];
    VideoCourseChapterViewController *chapterVC = [[VideoCourseChapterViewController alloc]init];
    chapterVC.course = self.course;
    chapterVC.isFromRecord = NO;
    [chapterVC setVideoCourseChapterFragmentCompleteBlock:^(YXFileItemBase *fileItem, BOOL isHaveVideo) {
        STRONG_SELF
        if (fileItem) {
            self.playMangerView.delegate = fileItem;
            self.playMangerView.exitDelegate = fileItem;
            self.playMangerView.fileItem = fileItem;
        }else {
            if (isHaveVideo) {
                
            }else {
                
            }
        }
    }];
    UIViewController *studentsVC = [[NSClassFromString(@"YXTaskViewController") alloc] init];
    studentsVC.view.backgroundColor = [UIColor grayColor];
    UIViewController *taskVC = [[NSClassFromString(@"YXTaskViewController") alloc] init];
    [self addChildViewController:chapterVC];
    [self addChildViewController:studentsVC];
    [self addChildViewController:taskVC];
    self.containerView.viewControllers = @[chapterVC,studentsVC,taskVC];
    self.containerView.tag = 10001;
    [self.playMangerView setVideoPlayManagerViewFinishBlock:^{
        STRONG_SELF
        [chapterVC readyNextWillplayVideo];
    }];
}
- (void)setupLayout {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
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
    [self.view layoutIfNeeded];
}
//- (void)startLoading {
//    [YXPromtController startLoadingInView:self.contentView];
//}
//- (void)stopLoading {
//    [YXPromtController stopLoadingInView:self.contentView];
//    dispatch_async(dispatch_get_main_queue(), ^{//fix bug 367
//        NSArray *subviews = [self.contentView subviews];
//        for (UIView *view in subviews) {
//            if ([view isKindOfClass:[MBProgressHUD class]]) {
//                [self.contentView bringSubviewToFront:view];
//                break;
//            }
//        }
//    });
//}

//- (void)showEnclosureButton:(ActivityToolVideoRequestItem_Body_Content *)content {
//    if (content) {
//        [self setupRightWithTitle:@"附件"];
//    }
//}
//- (void)naviRightAction {
//    ActivityEnclosureViewController *VC = [[ActivityEnclosureViewController alloc] init];
//    VC.content = [self.toolVideoItem.body formatToolEnclosure];
//    [self.navigationController pushViewController:VC animated:YES];
//}

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
        [self.navigationController popViewControllerAnimated:YES];
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
