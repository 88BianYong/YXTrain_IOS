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
@interface ActivityPlayViewController ()
@property (nonatomic, strong) ActivityPlayManagerView *playMangerView;
@property (nonatomic, strong) ActivityCommentInputView *inputTextView;
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
    [self.playMangerView setRotateScreenBlock:^(BOOL isVertical) {
        STRONG_SELF
        [self rotateScreenAction];
    }];
    [self.view addSubview:self.playMangerView];
    
    self.inputTextView = [[ActivityCommentInputView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64.0f - 44.0f, kScreenWidth, 44.0f)];
    [self.view addSubview:self.inputTextView];
}
- (void)setupLayout {
    [super setupLayout];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50.0f);
        make.top.equalTo(self.playMangerView.mas_bottom);
    }];
    [self remakeForHalfSize];
    [self.inputTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(140.0f);
    }];
    [self.tableView reloadData];
}

- (void)remakeForFullSize {
    self.inputTextView.hidden = YES;
    self.playMangerView.isFullscreen = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.playMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
}

- (void)remakeForHalfSize {
    self.inputTextView.hidden = NO;
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


@end
