//
//  XYChooseProjectViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "XYChooseProjectViewController.h"

@interface XYChooseProjectViewController ()

@end

@implementation XYChooseProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手机研修";
    [self setupUI];
    [self requestForProjectList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark - setupUI
- (void)setupUI {
    WEAK_SELF
    self.errorView = [[YXErrorView alloc]init];
    self.errorView.retryBlock = ^{
        STRONG_SELF
        [self requestForProjectList];
    };
    self.emptyView = [[YXEmptyView alloc]init];
    self.dataErrorView = [[DataErrorView alloc]init];
    self.dataErrorView.refreshBlock = ^{
        STRONG_SELF
        [self requestForProjectList];
    };
    
}
#pragma mark - request
- (void)requestForProjectList {
    [self startLoading];
    WEAK_SELF
    [[LSTSharedInstance sharedInstance].trainManager getProjectsWithCompleteBlock:^(NSArray *groups, NSError *error) {
        STRONG_SELF
        self.emptyView.imageName = @"无培训项目";
        self.emptyView.title = @"您没有已参加的培训项目";
        self.emptyView.subTitle = @"";
        UnhandledRequestData *data = [[UnhandledRequestData alloc]init];
        data.requestDataExist = YES;
        data.localDataExist = NO;
        data.error = error;
        if ([self handleRequestData:data]) {
            [self stopLoading];
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kXYTrainChooseProject object:@([LSTSharedInstance sharedInstance].trainManager.trainStatus)];
    }];
}
@end
