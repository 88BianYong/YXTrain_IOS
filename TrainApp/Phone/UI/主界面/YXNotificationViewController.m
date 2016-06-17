//
//  YXNotificationViewController.m
//  TrainApp
//
//  Created by niuzhaowang on 16/6/17.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXNotificationViewController.h"

@interface YXNotificationViewController ()

@end

@implementation YXNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
    self.title = @"通知";
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    lb.text = @"vc3";
    lb.textColor = [UIColor blackColor];
    [self.view addSubview:lb];
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
