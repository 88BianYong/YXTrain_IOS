//
//  XYMessageViewController.m
//  TrainApp
//
//  Created by 郑小龙 on 2017/7/6.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXMessageViewController_17.h"

@interface YXMessageViewController_17 ()

@end

@implementation YXMessageViewController_17

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    UILabel *label = [[UILabel alloc] init];
    label.text = @"消息";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
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
