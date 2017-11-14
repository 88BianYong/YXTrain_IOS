//
//  YXCourseBaseViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXCourseBaseViewController.h"

@interface YXCourseBaseViewController ()

@end

@implementation YXCourseBaseViewController

- (void)viewDidLoad {
    self.isWaitingForFilter = YES;
    [super viewDidLoad];
    self.title = @"课程列表";
    if ([self isJudgmentChooseCourse]) {
        [self setupUI];
    }
}
- (BOOL)isJudgmentChooseCourse{
    if ([LSTSharedInstance sharedInstance].trainManager.currentProject.isOpenTheme.boolValue) {
        self.emptyView = [[YXEmptyView alloc]init];
        self.emptyView.title = @"请先等待主题选学";
        self.emptyView.imageName = @"没选课";
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        return NO;
    }else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setupUI {
    
}

@end
