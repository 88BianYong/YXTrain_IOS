//
//  XYLearningViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXLearningViewController_17.h"

@interface YXLearningViewController_17 ()

@end

@implementation YXLearningViewController_17

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学习";
    UILabel *label = [[UILabel alloc] init];
    label.text = @"学习";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
