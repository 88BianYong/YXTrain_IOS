//
//  YXTaskViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXTaskViewController.h"
#import "YXCourseViewController.h"

@interface YXTaskViewController ()

@end

@implementation YXTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"任务";
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 60, 40)];
    [b setTitle:@"Push" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnAction{
    YXCourseViewController *vc = [[YXCourseViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
