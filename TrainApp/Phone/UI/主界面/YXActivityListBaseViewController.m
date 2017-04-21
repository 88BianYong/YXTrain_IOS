//
//  YXActivityListBaseViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/4/12.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXActivityListBaseViewController.h"

@interface YXActivityListBaseViewController ()

@end

@implementation YXActivityListBaseViewController

- (void)viewDidLoad {
    self.isWaitingForFilter = YES;
    [super viewDidLoad];
    self.title = @"活动列表";
    if ([self isJudgmentChooseCourse]) {
        [self setupUI];
    }
}
- (BOOL)isJudgmentChooseCourse{
    if ([YXTrainManager sharedInstance].currentProject.isOpenTheme.boolValue || 1) {
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
- (void)setupUI {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
