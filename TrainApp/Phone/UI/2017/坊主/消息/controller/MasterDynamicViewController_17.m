//
//  MasterDynamicViewController_17.m
//  TrainApp
//
//  Created by 郑小龙 on 2018/1/9.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MasterDynamicViewController_17.h"

@interface MasterDynamicViewController_17 ()

@end

@implementation MasterDynamicViewController_17

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息动态";
    self.emptyView = [[YXEmptyView alloc] init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
