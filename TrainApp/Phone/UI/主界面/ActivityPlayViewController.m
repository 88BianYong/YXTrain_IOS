//
//  ActivityPlayViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/4.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "ActivityPlayViewController.h"
#import "ActivityPlayManagerView.h"
#import "ActivityCommentInputView.h"
#import "CommentPagedListFetcher.h"
#import "ActivityToolVideoRequest.h"
//#import "ActivityEnclosureViewController.h"
#import "YXWebViewController.h"
@interface ActivityPlayViewController ()
@property (nonatomic, strong) ActivityPlayManagerView *playMangerView;
@property (nonatomic, strong) ActivityToolVideoRequest *videoRequest;
@property (nonatomic, strong) ActivityToolVideoRequestItem *toolVideoItem;

@end

@implementation ActivityPlayViewController
- (void)dealloc{
    DDLogError(@"release====>%@",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    self.dataFetcher = [[CommentPagedListFetcher alloc] init];
    [super viewDidLoad];
    self.title = @"视频";
    self.view.backgroundColor = [UIColor blackColor];
    [self requestForActivityToolVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setupUI
- (void)setupUI{
    [super setupUI];
    self.playMangerView = [[ActivityPlayManagerView alloc] init];
    WEAK_SELF
    [self.playMangerView setActivityPlayManagerRotateScreenBlock:^(BOOL isVertical) {
        STRONG_SELF
        [self rotateScreenAction];
    }];
    [self.playMangerView setActivityPlayManagerPlayVideoBlock:^(ActivityPlayManagerStatus status) {
        STRONG_SELF
        if (status == ActivityPlayManagerStatus_Unknown) {
            YXWebViewController *VC = [[YXWebViewController alloc] init];
            VC.urlString = [self.toolVideoItem.body formatToolVideo].previewurl;
            VC.isUpdatTitle = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }else {
          [self requestForActivityToolVideo];
        }
    }];
    [self.view addSubview:self.playMangerView];
}
- (void)setupLayout {
    [super setupLayout];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44.0f);
        make.top.equalTo(self.playMangerView.mas_bottom);
    }];
    [self remakeForHalfSize];
}

- (void)remakeForFullSize {
    self.playMangerView.isFullscreen = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.playMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
}

- (void)remakeForHalfSize {
    self.playMangerView.isFullscreen = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.playMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.playMangerView.mas_width).multipliedBy(9.0 / 16.0).priority(999);
    }];
    [self.view layoutIfNeeded];
}

- (void)showEnclosureButton:(ActivityToolVideoRequestItem_Body_Content *)content {
    if (content) {
        [self setupRightWithTitle:@"附件"];
    }
}
- (void)naviRightAction {
//    ActivityEnclosureViewController *VC = [[ActivityEnclosureViewController alloc] init];
//    VC.content = [self.toolVideoItem.body formatToolEnclosure];
//    [self.navigationController pushViewController:VC animated:YES];
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
#pragma mark - request
- (void)requestForActivityToolVideo {
    if (self.videoRequest) {
        [self.videoRequest stopRequest];
    }
    ActivityToolVideoRequest *request = [[ActivityToolVideoRequest alloc] init];
    request.aid = self.tool.aid;
    request.toolId = self.tool.toolid;
    request.w = [YXTrainManager sharedInstance].currentProject.w;
    WEAK_SELF
    [request startRequestWithRetClass:[ActivityToolVideoRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            if (error.code == -2) {
                self.playMangerView.playStatus = ActivityPlayManagerStatus_DataError;
            }else {
                self.playMangerView.playStatus = ActivityPlayManagerStatus_NetworkError;
            }
            
        }else {
            ActivityToolVideoRequestItem *item = (ActivityToolVideoRequestItem *)retItem;
            self.toolVideoItem = item;
            self.playMangerView.content = [item.body formatToolVideo];
            [self showEnclosureButton:[item.body formatToolEnclosure]];
        }
    }];
    self.videoRequest = request;
}
@end
