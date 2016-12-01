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
#import "ActivityEnclosureViewController.h"
#import "YXWebViewController.h"
#import "VideoCommentErrorView.h"
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
    self.dataFetcher.aid = self.tool.aid;
    self.dataFetcher.toolid = self.tool.toolid;
    self.dataFetcher.w = [YXTrainManager sharedInstance].currentProject.w;
    self.dataFetcher.pageIndex = 1;
    self.dataFetcher.pageSize = 10;
//    self.commentErrorView = [[VideoCommentErrorView alloc] init];
    [super viewDidLoad];
    self.title = @"视频";
    self.view.backgroundColor = [UIColor blackColor];
    [self requestForActivityToolVideo];
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
            VC.urlString = [self.toolVideoItem.body formatToolVideo].external_url;
            VC.isUpdatTitle = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }else {
          [self requestForActivityToolVideo];
        }
    }];
    [self.playMangerView setActivityPlayManagerBackActionBlock:^{
        STRONG_SELF
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }];
    [self.view addSubview:self.playMangerView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30.0f)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.0f, 12.0f, 200, 12.0f)];
    commentLabel.text = @"评论";
    commentLabel.textColor = [UIColor colorWithHexString:@"a1a7ae"];
    commentLabel.font = [UIFont systemFontOfSize:12.0f];
    [headerView addSubview:commentLabel];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 30.0f - 1.0f / [UIScreen mainScreen].scale, kScreenWidth - 30.0f, 1.0f / [UIScreen mainScreen].scale)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"eceef2"];
    [headerView addSubview:lineView];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableHeaderView.hidden = YES;
    self.dataErrorView.isActivityVideo = YES;
    self.emptyView.isActivityVideo = YES;
    self.errorView.isActivityVideo = YES;
}
- (void)setupLayout {
    [super setupLayout];
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44.0f);
        make.top.equalTo(self.playMangerView.mas_bottom).offset(30.0f);
    }];
    
    [self.errorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).priorityLow();
        make.top.equalTo(self.playMangerView.mas_bottom).offset(30.0f);
    }];
    [self.dataErrorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.playMangerView.mas_bottom).offset(30.0f);
    }];

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

- (void)showEnclosureButton:(ActivityToolVideoRequestItem_Body_Content *)content {
    if (content) {
        [self setupRightWithTitle:@"附件"];
    }
}
- (void)naviRightAction {
    ActivityEnclosureViewController *VC = [[ActivityEnclosureViewController alloc] init];
    VC.content = [self.toolVideoItem.body formatToolEnclosure];
    [self.navigationController pushViewController:VC animated:YES];
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
            if (isEmpty([item.body formatToolVideo])) {
                self.playMangerView.playStatus = ActivityPlayManagerStatus_Empty;
            }
            [self showEnclosureButton:[item.body formatToolEnclosure]];
        }
    }];
    self.videoRequest = request;
}
@end
