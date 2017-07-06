//
//  XYMineViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMineViewController_17.h"

@interface YXMineViewController_17 ()

@end

@implementation YXMineViewController_17

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    UILabel *label = [[UILabel alloc] init];
    label.text = @"我";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor blueColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
